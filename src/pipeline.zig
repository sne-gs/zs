const std = @import("std");
const Context = @import("context.zig").Context;
const Response = @import("response.zig").Response;

pub fn Pipeline(comptime Env: type, comptime HandlerId: type) type {
    return PipelineBuilder(Env, HandlerId, .{}, .{});
}

fn PipelineBuilder(
    comptime Env: type,
    comptime TargetHandlerId: type,
    comptime global_mids: anytype,
    comptime group_configs: anytype,
) type {
    return struct {
        const Self = @This();

        pub fn global(comptime mids: anytype) type {
            return PipelineBuilder(Env, TargetHandlerId, global_mids ++ mids, group_configs);
        }

        pub fn group(
            comptime tag: anytype,
            comptime Locals: type,
            comptime SubDispatcher: type,
            comptime mids: anytype,
        ) type {
            const GroupConfig = struct {
                pub const group_tag = tag;
                pub const LocalsType = Locals;
                pub const Dispatcher = SubDispatcher;
                pub const middlewares = mids;
            };
            return PipelineBuilder(Env, TargetHandlerId, global_mids, group_configs ++ .{GroupConfig});
        }

        pub fn build() type {
            return struct {
                pub const HandlerId = TargetHandlerId;

                fn findUnionGroupConfig(comptime tag: @typeInfo(HandlerId).@"union".tag_type.?) @TypeOf(group_configs[0]) {
                    inline for (group_configs) |g| {
                        if (g.group_tag == tag) return g;
                    }
                    @compileError("No group configured for union tag: " ++ @tagName(tag));
                }

                fn findEnumGroupConfig(comptime value: HandlerId) @TypeOf(group_configs[0]) {
                    inline for (group_configs) |g| {
                        if (g.group_tag == value) return g;
                    }
                    @compileError("No group configured for enum value: " ++ @tagName(value));
                }

                const CoreRouter = if (group_configs.len == 0)
                    struct {
                        pub fn dispatch(id: HandlerId, ctx_any: anytype) Response {
                            _ = id;
                            _ = ctx_any;
                            return Response.status(.not_found).static("");
                        }
                    }
                else
                    struct {
                        pub fn dispatch(id: HandlerId, ctx_any: anytype) Response {
                            switch (@typeInfo(HandlerId)) {
                                .@"union" => {
                                    const tag = std.meta.activeTag(id);
                                    switch (tag) {
                                        inline else => |comptime_tag| {
                                            const group_cfg = comptime findUnionGroupConfig(comptime_tag);
                                            const group_locals: group_cfg.LocalsType = if (group_cfg.LocalsType == void) {} else .{};
                                            const GroupCtxType = Context(Env, group_cfg.LocalsType);
                                            var group_ctx = GroupCtxType.init(
                                                ctx_any.req,
                                                ctx_any.env,
                                                if (group_cfg.LocalsType == void) group_locals else group_locals,
                                            );
                                            const PipelineChain = ComposeChain(Env, GroupCtxType, group_cfg.middlewares, group_cfg.Dispatcher);
                                            return PipelineChain.dispatch(id, &group_ctx);
                                        },
                                    }
                                },
                                .@"enum" => {
                                    switch (id) {
                                        inline else => |comptime_value| {
                                            const group_cfg = comptime findEnumGroupConfig(comptime_value);
                                            const group_locals: group_cfg.LocalsType = if (group_cfg.LocalsType == void) {} else .{};
                                            const GroupCtxType = Context(Env, group_cfg.LocalsType);
                                            var group_ctx = GroupCtxType.init(
                                                ctx_any.req,
                                                ctx_any.env,
                                                if (group_cfg.LocalsType == void) group_locals else group_locals,
                                            );
                                            const PipelineChain = ComposeChain(Env, GroupCtxType, group_cfg.middlewares, group_cfg.Dispatcher);
                                            return PipelineChain.dispatch(id, &group_ctx);
                                        },
                                    }
                                },
                                else => @compileError("HandlerId must be an enum or union(enum)"),
                            }
                        }
                    };

                pub fn dispatch(id: HandlerId, req: anytype, env: Env) Response {
                    const GlobalCtxType = Context(Env, void);
                    const FinalChain = ComposeChain(Env, GlobalCtxType, global_mids, CoreRouter);

                    const fake_locals: void = {};
                    const req_val = if (@typeInfo(@TypeOf(req)) == .pointer) req.* else req;
                    var ctx = GlobalCtxType.init(req_val, env, fake_locals);
                    return FinalChain.dispatch(id, &ctx);
                }
            };
        }
    };
}

