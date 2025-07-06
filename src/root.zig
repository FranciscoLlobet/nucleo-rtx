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
    thread: rtx.StaticThread(@This(), 8 * 128, "Test Queue", threadRunner) = undefined,
    timer: rtx.StaticTimer(@This(), "Job Queue Timer", timerFn),
    event: rtx.StaticEventFlags("Event"),
    queue: rtx.StaticMessageQueue(job_queue_element, 5, "msg queue"),

    fn new(self: *@This()) !void {
        try self.thread.new(self, 0, .osPriorityNormal);
        try self.timer.new(.osTimerPeriodic, self, 0);
        try self.event.new(0);
        try self.queue.new(0);
    }

    fn threadRunner(arg: ?*@This()) void {
        arg.?.timer.start(1000) catch {};

        while (true) {
            if (arg.?.queue.getMsg(500)) |msg| {
                msg.data.job_fn(msg.data.param1);
            } else |_| {
                // Catch errors
            }

            // if (arg.?.event.wait(0xFF, .osFlagsWaitAny, 500)) |val| {
            //     _ = val;
            //
            // } else |err| {
            //     if (err == rtx.osError.osError) {
            //
            //     } else if (err == rtx.osError.osErrorTimeout) {
            //
            //    } else {}
            //
        }
    }

    fn job(param1: ?*anyopaque) void {
        _ = param1;
        //
    }

    fn timerFn(arg: ?*@This()) void {
        arg.?.queue.put(&job_queue_element{ .job_fn = job, .param1 = null }, 0, 0) catch {};
    }
} = undefined;

export fn zmain() noreturn {
    _ = main();

    rtx.kernel.initialize() catch {};

    jobQueueTask.new() catch {};

    rtx.kernel.start() catch {};

    unreachable;
}

export fn _start() linksection(".init") callconv(.naked) void {
    asm volatile ("b Reset_Handler");
}
