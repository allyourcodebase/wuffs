[Wuffs](https://github.com/google/wuffs) file loading library packaged for zig

# Usage

For zig 0.13.0, packages wuffs version 0.4.0-alpha.9+3837.20240914

```
zig fetch --save=wuffs git+https://github.com/allyourcodebase/wuffs
```

Then, choose one:

## Option 1: Statically linking wuffs

build.zig:

```
const wuffs = b.dependency("wuffs", .{.target = target, .optimize = optimize});
exe.linkLibrary(wuffs.artifact("wuffs"));
```

c:

```
#include <wuffs.h>
```

## Option 2: Using from zig with automatic translate-c bindings

build.zig:

```
const wuffs = b.dependency("wuffs", .{.target = target, .optimize = optimize});
exe.root_module.addImport("wuffs", wuffs.module("wuffs"));
```

zig:

```
const wuffs = @import("wuffs");
```

## Option 3: Using in one file from C without exporting any symbols:

build.zig:

```
const wuffs = b.dependency("wuffs", .{.target = target, .optimize = optimize});
exe.addIncludePath(wuffs.b.dependency("wuffs", .{}).path("release/c"));
```

c:

```
#define WUFFS_CONFIG__STATIC_FUNCTIONS
#define WUFFS_IMPLEMENTATION
#include <wuffs-v0.4.c>

// wuffs functions can be used in this file only and do not leak any symbols outside this file
```

# Zig Usage Example

https://github.com/pfgithub/blockeditor/blob/014d596aa439cc2273b7b534768865d4fa037e55/packages/loadimage/src/loadimage.zig#L39

# Notes

This package is for using the wuffs standard library. It downloads a prebuilt `.c` file, and does not package the wuffs compiler itself for use with zig.
