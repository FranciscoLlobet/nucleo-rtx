//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const rtx = @import("cmsis_rtx");

extern fn main() callconv(.C) c_int;

fn threadRunner(arg: ?*anyopaque) void {
    _ = arg;
    while (true) {}
}

var thread: rtx.StaticThread(anyopaque, 8 * 128, "Test Thread", threadRunner) = undefined;

export fn zmain() noreturn {
    _ = main();

    rtx.kernel.initialize() catch {};

    thread.new(null, 0, 24) catch {};

    rtx.kernel.start() catch {};

    unreachable;
}

export fn _start() linksection(".init") callconv(.naked) void {
    asm volatile ("b Reset_Handler");
}
