# tkrzw-zig

Zig bindings of tkrzw via `tkrzw_langc.h`.

Right now, to use this library you need to install tkrzw on your machine as a dynamic library.

The API is also incomplete. Please contribute!

## Usage

First, download this repo somewhere. +1 if you know `git submodule`.

Then, put in your `build.zig`:
```

const tkrzw = @import("path/to/tkrzw-zig/build.zig");

pub fn build(b: *std.build.Builder) void {
    ...
    tkrzw.link(exe); // link library
    exe.addPackage(tkrzw.pkg()); // allow @import("tkrzw") in your code
}
```

## TODO
- static linking & build from source
- more API
