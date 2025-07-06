const c_rtx = @import("c.zig").c_rtx;
const core = @import("core.zig");

pub const osError = core.osError;
const osErrorMap = core.osErrorMap;

pub const osSemaphoreAttr_t = c_rtx.osSemaphoreAttr_t;
pub const osSemaphoreId_t = c_rtx.osSemaphoreId_t;

pub const osSemaphoreNew = c_rtx.osSemaphoreNew;
pub const osSemaphoreGetName = c_rtx.osSemaphoreGetName;
pub const osSemaphoreAcquire = c_rtx.osSemaphoreAcquire;
pub const osSemaphoreRelease = c_rtx.osSemaphoreRelease;
pub const osSemaphoreGetCount = c_rtx.osSemaphoreGetCount;
pub const osSemaphoreDelete = c_rtx.osSemaphoreDelete;

const semaphore = @This();

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
