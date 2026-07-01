const std = @import("std");

pub const Writer = struct {
    ctx: *anyopaque,
    writeFn: *const fn (ctx: *anyopaque, w: *std.Io.net.Stream.Writer) anyerror!void,
    deinitFn: ?*const fn (ctx: *anyopaque) void = null,

    pub fn write(self: Writer, w: *std.Io.net.Stream.Writer) anyerror!void {
        return self.writeFn(self.ctx, w);
    }

    pub fn deinit(self: Writer) void {
        if (self.deinitFn) |f| f(self.ctx);
    }
};

const testing = std.testing;

const MockCtx = struct {
    write_called: bool = false,
    writer_ptr: ?*std.Io.net.Stream.Writer = null,
    deinit_called: bool = false,
};

fn mockWrite(ctx: *anyopaque, w: *std.Io.net.Stream.Writer) anyerror!void {
    const self = @as(*MockCtx, @ptrCast(@alignCast(ctx)));
    self.write_called = true;
    self.writer_ptr = w;
}

fn mockWriteFail(ctx: *anyopaque, w: *std.Io.net.Stream.Writer) anyerror!void {
    _ = ctx;
    _ = w;
    return error.SomeError;
}

fn mockDeinit(ctx: *anyopaque) void {
    const self = @as(*MockCtx, @ptrCast(@alignCast(ctx)));
    self.deinit_called = true;
}

test "Writer.write calls writeFn with correct ctx and writer pointer" {
    var mock = MockCtx{};
    const writer = Writer{
        .ctx = &mock,
        .writeFn = mockWrite,
    };

    var dummy_writer: std.Io.net.Stream.Writer = undefined;
    try writer.write(&dummy_writer);

    try testing.expect(mock.write_called);
    try testing.expectEqual(&dummy_writer, mock.writer_ptr);
}

test "Writer.write propagates error from writeFn" {
    var mock = MockCtx{};
    const writer = Writer{
        .ctx = &mock,
        .writeFn = mockWriteFail,
    };

    var dummy_writer: std.Io.net.Stream.Writer = undefined;
    try testing.expectError(error.SomeError, writer.write(&dummy_writer));
}

test "Writer.deinit calls deinitFn when present" {
    var mock = MockCtx{};
    const writer = Writer{
        .ctx = &mock,
        .writeFn = mockWrite,
        .deinitFn = mockDeinit,
    };

    writer.deinit();
    try testing.expect(mock.deinit_called);
}

test "Writer.deinit without deinitFn is safe" {
    var mock = MockCtx{};
    const writer = Writer{
        .ctx = &mock,
        .writeFn = mockWrite,
        .deinitFn = null,
    };

    writer.deinit();
}
