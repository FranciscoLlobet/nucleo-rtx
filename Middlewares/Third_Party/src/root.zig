const std = @import("std");
const c_rtx = @cImport({
    @cInclude("cmsis_os2.h");
    @cInclude("rtx_os.h");
});

const osError = error{
    osError,
    osErrorTimeout,
    osErrorResource,
    osErrorParameter,
    osErrorNoMemory,
    osErrorISR,
    osErrorSafetyClass,
};

pub const osStatus_t = c_rtx.osStatus_t;

fn osErrorMap(osStatus: osStatus_t) osError!void {
    return switch (osStatus) {
        c_rtx.osOK => {},
        c_rtx.osError => osError.osError,
        c_rtx.osErrorTimeout => osError.osErrorTimeout,
        c_rtx.osErrorResource => osError.osErrorParameter,
        c_rtx.osErrorParameter => osError.osErrorParameter,
        c_rtx.osErrorNoMemory => osError.osErrorNoMemory,
        c_rtx.osErrorSafetyClass => osError.osErrorSafetyClass,
        else => osError.osError,
    };
}

pub const osThreadFunc_t = c_rtx.osThreadFunc_t;
pub const osThreadAttr_t = c_rtx.osThreadAttr_t;
pub const osThreadId_t = c_rtx.osThreadId_t;

pub const osKernelInitialize = c_rtx.osKernelInitialize;
pub const osDelay = c_rtx.osDelay;
pub const osKernelStart = c_rtx.osKernelStart;
pub const osThreadNew = c_rtx.osThreadNew;
pub const osThreadGetState = c_rtx.osThreadGetState;
pub const osThreadGetId = c_rtx.osThreadGetId;
pub const osThreadGetStackSize = c_rtx.osThreadGetStackSize;
pub const osThreadGetStackSpace = c_rtx.osThreadGetStackSpace;
pub const osThreadYield = c_rtx.osThreadYield;
pub const osThreadSuspend = c_rtx.osThreadSuspend;
pub const osThreadResume = c_rtx.osThreadResume;

pub const osThreadFlagsSet = c_rtx.osThreadFlagsSet;
pub const osThreadFlagsGet = c_rtx.osThreadFlagsGet;
pub const osThreadFlagsClear = c_rtx.osThreadFlagsClear;
pub const osThreadFlagsWait = c_rtx.osThreadFlagsWait;

pub const osDelayUntil = c_rtx.osDelayUntil;

pub const kernel = struct {
    pub const State = enum(i32) {
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
};

pub const osThreadState = enum(i32) {
    osThreadInactive = c_rtx.osThreadInactive,
    osThreadReady = c_rtx.osThreadReady,
    osThreadRunning = c_rtx.osThreadRunning,
    osThreadBlocked = c_rtx.osThreadBlocked,
    osThreadTerminated = c_rtx.osThreadTerminated,
    osThreadError = c_rtx.osThreadError,
};

/// Static thread
pub fn StaticThread(comptime T: type, comptime stack_size: usize, comptime name: [*:0]const u8, comptime taskRunnerFn: *const fn (?*T) void) type {
    return struct {
        /// ThreadId
        thread: thread = undefined,

        /// Thread attributes
        attr: c_rtx.osThreadAttr_t = .{
            .name = name,
            .attr_bits = 0,
            .cb_mem = null,
            .cb_size = 0,
            .stack_mem = null,
            .stack_size = 0,
            .priority = 0,
            .tz_module = undefined,
            .affinity_mask = 0,
        },

        /// Control Block
        cb: c_rtx.osRtxThread_t align(4) = undefined,

        /// Static task
        stack: [stack_size]u8 align(8) = undefined,

        fn run(arg: ?*anyopaque) callconv(.C) void {
            taskRunnerFn(@as(?*T, @ptrCast(@alignCast(arg))));
        }

        pub fn new(self: *@This(), arg: ?*T, attr_bits: u32, priority: u32) osError!void {
            self.attr.stack_mem = self.stack[0..].ptr;
            self.attr.stack_size = self.stack[0..].len * @sizeOf(u8);
            self.attr.cb_mem = &self.cb;
            self.attr.cb_size = @sizeOf(c_rtx.osRtxThread_t);
            self.attr.attr_bits = attr_bits;
            self.attr.priority = @intCast(priority);

            self.thread = thread.new(run, @ptrCast(@alignCast(arg)), &self.attr);
        }

        pub fn getThreadRef(self: *const @This()) *thread {
            return &self.thread;
        }
        pub fn getState(self: *const @This()) osThreadState {
            return self.thread.getState();
        }
        pub fn getStackSize(self: *const @This()) usize {
            return self.thread.getStackSize();
        }
        pub fn getStackSpace(self: *const @This()) usize {
            return self.thread.getStackSpace();
        }
        pub fn yield(self: *const @This()) !void {
            return self.thread.yield();
        }
        pub fn threadSuspend(self: *const @This()) !void {
            return self.thread.threadSuspend();
        }
        pub fn threadResume(self: *const @This()) !void {
            return self.thread.threadResume();
        }
        pub fn flagsSet(self: *const @This(), flags: u32) u32 {
            return self.thread.flagsSet(flags);
        }
        pub fn flagsClear(self: *const @This(), flags: u32) u32 {
            return self.thread.flagsClear(flags);
        }
        pub fn flagsGet(self: *const @This()) u32 {
            return self.thread.flagsGet();
        }
        pub fn flagsWait(self: *const @This(), options: u32, timeout: u32) u32 {
            return self.thread.flagsWait(options, timeout);
        }
    };
}

pub const thread = struct {
    id: osThreadId_t = undefined,

    pub fn create(id: osThreadId_t) @This() {
        return .{ .id = id };
    }
    pub fn new(func: osThreadFunc_t, argument: ?*anyopaque, attr: *const osThreadAttr_t) @This() {
        return @This().create(osThreadNew(func, argument, attr));
    }

    pub fn getState(self: *const @This()) osThreadState {
        return @as(osThreadState, @enumFromInt(osThreadGetState(self.id)));
    }

    pub fn getStackSize(self: *const @This()) usize {
        return @intCast(osThreadGetStackSize(self.id));
    }

    pub fn getStackSpace(self: *const @This()) usize {
        return @intCast(osThreadGetStackSpace(self.id));
    }

    pub fn yield(self: *const @This()) !void {
        _ = self;
        return osErrorMap(osThreadYield());
    }

    pub fn threadSuspend(self: *const @This()) !void {
        return osErrorMap(osThreadSuspend(self.id));
    }

    pub fn threadResume(self: *const @This()) !void {
        return osErrorMap(osThreadResume(self.id));
    }

    pub fn flagsSet(self: *const @This(), flags: u32) u32 {
        return osThreadFlagsSet(self.id, flags);
    }
    pub fn flagsClear(self: *const @This(), flags: u32) u32 {
        return osThreadFlagsClear(self.id, flags);
    }
    pub fn flagsGet(self: *const @This()) u32 {
        return osThreadFlagsGet(self.id);
    }
    pub fn flagsWait(self: *const @This(), options: u32, timeout: u32) u32 {
        return osThreadFlagsWait(self.id, options, timeout);
    }
};
