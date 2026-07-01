const KeyValueStore = @import("kv.zig").KeyValueStore;

pub const max_params = 8;
pub const Params = KeyValueStore(max_params);

const std = @import("std");
const testing = std.testing;

test "Params set and get" {
    var p = Params{};
    p.set("id", "42");
    try testing.expectEqualStrings("42", p.get("id").?);
}

test "Params get missing key" {
    var p = Params{};
    try testing.expectEqual(@as(?[]const u8, null), p.get("nope"));
}

test "Params respects max capacity" {
    var p = Params{};
    const keys = [_][]const u8{ "a", "b", "c", "d", "e", "f", "g", "h" }; // exactly max_params
    for (keys) |k| {
        p.set(k, "val");
    }
    try testing.expectEqual(@as(usize, max_params), p.count);
    p.set("extra", "fail");
    try testing.expectEqual(@as(?[]const u8, null), p.get("extra"));
}
