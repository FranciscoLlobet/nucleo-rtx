pub const c_rtx = @import("c.zig").c_rtx;

// All shared error types
pub const osError = error{
    osError,
    osErrorTimeout,
    osErrorResource,
    osErrorParameter,
    osErrorNoMemory,
    osErrorISR,
    osErrorSafetyClass,
};

pub const osFlagsError = error{
    osFlagsErrorUnknown,
    osFlagsErrorTimeout,
    osFlagsErrorResource,
    osFlagsErrorParameter,
    osFlagsErrorISR,
    osFlagsErrorSafetyClass,
};

// All basic types that multiple modules need
pub const osStatus_t = c_rtx.osStatus_t;
pub const osThreadId_t = c_rtx.osThreadId_t;
pub const osTimerId_t = c_rtx.osTimerId_t;
pub const osEventFlagsId_t = c_rtx.osEventFlagsId_t;
pub const osSemaphoreId_t = c_rtx.osSemaphoreId_t;
pub const osMutexId_t = c_rtx.osMutexId_t;
pub const osMessageQueueId_t = c_rtx.osMessageQueueId_t;

// All shared constants
pub const osWaitForever: u32 = @intCast(c_rtx.osWaitForever);

// All shared enums
pub const osFlagsOptions = enum(u32) {
    osFlagsWaitAny = c_rtx.osFlagsWaitAny,
    osFlagsWaitAll = c_rtx.osFlagsWaitAll,
    osFlagsNoClear = c_rtx.osFlagsNoClear,
};

// Error mapping functions
pub fn osErrorMap(osStatus: osStatus_t) osError!void {
    return switch (osStatus) {
        c_rtx.osOK => {},
        c_rtx.osError => osError.osError,
        c_rtx.osErrorTimeout => osError.osErrorTimeout,
        c_rtx.osErrorResource => osError.osErrorResource,
        c_rtx.osErrorParameter => osError.osErrorParameter,
        c_rtx.osErrorNoMemory => osError.osErrorNoMemory,
        c_rtx.osErrorSafetyClass => osError.osErrorSafetyClass,
        else => osError.osError,
    };
}

pub fn osFlagsErrorMap(ef: u32) osFlagsError!u32 {
    if (@as(u32, @intCast(c_rtx.osFlagsError & ef)) == @as(u32, @intCast(c_rtx.osFlagsError))) {
        return switch (ef) {
            c_rtx.osFlagsErrorUnknown => osFlagsError.osFlagsErrorUnknown,
            c_rtx.osFlagsErrorTimeout => osFlagsError.osFlagsErrorTimeout,
            c_rtx.osFlagsErrorResource => osFlagsError.osFlagsErrorResource,
            c_rtx.osFlagsErrorParameter => osFlagsError.osFlagsErrorParameter,
            c_rtx.osFlagsErrorISR => osFlagsError.osFlagsErrorISR,
            c_rtx.osFlagsErrorSafetyClass => osFlagsError.osFlagsErrorSafetyClass,
            else => osFlagsError.osFlagsErrorUnknown,
        };
    } else {
        return ef;
    }
}
