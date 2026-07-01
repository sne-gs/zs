const std = @import("std");
const zs = @import("zs");
const serde = @import("serde");
const zio = @import("zio");

fn jsonResponse(allocator: std.mem.Allocator, value: anytype) zs.Response {
    const body_or_err = serde.json.toSlice(allocator, value);
    const body = body_or_err catch |err| {
        std.debug.print("jsonResponse: serialization failed: {}\n", .{err});
        return zs.Response
            .status(.internal_server_error)
            .static("Serialization failed");
    };
    return zs.Response
        .status(.ok)
        .content(.json)
        .owned(body, allocator);
}

const GlobalRoutes = enum { root };

const ApiRoutes = enum { get_users, create_user };
const WebRoutes = enum { home, profile };

const HandlerId = union(enum) {
    global: GlobalRoutes,
    api: ApiRoutes,
    web: WebRoutes,
};

const ApiExt = struct {
    client_ip: []const u8 = "127.0.0.1",
    request_quota: u32 = 100,
};

const WebExt = struct {
    session_id: ?[]const u8 = null,
    is_admin: bool = false,
};

pub fn Logger(comptime EnvType: type, comptime CtxType: type, comptime NextType: type) type {
    _ = EnvType;
    return struct {
        pub fn dispatch(id: anytype, ctx: *CtxType) zs.Response {
            std.debug.print("[Global Logger] Request ID: {}\n", .{id});
            std.debug.print("  Method: {s}, Path: {s}\n", .{
                @tagName(ctx.req.head.method),
                ctx.req.head.path,
            });

            const headers = ctx.req.head.headers.slice();
            for (headers) |h| {
                std.debug.print("  Header: {s}: {s}\n", .{ h.name, h.value });
            }

            const query = ctx.req.head.query.slice();
            for (query) |q| {
                std.debug.print("  Query: {s}: {s}\n", .{ q.name, q.value });
            }

            const params = ctx.req.head.params.slice();
            for (params) |p| {
                std.debug.print("  Param: {s}: {s}\n", .{ p.name, p.value });
            }

            const res = NextType.dispatch(id, ctx);

            std.debug.print("[Global Logger] Response status: {}\n", .{res._status});
            std.debug.print("[Global Logger] Finished\n", .{});

            return res;
        }
    };
}

pub fn RateLimiter(comptime EnvType: type, comptime CtxType: type, comptime NextType: type) type {
    _ = EnvType;
    return struct {
        pub fn dispatch(id: anytype, ctx: *CtxType) zs.Response {
            ctx.ext.request_quota -= 1;
            if (ctx.ext.request_quota == 0) {
                return zs.Response
                    .status(.too_many_requests)
                    .static("Rate limit reached");
            }
            return NextType.dispatch(id, ctx);
        }
    };
}

pub fn SessionLoader(comptime EnvType: type, comptime CtxType: type, comptime NextType: type) type {
    _ = EnvType;
    return struct {
        pub fn dispatch(id: anytype, ctx: *CtxType) zs.Response {
            ctx.ext.session_id = "sess_987654321";
            ctx.ext.is_admin = true;
            return NextType.dispatch(id, ctx);
        }
    };
}

const GlobalDispatcher = struct {
    pub fn handleRoot(ctx: *zs.Context(void, void)) zs.Response {
        _ = ctx;
        return zs.Response
            .status(.ok)
            .static("Hello, World!");
    }

    pub fn dispatch(id: HandlerId, ctx: *zs.Context(void, void)) zs.Response {
        switch (id) {
            .global => |g| switch (g) {
                .root => return handleRoot(ctx),
            },
            else => unreachable,
        }
    }
};

const ApiDispatcher = struct {
    const User = struct {
        id: []const u8,
        name: []const u8,
    };

    const Created = struct {
        created: bool,
    };

    pub fn handleGetUsers(ctx: *zs.Context(void, ApiExt)) zs.Response {
        return jsonResponse(
            ctx.req.alloc,
            [_]User{
                .{ .id = "1", .name = "Bob" },
                .{ .id = "2", .name = "John" },
            },
        );
    }

    pub fn handleCreateUser(ctx: *zs.Context(void, ApiExt)) zs.Response {
        return jsonResponse(
            ctx.req.alloc,
            Created{ .created = true },
        );
    }

    pub fn dispatch(id: HandlerId, ctx: *zs.Context(void, ApiExt)) zs.Response {
        std.debug.print("API → quota left: {d}\n", .{ctx.ext.request_quota});
        switch (id) {
            .api => |api_route| switch (api_route) {
                .get_users => return handleGetUsers(ctx),
                .create_user => return handleCreateUser(ctx),
            },
            else => unreachable,
        }
    }
};

const WebDispatcher = struct {
    pub fn handleHome(ctx: *zs.Context(void, WebExt)) zs.Response {
        const name = ctx.req.head.params.get("name") orelse "stranger";
        const content = "Welcome, {s}";
        const res = std.fmt.allocPrint(ctx.req.alloc, content, .{name}) catch |err| {
            std.debug.print("web.home: allocPrint failed: {}\n", .{err});
            return zs.Response
                .status(.internal_server_error)
                .static("Internal server error");
        };
        return zs.Response
            .status(.ok)
            .static(res);
    }

    pub fn handleProfile(ctx: *zs.Context(void, WebExt)) zs.Response {
        if (!ctx.ext.is_admin) {
            return zs.Response
                .status(.forbidden)
                .static("Access Denied");
        }
        return zs.Response
            .status(.ok)
            .content(.html)
            .static("<h1>Admin Dashboard</h1>");
    }

    pub fn dispatch(id: HandlerId, ctx: *zs.Context(void, WebExt)) zs.Response {
        std.debug.print("Web → session: {s}\n", .{ctx.ext.session_id orelse "none"});

        switch (id) {
            .web => |web_route| switch (web_route) {
                .home => return handleHome(ctx),
                .profile => return handleProfile(ctx),
            },
            else => unreachable,
        }
    }
};

pub const Pipe = zs.Pipeline(void, HandlerId)
    .global(.{Logger})
    .group(.global, void, GlobalDispatcher, .{})
    .group(.api, ApiExt, ApiDispatcher, .{RateLimiter})
    .group(.web, WebExt, WebDispatcher, .{SessionLoader})
    .build();

const global_routes = [_]zs.Route(HandlerId){
    .{ .method = .get, .path = "/", .handler = .{ .global = .root } },
};

const api_routes = [_]zs.Route(HandlerId){
    .{ .method = .get, .path = "/api/users", .handler = .{ .api = .get_users } },
    .{ .method = .post, .path = "/api/user", .handler = .{ .api = .create_user } },
};

const web_routes = [_]zs.Route(HandlerId){
    .{ .method = .get, .path = "/home/{name}", .handler = .{ .web = .home } },
    .{ .method = .get, .path = "/profile", .handler = .{ .web = .profile } },
};

const routes = global_routes ++ api_routes ++ web_routes;

pub fn main(init: std.process.Init) !void {
    const alloc = init.arena.allocator();
    const rt = try zio.Runtime.init(alloc, .{
        .executors = .auto,
    });
    defer rt.deinit();
    const io = rt.io();

    const ServerType = zs.Server(Pipe, void, &routes);
    var server = try ServerType.init({}, alloc);
    server.setHost("127.0.0.1");
    server.setPort(3001);
    var group: std.Io.Group = .init;
    defer group.cancel(io);

    try server.start(io, &group);
    try group.await(io);
}
