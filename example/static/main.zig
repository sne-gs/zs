const std = @import("std");
const zs = @import("zs");
const zio = @import("zio");

const Handler = enum { _unused };

pub const AppPipeline = zs.Pipeline(void, Handler).build();

const routes = [_]zs.Route(Handler){};

pub fn main(init: std.process.Init) !void {
    const alloc = init.arena.allocator();
    const rt = try zio.Runtime.init(std.heap.smp_allocator, .{ .executors = @enumFromInt(12) });
    defer rt.deinit();
    const io = rt.io();

    const ServerType = zs.Server(AppPipeline, void, &routes);
    var server = try ServerType.init({}, alloc);
    server.setPort(3001);
    server.mapStaticAssets("static");

    var group: std.Io.Group = .init;
    defer group.cancel(io);
    try server.start(io, &group);
    try group.await(io);
}
