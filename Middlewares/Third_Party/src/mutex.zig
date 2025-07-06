const c_rtx = @import("c.zig").c_rtx;
const core = @import("core.zig");

pub const osError = core.osError;
const osErrorMap = core.osErrorMap;
pub const osThreadId_t = core.osThreadId_t;

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

const mutex = @This();

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
