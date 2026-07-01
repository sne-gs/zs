const std = @import("std");
const Headers = @import("headers.zig").Headers;
const Reader = @import("reader.zig").Reader;
const Writer = @import("writer.zig").Writer;
const init = @import("headers.zig").init;

pub const Response = struct {
    pub const Owned = struct {
        ptr: []u8,
        allocator: std.mem.Allocator,
    };

    pub const Body = union(enum) {
        static: []const u8,
        owned: Owned,
        reader: Reader,
        writer: Writer,
        empty,
    };

    pub const ContentType = enum {
        json,
        html,
        text,
        pub fn asString(self: ContentType) []const u8 {
            return switch (self) {
                .json => "application/json",
                .html => "text/html",
                .text => "text/plain",
            };
        }
    };

    _status: std.http.Status = .ok,
    _body: Body = .empty,
    _headers: Headers = init(),

    pub fn status(value: std.http.Status) Response {
        return Response{ ._status = value };
    }

    pub fn content(self: Response, value: ContentType) Response {
        var res = self;
        res._headers.set("content-type", value.asString());
        return res;
    }

    pub fn static(self: Response, value: []const u8) Response {
        var res = self;
        res._body = .{ .static = value };
        return res;
    }

    pub fn owned(self: Response, ptr: []u8, allocator: std.mem.Allocator) Response {
        var res = self;
        res._body = .{ .owned = .{ .ptr = ptr, .allocator = allocator } };
        return res;
    }

    pub fn reader(self: Response, value: Reader) Response {
        var res = self;
        res._body = .{ .reader = value };
        return res;
    }

    pub fn writer(self: Response, value: Writer) Response {
        var res = self;
        res._body = .{ .writer = value };
        return res;
    }

    pub fn empty(self: Response) Response {
        var res = self;
        res._body = .empty;
        return res;
    }

    pub fn header(self: Response, name: []const u8, value: []const u8) Response {
        var res = self;
        res._headers.set(name, value);
        return res;
    }

    pub fn deinit(self: *const Response) void {
        switch (self._body) {
            .owned => |o| o.allocator.free(o.ptr),
            .reader => |r| r.deinit(),
            .writer => |w| w.deinit(),
            else => {},
        }
    }
};

const testing = std.testing;

const MockCtx = struct {
    deinit_called: bool = false,
};

fn mockReaderDeinit(ctx: *anyopaque) void {
    const self = @as(*MockCtx, @ptrCast(@alignCast(ctx)));
    self.deinit_called = true;
}

fn mockWriterDeinit(ctx: *anyopaque) void {
    const self = @as(*MockCtx, @ptrCast(@alignCast(ctx)));
    self.deinit_called = true;
}

fn dummyRead(ctx: *anyopaque, buffer: []const []u8) anyerror!usize {
    _ = ctx;
    _ = buffer;
    return 0;
}

fn dummyWrite(ctx: *anyopaque, w: *std.Io.net.Stream.Writer) anyerror!void {
    _ = ctx;
    _ = w;
}

fn makeMockReader(allocator: std.mem.Allocator) !Reader {
    const ctx = try allocator.create(MockCtx);
    ctx.* = .{};
    return Reader{
        .ctx = ctx,
        .readFn = dummyRead,
        .deinitFn = mockReaderDeinit,
    };
}

fn makeMockWriter(allocator: std.mem.Allocator) !Writer {
    const ctx = try allocator.create(MockCtx);
    ctx.* = .{};
    return Writer{
        .ctx = ctx,
        .writeFn = dummyWrite,
        .deinitFn = mockWriterDeinit,
    };
}

test "ContentType.asString" {
    try testing.expectEqualStrings("application/json", Response.ContentType.json.asString());
    try testing.expectEqualStrings("text/html", Response.ContentType.html.asString());
    try testing.expectEqualStrings("text/plain", Response.ContentType.text.asString());
}

test "Response.status" {
    const res = Response.status(.not_found);
    try testing.expectEqual(std.http.Status.not_found, res._status);
}

test "Response.content" {
    const res = Response.status(.ok).content(.json);
    try testing.expectEqualStrings("application/json", res._headers.get("content-type").?);
}

test "Response.content override" {
    const res = Response.status(.ok).content(.html).content(.text);
    try testing.expectEqualStrings("text/plain", res._headers.get("content-type").?);
}

test "Response.static" {
    const data = "hello";
    const res = Response.status(.ok).static(data);
    try testing.expectEqualStrings(data, res._body.static);
}

test "Response.owned" {
    const alloc = testing.allocator;
    const data = try alloc.dupe(u8, "owned");
    const res = Response.status(.ok).owned(data, alloc);
    try testing.expectEqual(data, res._body.owned.ptr);
    try testing.expectEqual(alloc, res._body.owned.allocator);
    res.deinit();
}

test "Response.reader" {
    const alloc = testing.allocator;
    const reader = try makeMockReader(alloc);
    defer alloc.destroy(@as(*MockCtx, @ptrCast(@alignCast(reader.ctx))));
    const res = Response.status(.ok).reader(reader);
    try testing.expect(res._body == .reader);
}

test "Response.writer" {
    const alloc = testing.allocator;
    const writer = try makeMockWriter(alloc);
    defer alloc.destroy(@as(*MockCtx, @ptrCast(@alignCast(writer.ctx))));
    const res = Response.status(.ok).writer(writer);
    try testing.expect(res._body == .writer);
}

test "Response.empty" {
    const res = Response.status(.ok).static("x").empty();
    try testing.expect(res._body == .empty);
}

test "Response.header" {
    const res = Response.status(.ok).header("X-Test", "val");
    try testing.expectEqualStrings("val", res._headers.get("X-Test").?);
}

test "Response.header multiple" {
    const res = Response.status(.ok).header("A", "1").header("B", "2");
    try testing.expectEqualStrings("1", res._headers.get("A").?);
    try testing.expectEqualStrings("2", res._headers.get("B").?);
}

test "Response.deinit empty" {
    Response.status(.ok).empty().deinit();
}

test "Response.deinit static" {
    Response.status(.ok).static("abc").deinit();
}

test "Response.deinit owned frees memory" {
    const alloc = testing.allocator;
    const data = try alloc.dupe(u8, "owned");
    const res = Response.status(.ok).owned(data, alloc);
    res.deinit();
}

test "Response.deinit reader" {
    const alloc = testing.allocator;
    const reader = try makeMockReader(alloc);
    const mock = @as(*MockCtx, @ptrCast(@alignCast(reader.ctx)));
    defer alloc.destroy(mock);

    const res = Response.status(.ok).reader(reader);
    res.deinit();
    try testing.expect(mock.deinit_called);
}

test "Response.deinit writer" {
    const alloc = testing.allocator;
    const writer = try makeMockWriter(alloc);
    const mock = @as(*MockCtx, @ptrCast(@alignCast(writer.ctx)));
    defer alloc.destroy(mock);

    const res = Response.status(.ok).writer(writer);
    res.deinit();
    try testing.expect(mock.deinit_called);
}

test "Response chaining" {
    const alloc = testing.allocator;
    const data = try alloc.dupe(u8, "chain");
    defer alloc.free(data);
    const res = Response.status(.created)
        .content(.json)
        .header("X-Id", "42")
        .owned(data, alloc);
    try testing.expectEqual(std.http.Status.created, res._status);
    try testing.expectEqualStrings("application/json", res._headers.get("content-type").?);
    try testing.expectEqualStrings("42", res._headers.get("X-Id").?);
    try testing.expectEqual(data, res._body.owned.ptr);
}
