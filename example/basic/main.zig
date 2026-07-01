const std = @import("std");
const zs = @import("zs");
const zio = @import("zio");

const Handler = enum {
    b13b,
    b1kb,
    b1mb,
};

const body_13b = blk: {
    var buf: [13]u8 = undefined;
    @memset(&buf, 'a');
    break :blk buf;
};

const body_1kb = blk: {
    var buf: [1024]u8 = undefined;
    @memset(&buf, 'a');
    break :blk buf;
};

const body_1mb = blk: {
    var buf: [1024 * 1024]u8 = undefined;
    @memset(&buf, 'a');
    break :blk buf;
};

const Dispatcher = struct {
    pub fn dispatch(id: Handler, ctx: *zs.Context(void, void)) zs.Response {
        _ = ctx;
        return switch (id) {
            .b13b => zs.Response.status(.ok).static(&body_13b),
            .b1kb => zs.Response.status(.ok).static(&body_1kb),
            .b1mb => zs.Response.status(.ok).static(&body_1mb),
        };
    }
};

pub const Pipeline = zs.Pipeline(void, Handler)
    .group(.b13b, void, Dispatcher, &.{})
    .group(.b1kb, void, Dispatcher, &.{})
    .group(.b1mb, void, Dispatcher, &.{})
    .build();

const routes = [_]zs.Route(Handler){
    .{ .method = .get, .path = "/b13b", .handler = .b13b },
    .{ .method = .post, .path = "/b13b", .handler = .b13b },
    .{ .method = .get, .path = "/b1kb", .handler = .b1kb },
    .{ .method = .post, .path = "/b1kb", .handler = .b1kb },
    .{ .method = .get, .path = "/b1mb", .handler = .b1mb },
    .{ .method = .post, .path = "/b1mb", .handler = .b1mb },
};

pub fn main(init: std.process.Init) !void {
    const alloc = init.arena.allocator();
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
