const std = @import("std");
const c_rtx = @import("c.zig").c_rtx;
const core = @import("core.zig");

pub const eventFlags = @import("eventFlags.zig");
pub const thread = @import("thread.zig");
pub const timer = @import("timer.zig");
pub const mutex = @import("mutex.zig");

pub const MessageQueue = @import("messageQueue.zig").MessageQueue;
pub const StaticMessageQueue = @import("messageQueue.zig").StaticMessageQueue;

pub const StaticThread = thread.StaticThread;
pub const StaticTimer = timer.StaticTimer;
pub const StaticMutex = mutex.StaticMutex;

pub const osThreadId_t = thread.osThreadId_t;

pub const osError = core.osError;

const osErrorMap = core.osErrorMap;

pub const osFlagsError = eventFlags.osFlagsError;

const osFlagsErrorMap = eventFlags.osFlagsErrorMap;

pub const osStatus_t = core.osStatus_t;

pub const osWaitForever: u32 = @intCast(c_rtx.osWaitForever);

pub const osKernelInitialize = c_rtx.osKernelInitialize;
pub const osKernelStart = c_rtx.osKernelStart;

pub fn osDelay(ticks: u32) osError!void {
    return osErrorMap(c_rtx.osDelay(ticks));
}

pub fn osDelayUntil(ticks: u32) osError!void {
    return osErrorMap(c_rtx.osDelayUntil(ticks));
}

pub const kernel = struct {
    pub const osKernelState = enum(i32) {
        osKernelInactive = c_rtx.osKernelInactive,
        osKernelReady = c_rtx.osKernelReady,
        osKernelRunning = c_rtx.osKernelRunning,
        osKernelLocked = c_rtx.osKernelLocked,
        osKernelSuspended = c_rtx.osKernelSuspended,
        osKernelError = c_rtx.osKernelError,
    };

    pub fn initialize() osError!void {
        return osErrorMap(c_rtx.osKernelInitialize());
    }

    pub fn start() osError!void {
        return osErrorMap(c_rtx.osKernelStart());
    }

    pub fn getState() osKernelState {
        return @enumFromInt(c_rtx.osKernelGetState());
    }

    pub fn getTickCount() u32 {
        return c_rtx.osKernelGetTickCount();
    }

    pub fn getSysTimerFreq() u32 {
        return c_rtx.osKernelGetSysTimerFreq();
    }
};