fn ComposeChain(
    comptime Env: type,
    comptime TargetContext: type,
    comptime middlewares: anytype,
    comptime Base: type,
) type {
    var Current = Base;
    comptime var i = middlewares.len;
    inline while (i > 0) {
        i -= 1;
        Current = middlewares[i](Env, TargetContext, Current);
    }
    return Current;
}

const testing = std.testing;
const Request = @import("request.zig").Request;

const TestEnv = struct {
    message: []const u8,
};

const TestHandlerId = enum {
    alpha,
    beta,
};

fn makeTestRequest(alloc: std.mem.Allocator) Request {
    return Request{
        .alloc = alloc,
        .head = .{
            .method = .get,
            .path = "/",
            .qstr = "",
            .headers = .{},
            .query = .{},
            .params = .{},
        },
        .body = .{
            .reader = undefined,
            .content_length = 0,
        },
    };
}

fn AddHeaderMiddleware(comptime value: []const u8, comptime HandlerId: type) type {
    return struct {
        fn mw(
            comptime EnvType: type,
            comptime CtxType: type,
            comptime Next: type,
        ) type {
            _ = EnvType;
            return struct {
                fn dispatch(id: HandlerId, ctx: *CtxType) Response {
                    var res = Next.dispatch(id, ctx);
                    return res.header("X-Mid", value);
                }
            };
        }
    };
}

fn PrependBodyMiddleware(comptime prefix: []const u8, comptime HandlerId: type) type {
    return struct {
        fn mw(
            comptime EnvType: type,
            comptime CtxType: type,
            comptime Next: type,
        ) type {
            _ = EnvType;
            return struct {
                fn dispatch(id: HandlerId, ctx: *CtxType) Response {
                    var res = Next.dispatch(id, ctx);
                    if (res._body == .static) {
                        const new_body = std.fmt.allocPrint(
                            ctx.req.alloc,
                            "{s}{s}",
                            .{ prefix, res._body.static },
                        ) catch return res;
                        res._body = .{ .owned = .{ .ptr = new_body, .allocator = ctx.req.alloc } };
                    }
                    return res;
                }
            };
        }
    };
}

fn ShortCircuitMiddleware(comptime HandlerId: type) type {
    return struct {
        fn mw(
            comptime EnvType: type,
            comptime CtxType: type,
            comptime Next: type,
        ) type {
            _ = EnvType;
            _ = Next;
            return struct {
                fn dispatch(id: HandlerId, ctx: *CtxType) Response {
                    _ = id;
                    _ = ctx;
                    return Response.status(.internal_server_error).static("I'm a teapot");
                }
            };
        }
    };
}

const TestDispatcher = struct {
    pub fn dispatch(id: TestHandlerId, ctx: anytype) Response {
        _ = ctx.req;
        return switch (id) {
            .alpha => Response.status(.ok).static(ctx.env.message),
            .beta => Response.status(.ok).static("beta"),
        };
    }
};

test "Pipeline basic dispatch without middleware" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const PipelineType = Pipeline(TestEnv, TestHandlerId)
        .group(.alpha, void, TestDispatcher, .{})
        .group(.beta, void, TestDispatcher, .{})
        .build();
    const env = TestEnv{ .message = "hello" };
    const req = makeTestRequest(aa);

    const res = PipelineType.dispatch(.alpha, req, env);
    defer res.deinit();

    try testing.expectEqual(std.http.Status.ok, res._status);
    try testing.expectEqualStrings("hello", res._body.static);
}

test "Pipeline with global middleware" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const PipelineType = Pipeline(TestEnv, TestHandlerId)
        .global(.{AddHeaderMiddleware("global", TestHandlerId).mw})
        .group(.alpha, void, TestDispatcher, .{})
        .group(.beta, void, TestDispatcher, .{})
        .build();
    const env = TestEnv{ .message = "hello" };
    const req = makeTestRequest(aa);

    const res = PipelineType.dispatch(.alpha, req, env);
    defer res.deinit();

    try testing.expectEqualStrings("global", res._headers.get("X-Mid").?);
    try testing.expectEqualStrings("hello", res._body.static);
}

test "Pipeline with group middleware and locals" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const GroupLocals = struct {
        extra: []const u8 = "",
    };

    const PipelineType = Pipeline(TestEnv, TestHandlerId)
        .group(.alpha, GroupLocals, TestDispatcher, .{
            PrependBodyMiddleware("alpha:", TestHandlerId).mw,
        })
        .group(.beta, void, TestDispatcher, .{})
        .build();
    const env = TestEnv{ .message = "world" };
    const req = makeTestRequest(aa);

    const res = PipelineType.dispatch(.alpha, req, env);
    defer res.deinit();

    try testing.expectEqualStrings("alpha:world", res._body.owned.ptr);
    try testing.expect(res._headers.get("X-Mid") == null);
}

