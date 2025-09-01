const std = @import("std");

const core = @import("core.zig");

const c = core.c;
const osError = core.osError;
const osErrorMap = core.osErrorMap;

const tick_value_t = core.tick_value_t;
const return_values = core.return_values;

const TX_QUEUE = c.TX_QUEUE;

pub fn Queue(comptime T: type) type {
    return struct {
        tx_queue: TX_QUEUE = undefined,

        pub fn create(name: [*:0]const u8, queue_storage: []T) osError!@This() {
            var queue: @This() = undefined;

            try osErrorMap(c._tx_queue_create(
                &queue.tx_queue,
                @constCast(name),
                @intCast(@sizeOf(T)),
                queue_storage.ptr,
                @as(c.ULONG, @intCast(queue_storage.len)),
            ));

            return queue;
        }

        pub fn send(self: @This(), element: *const T, wait_option: tick_value_t) osError!void {
            try osErrorMap(c.tx_queue_send(
                &self.queue,
                @ptrCast(element),
                @intCast(wait_option),
            ));
        }

        pub fn receive(self: @This(), element: *T, wait_option: tick_value_t) osError!void {
            try osErrorMap(c.tx_queue_receive(
                &self.queue,
                @ptrCast(element),
                @intCast(wait_option),
            ));
        }
    };
}

pub fn StaticQueue(comptime T: type, comptime len: usize, comptime name: [*:0]const u8) type {
    return struct {
        queue: Queue(T) = undefined,
        storage: [len]T align(4) = undefined,

        pub fn create(self: *@This()) osError!void {
            self.queue = try Queue(T).create(name, &self.storage);
        }
        pub fn send(self: *@This(), element: *const T, wait_option: tick_value_t) osError!void {
            try self.queue.send(element, wait_option);
        }
        pub fn receive(self: *@This(), element: *T, wait_option: tick_value_t) osError!void {
            try self.queue.receive(element, wait_option);
        }
    };
}

//pub fn StaticQueue(T: type, usize n_elements) type
//{
//    return struct{

//        create(self : @This(), )

//    }
//}

//UINT        _tx_queue_create(TX_QUEUE *queue_ptr, CHAR *name_ptr, UINT message_size,
//                        VOID *queue_start, ULONG queue_size);
//UINT        _tx_queue_delete(TX_QUEUE *queue_ptr);
//UINT        _tx_queue_flush(TX_QUEUE *queue_ptr);
//UINT        _tx_queue_info_get(TX_QUEUE *queue_ptr, CHAR **name, ULONG *enqueued, ULONG *available_storage,
//                    TX_THREAD **first_suspended, ULONG *suspended_count, TX_QUEUE **next_queue);
//UINT        _tx_queue_performance_info_get(TX_QUEUE *queue_ptr, ULONG *messages_sent, ULONG *messages_received,
//                    ULONG *empty_suspensions, ULONG *full_suspensions, ULONG *full_errors, ULONG *timeouts);
//UINT        _tx_queue_performance_system_info_get(ULONG *messages_sent, ULONG *messages_received,
//                    ULONG *empty_suspensions, ULONG *full_suspensions, ULONG *full_errors, ULONG *timeouts);
//UINT        _tx_queue_prioritize(TX_QUEUE *queue_ptr);
//UINT        _tx_queue_receive(TX_QUEUE *queue_ptr, VOID *destination_ptr, ULONG wait_option);
//UINT        _tx_queue_send(TX_QUEUE *queue_ptr, VOID *source_ptr, ULONG wait_option);
//UINT        _tx_queue_send_notify(TX_QUEUE *queue_ptr, VOID (*queue_send_notify)(TX_QUEUE *notify_queue_ptr));
//UINT        _tx_queue_front_send(TX_QUEUE *queue_ptr, VOID *source_ptr, ULONG wait_option);
