const std = @import("std");
const Response = @import("response.zig").Response;
const Body = @import("response.zig").Body;
const Reader = @import("reader.zig").Reader;
const FileReaderCtx = @import("reader.zig").FileReaderCtx;

pub fn serve(
    io: std.Io,
    allocator: std.mem.Allocator,
    static_dir: []const u8,
    uri: []const u8,
    path_buf: []u8,
) !?Response {
    var remaining_uri = uri;
    while (remaining_uri.len > 0 and remaining_uri[0] == '/') {
        remaining_uri = remaining_uri[1..];
    }

    var fba = std.heap.FixedBufferAllocator.init(path_buf);
    const alloc = fba.allocator();

    const resolved_static = std.fs.path.resolve(alloc, &[_][]const u8{static_dir}) catch return null;

    const full_path = std.fs.path.resolve(alloc, &[_][]const u8{
        resolved_static,
        remaining_uri,
    }) catch return null;

    if (!std.mem.startsWith(u8, full_path, resolved_static) or
        (full_path.len > resolved_static.len and full_path[resolved_static.len] != std.fs.path.sep))
    {
        return null;
    }

    const file_stat = std.Io.Dir.cwd().statFile(io, full_path, .{}) catch return null;

    var final_path = full_path;
    if (file_stat.kind == .directory) {
        const index_path = std.fs.path.joinZ(alloc, &.{ full_path, "index.html" }) catch return null;
        if (std.Io.Dir.cwd().statFile(io, index_path, .{})) |_| {
            final_path = index_path;
        } else |_| {
            return null;
        }
    }

    const file = std.Io.Dir.cwd().openFile(io, final_path, .{ .mode = .read_only }) catch return null;
    errdefer file.close(io);

    const file_size = file.length(io) catch return null;
    const content_type = detectContentType(final_path);

    const reader, _ = try fileReader(io, allocator, file, file_size);

    var response = Response.status(.ok).reader(reader);
    response = response.header("content-type", content_type);
    return response;
}

fn fileReader(
    io: std.Io,
    allocator: std.mem.Allocator,
    file: std.Io.File,
    file_size: u64,
) !struct { Reader, []const u8 } {
    const ctx = try allocator.create(FileReaderCtx);
    errdefer allocator.destroy(ctx);

    const size_str = try std.fmt.allocPrint(allocator, "{d}", .{file_size});
    errdefer allocator.free(size_str);

    ctx.* = .{
        .file = file,
        .allocator = allocator,
        .io = io,
        .size_str = size_str,
    };

    const reader = Reader{
        .ctx = @ptrCast(ctx),
        .readFn = FileReaderCtx.read,
        .deinitFn = FileReaderCtx.deinit,
    };

    return .{ reader, size_str };
}

fn detectContentType(path: []const u8) []const u8 {
    const ext = std.fs.path.extension(path);
    if (std.mem.eql(u8, ext, ".html") or std.mem.eql(u8, ext, ".htm")) return "text/html";
    if (std.mem.eql(u8, ext, ".css")) return "text/css";
    if (std.mem.eql(u8, ext, ".js")) return "application/javascript";
    if (std.mem.eql(u8, ext, ".json")) return "application/json";
    if (std.mem.eql(u8, ext, ".png")) return "image/png";
    if (std.mem.eql(u8, ext, ".jpg") or std.mem.eql(u8, ext, ".jpeg")) return "image/jpeg";
    if (std.mem.eql(u8, ext, ".gif")) return "image/gif";
    if (std.mem.eql(u8, ext, ".svg")) return "image/svg+xml";
    if (std.mem.eql(u8, ext, ".ico")) return "image/x-icon";
    if (std.mem.eql(u8, ext, ".txt")) return "text/plain";
    return "application/octet-stream";
}

const testing = std.testing;

test "serve plain file" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();

    try tmp.dir.createDir(io, "public", .default_dir);
    defer tmp.dir.deleteTree(io, "public") catch {};

    try tmp.dir.writeFile(io, .{ .sub_path = "public/hello.txt", .data = "Hello, static world!" });

    const static_dir = try tmp.dir.openDir(io, "public", .{ .iterate = false });
    defer static_dir.close(io);

    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const static_path_str = path_buffer[0..try static_dir.realPath(io, &path_buffer)];

    var path_buf: [1024]u8 = undefined;
    const res = (try serve(io, alloc, static_path_str, "/hello.txt", &path_buf)).?;
    defer res.deinit();

    try testing.expectEqual(std.http.Status.ok, res._status);
    try testing.expectEqualStrings("text/plain", res._headers.get("content-type").?);

    var body_buf: [4096]u8 = undefined;
    const n = try res._body.reader.read(&.{body_buf[0..]});
    try testing.expectEqualStrings("Hello, static world!", body_buf[0..n]);
}

