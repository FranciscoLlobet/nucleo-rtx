// Copyright 2025 Francisco Llobet-Blandino
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
const core = @import("core.zig");
const c_rtx = core.c_rtx;

pub const osError = core.osError;

const osErrorMap = core.osErrorMap;

const kernel = @This();

pub const osKernelState = enum(i32) {
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

pub fn getState() osKernelState {
    return @enumFromInt(c_rtx.osKernelGetState());
}

pub fn getTickCount() u32 {
    return c_rtx.osKernelGetTickCount();
}

pub fn getSysTimerFreq() u32 {
    return c_rtx.osKernelGetSysTimerFreq();
}
