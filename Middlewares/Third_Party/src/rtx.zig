const std = @import("std");
const c_rtx = @cImport({
    @cInclude("cmsis_os2.h");
    @cInclude("rtx_os.h");
});

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

pub const osFlagsError = error{
    osFlagsError,
    osFlagsErrorUnknown,
    osFlagsErrorTimeout,
    osFlagsErrorResource,
    osFlagsErrorParameter,
    osFlagsErrorISR,
    osFlagsErrorSafetyClass,
};

pub const osFlagsOptions = enum(u32) {
    osFlagsWaitAny = c_rtx.osFlagsWaitAny,
    osFlagsWaitAll = c_rtx.osFlagsWaitAll,
    osFlagsNoClear = c_rtx.osFlagsNoClear,
};

fn osErrorMap(osStatus: osStatus_t) osError!void {
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

pub const osWaitForever: u32 = @intCast(c_rtx.osWaitForever);

pub const osThreadFunc_t = c_rtx.osThreadFunc_t;
pub const osThreadAttr_t = c_rtx.osThreadAttr_t;
pub const osThreadId_t = c_rtx.osThreadId_t;

pub const osKernelInitialize = c_rtx.osKernelInitialize;
pub const osKernelStart = c_rtx.osKernelStart;

pub const osDelay = c_rtx.osDelay;
pub const osDelayUntil = c_rtx.osDelayUntil;

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

/// Thread priority values
pub const osThreadPriority = enum(i32) {
    osPriorityNone = c_rtx.osPriorityNone,
    osPriorityIdle = c_rtx.osPriorityIdle,
    osPriorityLow = c_rtx.osPriorityLow,
    osPriorityLow1 = c_rtx.osPriorityLow1,
    osPriorityLow2 = c_rtx.osPriorityLow2,
    osPriorityLow3 = c_rtx.osPriorityLow3,
    osPriorityLow4 = c_rtx.osPriorityLow4,
    osPriorityLow5 = c_rtx.osPriorityLow5,
    osPriorityLow6 = c_rtx.osPriorityLow6,
    osPriorityLow7 = c_rtx.osPriorityLow7,
    osPriorityBelowNormal = c_rtx.osPriorityBelowNormal,
    osPriorityBelowNormal1 = c_rtx.osPriorityBelowNormal1,
    osPriorityBelowNormal2 = c_rtx.osPriorityBelowNormal2,
    osPriorityBelowNormal3 = c_rtx.osPriorityBelowNormal3,
    osPriorityBelowNormal4 = c_rtx.osPriorityBelowNormal4,
    osPriorityBelowNormal5 = c_rtx.osPriorityBelowNormal5,
    osPriorityBelowNormal6 = c_rtx.osPriorityBelowNormal6,
    osPriorityBelowNormal7 = c_rtx.osPriorityBelowNormal7,
    osPriorityNormal = c_rtx.osPriorityNormal,
    osPriorityNormal1 = c_rtx.osPriorityNormal1,
    osPriorityNormal2 = c_rtx.osPriorityNormal2,
    osPriorityNormal3 = c_rtx.osPriorityNormal3,
    osPriorityNormal4 = c_rtx.osPriorityNormal4,
    osPriorityNormal5 = c_rtx.osPriorityNormal5,
    osPriorityNormal6 = c_rtx.osPriorityNormal6,
    osPriorityNormal7 = c_rtx.osPriorityNormal7,
    osPriorityAboveNormal = c_rtx.osPriorityAboveNormal,
    osPriorityAboveNormal1 = c_rtx.osPriorityAboveNormal1,
    osPriorityAboveNormal2 = c_rtx.osPriorityAboveNormal2,
    osPriorityAboveNormal3 = c_rtx.osPriorityAboveNormal3,
    osPriorityAboveNormal4 = c_rtx.osPriorityAboveNormal4,
    osPriorityAboveNormal5 = c_rtx.osPriorityAboveNormal5,
    osPriorityAboveNormal6 = c_rtx.osPriorityAboveNormal6,
    osPriorityAboveNormal7 = c_rtx.osPriorityAboveNormal7,
    osPriorityHigh = c_rtx.osPriorityHigh,
    osPriorityHigh1 = c_rtx.osPriorityHigh1,
    osPriorityHigh2 = c_rtx.osPriorityHigh2,
    osPriorityHigh3 = c_rtx.osPriorityHigh3,
    osPriorityHigh4 = c_rtx.osPriorityHigh4,
    osPriorityHigh5 = c_rtx.osPriorityHigh5,
    osPriorityHigh6 = c_rtx.osPriorityHigh6,
    osPriorityHigh7 = c_rtx.osPriorityHigh7,
    osPriorityRealtime = c_rtx.osPriorityRealtime,
    osPriorityRealtime1 = c_rtx.osPriorityRealtime1,
    osPriorityRealtime2 = c_rtx.osPriorityRealtime2,
    osPriorityRealtime3 = c_rtx.osPriorityRealtime3,
    osPriorityRealtime4 = c_rtx.osPriorityRealtime4,
    osPriorityRealtime5 = c_rtx.osPriorityRealtime5,
    osPriorityRealtime6 = c_rtx.osPriorityRealtime6,
    osPriorityRealtime7 = c_rtx.osPriorityRealtime7,
    osPriorityISR = c_rtx.osPriorityISR,
    osPriorityError = c_rtx.osPriorityError,
    osPriorityReserved = c_rtx.osPriorityReserved,
};

/// Static thread
pub fn StaticThread(comptime T: type, comptime stack_size: usize, comptime name: [*:0]const u8, comptime taskRunnerFn: *const fn (?*T) void) type {
    return struct {
        /// ThreadId
        thread: thread = undefined,

        /// Control Block, 32-Bit alignment needed
        cb: c_rtx.osRtxThread_t align(4) = undefined,

        /// Static task, 64-Bit alignment needed
        stack: [stack_size]u8 align(8) = undefined,

        fn run(arg: ?*anyopaque) callconv(.C) void {
            taskRunnerFn(@as(?*T, @ptrCast(@alignCast(arg))));
        }

        pub fn new(self: *@This(), arg: ?*T, attr_bits: u32, priority: osThreadPriority) osError!void {

            // Thread attributes
            const attr: c_rtx.osThreadAttr_t = .{
                .name = name,
                .attr_bits = attr_bits,
                .cb_mem = &self.cb,
                .cb_size = @sizeOf(c_rtx.osRtxThread_t),
                .stack_mem = self.stack[0..].ptr,
                .stack_size = self.stack[0..].len * @sizeOf(u8),
                .priority = @intFromEnum(priority),
                .tz_module = undefined,
                .affinity_mask = 0,
            };

            self.thread = thread.new(run, @ptrCast(@alignCast(arg)), &attr);
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
        pub fn threadSuspend(self: *const @This()) osError!void {
            return self.thread.threadSuspend();
        }
        pub fn threadResume(self: *const @This()) osError!void {
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
        pub fn flagsWait(self: *const @This(), options: osFlagsOptions, timeout: u32) u32 {
            return self.thread.flagsWait(options, timeout);
        }
    };
}

pub const thread = struct {
    id: osThreadId_t = undefined,

    /// Creates a Thread object using an existing ThreadId reference
    pub fn create(id: osThreadId_t) @This() {
        return .{ .id = id };
    }
    /// Creates a new Thread
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

    pub fn yield(self: *const @This()) osError!void {
        _ = self;
        return osErrorMap(osThreadYield());
    }

    pub fn threadSuspend(self: *const @This()) osError!void {
        return osErrorMap(osThreadSuspend(self.id));
    }

    pub fn threadResume(self: *const @This()) osError!void {
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

    pub fn flagsWait(self: *const @This(), options: osFlagsOptions, timeout: u32) osError!u32 {
        return osFlagsErrorMap(osThreadFlagsWait(self.id, options, timeout));
    }
};

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

pub const timer = struct {
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
};

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

pub const osEventFlagsAttr_t = c_rtx.osEventFlagsAttr_t;
pub const osEventFlagsId_t = c_rtx.osEventFlagsId_t;

pub const osEventFlagsNew = c_rtx.osEventFlagsNew;
pub const osEventFlagsGetName = c_rtx.osEventFlagsGetName;
pub const osEventFlagsSet = c_rtx.osEventFlagsSet;
pub const osEventFlagsClear = c_rtx.osEventFlagsClear;
pub const osEventFlagsGet = c_rtx.osEventFlagsGet;
pub const osEventFlagsWait = c_rtx.osEventFlagsWait;
pub const osEventFlagsDelete = c_rtx.osEventFlagsDelete;

fn osFlagsErrorMap(ef: u32) osError!u32 {
    if (@as(u32, @intCast(c_rtx.osFlagsError & ef)) == @as(u32, @intCast(c_rtx.osFlagsError))) {
        return switch (ef) {
            c_rtx.osFlagsErrorUnknown => osError.osError,
            c_rtx.osFlagsErrorTimeout => osError.osErrorTimeout,
            c_rtx.osFlagsErrorResource => osError.osErrorResource,
            c_rtx.osFlagsErrorParameter => osError.osErrorParameter,
            c_rtx.osFlagsErrorISR => osError.osErrorISR,
            c_rtx.osFlagsErrorSafetyClass => osError.osErrorSafetyClass,
            else => osError.osError,
        };
    } else {
        return ef;
    }
}

pub const eventFlags = struct {
    id: osEventFlagsId_t = undefined,

    /// Creates an EventFlags object using an existing EventFlagsId reference
    pub fn create(id: osEventFlagsId_t) @This() {
        return .{ .id = id };
    }

    /// Creates a new EventFlags object
    pub fn new(attr: ?*const osEventFlagsAttr_t) @This() {
        return @This().create(osEventFlagsNew(attr));
    }

    /// Get event flags name
    pub fn getName(self: *const @This()) ?[*:0]const u8 {
        return osEventFlagsGetName(self.id);
    }

    /// Set specified event flags
    pub fn set(self: *const @This(), flags: u32) u32 {
        return osEventFlagsSet(self.id, flags);
    }

    /// Clear specified event flags
    pub fn clear(self: *const @This(), flags: u32) u32 {
        return osEventFlagsClear(self.id, flags);
    }

    /// Get current event flags
    pub fn get(self: *const @This()) u32 {
        return osEventFlagsGet(self.id);
    }

    /// Wait for one or more event flags to become signaled
    pub fn wait(self: *const @This(), flags: u32, options: osFlagsOptions, timeout: u32) osError!u32 {
        return osFlagsErrorMap(osEventFlagsWait(self.id, flags, @intFromEnum(options), timeout));
    }

    /// Delete the event flags object
    pub fn delete(self: *const @This()) osError!void {
        return osErrorMap(osEventFlagsDelete(self.id));
    }
};

/// Static event flags with compile-time control block allocation
pub fn StaticEventFlags(comptime name: [*:0]const u8) type {
    return struct {
        /// EventFlags object
        ef: eventFlags = undefined,

        /// Control Block, 32-Bit alignment needed
        cb: c_rtx.osRtxEventFlags_t align(4) = undefined,

        /// Create new static event flags
        pub fn new(self: *@This(), attr_bits: u32) osError!void {
            // EventFlags attributes
            const attr: c_rtx.osEventFlagsAttr_t = .{
                .name = name,
                .attr_bits = attr_bits,
                .cb_mem = &self.cb,
                .cb_size = @sizeOf(c_rtx.osRtxEventFlags_t),
            };

            self.ef = eventFlags.new(&attr);

            // Check if event flags creation failed
            if (self.ef.id == null) {
                return osError.osError;
            }
        }

        /// Get event flags reference
        pub fn getEventFlagsRef(self: *const @This()) *const eventFlags {
            return &self.ef;
        }

        /// Get event flags name
        pub fn getName(self: *const @This()) ?[*:0]const u8 {
            return self.ef.getName();
        }

        /// Set specified event flags
        pub fn set(self: *const @This(), flags: u32) u32 {
            return self.ef.set(flags);
        }

        /// Clear specified event flags
        pub fn clear(self: *const @This(), flags: u32) u32 {
            return self.ef.clear(flags);
        }

        /// Get current event flags
        pub fn get(self: *const @This()) u32 {
            return self.ef.get();
        }

        /// Wait for one or more event flags to become signaled
        pub fn wait(self: *const @This(), flags: u32, options: osFlagsOptions, timeout: u32) osError!u32 {
            return self.ef.wait(flags, options, timeout);
        }

        /// Delete the event flags object
        pub fn delete(self: *const @This()) osError!void {
            return self.ef.delete();
        }
    };
}

pub const osSemaphoreAttr_t = c_rtx.osSemaphoreAttr_t;
pub const osSemaphoreId_t = c_rtx.osSemaphoreId_t;

pub const osSemaphoreNew = c_rtx.osSemaphoreNew;
pub const osSemaphoreGetName = c_rtx.osSemaphoreGetName;
pub const osSemaphoreAcquire = c_rtx.osSemaphoreAcquire;
pub const osSemaphoreRelease = c_rtx.osSemaphoreRelease;
pub const osSemaphoreGetCount = c_rtx.osSemaphoreGetCount;
pub const osSemaphoreDelete = c_rtx.osSemaphoreDelete;

// ===== Semaphore Wrapper Struct =====
pub const semaphore = struct {
    id: osSemaphoreId_t = undefined,

    /// Creates a Semaphore object using an existing SemaphoreId reference
    pub fn create(id: osSemaphoreId_t) @This() {
        return .{ .id = id };
    }

    /// Creates a new Semaphore
    pub fn new(max_count: u32, initial_count: u32, attr: ?*const osSemaphoreAttr_t) @This() {
        return @This().create(osSemaphoreNew(max_count, initial_count, attr));
    }

    /// Get semaphore name
    pub fn getName(self: *const @This()) ?[*:0]const u8 {
        return osSemaphoreGetName(self.id);
    }

    /// Acquire a semaphore token or timeout if no tokens are available
    pub fn acquire(self: *const @This(), timeout: u32) osError!void {
        return osErrorMap(osSemaphoreAcquire(self.id, timeout));
    }

    /// Release a semaphore token up to the initial maximum count
    pub fn release(self: *const @This()) osError!void {
        return osErrorMap(osSemaphoreRelease(self.id));
    }

    /// Get current semaphore token count
    pub fn getCount(self: *const @This()) u32 {
        return osSemaphoreGetCount(self.id);
    }

    /// Delete the semaphore
    pub fn delete(self: *const @This()) osError!void {
        return osErrorMap(osSemaphoreDelete(self.id));
    }
};

// ===== Static Semaphore Generic =====
/// Static semaphore with compile-time control block allocation
pub fn StaticSemaphore(comptime name: [*:0]const u8) type {
    return struct {
        /// Semaphore object
        sem: semaphore = undefined,

        /// Control Block, 32-Bit alignment needed
        cb: c_rtx.osRtxSemaphore_t align(4) = undefined,

        /// Create new static semaphore
        pub fn new(self: *@This(), max_count: u32, initial_count: u32, attr_bits: u32) osError!void {
            // Semaphore attributes
            const attr: c_rtx.osSemaphoreAttr_t = .{
                .name = name,
                .attr_bits = attr_bits,
                .cb_mem = &self.cb,
                .cb_size = @sizeOf(c_rtx.osRtxSemaphore_t),
            };

            self.sem = semaphore.new(max_count, initial_count, &attr);

            // Check if semaphore creation failed
            if (self.sem.id == null) {
                return osError.osError;
            }
        }

        /// Get semaphore reference
        pub fn getSemaphoreRef(self: *const @This()) *const semaphore {
            return &self.sem;
        }

        /// Get semaphore name
        pub fn getName(self: *const @This()) ?[*:0]const u8 {
            return self.sem.getName();
        }

        /// Acquire a semaphore token or timeout if no tokens are available
        pub fn acquire(self: *const @This(), timeout: u32) osError!void {
            return self.sem.acquire(timeout);
        }

        /// Release a semaphore token up to the initial maximum count
        pub fn release(self: *const @This()) osError!void {
            return self.sem.release();
        }

        /// Get current semaphore token count
        pub fn getCount(self: *const @This()) u32 {
            return self.sem.getCount();
        }

        /// Delete the semaphore
        pub fn delete(self: *const @This()) osError!void {
            return self.sem.delete();
        }
    };
}

// ===== Mutex C Function Re-exports =====
pub const osMutexAttr_t = c_rtx.osMutexAttr_t;
pub const osMutexId_t = c_rtx.osMutexId_t;

pub const osMutexNew = c_rtx.osMutexNew;
pub const osMutexGetName = c_rtx.osMutexGetName;
pub const osMutexAcquire = c_rtx.osMutexAcquire;
pub const osMutexRelease = c_rtx.osMutexRelease;
pub const osMutexGetOwner = c_rtx.osMutexGetOwner;
pub const osMutexDelete = c_rtx.osMutexDelete;

/// Mutex attribute bits
pub const osMutexRecursive = c_rtx.osMutexRecursive;
pub const osMutexPrioInherit = c_rtx.osMutexPrioInherit;
pub const osMutexRobust = c_rtx.osMutexRobust;

pub const mutex = struct {
    id: osMutexId_t = undefined,

    /// Creates a Mutex object using an existing MutexId reference
    pub fn create(id: osMutexId_t) @This() {
        return .{ .id = id };
    }

    /// Creates a new Mutex
    pub fn new(attr: ?*const osMutexAttr_t) @This() {
        return @This().create(osMutexNew(attr));
    }

    /// Get mutex name
    pub fn getName(self: *const @This()) ?[*:0]const u8 {
        return osMutexGetName(self.id);
    }

    /// Acquire a mutex or timeout if it is locked
    pub fn acquire(self: *const @This(), timeout: u32) osError!void {
        return osErrorMap(osMutexAcquire(self.id, timeout));
    }

    /// Release a mutex that was acquired
    pub fn release(self: *const @This()) osError!void {
        return osErrorMap(osMutexRelease(self.id));
    }

    /// Get thread which owns the mutex
    pub fn getOwner(self: *const @This()) ?osThreadId_t {
        return osMutexGetOwner(self.id);
    }

    /// Delete the mutex
    pub fn delete(self: *const @This()) osError!void {
        return osErrorMap(osMutexDelete(self.id));
    }
};

/// Static mutex with compile-time control block allocation
pub fn StaticMutex(comptime name: [*:0]const u8) type {
    return struct {
        /// Mutex object
        mtx: mutex = undefined,

        /// Control Block, 32-Bit alignment needed
        cb: c_rtx.osRtxMutex_t align(4) = undefined,

        /// Create new static mutex
        pub fn new(self: *@This(), attr_bits: u32) osError!void {
            // Mutex attributes
            const attr: c_rtx.osMutexAttr_t = .{
                .name = name,
                .attr_bits = attr_bits,
                .cb_mem = &self.cb,
                .cb_size = @sizeOf(c_rtx.osRtxMutex_t),
            };

            self.mtx = mutex.new(&attr);

            // Check if mutex creation failed
            if (self.mtx.id == null) {
                return osError.osError;
            }
        }

        /// Get mutex reference
        pub fn getMutexRef(self: *const @This()) *const mutex {
            return &self.mtx;
        }

        /// Get mutex name
        pub fn getName(self: *const @This()) ?[*:0]const u8 {
            return self.mtx.getName();
        }

        /// Acquire a mutex or timeout if it is locked
        pub fn acquire(self: *const @This(), timeout: u32) osError!void {
            return self.mtx.acquire(timeout);
        }

        /// Release a mutex that was acquired
        pub fn release(self: *const @This()) osError!void {
            return self.mtx.release();
        }

        /// Get thread which owns the mutex
        pub fn getOwner(self: *const @This()) ?osThreadId_t {
            return self.mtx.getOwner();
        }

        /// Delete the mutex
        pub fn delete(self: *const @This()) osError!void {
            return self.mtx.delete();
        }
    };
}

pub const osMessageQueueAttr_t = c_rtx.osMessageQueueAttr_t;
pub const osMessageQueueId_t = c_rtx.osMessageQueueId_t;

pub const osMessageQueueNew = c_rtx.osMessageQueueNew;
pub const osMessageQueueGetName = c_rtx.osMessageQueueGetName;
pub const osMessageQueuePut = c_rtx.osMessageQueuePut;
pub const osMessageQueueGet = c_rtx.osMessageQueueGet;
pub const osMessageQueueGetCapacity = c_rtx.osMessageQueueGetCapacity;
pub const osMessageQueueGetMsgSize = c_rtx.osMessageQueueGetMsgSize;
pub const osMessageQueueGetCount = c_rtx.osMessageQueueGetCount;
pub const osMessageQueueGetSpace = c_rtx.osMessageQueueGetSpace;
pub const osMessageQueueReset = c_rtx.osMessageQueueReset;
pub const osMessageQueueDelete = c_rtx.osMessageQueueDelete;

pub fn MessageQueue(comptime T: type) type {
    return struct {
        id: osMessageQueueId_t = undefined,

        pub const Message = struct {
            data: T,
            priority: u32,
        };

        /// Creates a MessageQueue object using an existing MessageQueueId reference
        pub fn create(id: osMessageQueueId_t) @This() {
            return .{ .id = id };
        }

        /// Creates a new MessageQueue for type T
        pub fn new(msg_count: u32, attr: ?*const osMessageQueueAttr_t) @This() {
            return @This().create(osMessageQueueNew(msg_count, @sizeOf(T), attr));
        }

        /// Get message queue name
        pub fn getName(self: *const @This()) ?[*:0]const u8 {
            return osMessageQueueGetName(self.id);
        }

        /// Put a message into the queue
        pub fn put(self: *const @This(), msg: *const T, msg_prio: u8, timeout: u32) osError!void {
            return osErrorMap(osMessageQueuePut(self.id, msg, msg_prio, timeout));
        }

        /// Get a message from the queue
        pub fn get(self: *const @This(), msg: *T, msg_prio: ?*u8, timeout: u32) osError!void {
            return osErrorMap(osMessageQueueGet(self.id, msg, msg_prio, timeout));
        }

        /// Ger a message from the queue
        pub fn getMsg(self: *const @This(), timeout: u32) osError!Message {
            var msg: Message = undefined;

            try self.get(&(msg.data), &(msg.priority), timeout);

            return msg;
        }

        /// Get maximum number of messages in the queue
        pub fn getCapacity(self: *const @This()) u32 {
            return osMessageQueueGetCapacity(self.id);
        }

        /// Get maximum message size in bytes
        pub fn getMsgSize(self: *const @This()) u32 {
            return osMessageQueueGetMsgSize(self.id);
        }

        /// Get number of queued messages
        pub fn getCount(self: *const @This()) usize {
            return @intCast(osMessageQueueGetCount(self.id));
        }

        /// Get number of available slots for messages
        pub fn getSpace(self: *const @This()) usize {
            return @intCast(osMessageQueueGetSpace(self.id));
        }

        /// Reset the message queue to initial empty state
        pub fn reset(self: *const @This()) osError!void {
            return osErrorMap(osMessageQueueReset(self.id));
        }

        /// Delete the message queue
        pub fn delete(self: *const @This()) osError!void {
            return osErrorMap(osMessageQueueDelete(self.id));
        }
    };
}

pub fn StaticMessageQueue(comptime T: type, comptime msg_count: usize, comptime name: [*:0]const u8) type {
    return struct {
        /// MessageQueue object
        mq: MessageQueue(T) = undefined,

        /// Control Block, 32-Bit alignment needed
        cb: c_rtx.osRtxMessageQueue_t align(4) = undefined,

        /// Static message storage, 32-Bit alignment needed
        storage: [msg_count * @sizeOf(T)]u8 align(4) = undefined,

        /// Create new static message queue
        pub fn new(self: *@This(), attr_bits: u32) osError!void {
            // MessageQueue attributes
            const attr: c_rtx.osMessageQueueAttr_t = .{
                .name = name,
                .attr_bits = attr_bits,
                .cb_mem = &self.cb,
                .cb_size = @sizeOf(c_rtx.osRtxMessageQueue_t),
                .mq_mem = self.storage[0..].ptr,
                .mq_size = self.storage.len,
            };

            self.mq = MessageQueue(T).new(msg_count, &attr);

            // Check if message queue creation failed
            if (self.mq.id == null) {
                return osError.osError;
            }
        }

        /// Get message queue reference
        pub fn getMessageQueueRef(self: *const @This()) *const MessageQueue(T) {
            return &self.mq;
        }

        /// Get message queue name
        pub fn getName(self: *const @This()) ?[*:0]const u8 {
            return self.mq.getName();
        }

        /// Put a message into the queue
        pub fn put(self: *const @This(), msg: *const T, msg_prio: u8, timeout: u32) osError!void {
            return self.mq.put(msg, msg_prio, timeout);
        }

        /// Get a message from the queue (C-style API)
        pub fn get(self: *const @This(), msg: *T, msg_prio: ?*u8, timeout: u32) osError!void {
            return self.mq.get(msg, msg_prio, timeout);
        }

        /// Receive a message from the queue (returns message directly)
        pub fn receive(self: *const @This(), timeout: u32) osError!T {
            return self.mq.receive(timeout);
        }

        /// Receive a message with priority from the queue
        pub fn receiveWithPriority(self: *const @This(), timeout: u32) osError!MessageQueue(T).Message {
            return self.mq.receiveWithPriority(timeout);
        }

        /// Get maximum number of messages in the queue
        pub fn getCapacity(self: *const @This()) u32 {
            return self.mq.getCapacity();
        }

        /// Get maximum message size in bytes
        pub fn getMsgSize(self: *const @This()) u32 {
            return self.mq.getMsgSize();
        }

        /// Get number of queued messages
        pub fn getCount(self: *const @This()) usize {
            return self.mq.getCount();
        }

        /// Get number of available slots for messages
        pub fn getSpace(self: *const @This()) usize {
            return self.mq.getSpace();
        }

        /// Reset the message queue to initial empty state
        pub fn reset(self: *const @This()) osError!void {
            return self.mq.reset();
        }

        /// Delete the message queue
        pub fn delete(self: *const @This()) osError!void {
            return self.mq.delete();
        }

        /// Check if queue is empty
        pub fn isEmpty(self: *const @This()) bool {
            return self.mq.isEmpty();
        }

        /// Check if queue is full
        pub fn isFull(self: *const @This()) bool {
            return self.mq.isFull();
        }

        /// Try to put without blocking (timeout = 0)
        pub fn tryPut(self: *const @This(), msg: *const T, msg_prio: u8) osError!void {
            return self.mq.tryPut(msg, msg_prio);
        }

        /// Try to receive without blocking (returns message directly)
        pub fn tryReceive(self: *const @This()) osError!T {
            return self.mq.tryReceive();
        }

        /// Put with forever timeout
        pub fn putBlocking(self: *const @This(), msg: *const T, msg_prio: u8) osError!void {
            return self.mq.putBlocking(msg, msg_prio);
        }

        /// Receive with forever timeout (returns message directly)
        pub fn receiveBlocking(self: *const @This()) osError!T {
            return self.mq.receiveBlocking();
        }
    };
}
