const c_rtx = @import("c.zig").c_rtx;
const core = @import("core.zig");

pub const osError = core.osError;
const osErrorMap = core.osErrorMap;

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

fn messageQueueMemSize(comptime msg_count: usize, comptime msg_size: usize) usize {
    return @intCast((4 * @as(u32, @intCast(msg_count))) * (3 + ((@as(u32, @intCast(msg_size)) + 3) / 4)));
}

pub fn MessageQueue(comptime T: type) type {
    return struct {
        id: osMessageQueueId_t = undefined,

        pub const Message = struct {
            data: T,
            priority: u8,
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
        storage: [messageQueueMemSize(msg_count, @sizeOf(T))]u8 align(4) = undefined,

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

        /// Ger a message from the queue
        pub fn getMsg(self: *const @This(), timeout: u32) osError!MessageQueue(T).Message {
            var msg: MessageQueue(T).Message = undefined;

            try self.get(&(msg.data), &(msg.priority), timeout);

            return msg;
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
    };
}
