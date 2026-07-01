const std = @import("std");
const Io = std.Io;
const Socket = Io.net.Socket;
const Protocol = Io.net.Protocol;
const Request = @import("request.zig").Request;
const Response = @import("response.zig").Response;
const Context = @import("context.zig").Context;
const TrieRouter = @import("router.zig").TrieRouter;
const Route = @import("router.zig").Route;
const Params = @import("params.zig").Params;
const Headers = @import("headers.zig").Headers;
const static = @import("static.zig");

const MAX_HEAD_SIZE = 64 * 1024;
const MAX_BODY_SIZE = 1024 * 1024;

const READ_BUFFER_SIZE = 1024 * 1024;
const WRITE_BUFFER_SIZE = 1024 * 1024;
const BODY_BUFFER_SIZE = 256 * 1024;
const CHUNK_BUFFER_SIZE = 1024 * 1024;

pub const Buffers = struct {
    read: [READ_BUFFER_SIZE]u8 = undefined,
    write: [WRITE_BUFFER_SIZE]u8 = undefined,
    body: [BODY_BUFFER_SIZE]u8 = undefined,
    chunk: [CHUNK_BUFFER_SIZE]u8 = undefined,
    path: [std.fs.max_path_bytes]u8 = undefined,
};

pub fn Server(
    comptime Dispatch: type,
    comptime Env: type,
    comptime routes: []const Route(Dispatch.HandlerId),
) type {
    return struct {
        const Self = @This();

        const RouterType = TrieRouter(Dispatch.HandlerId, routes, .{});

        env: Env,
        host: []const u8,
        port: u16,
        static_dir: ?[]const u8,
        allocator: std.mem.Allocator,

        pub fn init(env: Env, allocator: std.mem.Allocator) !Self {
            return Self{
                .env = env,
                .host = "127.0.0.1",
                .port = 8080,
                .static_dir = null,
                .allocator = allocator,
            };
        }

        pub fn setHost(self: *Self, host: []const u8) void {
            self.host = host;
        }

        pub fn setPort(self: *Self, port: u16) void {
            self.port = port;
        }

        pub fn mapStaticAssets(self: *Self, dir_path: ?[]const u8) void {
            self.static_dir = dir_path;
        }

        pub fn start(self: *Self, io: Io, group: *Io.Group) !void {
            const ipAddr = try Io.net.IpAddress.parseIp4(self.host, self.port);
            var listener = try ipAddr.listen(io, .{
                .mode = Socket.Mode.stream,
                .protocol = Protocol.tcp,
                .reuse_address = true,
                .kernel_backlog = 4096,
            });
            defer listener.deinit(io);

            while (true) {
                const conn = try listener.accept(io);
                errdefer conn.close(io);
                group.concurrent(io, handleClient, .{ self, io, conn }) catch {
                    conn.close(io);
                };
            }
        }

        fn handleClient(self: *Self, io: std.Io, stream: std.Io.net.Stream) error{Canceled}!void {
            defer stream.close(io);
            var bufs = self.allocator.create(Buffers) catch return error.Canceled;
            defer self.allocator.destroy(bufs);
            var reader = stream.reader(io, &bufs.read);
            var writer = stream.writer(io, &bufs.write);

            return self.accept(io, stream, &reader, &writer, bufs) catch |err| {
                if (err == error.EndOfStream) return error.Canceled;
                if (err == error.Canceled) return error.Canceled;
                if (err == error.ReadFailed) return error.Canceled;
                if (err == error.HttpConnectionClosing) return error.Canceled;
                if (err == error.ConnectionResetByPeer) return error.Canceled;
                if (err == error.HttpHeadersOversize) return error.Canceled;
                std.debug.print("Connection error: {}\n", .{err});
                return error.Canceled;
            };
        }

        fn send(
            res: *const Response,
            writer: *std.Io.net.Stream.Writer,
            buf: []u8,
        ) !void {
            try writer.interface.print(
                "HTTP/1.1 {d} {s}\r\n",
                .{ @intFromEnum(res._status), @tagName(res._status) },
            );
            for (res._headers.slice()) |hdr| {
                try writer.interface.print("{s}: {s}\r\n", .{ hdr.name, hdr.value });
            }
            switch (res._body) {
                .static => |s| {
                    try writer.interface.print("content-length: {d}\r\n\r\n", .{s.len});
                    try writer.interface.writeAll(s);
                },
                .owned => |o| {
                    try writer.interface.print("content-length: {d}\r\n\r\n", .{o.ptr.len});
                    try writer.interface.writeAll(o.ptr);
                },
                .empty => {
                    try writer.interface.writeAll("content-length: 0\r\n\r\n");
                },
                .reader => |r| {
                    try writer.interface.writeAll("transfer-encoding: chunked\r\n\r\n");
                    var iov_buf = [1][]u8{buf[0..]};
                    const iov: []const []u8 = &iov_buf;
                    while (true) {
                        const n = try r.read(iov);
                        if (n == 0) break;
                        try writer.interface.print("{x}\r\n", .{n});
                        try writer.interface.writeAll(iov_buf[0][0..n]);
                        try writer.interface.writeAll("\r\n");
                    }
                    try writer.interface.writeAll("0\r\n\r\n");
                },
                .writer => |w| {
                    try writer.interface.writeAll("\r\n");
                    try w.write(writer);
                    w.deinit();
                },
            }
            try writer.interface.flush();
        }

        fn accept(
            self: *Self,
            io: std.Io,
            stream: std.Io.net.Stream,
            reader: *std.Io.net.Stream.Reader,
            writer: *std.Io.net.Stream.Writer,
            bufs: *Buffers,
        ) anyerror!void {
            var req_arena = std.heap.ArenaAllocator.init(self.allocator);
            defer req_arena.deinit();
            while (true) {
                _ = req_arena.reset(.retain_capacity);
                const alloc = req_arena.allocator();

                var req = try Request.init(alloc, reader);

                const oversized = blk: {
                    if (req.head.headers.get("content-length")) |cl_str| {
                        const cl = std.fmt.parseInt(u64, cl_str, 10) catch 0;
                        break :blk cl > MAX_BODY_SIZE;
                    }
                    break :blk false;
                };

                const res = if (oversized)
                    Response.status(.payload_too_large).static("Request entity too large")
                else switch (RouterType.match(req.head.method, req.head.path, &req.head.params)) {
                    .match => |handler_id| Dispatch.dispatch(handler_id, &req, self.env),
                    .method_not_allowed => Response.status(.method_not_allowed)
                        .static("Method not allowed."),
                    .not_found => if (self.static_dir) |dir|
                        (try static.serve(io, alloc, dir, req.head.path, &bufs.path)) orelse
                            Response.status(.internal_server_error)
                                .static("Failed to serve file.")
                    else
                        Response.status(.not_found).static("404 Not found."),
                };
                defer res.deinit();

                try send(&res, writer, &bufs.chunk);
                const conn_header = req.head.headers.get("connection") orelse "";
                const keep_alive = !std.ascii.eqlIgnoreCase(conn_header, "close");

                if (!keep_alive) {
                    stream.shutdown(io, .both) catch return error.Canceled;
                    break;
                }
            }
        }
    };
}

