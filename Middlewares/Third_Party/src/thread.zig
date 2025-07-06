const core = @import("core.zig");
const c_rtx = core.c_rtx;
const eventFlags = @import("eventFlags.zig");

pub const osError = core.osError;
pub const osFlagsError = eventFlags.osFlagsError;

const osErrorMap = core.osErrorMap;
const osFlagsErrorMap = eventFlags.osFlagsErrorMap;

pub const osThreadId_t = c_rtx.osThreadId_t;
pub const osThreadFunc_t = c_rtx.osThreadFunc_t;
pub const osThreadAttr_t = c_rtx.osThreadAttr_t;
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

const thread = @This();

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
    return if (self.id == c_rtx.osThreadGetId()) osErrorMap(osThreadYield()) else osError.osError;
}

pub fn threadSuspend(self: *const @This()) osError!void {
    return osErrorMap(osThreadSuspend(self.id));
}

pub fn threadResume(self: *const @This()) osError!void {
    return osErrorMap(osThreadResume(self.id));
}

pub fn flagsSet(self: *const @This(), flags: u32) osFlagsError!u32 {
    return osFlagsErrorMap(osThreadFlagsSet(self.id, flags));
}

pub fn flagsClear(self: *const @This(), flags: u32) osFlagsError!u32 {
    return if (self.id == osThreadGetId()) osFlagsErrorMap(osThreadFlagsClear(flags)) else osFlagsError.osFlagsErrorUnknown;
}

pub fn flagsGet(self: *const @This()) osFlagsError!u32 {
    return if (self.id == osThreadGetId()) osFlagsErrorMap(osThreadFlagsGet()) else osFlagsError.osFlagsErrorUnknown;
}

pub fn flagsWait(self: *const @This(), flags: u32, options: u32, timeout: u32) osFlagsError!u32 {
    return if (self.id == osThreadGetId()) osFlagsErrorMap(osThreadFlagsWait(flags, options, timeout)) else osFlagsError.osFlagsErrorUnknown;
}

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

        pub fn new(self: *@This(), arg: ?*T, attr_bits: u32, priority: thread.osThreadPriority) osError!void {

            // Thread attributes
            const attr: c_rtx.osThreadAttr_t = .{
                .name = name,
                .attr_bits = attr_bits,
                .cb_mem = &self.cb,
                .cb_size = @sizeOf(c_rtx.osRtxThread_t),
                .stack_mem = self.stack[0..].ptr,
                .stack_size = self.stack[0..].len,
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
        pub fn flagsSet(self: *const @This(), flags: u32) osFlagsError!u32 {
            return self.thread.flagsSet(flags);
        }
        pub fn flagsClear(self: *const @This(), flags: u32) osFlagsError!u32 {
            return self.thread.flagsClear(flags);
        }
        pub fn flagsGet(self: *const @This()) osFlagsError!u32 {
            return self.thread.flagsGet();
        }
        pub fn flagsWait(self: *const @This(), flags: u32, options: u32, timeout: u32) osFlagsError!u32 {
            return self.thread.flagsWait(flags, options, timeout);
        }
    };
}
