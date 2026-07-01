const std = @import("std");

pub fn percentDecode(encoded: []const u8, buf: []u8) ![]u8 {
    var i: usize = 0;
    var j: usize = 0;
    while (i < encoded.len) {
        if (encoded[i] == '%') {
            if (i + 2 >= encoded.len) return error.InvalidPercentEncoding;
            const hex_str = encoded[i + 1 .. i + 3];
            const byte = try std.fmt.parseInt(u8, hex_str, 16);
            if (j >= buf.len) return error.BufferTooSmall;
            buf[j] = byte;
            j += 1;
            i += 3;
        } else if (encoded[i] == '+') {
            if (j >= buf.len) return error.BufferTooSmall;
            buf[j] = ' ';
            j += 1;
            i += 1;
        } else {
            if (j >= buf.len) return error.BufferTooSmall;
            buf[j] = encoded[i];
            j += 1;
            i += 1;
        }
    }
    return buf[0..j];
}

pub fn getUrlEncodedValue(body: []const u8, key: []const u8, buf: []u8) !?[]u8 {
    var pairs = std.mem.splitScalar(u8, body, '&');
    while (pairs.next()) |pair| {
        var kv = std.mem.splitScalar(u8, pair, '=');
        const k = kv.next() orelse continue;
        if (std.mem.eql(u8, k, key)) {
            const enc_val = kv.next() orelse "";
            return try percentDecode(enc_val, buf);
        }
    }
    return null;
}

test "percentDecode" {
    var buf: [64]u8 = undefined;
    const decoded = try percentDecode("hello%20world%21", &buf);
    try std.testing.expectEqualSlices(u8, "hello world!", decoded);
}

test "getUrlEncodedValue" {
    const body = "name=John+Doe&city=Paris%20France";
    var buf: [64]u8 = undefined;
    const name = try getUrlEncodedValue(body, "name", &buf);
    try std.testing.expectEqualSlices(u8, "John Doe", name.?);
    const city = try getUrlEncodedValue(body, "city", &buf);
    try std.testing.expectEqualSlices(u8, "Paris France", city.?);
    const missing = try getUrlEncodedValue(body, "missing", &buf);
    try std.testing.expect(missing == null);
}
