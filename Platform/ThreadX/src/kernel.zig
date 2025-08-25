const std = @import("std");

const c = @import("c.zig").c;

pub const application_define_t = *const fn (first_unused_memory: ?*anyopaque) void;
pub const kernel = @This();

var start: application_define_t = undefined;

pub fn enter(comptime start_fn: application_define_t) noreturn {
    start = start_fn;

    c.tx_kernel_enter();
    unreachable;
}

export fn tx_application_define(first_unused_memory: ?*anyopaque) callconv(.C) void {
    start(first_unused_memory);
}
