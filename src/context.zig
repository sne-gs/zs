const std = @import("std");
const Request = @import("request.zig").Request;
const Response = @import("response.zig").Response;

pub fn Context(comptime Env: type, comptime Ext: type) type {
    return struct {
        const Self = @This();
        req: Request,
        env: Env,
        ext: Ext,

        pub fn init(
            req: Request,
            env: Env,
            ext: Ext,
        ) Self {
            return .{
                .req = req,
                .env = env,
                .ext = ext,
            };
        }
    };
}
