//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const rtx = @import("cmsis_rtx");
const threadx = @import("threadx");

extern fn main() callconv(.C) c_int;

pub fn JobQueueTask(comptime T: type, comptime stack_size: usize, comptime queue_len: usize, comptime name: []const u8) type {
    return struct {
        /// Job Function Type
        pub const jobFnType = *const fn (param1: ?*T) void;

        /// Job Parameter Type
        pub const jobFnParamType = ?*T;

        /// Job Queue Element Type
        const jobQueueElement = struct {
            job_fn: jobFnType,
            param1: jobFnParamType,
        };

        /// Static Thread
        thread: rtx.StaticThread(@This(), stack_size, name ++ "Runner", jobRunner),

        /// Static Job Queue
        queue: rtx.StaticMessageQueue(jobQueueElement, queue_len, name ++ "Queue"),

        fn jobRunner(arg: ?*@This()) void {
            periodic_timer.start(1000) catch {};
            while (true) {
                if (arg.?.queue.getMsg(rtx.osWaitForever)) |el| {
                    el.msg.job_fn(el.msg.param1);
                } else |err| switch (err) {
                    rtx.osError.osErrorTimeout => {
                        continue; // Timeout, just continue
                    },
                    else => {
                        // Other errors
                    },
                }
            }
        }

        pub fn submitJob(self: *@This(), jobfn: jobFnType, param1: jobFnParamType, timeout: u32) !void {
            try self.queue.put(&jobQueueElement{ .job_fn = jobfn, .param1 = param1 }, 0, timeout);
        }

        pub fn new(self: *@This(), priority: rtx.thread.osThreadPriority) !void {
            try self.thread.new(self, 0, priority);
            try self.queue.new(0);
        }
    };
}

const jobQueueTaskType = JobQueueTask(u32, 1024, 5, "JobQueue");

var jobQueueTask: jobQueueTaskType = undefined;

fn job(param: jobQueueTaskType.jobFnParamType) void {
    _ = param;
}

fn periodic_callback(arg: ?*@TypeOf(jobQueueTask)) void {
    arg.?.submitJob(job, null, 0) catch {};
}

var periodic_timer: rtx.StaticTimer(@TypeOf(jobQueueTask), "Periodic Timer", periodic_callback) = undefined;

export fn zmain() noreturn {
    _ = main();

    rtx.kernel.initialize() catch {};

    jobQueueTask.new(.osPriorityNormal) catch {};

    periodic_timer.new(.osTimerPeriodic, &jobQueueTask, 0) catch {};

    rtx.kernel.start() catch {};

    unreachable;
}

export fn _start() linksection(".init") callconv(.naked) void {
    asm volatile ("b Reset_Handler");
}
