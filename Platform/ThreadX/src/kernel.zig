const std = @import("std");

const c = @import("c.zig").c;

pub fn enter() noreturn {
    c.tx_kernel_enter();
    unreachable;
}
