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

    const stm32_hal = b.dependency("stm32_hal", .{});

    const Core = b.dependency("Core", .{});

    const cmsis_6 = b.dependency("cmsis_6", .{});

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
        "../CMSIS_6/CMSIS_6/CMSIS/RTOS2/Source/os_systick.c",
    }, .flags = &.{
        "-std=c99",
        "-DCMSIS_device_header=\"stm32g4xx.h\"",
        "-DSTM32G474xx",
        "-O2",
        "-DUSE_HAL_DRIVER",
        "-ffunction-sections",
        "-fdata-sections",
    } });

    lib.addIncludePath(Core.artifact("Core").getEmittedIncludeTree().path(b, "core/include"));
    lib.addIncludePath(stm32_hal.artifact("stm32_hal").getEmittedIncludeTree().path(b, "stm32_hal/include"));
    lib.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/core/include"));
    lib.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/rtos2/include"));
    lib.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/device/st/stm32g4xx/include"));

    lib.addIncludePath(b.path("CMSIS-RTX/Include"));

    // STM32 CMSIS
    lib.addIncludePath(b.path("../../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));

    // Stdlib
    lib.addIncludePath(b.path("../../picolibc/include"));

    lib.installHeadersDirectory(b.path("CMSIS-RTX/Include"), "cmsis_rtx/include", .{});

    mod.addIncludePath(Core.artifact("Core").getEmittedIncludeTree().path(b, "core/include"));
    mod.addIncludePath(stm32_hal.artifact("stm32_hal").getEmittedIncludeTree().path(b, "stm32_hal/include"));

    mod.addIncludePath(b.path("CMSIS-RTX/Include"));
    mod.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/core/include"));
    mod.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/rtos2/include"));
    mod.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/device/st/stm32g4xx/include"));

    mod.addIncludePath(b.path("../../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));
    mod.addIncludePath(b.path("../../picolibc/include"));

    b.installArtifact(lib);
}