test "serve directory with index.html" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();

    try tmp.dir.createDir(io, "site", .default_dir);
    defer tmp.dir.deleteTree(io, "site") catch {};

    try tmp.dir.writeFile(io, .{ .sub_path = "site/index.html", .data = "<h1>Index</h1>" });

    const static_dir = try tmp.dir.openDir(io, "site", .{ .iterate = false });
    defer static_dir.close(io);

    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const static_path_str = path_buffer[0..try static_dir.realPath(io, &path_buffer)];

    var path_buf: [1024]u8 = undefined;
    const res = (try serve(io, alloc, static_path_str, "/", &path_buf)).?;
    defer res.deinit();

    try testing.expectEqual(std.http.Status.ok, res._status);
    try testing.expectEqualStrings("text/html", res._headers.get("content-type").?);

    var body_buf: [4096]u8 = undefined;
    const n = try res._body.reader.read(&.{body_buf[0..]});
    try testing.expectEqualStrings("<h1>Index</h1>", body_buf[0..n]);
}

test "serve directory without index.html returns null" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();

    try tmp.dir.createDir(io, "empty_dir", .default_dir);
    defer tmp.dir.deleteTree(io, "empty_dir") catch {};

    const static_dir = try tmp.dir.openDir(io, "empty_dir", .{ .iterate = false });
    defer static_dir.close(io);

    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const static_path_str = path_buffer[0..try static_dir.realPath(io, &path_buffer)];

    var path_buf: [1024]u8 = undefined;
    const maybe = try serve(io, alloc, static_path_str, "/", &path_buf);
    try testing.expect(maybe == null);
}

test "serve file not found returns null" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();

    try tmp.dir.createDir(io, "files", .default_dir);
    defer tmp.dir.deleteTree(io, "files") catch {};

    const static_dir = try tmp.dir.openDir(io, "files", .{ .iterate = false });
    defer static_dir.close(io);

    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const static_path_str = path_buffer[0..try static_dir.realPath(io, &path_buffer)];

    var path_buf: [1024]u8 = undefined;
    const maybe = try serve(io, alloc, static_path_str, "/missing.txt", &path_buf);
    try testing.expect(maybe == null);
}

test "path traversal attempt returns null" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();

    // Create a file outside the static directory
    try tmp.dir.writeFile(io, .{ .sub_path = "secret.txt", .data = "secret" });

    try tmp.dir.createDir(io, "public", .default_dir);
    defer tmp.dir.deleteTree(io, "public") catch {};

    const static_dir = try tmp.dir.openDir(io, "public", .{ .iterate = false });
    defer static_dir.close(io);

    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const static_path_str = path_buffer[0..try static_dir.realPath(io, &path_buffer)];

    var path_buf: [1024]u8 = undefined;
    const maybe = try serve(io, alloc, static_path_str, "/../secret.txt", &path_buf);
    try testing.expect(maybe == null);
}

test "content type detection" {
    const alloc = testing.allocator;
    var threaded = std.Io.Threaded.init(alloc, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var tmp = testing.tmpDir(.{});
    defer tmp.cleanup();

    try tmp.dir.createDir(io, "static", .default_dir);
    defer tmp.dir.deleteTree(io, "static") catch {};

    try tmp.dir.writeFile(io, .{ .sub_path = "static/app.js", .data = "console.log('hi');" });

    const static_dir = try tmp.dir.openDir(io, "static", .{ .iterate = false });
    defer static_dir.close(io);

    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const static_path_str = path_buffer[0..try static_dir.realPath(io, &path_buffer)];

    var path_buf: [1024]u8 = undefined;
    const res = (try serve(io, alloc, static_path_str, "/app.js", &path_buf)).?;
    defer res.deinit();

    try testing.expectEqualStrings("application/javascript", res._headers.get("content-type").?);
}