test "Pipeline global and group middleware ordering" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const PipelineType = Pipeline(TestEnv, TestHandlerId)
        .global(.{AddHeaderMiddleware("outer", TestHandlerId).mw})
        .group(.alpha, void, TestDispatcher, .{
            AddHeaderMiddleware("inner", TestHandlerId).mw,
        })
        .group(.beta, void, TestDispatcher, .{})
        .build();
    const env = TestEnv{ .message = "test" };
    const req = makeTestRequest(aa);

    const res = PipelineType.dispatch(.alpha, req, env);
    defer res.deinit();

    try testing.expectEqualStrings("outer", res._headers.get("X-Mid").?);
}

test "Pipeline short‑circuit middleware" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const PipelineType = Pipeline(TestEnv, TestHandlerId)
        .global(.{ShortCircuitMiddleware(TestHandlerId).mw})
        .group(.alpha, void, TestDispatcher, .{})
        .group(.beta, void, TestDispatcher, .{})
        .build();
    const env = TestEnv{ .message = "unreachable" };
    const req = makeTestRequest(aa);

    const res = PipelineType.dispatch(.alpha, req, env);
    defer res.deinit();

    try testing.expectEqual(std.http.Status.internal_server_error, res._status);
    try testing.expectEqualStrings("I'm a teapot", res._body.static);
}

test "Pipeline with union handler ID" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const UnionId = union(enum) {
        admin: struct { level: u8 },
        public,
    };

    const UnionEnv = struct {};

    const UnionDispatcher = struct {
        pub fn dispatch(id: UnionId, ctx: anytype) Response {
            _ = ctx.req;
            _ = ctx.env;
            return switch (id) {
                .admin => Response.status(.ok).static("admin"),
                .public => Response.status(.ok).static("public"),
            };
        }
    };

    const PipelineType = Pipeline(UnionEnv, UnionId)
        .group(.admin, void, UnionDispatcher, .{})
        .group(.public, void, UnionDispatcher, .{})
        .global(.{AddHeaderMiddleware("union", UnionId).mw})
        .build();

    const req = makeTestRequest(aa);
    const res = PipelineType.dispatch(.{ .admin = .{ .level = 3 } }, req, UnionEnv{});
    defer res.deinit();

    try testing.expectEqualStrings("admin", res._body.static);
    try testing.expectEqualStrings("union", res._headers.get("X-Mid").?);
}

test "Pipeline dispatches to correct group based on enum value" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const PipelineType = Pipeline(TestEnv, TestHandlerId)
        .group(.alpha, void, TestDispatcher, .{})
        .group(.beta, void, TestDispatcher, .{})
        .build();

    const env = TestEnv{ .message = "a" };
    const req = makeTestRequest(aa);

    const res_alpha = PipelineType.dispatch(.alpha, req, env);
    defer res_alpha.deinit();
    try testing.expectEqualStrings("a", res_alpha._body.static);

    const res_beta = PipelineType.dispatch(.beta, req, env);
    defer res_beta.deinit();
    try testing.expectEqualStrings("beta", res_beta._body.static);
}

test "Pipeline without any groups returns not_found" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const PipelineType = Pipeline(TestEnv, TestHandlerId).build();
    const env = TestEnv{ .message = "x" };
    const req = makeTestRequest(aa);

    const res = PipelineType.dispatch(.alpha, req, env);
    defer res.deinit();

    try testing.expectEqual(std.http.Status.not_found, res._status);
}

test "Pipeline union handler with non-void locals" {
    const alloc = testing.allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const aa = arena.allocator();

    const UnionId = union(enum) {
        admin: struct { level: u8 },
        public,
    };

    const UnionEnv = struct {};

    const AdminLocals = struct {
        some_field: u32 = 0,
    };

    const AdminDispatcher = struct {
        pub fn dispatch(id: UnionId, ctx: anytype) Response {
            _ = id;
            _ = ctx;
            return Response.status(.ok).static("admin_with_locals");
        }
    };

    const PublicDispatcher = struct {
        pub fn dispatch(id: UnionId, ctx: anytype) Response {
            _ = id;
            _ = ctx;
            return Response.status(.ok).static("public");
        }
    };

    const PipelineType = Pipeline(UnionEnv, UnionId)
        .group(.admin, AdminLocals, AdminDispatcher, .{})
        .group(.public, void, PublicDispatcher, .{})
        .build();

    const req = makeTestRequest(aa);
    const env = UnionEnv{};
    const res = PipelineType.dispatch(.{ .admin = .{ .level = 3 } }, req, env);
    defer res.deinit();

    try testing.expectEqualStrings("admin_with_locals", res._body.static);
}