const testing = std.testing;

const TestHandlerId = enum { home, submit };
const TestEnv = struct { message: []const u8 };

const TestDispatch = struct {
    pub const HandlerId = TestHandlerId;

    fn dispatch(id: HandlerId, req: *const Request, env: TestEnv) Response {
        _ = req;
        return switch (id) {
            .home => Response.status(.ok).static(env.message),
            .submit => Response.status(.ok).static("posted"),
        };
    }
};

fn loopbackPair(io: std.Io) !struct { reader_stream: std.Io.net.Stream, writer_stream: std.Io.net.Stream } {
    const loopback = try std.Io.net.IpAddress.parseIp4("127.0.0.1", 0);
    var listener = try loopback.listen(io, .{
        .mode = .stream,
        .protocol = .tcp,
        .reuse_address = true,
        .kernel_backlog = 1,
    });
    defer listener.deinit(io);

    const address = listener.socket.address;
    var writer = try address.connect(io, .{ .mode = .stream, .protocol = .tcp });
    errdefer writer.close(io);

    var reader = try listener.accept(io);
    errdefer reader.close(io);

    return .{ .reader_stream = reader, .writer_stream = writer };
}

fn sendRequest(io: std.Io, writer: *std.Io.net.Stream, data: []const u8, buffer: []u8) !void {
    var w = writer.writer(io, buffer);
    _ = try w.interface.write(data);
    try w.interface.flush();
}

test "server routes GET / to handler" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    const routes = [_]Route(TestHandlerId){
        .{ .method = .get, .path = "/", .handler = .home },
    };
    const ServerType = Server(TestDispatch, TestEnv, &routes);
    const env = TestEnv{ .message = "hello world" };
    var srv = try ServerType.init(env, alloc);
    srv.static_dir = null;

    var bufs: Buffers = .{};
    var reader = reader_stream.reader(io, &bufs.read);
    var writer = writer_stream.writer(io, &bufs.write);

    const request = "GET / HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n";
    var send_buf: [256]u8 = undefined;
    try sendRequest(io, &writer_stream, request, &send_buf);

    try srv.accept(io, reader_stream, &reader, &writer, &bufs);

    var resp_buf: [4096]u8 = undefined;
    var total: usize = 0;
    while (true) {
        const n = try reader.interface.readSliceShort(resp_buf[total..]);
        if (n == 0) break;
        total += n;
    }
    const response = resp_buf[0..total];

    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "HTTP/1.1 200 ok"));
    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "hello world"));
}

