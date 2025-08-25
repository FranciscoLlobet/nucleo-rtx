const core = @import("core.zig");
const c = core.c;

pub const TX_TIMER = c.TX_TIMER;
pub const tick_value_t = core.tick_value_t;

const timer = @This();

const auto_activate_e = enum(c.UINT){
    auto_activate = c.TX_AUTO_ACTIVATE,
    no_activate = c.TX_NO_ACTIVATE,
};

pub const return_values = core.return_values;

pub const expiration_input_t = c.ULONG;
pub const expiration_function_t = *const fn (id : expiration_input_t) callconv(.C) void;

tx_timer : TX_TIMER = undefined,

pub fn new(self: *@This(), name_ptr : [*:0]const u8, expiration_function : expiration_function_t, expiration_input : expiration_input_t, initial_ticks : tick_value_t, reschedule_ticks : tick_value_t,  auto_activate : auto_activate_e) return_values{
    return @enumFromInt(c._tx_timer_create(
        &(self.tx_timer),
        @constCast(name_ptr),
        expiration_function,
        expiration_input,
        initial_ticks,
        reschedule_ticks,
        @intFromEnum(auto_activate)
    ));
}
