const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const wuffs_dep = b.dependency("wuffs", .{});

    const wuffs_lib = b.addLibrary(.{
        .name = "wuffs",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    wuffs_lib.addCSourceFile(.{
        .file = wuffs_dep.path("release/c/wuffs-v0.4.c"),
        .flags = &.{"-DWUFFS_IMPLEMENTATION"},
    });
    wuffs_lib.installHeader(wuffs_dep.path("release/c/wuffs-v0.4.c"), "wuffs.h");
    b.installArtifact(wuffs_lib);

    const wuffs_translatec = b.addTranslateC(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .root_source_file = wuffs_dep.path("release/c/wuffs-v0.4.c"),
    });

    const wuffs_mod = wuffs_translatec.addModule("wuffs");
    wuffs_mod.linkLibrary(wuffs_lib);
}
