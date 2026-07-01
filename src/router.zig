const std = @import("std");
const Params = @import("params.zig").Params;
const hparse = @import("hparse");

pub fn Route(comptime HandlerId: type) type {
    return struct {
        method: hparse.Method,
        path: []const u8,
        handler: HandlerId,
    };
}

fn isParamSegment(seg: []const u8) bool {
    return seg.len > 2 and seg[0] == '{' and seg[seg.len - 1] == '}';
}

fn toLower(comptime name: []const u8) *const [name.len]u8 {
    comptime var lowered: [name.len]u8 = undefined;
    inline for (name, 0..) |c, i| {
        lowered[i] = std.ascii.toLower(c);
    }
    return &lowered;
}

pub const RouterOptions = struct {
    max_nodes: usize = 128,
    max_children_per_node: usize = 8,
    max_params: usize = 8,
    max_segments_per_path: usize = 16,
};

pub fn TrieRouter(
    comptime HandlerId: type,
    comptime route_list: []const Route(HandlerId),
    comptime opts: RouterOptions,
) type {
    @setEvalBranchQuota(50_000);

    comptime {
        var max_params_found: usize = 0;
        for (route_list) |r| {
            var count: usize = 0;
            var it = std.mem.splitScalar(u8, r.path, '/');
            while (it.next()) |seg| {
                if (isParamSegment(seg)) count += 1;
            }
            max_params_found = @max(max_params_found, count);
        }
        if (max_params_found > opts.max_params) {
            @compileError("Route contains " ++ @as([]const u8, @typeName(max_params_found)) ++
                " parameters, but max_params is " ++ @typeName(opts.max_params));
        }
    }

    const Node = struct {
        segment: []const u8,
        is_param: bool,
        handlers: std.EnumArray(hparse.Method, ?HandlerId) = std.EnumArray(hparse.Method, ?HandlerId).initFill(null),
        children: [opts.max_children_per_node]u16 = undefined,
        children_len: u8 = 0,

        fn addChild(self: *@This(), child_idx: u16) void {
            if (self.children_len >= self.children.len) {
                @compileError("Node has too many children. Increase max_children_per_node.");
            }
            self.children[self.children_len] = child_idx;
            self.children_len += 1;
        }
    };

    comptime var nodes: [opts.max_nodes]Node = undefined;
    comptime var node_count: usize = 1;
    nodes[0] = .{ .segment = "/", .is_param = false };

    for (route_list) |route| {
        var segs: [opts.max_segments_per_path][]const u8 = undefined;
        var seg_count: usize = 0;

        var it = std.mem.splitScalar(u8, route.path, '/');

        while (it.next()) |seg| {
            if (seg.len == 0) continue;
            if (seg_count >= opts.max_segments_per_path) {
                @compileError("Too many segments in path: " ++ route.path);
            }
            segs[seg_count] = seg;
            seg_count += 1;
        }

        if (seg_count == 0) {
            if (nodes[0].handlers.get(route.method) != null) {
                @compileError("Duplicate route: / for method " ++ @tagName(route.method));
            }
            nodes[0].handlers.set(route.method, route.handler);
            continue;
        }

        var parent_idx: usize = 0;
        for (0..seg_count) |i| {
            const current_seg = segs[i];
            const is_last = (i == seg_count - 1);
            const is_param = isParamSegment(current_seg);
            const seg_to_use = if (is_param) blk: {
                const raw_name = current_seg[1 .. current_seg.len - 1];
                for (raw_name) |c| {
                    if (!std.ascii.isAlphanumeric(c) and c != '_') {
                        @compileError("Invalid parameter name (must be alphanumeric/underscore): " ++ current_seg);
                    }
                }
                const lower = toLower(raw_name);
                const param_seg = "{" ++ lower ++ "}";
                break :blk param_seg;
            } else current_seg;

            var found_child: ?usize = null;

            if (!is_param) {
                for (0..nodes[parent_idx].children_len) |j| {
                    const child_idx = nodes[parent_idx].children[j];
                    const child = nodes[child_idx];
                    if (!child.is_param and std.mem.eql(u8, child.segment, seg_to_use)) {
                        found_child = child_idx;
                        break;
                    }
                }
            } else {
                for (0..nodes[parent_idx].children_len) |j| {
                    const child_idx = nodes[parent_idx].children[j];
                    const child = nodes[child_idx];
                    if (child.is_param) {
                        if (!std.mem.eql(u8, child.segment, seg_to_use)) {
                            @compileError("Parameter collision: expected " ++ child.segment ++ ", found " ++ seg_to_use);
                        }
                        found_child = child_idx;
                        break;
                    }
                }
            }

            if (found_child) |child_idx| {
                parent_idx = child_idx;
                if (is_last) {
                    if (nodes[parent_idx].handlers.get(route.method) != null) {
                        @compileError("Duplicate route: " ++ route.path ++ " for method " ++ @tagName(route.method));
                    }
                    nodes[parent_idx].handlers.set(route.method, route.handler);
                }
            } else {
                if (node_count >= opts.max_nodes) {
                    @compileError("Router exceeded max_nodes limit. Increase max_nodes.");
                }
                const new_idx = node_count;
                node_count += 1;
                nodes[new_idx] = .{
                    .segment = seg_to_use,
                    .is_param = is_param,
                };
                nodes[parent_idx].addChild(@intCast(new_idx));
                parent_idx = new_idx;

                if (is_last) {
                    nodes[parent_idx].handlers.set(route.method, route.handler);
                }
            }
        }
    }

    const PackedArray = [node_count]Node;
    const final_nodes: PackedArray = blk: {
        var temp: PackedArray = undefined;
        for (0..node_count) |i| temp[i] = nodes[i];
        break :blk temp;
    };

    const MatchResult = union(enum) {
        match: HandlerId,
        method_not_allowed: std.EnumArray(hparse.Method, ?HandlerId),
        not_found,
    };

    return struct {
        pub fn match(
            method: hparse.Method,
            path: []const u8,
            params: *Params,
        ) MatchResult {
            const clean = std.mem.trim(u8, path, "/");
            const it = std.mem.splitScalar(u8, clean, '/');

            return matchStep(0, method, it, params);
        }

        fn matchStep(
            comptime node_idx: usize,
            method: hparse.Method,
            it: std.mem.SplitIterator(u8, .scalar),
            params: *Params,
        ) MatchResult {
            const node = comptime final_nodes[node_idx];

            var next_it = it;

            const current_seg = while (next_it.next()) |seg| {
                if (seg.len > 0) break seg;
            } else null;

            if (current_seg == null) {
                if (node.handlers.get(method)) |h| return .{ .match = h };

                inline for (std.enums.values(hparse.Method)) |m| {
                    if (node.handlers.get(m) != null) return .{ .method_not_allowed = node.handlers };
                }
                return .not_found;
            }

            const seg = current_seg.?;

            inline for (0..node.children_len) |i| {
                const child_idx = node.children[i];
                const child = comptime final_nodes[child_idx];

                if (!child.is_param and std.mem.eql(u8, child.segment, seg)) {
                    const res = matchStep(child_idx, method, next_it, params);
                    if (res != .not_found) return res;
                }
            }

            const param_child_idx = comptime blk: {
                var idx: ?usize = null;
                for (0..node.children_len) |i| {
                    const child_idx = node.children[i];
                    if (final_nodes[child_idx].is_param) {
                        if (idx != null) @compileError("Multiple parameter children");
                        idx = child_idx;
                    }
                }
                break :blk idx;
            };

            if (param_child_idx) |par| {
                const res = matchStep(par, method, next_it, params);

                switch (res) {
                    .match, .method_not_allowed => {
                        const child = comptime final_nodes[par];
                        const param_name = child.segment[1 .. child.segment.len - 1];
                        params.set(param_name, seg);
                        return res;
                    },
                    .not_found => {},
                }
            }

            return .not_found;
        }
    };
}

test "TrieRouter match simple" {
    const HandlerId = enum { home };
    const routes = [_]Route(HandlerId){
        .{ .method = .get, .path = "/home", .handler = .home },
    };
    const Router = TrieRouter(HandlerId, &routes, .{});

    var params = Params{};
    const h = Router.match(.get, "/home", &params);

    try std.testing.expect(h == .match and h.match == .home);
}
