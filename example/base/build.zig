const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zs_dep = b.dependency("zs", .{
        .target = target,
    });
    const zs_mod = zs_dep.module("zs");

    const zio = b.dependency("zio", .{
        .target = target,
        .optimize = optimize,
    });

    const zio_mod = zio.module("zio");

    const root_mod = b.createModule(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zs", .module = zs_mod },
            .{ .name = "zio", .module = zio_mod },
        },
    });

    const exe = b.addExecutable(.{
        .name = "base-example",
        .root_module = root_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the basic example application");
    run_step.dependOn(&run_cmd.step);
}