test "server returns 404 for unknown path" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    const routes = [_]Route(TestHandlerId){
        .{ .method = .get, .path = "/", .handler = .home },
    };
    const ServerType = Server(TestDispatch, TestEnv, &routes);
    const env = TestEnv{ .message = "hello" };
    var srv = try ServerType.init(env, alloc);
    srv.static_dir = null;

    var bufs: Buffers = .{};
    var reader = reader_stream.reader(io, &bufs.read);
    var writer = writer_stream.writer(io, &bufs.write);

    const request = "GET /missing HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n";
    var send_buf: [256]u8 = undefined;
    try sendRequest(io, &writer_stream, request, &send_buf);

    try srv.accept(io, reader_stream, &reader, &writer, &bufs);

    var resp_buf: [4096]u8 = undefined;
    var total: usize = 0;
    while (true) {
        const n = try reader.interface.readSliceShort(resp_buf[total..]);
        if (n == 0) break;
        total += n;
    }
    const response = resp_buf[0..total];

    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "HTTP/1.1 404 not_found"));
    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "404 Not found."));
}

test "server returns 405 for wrong method" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    const routes = [_]Route(TestHandlerId){
        .{ .method = .post, .path = "/submit", .handler = .submit },
    };
    const ServerType = Server(TestDispatch, TestEnv, &routes);
    const env = TestEnv{ .message = "" };
    var srv = try ServerType.init(env, alloc);
    srv.static_dir = null;

    var bufs: Buffers = .{};
    var reader = reader_stream.reader(io, &bufs.read);
    var writer = writer_stream.writer(io, &bufs.write);

    const request = "GET /submit HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n";
    var send_buf: [256]u8 = undefined;
    try sendRequest(io, &writer_stream, request, &send_buf);

    try srv.accept(io, reader_stream, &reader, &writer, &bufs);

    var resp_buf: [4096]u8 = undefined;
    var total: usize = 0;
    while (true) {
        const n = try reader.interface.readSliceShort(resp_buf[total..]);
        if (n == 0) break;
        total += n;
    }
    const response = resp_buf[0..total];

    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "HTTP/1.1 405 method_not_allowed"));
    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "Method not allowed."));
}

test "server returns 413 for oversized request" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    const routes = [_]Route(TestHandlerId){
        .{ .method = .post, .path = "/", .handler = .home },
    };
    const ServerType = Server(TestDispatch, TestEnv, &routes);
    const env = TestEnv{ .message = "" };
    var srv = try ServerType.init(env, alloc);
    srv.static_dir = null;

    var bufs: Buffers = .{};
    var reader = reader_stream.reader(io, &bufs.read);
    var writer = writer_stream.writer(io, &bufs.write);

    const request = "POST / HTTP/1.1\r\nHost: localhost\r\nContent-Length: 2097152\r\nConnection: close\r\n\r\n";
    var send_buf: [256]u8 = undefined;
    try sendRequest(io, &writer_stream, request, &send_buf);

    try srv.accept(io, reader_stream, &reader, &writer, &bufs);

    var resp_buf: [4096]u8 = undefined;
    var total: usize = 0;
    while (true) {
        const n = try reader.interface.readSliceShort(resp_buf[total..]);
        if (n == 0) break;
        total += n;
    }
    const response = resp_buf[0..total];

    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "HTTP/1.1 413 payload_too_large"));
    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "Request entity too large"));
}

test "server handles multiple requests with keep‑alive" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    const routes = [_]Route(TestHandlerId){
        .{ .method = .get, .path = "/", .handler = .home },
    };
    const ServerType = Server(TestDispatch, TestEnv, &routes);
    const env = TestEnv{ .message = "first" };
    var srv = try ServerType.init(env, alloc);
    srv.static_dir = null;

    var bufs: Buffers = .{};
    var reader = reader_stream.reader(io, &bufs.read);
    var writer = writer_stream.writer(io, &bufs.write);

    const req1 = "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n";
    var send_buf1: [256]u8 = undefined;
    try sendRequest(io, &writer_stream, req1, &send_buf1);

    const req2 = "GET / HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n";
    var send_buf2: [256]u8 = undefined;
    try sendRequest(io, &writer_stream, req2, &send_buf2);

    try srv.accept(io, reader_stream, &reader, &writer, &bufs);

    var resp_buf: [8192]u8 = undefined;
    var total: usize = 0;
    while (true) {
        const n = try reader.interface.readSliceShort(resp_buf[total..]);
        if (n == 0) break;
        total += n;
    }
    const response = resp_buf[0..total];

    try testing.expect(std.mem.containsAtLeast(u8, response, 2, "HTTP/1.1 200 ok"));
    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "first"));
    try testing.expect(std.mem.containsAtLeast(u8, response, 1, "first"));
}
