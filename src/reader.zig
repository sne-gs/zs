const std = @import("std");

pub const Reader = struct {
    ctx: *anyopaque,
    readFn: *const fn (ctx: *anyopaque, buffer: []const []u8) anyerror!usize,
    deinitFn: ?*const fn (ctx: *anyopaque) void = null,

    pub fn read(self: Reader, buffer: []const []u8) anyerror!usize {
        return self.readFn(self.ctx, buffer);
    }

    pub fn deinit(self: Reader) void {
        if (self.deinitFn) |f| f(self.ctx);
    }
};

pub const StringReaderCtx = struct {
    data: []u8,
    pos: usize = 0,
    allocator: std.mem.Allocator,

    pub fn read(ctx: *anyopaque, buffer: []const []u8) anyerror!usize {
        const self = @as(*StringReaderCtx, @ptrCast(@alignCast(ctx)));
        var total: usize = 0;
        for (buffer) |slice| {
            const remaining = self.data.len - self.pos;
            if (remaining == 0) break;
            const n = @min(slice.len, remaining);
            @memcpy(slice[0..n], self.data[self.pos..][0..n]);
            self.pos += n;
            total += n;
            if (n < slice.len) break;
        }
        return total;
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self = @as(*StringReaderCtx, @ptrCast(@alignCast(ctx)));
        self.allocator.free(self.data);
        self.allocator.destroy(self);
    }
};

pub const FileReaderCtx = struct {
    file: std.Io.File,
    allocator: std.mem.Allocator,
    io: std.Io,
    size_str: []const u8,
    offset: u64 = 0,

    pub fn read(ctx: *anyopaque, buffer: []const []u8) !usize {
        const self = @as(*@This(), @ptrCast(@alignCast(ctx)));
        if (buffer.len == 0) return 0;
        const n = try self.file.readPositional(self.io, buffer, self.offset);
        self.offset += n;
        return n;
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self = @as(*@This(), @ptrCast(@alignCast(ctx)));
        self.file.close(self.io);
        self.allocator.free(self.size_str);
        self.allocator.destroy(self);
    }
};

pub const LengthReaderCtx = struct {
    reader: *std.Io.net.Stream.Reader,
    content_length: u64,
    bytes_read: u64 = 0,

    pub fn read(ctx: *anyopaque, buffer: []const []u8) !usize {
        const self = @as(*LengthReaderCtx, @ptrCast(@alignCast(ctx)));
        if (self.bytes_read >= self.content_length) return 0;

        var total: usize = 0;
        for (buffer) |buf| {
            const remaining = self.content_length - self.bytes_read;
            if (remaining == 0) break;
            const to_read = @min(buf.len, remaining);
            const n = try self.reader.interface.readSliceShort(buf[0..to_read]);
            if (n == 0) return error.UnexpectedEndOfStream;
            self.bytes_read += n;
            total += n;
            if (n < to_read) break;
        }
        return total;
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self = @as(*LengthReaderCtx, @ptrCast(@alignCast(ctx)));
        if (self.bytes_read < self.content_length) {
            const remaining = self.content_length - self.bytes_read;
            _ = self.reader.interface.discard(.limited(remaining)) catch {};
        }
    }
};

