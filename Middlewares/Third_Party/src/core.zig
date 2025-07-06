const c_rtx = @import("c.zig").c_rtx;

pub const osStatus_t = c_rtx.osStatus_t;

pub const osError = error{
    osError,
    osErrorTimeout,
    osErrorResource,
    osErrorParameter,
    osErrorNoMemory,
    osErrorISR,
    osErrorSafetyClass,
};

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

pub const osThreadId_t = c_rtx.osThreadId_t;
