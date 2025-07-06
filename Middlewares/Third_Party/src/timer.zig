const c_rtx = @import("c.zig").c_rtx;
const core = @import("core.zig");

pub const osError = core.osError;
const osErrorMap = core.osErrorMap;

pub const osTimerFunc_t = c_rtx.osTimerFunc_t;
pub const osTimerAttr_t = c_rtx.osTimerAttr_t;
pub const osTimerId_t = c_rtx.osTimerId_t;

pub const osTimerNew = c_rtx.osTimerNew;
pub const osTimerGetName = c_rtx.osTimerGetName;
pub const osTimerStart = c_rtx.osTimerStart;
pub const osTimerStop = c_rtx.osTimerStop;
pub const osTimerIsRunning = c_rtx.osTimerIsRunning;
pub const osTimerDelete = c_rtx.osTimerDelete;

pub const osTimerType = enum(u32) {
    osTimerOnce = c_rtx.osTimerOnce,
    osTimerPeriodic = c_rtx.osTimerPeriodic,
};

const timer = @This();

id: osTimerId_t = undefined,

/// Creates a Timer object using an existing TimerId reference
pub fn create(id: osTimerId_t) @This() {
    return .{ .id = id };
}

/// Creates a new Timer
pub fn new(func: osTimerFunc_t, timer_type: osTimerType, argument: ?*anyopaque, attr: ?*const osTimerAttr_t) @This() {
    return @This().create(osTimerNew(func, @intFromEnum(timer_type), argument, attr));
}

/// Get timer name
pub fn getName(self: *const @This()) ?[*:0]const u8 {
    return osTimerGetName(self.id);
}

/// Start or restart the timer
pub fn start(self: *const @This(), ticks: u32) osError!void {
    return osErrorMap(osTimerStart(self.id, ticks));
}

/// Stop the timer
pub fn stop(self: *const @This()) osError!void {
    return osErrorMap(osTimerStop(self.id));
}

/// Check if timer is running
pub fn isRunning(self: *const @This()) bool {
    return osTimerIsRunning(self.id) != 0;
}

/// Delete the timer
pub fn delete(self: *const @This()) osError!void {
    return osErrorMap(osTimerDelete(self.id));
}

/// Static timer with compile-time control block allocation
pub fn StaticTimer(comptime T: type, comptime name: [*:0]const u8, comptime timerCallbackFn: *const fn (?*T) void) type {
    return struct {
        /// Timer object
        tim: timer = undefined,

        /// Control Block, 32-Bit alignment needed
        cb: c_rtx.osRtxTimer_t align(4) = undefined,

        fn callback(arg: ?*anyopaque) callconv(.C) void {
            timerCallbackFn(@as(?*T, @ptrCast(@alignCast(arg))));
        }

        /// Create new static timer
        pub fn new(self: *@This(), timer_type: osTimerType, arg: ?*T, attr_bits: u32) osError!void {
            // Timer attributes
            const attr: c_rtx.osTimerAttr_t = .{
                .name = name,
                .attr_bits = attr_bits,
                .cb_mem = &self.cb,
                .cb_size = @sizeOf(c_rtx.osRtxTimer_t),
            };

            self.tim = timer.new(callback, timer_type, @ptrCast(@alignCast(arg)), &attr);

            // Check if timer creation failed
            if (self.tim.id == null) {
                return osError.osError;
            }
        }

        /// Get timer reference
        pub fn getTimerRef(self: *const @This()) *const timer {
            return &self.tim;
        }

        /// Get timer name
        pub fn getName(self: *const @This()) ?[*:0]const u8 {
            return self.tim.getName();
        }

        /// Start or restart the timer
        pub fn start(self: *const @This(), ticks: u32) osError!void {
            return self.tim.start(ticks);
        }

        /// Stop the timer
        pub fn stop(self: *const @This()) osError!void {
            return self.tim.stop();
        }

        /// Check if timer is running
        pub fn isRunning(self: *const @This()) bool {
            return self.tim.isRunning();
        }

        /// Delete the timer
        pub fn delete(self: *const @This()) osError!void {
            return self.tim.delete();
        }
    };
}