pub const ChunkReaderCtx = struct {
    reader: *std.Io.net.Stream.Reader,
    max_body_size: u64,
    total_read: u64 = 0,
    state: enum { reading_size, reading_data, reading_trailer, done } = .reading_size,
    current_chunk_size: u64 = 0,
    remaining_in_chunk: u64 = 0,
    line_buf: [64]u8 = undefined,
    line_len: usize = 0,

    fn readLine(self: *@This(), out: []u8) ![]u8 {
        var idx: usize = 0;
        while (idx < out.len) {
            const n = try self.reader.interface.readSliceShort(out[idx .. idx + 1]);
            if (n == 0) return error.UnexpectedEndOfStream;
            idx += n;
            if (idx >= 2 and out[idx - 2] == '\r' and out[idx - 1] == '\n') {
                return out[0 .. idx - 2];
            }
        }
        return error.LineTooLong;
    }

    fn skipTrailers(self: *@This()) !void {
        var buf: [1024]u8 = undefined;
        while (true) {
            const line = try self.readLine(&buf);
            if (line.len == 0) break;
        }
    }

    pub fn read(ctx: *anyopaque, buffer: []const []u8) !usize {
        const self = @as(*@This(), @ptrCast(@alignCast(ctx)));
        if (self.state == .done) return 0;

        var buf_index: usize = 0;
        var buf_offset: usize = 0;
        var total: usize = 0;

        while (buf_index < buffer.len) {
            switch (self.state) {
                .reading_size => {
                    const line = try self.readLine(&self.line_buf);
                    const trimmed = std.mem.trim(u8, line, " \t");
                    if (trimmed.len == 0) continue;
                    const size = std.fmt.parseInt(u64, trimmed, 16) catch return error.InvalidChunkSize;
                    if (size == 0) {
                        try self.skipTrailers();
                        self.state = .done;
                        break;
                    }
                    self.current_chunk_size = size;
                    self.remaining_in_chunk = size;
                    self.state = .reading_data;
                },
                .reading_data => {
                    while (buf_index < buffer.len and self.remaining_in_chunk > 0) {
                        const buf = buffer[buf_index];
                        const space_left = buf.len - buf_offset;
                        const to_read = @min(space_left, self.remaining_in_chunk);
                        const n = try self.reader.interface.readSliceShort(buf[buf_offset..][0..to_read]);
                        if (n == 0) return error.UnexpectedEndOfStream;
                        self.remaining_in_chunk -= n;
                        self.total_read += n;
                        total += n;
                        buf_offset += n;
                        if (buf_offset == buf.len) {
                            buf_index += 1;
                            buf_offset = 0;
                        }
                        if (n < to_read) break;
                    }
                    if (self.remaining_in_chunk == 0) {
                        var crlf: [2]u8 = undefined;
                        _ = try self.reader.interface.readSliceAll(&crlf);
                        if (crlf[0] != '\r' or crlf[1] != '\n') return error.InvalidChunkEnd;
                        if (self.total_read > self.max_body_size) return error.BodyTooLarge;
                        self.state = .reading_size;
                    } else {
                        break;
                    }
                },
                .reading_trailer, .done => {
                    self.state = .done;
                    return 0;
                },
            }
        }
        return total;
    }

    pub fn deinit(ctx: *anyopaque) void {
        _ = ctx;
    }
};

const testing = std.testing;

test "StringReaderCtx - basic reads and vector bounds" {
    const alloc = testing.allocator;

    const data = try alloc.dupe(u8, "Hello, Zig 0.16!");

    const ctx = try alloc.create(StringReaderCtx);
    ctx.* = .{
        .data = data,
        .allocator = alloc,
    };

    const reader = Reader{
        .ctx = ctx,
        .readFn = StringReaderCtx.read,
        .deinitFn = StringReaderCtx.deinit,
    };
    defer reader.deinit();

    var buf1: [7]u8 = undefined;
    var buf2: [4]u8 = undefined;
    const slices = [_][]u8{ &buf1, &buf2 };

    const n = try reader.read(&slices);
    try testing.expectEqual(@as(usize, 11), n);
    try testing.expectEqualStrings("Hello, ", &buf1);
    try testing.expectEqualStrings("Zig ", &buf2);

    var buf3: [10]u8 = undefined;
    const slices2 = [_][]u8{&buf3};
    const n2 = try reader.read(&slices2);

    try testing.expectEqual(@as(usize, 5), n2);
    try testing.expectEqualStrings("0.16!", buf3[0..5]);

    const n3 = try reader.read(&slices2);
    try testing.expectEqual(@as(usize, 0), n3);
}

test "FileReaderCtx - tracks offsets correctly" {
    const alloc = testing.allocator;
    const tmp_dir = testing.tmpDir(.{});
    var tmp = tmp_dir;
    defer tmp.cleanup();

    const file_name = "test_data.txt";

    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    try tmp.dir.writeFile(io, .{ .sub_path = file_name, .data = "File Content Test" });
    const io_file = try tmp.dir.openFile(io, file_name, .{});

    const size_str = try alloc.dupe(u8, "17");

    const ctx = try alloc.create(FileReaderCtx);
    ctx.* = .{
        .file = io_file,
        .allocator = alloc,
        .io = io,
        .size_str = size_str,
        .offset = 0,
    };

    const reader = Reader{
        .ctx = ctx,
        .readFn = FileReaderCtx.read,
        .deinitFn = FileReaderCtx.deinit,
    };
    defer reader.deinit();

    var buf: [12]u8 = undefined;
    const slices = [_][]u8{&buf};

    const n = try reader.read(&slices);
    try testing.expectEqual(@as(usize, 12), n);
    try testing.expectEqualStrings("File Content", &buf);

    try testing.expectEqual(@as(u64, 12), ctx.offset);
}

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

test "ChunkReaderCtx - single chunk, exact buffer" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "5\r\nHello\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [5]u8 = undefined;
    const slices = [_][]u8{&buf};
    const n = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 5), n);
    try testing.expectEqualStrings("Hello", &buf);

    const n2 = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 0), n2);
}

