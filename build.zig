const std = @import("std");

const sep = std.fs.path.sep_str;

pub fn pkg() std.build.Pkg {
    const cwd = comptime std.fs.path.dirname(@src().file).?;
    return std.build.Pkg{
        .name = "tkrzw",
        .source = .{ .path = cwd ++ sep ++ "tkrzw.zig"}
    };
}

pub fn link(exe: *std.build.LibExeObjStep) void {
    const tkrzw_dir = comptime std.fs.path.dirname(@src().file).? ++ sep ++ "tkrzw";

    exe.addIncludePath(tkrzw_dir);
    exe.linkLibC();
    exe.linkSystemLibrary("tkrzw");

    // TODO: build from source

    // exe.linkLibCpp();
    // const static_lib_path = tkrzw_dir ++ sep ++ "libtkrzw.a";
    // exe.linkSystemLibraryName("stdc++");
    // exe.linkSystemLibraryName("rt");
    // exe.linkSystemLibraryName("atomic");
    // exe.linkSystemLibraryName("pthread");
    // exe.addLibraryPath(tkrzw_dir);
    // exe.linklibrary(static_lib_path);
}

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("tkrzw-zig-example", "src/example.zig");
    exe.setBuildMode(mode);
    exe.install();

    link(exe);
    exe.addPackage(pkg());

    const run_example_step = b.step("run-example", "Run example");
    run_example_step.dependOn(&exe.run().step);

    // const lib = b.addStaticLibrary("tkrzw-zig", "src/main.zig");
    // lib.setBuildMode(mode);
    // lib.install();

    // const main_tests = b.addTest("src/example.zig");
    // main_tests.setBuildMode(mode);

    // const test_step = b.step("test", "Run library tests");
    // test_step.dependOn(&main_tests.step);
}
