const std = @import("std");
const KeyValueStore = @import("kv.zig").KeyValueStore;

pub const max_headers = 32;
pub const Headers = KeyValueStore(max_headers);

pub fn init() Headers {
    var h: Headers = .{};
    h.set("content-type", "text/html");
    return h;
}

const testing = std.testing;

test "Headers init sets default content-type" {
    const h = init();
    try testing.expectEqualStrings("text/html", h.get("content-type").?);
}

test "Headers set and get" {
    var h = init();
    h.set("X-Custom", "hello");
    try testing.expectEqualStrings("hello", h.get("x-custom").?);
}
