const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const wuffs_dep = b.dependency("wuffs", .{});

    const headers = b.addTranslateC(.{
        .target = target,
        .optimize = optimize,
        .root_source_file = wuffs_dep.path("release/c/wuffs-v0.4.c"),
        .link_libc = true,
    });

    // Headers-only module, useful when depending on a system-provided shared library.
    _ = headers.addModule("headers");

    // This is the main module that contains both translated headers and implementation.
    const wuffs = b.addModule("wuffs", .{
        .root_source_file = headers.getOutput(),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    wuffs.addCSourceFile(.{
        .file = wuffs_dep.path("release/c/wuffs-v0.4.c"),
        .flags = &.{"-DWUFFS_IMPLEMENTATION"},
    });
    wuffs.sanitize_c = .off; // fixes a crash in ReleaseSafe mode at "return (*func_ptrs->decode_image_config)(self, a_dst, a_src)"

    // Same as 'wuffs' but without the translate-c stuff, added as a temporary workaround for regressions in Zig 0.16 translateC.
    const impl = b.addModule("impl", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    impl.addCSourceFile(.{
        .file = wuffs_dep.path("release/c/wuffs-v0.4.c"),
        .flags = &.{"-DWUFFS_IMPLEMENTATION"},
    });
    impl.sanitize_c = .off; // fixes a crash in ReleaseSafe mode at "return (*func_ptrs->decode_image_config)(self, a_dst, a_src)"

    const lib = b.addLibrary(.{
        .name = "wuffs",
        .linkage = .static,
        .root_module = impl,
    });
    lib.installHeader(wuffs_dep.path("release/c/wuffs-v0.4.c"), "wuffs.h");
    b.installArtifact(lib);

    const dynamic_lib = b.addLibrary(.{
        .name = "wuffs",
        .linkage = .dynamic,
        .root_module = impl,
    });
    dynamic_lib.installHeader(wuffs_dep.path("release/c/wuffs-v0.4.c"), "wuffs.h");
    b.installArtifact(dynamic_lib);
}
