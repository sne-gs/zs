const std = @import("std");
const Headers = @import("headers.zig").Headers;
const initHeaders = @import("headers.zig").init;
const Params = @import("params.zig").Params;
const Reader = @import("reader.zig").Reader;
const LengthReaderCtx = @import("reader.zig").LengthReaderCtx;
const ChunkReaderCtx = @import("reader.zig").ChunkReaderCtx;
const hparse = @import("hparse");

const MAX_BODY_SIZE = 1024 * 1024;

pub const Request = struct {
    pub const Head = struct {
        method: hparse.Method,
        path: []const u8,
        qstr: []const u8,
        headers: Headers,
        query: Params,
        params: Params,
    };

    pub const Body = struct {
        const Ctx = union(enum) {
            chunked: *ChunkReaderCtx,
            length: *LengthReaderCtx,
        };

        reader: Reader,
        content_length: u64,
        _ctx: ?Ctx = null,

        pub fn init(reader: Reader, content_length: u64) Body {
            return .{ .reader = reader, .content_length = content_length };
        }

        pub fn read(self: *Body, allocator: std.mem.Allocator) ![]const u8 {
            var list = try std.ArrayList(u8).initCapacity(allocator, 0);
            errdefer list.deinit(allocator);
            var buf: [4096]u8 = undefined;
            while (true) {
                const n = try self.reader.read(&.{buf[0..]});
                if (n == 0) break;
                try list.appendSlice(allocator, buf[0..n]);
            }
            return try list.toOwnedSlice(allocator);
        }

        pub fn deinit(self: *Body) void {
            self.reader.deinit();
        }
    };

    alloc: std.mem.Allocator,
    head: Head,
    body: Body,

    pub fn init(alloc: std.mem.Allocator, reader: *std.Io.net.Stream.Reader) !Request {
        const head = try parseHead(reader);
        const body = try parseBody(reader, head.headers, alloc);
        return Request{ .alloc = alloc, .head = head, .body = body };
    }

    fn parseUri(target: []const u8) struct {
        path: []const u8,
        qstr: []const u8,
    } {
        const query_start = std.mem.indexOfScalar(u8, target, '?');
        const path = if (query_start) |idx| target[0..idx] else target;
        const qstr = if (query_start) |idx| target[idx + 1 ..] else "";
        return .{ .path = path, .qstr = qstr };
    }

    fn parseHead(
        reader: *std.Io.net.Stream.Reader,
    ) !Head {
        var method: hparse.Method = .unknown;
        var maybe_target: ?[]const u8 = null;
        var version: hparse.Version = .@"1.0";
        var headers_arr: [32]hparse.Header = undefined;
        var header_count: usize = 0;

        while (true) {
            const avail = reader.interface.buffered();

            const consumed = hparse.parseRequest(
                avail,
                &method,
                &maybe_target,
                &version,
                &headers_arr,
                &header_count,
            ) catch |err| switch (err) {
                error.Incomplete => {
                    if (avail.len >= reader.interface.buffer.len) return error.RequestTooLarge;
                    try reader.interface.fill(avail.len + 1);
                    continue;
                },
                else => return err,
            };

            _ = try reader.interface.discard(.limited(consumed));
            break;
        }

        const target = maybe_target orelse return error.InvalidRequest;
        const parsed = parseUri(target);

        var headers = Headers{};
        for (headers_arr[0..header_count]) |hdr| {
            headers.set(hdr.key, hdr.value);
        }

        var query = Params{};
        if (parsed.qstr.len > 0) {
            var query_iter = std.mem.splitScalar(u8, parsed.qstr, '&');
            while (query_iter.next()) |pair| {
                if (pair.len == 0) continue;
                var eq_iter = std.mem.splitScalar(u8, pair, '=');
                const key = eq_iter.next() orelse continue;
                const val = eq_iter.next() orelse "";
                query.set(key, val);
            }
        }

        return Head{
            .method = method,
            .path = parsed.path,
            .qstr = parsed.qstr,
            .headers = headers,
            .query = query,
            .params = Params{},
        };
    }

    fn parseBody(reader: *std.Io.net.Stream.Reader, headers: Headers, allocator: std.mem.Allocator) !Body {
        var is_chunked = false;
        if (headers.get("transfer-encoding")) |te| {
            if (std.ascii.eqlIgnoreCase(te, "chunked")) {
                is_chunked = true;
            }
        }

        if (is_chunked) {
            const ctx = try allocator.create(ChunkReaderCtx);
            ctx.* = .{
                .reader = reader,
                .max_body_size = MAX_BODY_SIZE,
            };
            const r = Reader{
                .ctx = @ptrCast(ctx),
                .readFn = ChunkReaderCtx.read,
                .deinitFn = ChunkReaderCtx.deinit,
            };
            var body = Body.init(r, 0);
            body._ctx = .{ .chunked = ctx };
            return body;
        } else {
            var cl_str: []const u8 = "0";
            if (headers.get("content-length")) |v| cl_str = v;
            const trimmed = std.mem.trim(u8, cl_str, " \t");
            const cl = std.fmt.parseInt(u64, trimmed, 10) catch 0;
            const ctx = try allocator.create(LengthReaderCtx);
            ctx.* = .{
                .reader = reader,
                .content_length = cl,
                .bytes_read = 0,
            };
            const r = Reader{
                .ctx = @ptrCast(ctx),
                .readFn = LengthReaderCtx.read,
                .deinitFn = LengthReaderCtx.deinit,
            };
            var body = Body.init(r, cl);
            body._ctx = .{ .length = ctx };
            return body;
        }
    }

    pub fn deinit(self: *Request) void {
        self.body.deinit();
        if (self.body._ctx) |ctx| {
            switch (ctx) {
                .chunked => |c| self.alloc.destroy(c),
                .length => |l| self.alloc.destroy(l),
            }
        }
    }
};

