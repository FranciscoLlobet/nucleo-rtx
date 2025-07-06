// Copyright (c) 2025 Francisco Llobet-Blandino.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
