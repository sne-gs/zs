# zs

**z**ig **s**erver

- small (~1k lines of code excl. tests)
    - complexity bad, I already have kids to deal with
- fast (~360k req/sec plaintext)
  - it doesn't do much, and whatever it does it tries to do it a compile time
- tested (~95% coverage)
  - whatever it does it needs to keep doing it

## reasons

1) I needed a server to build stuff with
2) I don't want to use ai slop
3) I wanted to learn zig because of #2

## install

add zs to your build.zig.zon dependencies

```zig
// ...
.zs = .{
    .url = "git+https://codeberg.org/snegs/zs#<commit-hash>",
    .hash = "",
},
// ...
```

and to build.zig

```zig
// ...
const zs_dep = b.dependency("zs", .{
    .target = target,
});
const zs_mod = zs_dep.module("zs");
const root_mod = b.createModule(.{
    // ...
    .imports = &.{
        // ...
        .{ .name = "zs", .module = zs_mod }
    }
});
// ...
```

## router

zs uses a comptime, trie-based [router](./src/router.zig)

```zig
const Handler = enum {
    root,
};

const Dispatcher = struct {
    pub fn dispatch(id: Handler, ctx: *zs.Context(void, void)) zs.Response {
        _ = ctx;
        return switch (id) {
            .root => zs.Response.status(.ok).static("Hello, World!"),
        };
    }
};

pub const Pipeline = zs.Pipeline(void, Handler)
    .group(.root, void, Dispatcher, &.{})
    .build();

const routes = [_]zs.Route(Handler){
    .{ .method = .get, .path = "/", .handler = .root },
};
```

## context

zs supports a global [context type](./src/context.zig) to be passed in to each handler

```zig

const Env = struct {
    db: *sqlite.Database,
};

fn handle(ctx: *zs.Context(Env)) zs.Response {
    const db = ctx.env.db;
    _ = db;
    return zs.Response
        .status(.ok)
        .content(.html)
        .static("<h1>Hello, World!</h1>");
}

const Dispatch = struct {
    pub fn dispatch(id: HandlerId, ctx: *zs.Context(Env)) zs.Response {
        return switch (id) {
            .handle => handle(ctx),
        };
    }
};

pub const Pipe = zs.Pipeline(Env, HandlerId)
    .group(.global, void, Dispatch, .{})
    .build();
```

## middlewares

zs supports comptime [middlewares](./src/pipeline.zig) with route groupings and extensions:

```zig

const ApiRoutes = enum { get_users, create_user };
const WebRoutes = enum { home, profile };

const HandlerId = union(enum) {
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
            std.debug.print("[Logger] Request id: {}\n", .{id});
            const res = NextType.dispatch(id, ctx);
            std.debug.print("[Logger] Response status: {}\n", .{res._status});
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
        switch (id) {
            .api => |api_route| switch (api_route) {
                .get_users => return handleGetUsers(ctx),
                .create_user => return handleCreateUser(ctx),
            },
            else => unreachable,
        }
    }
};

pub const Pipe = zs.Pipeline(Env, HandlerId)
    .global(.{Logger})
    .group(.api, ApiExt, ApiDispatcher, .{RateLimiter})
    .group(.web, WebExt, WebDispatcher, .{SessionLoader})
    .build();
```

## runtime

zs is io agnostic so it should work with any io backend, for example with [zio](https://github.com/lalinsky/zio)

```zig

pub fn main(init: std.process.Init) !void {
    const alloc = init.arena.allocator();
    const rt = try zio.Runtime.init(alloc, .{});
    defer rt.deinit();
    const io = rt.io();

    const ServerType = zs.Server(Pipe, void, &routes);
    var server = try ServerType.init({}, alloc);

    server.setPort(3001);
    var group: std.Io.Group = .init;
    defer group.cancel(io);

    try server.start(io, &group);
    try group.await(io);
}

```

## benchmarks

the point of these is to make sure features added don't hurt performance

### env

- nixos
- cpu: amd ryzen 9 4900H (8 cores, 16 threads)
- server (zs) pinned to cores 0-7
- load gen (oha) pinned to cores 8-15

| case | method | req size | res size | req/sec | avg latency (ms) | total data | success rate |
|------|--------|----------|----------|---------|------------------|------------|--------------|
| **13b out** | GET | – | 13 B | 357,186.37 | 0.1380 | 132.86 MiB | 100% |
| **1kb in / 13b out** | POST | 1 KiB | 13 B | 338,037.74 | 0.1458 | 125.76 MiB | 100% |
| **1kb out** | GET | – | 1 KiB | 325,986.56 | 0.1512 | 9.33 GiB | 100% |
| **1kb in / 1kb out** | POST | 1 KiB | 1 KiB | 313,440.09 | 0.1573 | 8.97 GiB | 100% |
| **1mb out** | GET | – | 1 MiB | 4,508.97 | 11.0663 | 132.08 GiB | 100% |
| **1mb in / 1mb out** | POST | 1 MiB | 1 MiB | 4,548.91 | 10.9674 | 133.26 GiB | 100% |
| **actix 13b out** | GET | – | 13 B | 314,102.33 | 1.2704 | 116.84 MiB | 100% |

## license

- MIT

---
