//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const rtx = @import("cmsis_rtx");

extern fn main() callconv(.C) c_int;

const job_queue_fn = *const fn (param1: ?*anyopaque) void;

const job_queue_element = struct {
    job_fn: job_queue_fn,
    param1: ?*anyopaque,
};

var jobQueueTask: struct {
    thread: rtx.StaticThread(@This(), 8 * 128, "jobRunner", jobRunner),
    queue: rtx.StaticMessageQueue(job_queue_element, 5, "jobQueue"),

    fn new(self: *@This(), priority: rtx.thread.osThreadPriority) !void {
        try self.thread.new(self, 0, priority);
        try self.queue.new(0);
    }

    /// Job Runner Function
    fn jobRunner(arg: ?*@This()) void {
        periodic_timer.start(1000) catch {};

        while (true) {
            if (arg.?.queue.getMsg(rtx.osWaitForever)) |msg| {
                msg.data.job_fn(msg.data.param1);
            } else |_| {
                // Catch errors
            }
        }
    }

    pub fn submitJob(self: *@This(), jobfn: job_queue_fn, param1: ?*anyopaque, timeout: u32) !void {
        try self.queue.put(&job_queue_element{ .job_fn = jobfn, .param1 = param1 }, 0, timeout);
    }
} = undefined;

fn job(param: ?*anyopaque) void {
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

    // periodic_timer.start(1000) catch {};

    rtx.kernel.start() catch {};

    unreachable;
}

export fn _start() linksection(".init") callconv(.naked) void {
    asm volatile ("b Reset_Handler");
}
