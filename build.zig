const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const hparse_dep = b.dependency("hparse", .{
        .target = target,
        .optimize = optimize,
    });
    const hparse_module = hparse_dep.module("hparse");

    const test_mod = b.addModule("test_zs", .{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "hparse", .module = hparse_module },
        },
    });

    const all_tests = b.addTest(.{ .root_module = test_mod });
    const run_all_tests = b.addRunArtifact(all_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_all_tests.step);

    const coverage_step = b.step("coverage", "Generate code coverage report with kcov");

    const coverage_tests = b.addTest(.{
        .root_module = test_mod,
    });
    coverage_tests.root_module.optimize = .ReleaseSafe;

    const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out/kcov" });
    coverage_step.dependOn(&mkdir.step);

    const run_kcov = b.addSystemCommand(&.{
        "kcov",
        "--include-path=src/",
        "--exclude-pattern=/nix/store/",
        "zig-out/kcov",
    });
    run_kcov.addArtifactArg(coverage_tests);
    run_kcov.step.dependOn(&mkdir.step);
    coverage_step.dependOn(&run_kcov.step);
}
