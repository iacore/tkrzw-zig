const std = @import("std");

pub fn link(exe: *std.build.LibExeObjStep) void {
    // MYLIBOBJFILES="tkrzw_lib_common.o tkrzw_str_util.o tkrzw_hash_util.o tkrzw_time_util.o tkrzw_compress.o tkrzw_file_util.o tkrzw_file_std.o tkrzw_file_mmap.o tkrzw_file_pos.o tkrzw_file_poly.o tkrzw_message_queue.o tkrzw_dbm.o tkrzw_dbm_ulog.o tkrzw_dbm_common_impl.o tkrzw_dbm_hash_impl.o tkrzw_dbm_hash.o tkrzw_dbm_tree_impl.o tkrzw_dbm_tree.o tkrzw_dbm_skip_impl.o tkrzw_dbm_skip.o tkrzw_dbm_tiny.o tkrzw_dbm_baby.o tkrzw_dbm_cache.o tkrzw_dbm_std.o tkrzw_dbm_poly.o tkrzw_dbm_shard.o tkrzw_dbm_async.o tkrzw_cmd_util.o tkrzw_langc.o"
    const sep = std.fs.path.sep_str;
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

    const run_example_step = b.step("example", "Run example");
    run_example_step.dependOn(&exe.run().step);

    // const lib = b.addStaticLibrary("tkrzw-zig", "src/main.zig");
    // lib.setBuildMode(mode);
    // lib.install();

    // const main_tests = b.addTest("src/example.zig");
    // main_tests.setBuildMode(mode);

    // const test_step = b.step("test", "Run library tests");
    // test_step.dependOn(&main_tests.step);
}
