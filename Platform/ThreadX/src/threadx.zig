const std = @import("std");

//const c = @import("c.zig");

pub const kernel = @import("kernel.zig");

pub const thread = @import("thread.zig");

pub const timer = @import("timer.zig");

pub const queue = @import("queue.zig");

const core = @import("core.zig");

pub const tick_value_t = core.tick_value_t;
pub const return_values_t = core.tick_value_t;

pub const StaticQueue = queue.StaticQueue;
