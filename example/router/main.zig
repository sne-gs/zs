const std = @import("std");
const zs = @import("zs");
const zio = @import("zio");

const Handler = enum {
    root,
    auth_login,
};

const HandlerId = union(enum) { global: Handler };

const Dispatch = struct {
    pub fn dispatch(id: HandlerId, ctx: *zs.Context(void, void)) zs.Response {
        _ = ctx;
        return switch (id.global) {
            .root => zs.Response.status(.ok).static("Hello, World!"),
            .auth_login => zs.Response.status(.ok).static("authenticated"),
        };
    }
};

pub const Pipeline = zs.Pipeline(void, HandlerId)
    .group(.global, void, Dispatch, .{})
    .build();

const routes = [_]zs.Route(HandlerId){
    .{ .method = .GET, .path = "/", .handler = .{ .global = .root } },
    .{ .method = .POST, .path = "/api/v1/auth/login", .handler = .{ .global = .auth_login } },
};

pub fn main() !void {
    const alloc = std.heap.c_allocator; // or std.heap.page_allocator
    const rt = try zio.Runtime.init(alloc, .{
        .executors = .auto,
    });
    defer rt.deinit();
    const io = rt.io();

    const ServerType = zs.Server(Pipeline, void, &routes);
    var server = try ServerType.init({}, alloc);
    server.setHost("127.0.0.1");
    server.setPort(3001);
    var group: std.Io.Group = .init;
    defer group.cancel(io);

    try server.start(io, &group);
    try group.await(io);
}