const testing = std.testing;

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

fn feedAndClose(io: std.Io, writer: *std.Io.net.Stream, data: []const u8, buffer: []u8) !void {
    var w = writer.writer(io, buffer);
    _ = try w.interface.write(data);
    try w.interface.flush();
    try writer.shutdown(io, .send);
}

test "GET request with path and no query" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [128]u8 = undefined;
    const request_data = "GET /hello HTTP/1.1\r\nHost: example.com\r\n\r\n";
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [128]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    var req = try Request.init(alloc, &sr);
    defer req.deinit();

    try testing.expectEqual(hparse.Method.get, req.head.method);
    try testing.expectEqualStrings("/hello", req.head.path);
    try testing.expectEqualStrings("", req.head.qstr);
    try testing.expectEqualStrings("example.com", req.head.headers.get("host").?);
    try testing.expectEqual(@as(usize, 0), req.head.query.count);
}

test "GET request with query string" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [128]u8 = undefined;
    const request_data = "GET /search?q=zig&lang=en HTTP/1.1\r\n\r\n";
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [128]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    var req = try Request.init(alloc, &sr);
    defer req.deinit();

    try testing.expectEqualStrings("/search", req.head.path);
    try testing.expectEqualStrings("q=zig&lang=en", req.head.qstr);
    try testing.expectEqualStrings("zig", req.head.query.get("q").?);
    try testing.expectEqualStrings("en", req.head.query.get("lang").?);
}

test "POST request with Content-Length body" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [256]u8 = undefined;
    const body_data = "Hello, Zig!";
    const request_data = try std.fmt.allocPrint(alloc, "POST /submit HTTP/1.1\r\nContent-Length: {d}\r\n\r\n{s}", .{ body_data.len, body_data });
    defer alloc.free(request_data);
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [256]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    var req = try Request.init(alloc, &sr);
    defer req.deinit();

    const body = try req.body.read(alloc);
    defer alloc.free(body);
    try testing.expectEqualStrings(body_data, body);
}

test "POST request with chunked body" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [256]u8 = undefined;
    const request_data = "POST /data HTTP/1.1\r\nTransfer-Encoding: chunked\r\n\r\n5\r\nHello\r\n6\r\n World\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [256]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    var req = try Request.init(alloc, &sr);
    defer req.deinit();

    const body = try req.body.read(alloc);
    defer alloc.free(body);
    try testing.expectEqualStrings("Hello World", body);
}

test "Request without body (GET) returns empty body" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [128]u8 = undefined;
    const request_data = "GET / HTTP/1.1\r\n\r\n";
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [128]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    var req = try Request.init(alloc, &sr);
    defer req.deinit();

    const body = try req.body.read(alloc);
    defer alloc.free(body);
    try testing.expectEqual(@as(usize, 0), body.len);
}

test "Request with multiple headers" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [256]u8 = undefined;
    const request_data = "POST /multi HTTP/1.1\r\nX-Custom: value1\r\nX-Custom: value2\r\nContent-Length: 0\r\n\r\n";
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [256]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    var req = try Request.init(alloc, &sr);
    defer req.deinit();

    try testing.expectEqualStrings("value2", req.head.headers.get("x-custom").?);
}

test "Request too large" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [128]u8 = undefined;
    const request_data = "GET / HTTP/1.1\r\n" ++ ("x" ** 48);
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    try testing.expectError(error.RequestTooLarge, Request.init(alloc, &sr));
}

test "Invalid request line" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [128]u8 = undefined;
    const request_data = "123 / HTTP/1.1\r\n\r\n";
    try feedAndClose(io, &writer_stream, request_data, &write_buf);

    var read_buf: [128]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);

    try testing.expectError(error.Invalid, Request.init(alloc, &sr));
}
