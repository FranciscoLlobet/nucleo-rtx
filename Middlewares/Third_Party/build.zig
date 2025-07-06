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
const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "cmsis_rtx",
        .target = target,
        .optimize = optimize,
    });

    const mod = b.addModule("cmsis_rtx", .{
        .root_source_file = b.path("src/rtx.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.addCSourceFiles(.{ .files = &.{
        "CMSIS-RTX/Source/rtx_delay.c",
        "CMSIS-RTX/Source/rtx_evflags.c",
        "CMSIS-RTX/Source/rtx_kernel.c",
        "CMSIS-RTX/Source/rtx_evr.c",
        "CMSIS-RTX/Source/rtx_lib.c",
        "CMSIS-RTX/Source/rtx_memory.c",
        "CMSIS-RTX/Source/rtx_mempool.c",
        "CMSIS-RTX/Source/rtx_msgqueue.c",
        "CMSIS-RTX/Source/rtx_mutex.c",
        "CMSIS-RTX/Source/rtx_semaphore.c",
        "CMSIS-RTX/Source/rtx_system.c",
        "CMSIS-RTX/Source/rtx_thread.c",
        "CMSIS-RTX/Source/rtx_timer.c",
        "CMSIS-RTX/Source/GCC/irq_armv7m.S",
        "CMSIS_6/CMSIS/RTOS2/Source/os_systick.c",
    }, .flags = &.{
        "-std=c99",
        "-DCMSIS_device_header=\"stm32g4xx.h\"",
        "-DSTM32G474xx",
        "-O2",
        "-DUSE_HAL_DRIVER",
        "-ffunction-sections",
        "-fdata-sections",
    } });

    lib.addIncludePath(b.path("../../Core/Inc/"));

    lib.addIncludePath(b.path("CMSIS-RTX/Include"));
    lib.addIncludePath(b.path("CMSIS_6/CMSIS/Core/Include"));
    lib.addIncludePath(b.path("CMSIS_6/CMSIS/RTOS2/Include"));

    // STM32 CMSIS
    lib.addIncludePath(b.path("../../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));
    lib.addIncludePath(b.path("../../Drivers/stm32_hal/STM32G4xx_HAL_Driver/Inc"));

    // Stdlib
    lib.addIncludePath(b.path("../../picolibc/include"));

    mod.addIncludePath(b.path("../../Core/Inc/"));

    mod.addIncludePath(b.path("CMSIS-RTX/Include"));
    mod.addIncludePath(b.path("CMSIS_6/CMSIS/Core/Include"));
    mod.addIncludePath(b.path("CMSIS_6/CMSIS/RTOS2/Include"));

    mod.addIncludePath(b.path("../../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));
    mod.addIncludePath(b.path("../../Drivers/stm32_hal/STM32G4xx_HAL_Driver/Inc"));
    mod.addIncludePath(b.path("../../picolibc/include"));

    //lib.installHeader(source: LazyPath, dest_rel_path: []const u8)

    b.installArtifact(lib);
}
