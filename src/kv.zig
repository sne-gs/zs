const std = @import("std");

pub fn KeyValueStore(comptime max: usize) type {
    return struct {
        const Self = @This();

        items: [max]std.http.Header = undefined,
        count: usize = 0,

        pub fn set(self: *Self, key: []const u8, value: []const u8) void {
            for (self.items[0..self.count]) |*item| {
                if (eql(item.name, key)) {
                    item.value = value;
                    return;
                }
            }
            if (self.count < self.items.len) {
                self.items[self.count] = .{ .name = key, .value = value };
                self.count += 1;
            }
        }

        pub fn get(self: Self, key: []const u8) ?[]const u8 {
            for (self.items[0..self.count]) |item| {
                if (eql(item.name, key)) return item.value;
            }
            return null;
        }

        pub fn slice(self: *const Self) []const std.http.Header {
            return self.items[0..self.count];
        }

        fn eql(a: []const u8, b: []const u8) bool {
            return std.ascii.eqlIgnoreCase(a, b);
        }
    };
}

const testing = std.testing;

test "KV set and get" {
    var kv = KeyValueStore(4){};
    kv.set("Content-Type", "text/html");
    try testing.expectEqualStrings("text/html", kv.get("Content-Type").?);
}

test "KV get missing key returns null" {
    var kv = KeyValueStore(2){};
    try testing.expectEqual(@as(?[]const u8, null), kv.get("Missing"));
}

test "KV set overwrites existing key" {
    var kv = KeyValueStore(2){};
    kv.set("Accept", "json");
    kv.set("Accept", "xml");
    try testing.expectEqualStrings("xml", kv.get("Accept").?);
}

test "KV key lookup is case-insensitive" {
    var kv = KeyValueStore(2){};
    kv.set("Content-Type", "text/html");
    try testing.expectEqualStrings("text/html", kv.get("content-type").?);
    try testing.expectEqualStrings("text/html", kv.get("CONTENT-TYPE").?);
}

test "KV set beyond max capacity is ignored" {
    var kv = KeyValueStore(2){};
    kv.set("A", "1");
    kv.set("B", "2");
    kv.set("C", "3"); // should be ignored
    try testing.expectEqual(@as(usize, 2), kv.count);
    try testing.expectEqualStrings("1", kv.get("A").?);
    try testing.expectEqualStrings("2", kv.get("B").?);
    try testing.expectEqual(@as(?[]const u8, null), kv.get("C"));
}

test "KV slice returns only set items" {
    var kv = KeyValueStore(3){};
    kv.set("X", "xval");
    kv.set("Y", "yval");
    const sl = kv.slice();
    try testing.expectEqual(@as(usize, 2), sl.len);
    try testing.expectEqualStrings("X", sl[0].name);
    try testing.expectEqualStrings("xval", sl[0].value);
    try testing.expectEqualStrings("Y", sl[1].name);
    try testing.expectEqualStrings("yval", sl[1].value);
}

test "KV empty store slice is empty" {
    var kv = KeyValueStore(2){};
    try testing.expectEqual(@as(usize, 0), kv.slice().len);
}
