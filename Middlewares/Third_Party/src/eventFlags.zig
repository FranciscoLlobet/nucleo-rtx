const c_rtx = @import("c.zig").c_rtx;
const core = @import("core.zig");

const osStatus_t = core.osStatus_t;

pub const osError = core.osError;
pub const osErrorMap = core.osErrorMap;

pub const osFlagsWaitAny = c_rtx.osFlagsWaitAny;
pub const osFlagsWaitAll = c_rtx.osFlagsWaitAll;
pub const osFlagsNoClear = c_rtx.osFlagsNoClear;

pub const osEventFlagsAttr_t = c_rtx.osEventFlagsAttr_t;
pub const osEventFlagsId_t = c_rtx.osEventFlagsId_t;

pub const osEventFlagsNew = c_rtx.osEventFlagsNew;
pub const osEventFlagsGetName = c_rtx.osEventFlagsGetName;
pub const osEventFlagsSet = c_rtx.osEventFlagsSet;
pub const osEventFlagsClear = c_rtx.osEventFlagsClear;
pub const osEventFlagsGet = c_rtx.osEventFlagsGet;
pub const osEventFlagsWait = c_rtx.osEventFlagsWait;
pub const osEventFlagsDelete = c_rtx.osEventFlagsDelete;

pub const osFlagsError = error{
    osFlagsErrorUnknown,
    osFlagsErrorTimeout,
    osFlagsErrorResource,
    osFlagsErrorParameter,
    osFlagsErrorISR,
    osFlagsErrorSafetyClass,
};

fn osFlagsErrorMap(ef: u32) osFlagsError!u32 {
    if (@as(u32, @intCast(c_rtx.osFlagsError & ef)) == @as(u32, @intCast(c_rtx.osFlagsError))) {
        return switch (ef) {
            c_rtx.osFlagsErrorUnknown => osFlagsError.osFlagsErrorUnknown,
            c_rtx.osFlagsErrorTimeout => osFlagsError.osFlagsErrorTimeout,
            c_rtx.osFlagsErrorResource => osFlagsError.osFlagsErrorResource,
            c_rtx.osFlagsErrorParameter => osFlagsError.osFlagsErrorParameter,
            c_rtx.osFlagsErrorISR => osFlagsError.osFlagsErrorISR,
            c_rtx.osFlagsErrorSafetyClass => osFlagsError.osFlagsErrorSafetyClass,
            else => osFlagsError.osFlagsErrorUnknown,
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
    pub fn set(self: *const @This(), flags: u32) osFlagsError!u32 {
        return osFlagsErrorMap(osEventFlagsSet(self.id, flags));
    }

    /// Clear specified event flags
    pub fn clear(self: *const @This(), flags: u32) osFlagsError!u32 {
        return osFlagsErrorMap(osEventFlagsClear(self.id, flags));
    }

    /// Get current event flags
    pub fn get(self: *const @This()) osFlagsError!u32 {
        return osFlagsErrorMap(osEventFlagsGet(self.id));
    }

    /// Wait for one or more event flags to become signaled
    pub fn wait(self: *const @This(), flags: u32, options: u32, timeout: u32) osFlagsError!u32 {
        return osFlagsErrorMap(osEventFlagsWait(self.id, flags, options, timeout));
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
        pub fn set(self: *const @This(), flags: u32) osFlagsError!u32 {
            return self.ef.set(flags);
        }

        /// Clear specified event flags
        pub fn clear(self: *const @This(), flags: u32) osFlagsError!u32 {
            return self.ef.clear(flags);
        }

        /// Get current event flags
        pub fn get(self: *const @This()) osFlagsError!u32 {
            return self.ef.get();
        }

        /// Wait for one or more event flags to become signaled
        pub fn wait(self: *const @This(), flags: u32, options: u32, timeout: u32) osFlagsError!u32 {
            return self.ef.wait(flags, options, timeout);
        }

        /// Delete the event flags object
        pub fn delete(self: *const @This()) osError!void {
            return self.ef.delete();
        }
    };
}
