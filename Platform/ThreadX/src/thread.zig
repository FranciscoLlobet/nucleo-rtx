const std = @import("std");

const core = @import("core.zig");

const c = core.c;

const thread = @This();

const return_values = core.return_values;

pub const entry_input_t = c.ULONG;
pub const entry_function_t = *const fn (id : entry_input_t) callconv(.C) void;


const tick_value_t = core.tick_value_t;
const TX_NO_TIME_SLICE = @as(tick_value_t, c.TX_NO_TIME_SLICE);
const TX_AUTO_START = c.TX_AUTO_START;
const TX_DONT_START = c.TX_DONT_START;

pub const auto_start_e = enum(c.UINT){
    dont_start = TX_DONT_START,
    auto_start = TX_AUTO_START,
};

pub const priorities_e = enum(c.UINT){
    priorityIdle = 31,

    priorityLow = 6,
    priorityBelowNormal = 5,
    priorityNormal = 4,
    priorityAboveNormal = 3,
    priorityHigh = 2,
    priorityRealtime = 1,
    
    priorityISR = 0,
};


tx_thread : c.TX_THREAD = undefined, 


pub fn sleep(timer_ticks : tick_value_t) return_values {
    return @enumFromInt(c.tx_thread_sleep(timer_ticks));
}

pub fn new(self: *@This(), name_ptr : [*:0]const u8, entry_function : entry_function_t, entry_input : entry_input_t, stack_start : []u8, priority : priorities_e, preempt_threshold : priorities_e, time_slice : tick_value_t, auto_start : auto_start_e) return_values {

    return @enumFromInt(c._tx_thread_create(
        &(self.tx_thread),
         @constCast(name_ptr),
         @constCast(entry_function),
         entry_input, 
         stack_start.ptr,
         @as(c.ULONG, @intCast(stack_start.len)), 
         @intFromEnum(priority),
         @intFromEnum(preempt_threshold),
         time_slice,
         @intFromEnum(auto_start)));
         //@sizeOf(c.TX_THREAD)));
}

