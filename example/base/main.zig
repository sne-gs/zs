const std = @import("std");
const zio = @import("zio");

pub const std_options_debug_io = zio.debug_io;

const MAX_REQUEST_HEADER_SIZE = 64 * 1024;

fn handleClient(stream: zio.net.Stream) !void {
    defer stream.close();

    var read_buffer: [MAX_REQUEST_HEADER_SIZE]u8 = undefined;
    var reader = stream.reader(&read_buffer);

    var write_buffer: [4096]u8 = undefined;
    var writer = stream.writer(&write_buffer);

    var server = std.http.Server.init(&reader.interface, &writer.interface);

    while (true) {
        var request = server.receiveHead() catch |err| switch (err) {
            error.ReadFailed => |e| return reader.err orelse e,
            else => |e| return e,
        };

        const html = "Hello, World!";

        try request.respond(html, .{
            .status = .ok,
            .extra_headers = &.{
                .{ .name = "content-type", .value = "text/html; charset=utf-8" },
            },
        });

        if (!request.head.keep_alive) {
            try stream.shutdown(.both);
            break;
        }
    }

    std.log.info("HTTP client disconnected", .{});
}

pub fn main(init: std.process.Init) !void {
    const rt = try zio.Runtime.init(init.gpa, .{
        .executors = @enumFromInt(8),
    });
    defer rt.deinit();

    const addr = try zio.net.IpAddress.parseIp4("127.0.0.1", 3001);

    const server = try addr.listen(.{});
    defer server.close();

    std.log.info("HTTP server listening on {f}", .{server.socket.address});
    std.log.info("Visit http://{f} in your browser", .{server.socket.address});
    std.log.info("Press Ctrl+C to stop the server", .{});

    var group: zio.Group = .init;
    defer group.cancel();

    while (true) {
        const stream = try server.accept(.{});
        errdefer stream.close();

        try group.spawn(handleClient, .{stream});
    }
}
