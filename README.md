[Wuffs](https://github.com/google/wuffs) file loading library packaged for zig

# Usage

Packages wuffs version 0.4.0-alpha.9+3837.20240914

Run `zig build` to create static and dynamic libraries.

### Usage from Zig

If you're using this library from Zig, import the `wuffs` module, which will contain
the full implementation and translated C header files which you can use like so:

```zig
const wuffs = @import("wuffs");

test {
    std.testing.expectEqual(wuffs.WUFFS_BASE__FOURCC__BMP, some_value);
}
```

If you want to make use of dynamic linking, then you can import the `headers` module,
which will contain the translated C header files, but none of the implementation.

### Zig 0.16.0 translate-c regression note

As of Zig 0.16.0, the compiler switched to rely entirely on arocc for translating c headers, which caused some regressions
in header files that do macro acrobatics (which unfortunately includes this one).

As a temporary stopgap this package includes the `impl` module which contains the full implementation, similarly to the `wuffs` module,
but unlike `wuffs` it does not contain the translate-c header.

If you encounter a translate-c crash when importing `wuffs`, consider switching temporarily to `impl` and use manual `extern` definitions.