test "ChunkReaderCtx - multiple chunks, vector reads" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "4\r\nWiki\r\n5\r\npedia\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf1: [4]u8 = undefined;
    var buf2: [2]u8 = undefined;
    var buf3: [3]u8 = undefined;
    const slices = [_][]u8{ &buf1, &buf2, &buf3 };
    const n = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 9), n);
    try testing.expectEqualStrings("Wiki", &buf1);
    try testing.expectEqualStrings("pe", &buf2);
    try testing.expectEqualStrings("dia", &buf3);

    const n2 = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 0), n2);
}

test "ChunkReaderCtx - empty lines and spaces around size" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "\r\n  \t 3 \t \r\nABC\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [3]u8 = undefined;
    const slices = [_][]u8{&buf};
    const n = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 3), n);
    try testing.expectEqualStrings("ABC", &buf);
}

test "ChunkReaderCtx - trailer skipping" {
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
    const data = "4\r\nTest\r\n0\r\nX-Header: value\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [128]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [4]u8 = undefined;
    const slices = [_][]u8{&buf};
    const n = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 4), n);
    try testing.expectEqualStrings("Test", &buf);

    const n2 = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 0), n2);
}

test "ChunkReaderCtx - body size exceeds max_body_size" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "6\r\nABCDEF\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 5 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [6]u8 = undefined;
    const slices = [_][]u8{&buf};
    const result = chunk_reader.read(&slices);
    try testing.expectError(error.BodyTooLarge, result);
}

test "ChunkReaderCtx - invalid chunk size (non-hex)" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "GG\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [10]u8 = undefined;
    const slices = [_][]u8{&buf};
    const result = chunk_reader.read(&slices);
    try testing.expectError(error.InvalidChunkSize, result);
}

test "ChunkReaderCtx - missing CRLF after chunk data" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "3\r\nABCX\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [3]u8 = undefined;
    const slices = [_][]u8{&buf};
    const result = chunk_reader.read(&slices);
    try testing.expectError(error.InvalidChunkEnd, result);
}

test "ChunkReaderCtx - line too long in size line" {
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
    const line = "1" ** 63 ++ "\r\n";
    try feedAndClose(io, &writer_stream, line, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [1]u8 = undefined;
    const slices = [_][]u8{&buf};
    const result = chunk_reader.read(&slices);
    try testing.expectError(error.LineTooLong, result);
}

test "ChunkReaderCtx - short reads (1 byte at a time)" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "2\r\nAB\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [2]u8 = undefined;
    const slices = [_][]u8{&buf};
    const n = try chunk_reader.read(&slices);
    try testing.expectEqual(@as(usize, 2), n);
    try testing.expectEqualStrings("AB", &buf);
}

test "ChunkReaderCtx - unexpected end of stream while reading size" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "3\r";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [10]u8 = undefined;
    const slices = [_][]u8{&buf};
    const result = chunk_reader.read(&slices);
    try testing.expectError(error.UnexpectedEndOfStream, result);
}

test "ChunkReaderCtx - unexpected end of stream during trailer skip" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "3\r\nABC\r\n0\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [3]u8 = undefined;
    const slices = [_][]u8{&buf};
    _ = try chunk_reader.read(&slices);

    const result = chunk_reader.read(&slices);
    try testing.expectError(error.UnexpectedEndOfStream, result);
}

test "ChunkReaderCtx - deinit is a no-op" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();
}

test "ChunkReaderCtx - max_body_size triggers after chunk data CRLF" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "6\r\nABCDEF\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 5 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [6]u8 = undefined;
    const slices = [_][]u8{&buf};
    try testing.expectError(error.BodyTooLarge, chunk_reader.read(&slices));
}

test "ChunkReaderCtx - reading after done returns 0" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const pair = try loopbackPair(io);
    var reader_stream = pair.reader_stream;
    var writer_stream = pair.writer_stream;
    defer reader_stream.close(io);
    defer writer_stream.close(io);

    var write_buf: [64]u8 = undefined;
    const data = "3\r\nXYZ\r\n0\r\n\r\n";
    try feedAndClose(io, &writer_stream, data, &write_buf);

    var read_buf: [64]u8 = undefined;
    var sr = reader_stream.reader(io, &read_buf);
    var ctx = ChunkReaderCtx{ .reader = &sr, .max_body_size = 1024 };
    var chunk_reader = Reader{ .ctx = &ctx, .readFn = ChunkReaderCtx.read, .deinitFn = ChunkReaderCtx.deinit };
    defer chunk_reader.deinit();

    var buf: [3]u8 = undefined;
    const slices = [_][]u8{&buf};
    _ = try chunk_reader.read(&slices);

    var buf2: [1]u8 = undefined;
    const slices2 = [_][]u8{&buf2};
    const n = try chunk_reader.read(&slices2);
    try testing.expectEqual(@as(usize, 0), n);
}
