const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {

    //const target = b.standardTargetOptions(.{});
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .eabihf,
        .cpu_model = .{
            .explicit = &std.Target.arm.cpu.cortex_m4,
        },
    });

    const optimize = b.standardOptimizeOption(.{});

    const stm32_hal_package = b.dependency("stm32_hal", .{
        .optimize = optimize,
        .target = target,
    });

    const cmsis_rtx_package = b.dependency("cmsis_rtx", .{
        .optimize = optimize,
        .target = target,
    });

    const cmsis_6_package = b.dependency("cmsis_6", .{
        .optimize = optimize,
        .target = target,
    });

    const core_package = b.dependency("Core", .{
        .optimize = optimize,
        .target = target,
    });

    const exe = b.addExecutable(.{
        .name = "testy.elf",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(core_package.artifact("Core").getEmittedIncludeTree().path(b, "core/include"));
    exe.addIncludePath(stm32_hal_package.artifact("stm32_hal").getEmittedIncludeTree().path(b, "stm32_hal/include"));
    exe.addIncludePath(cmsis_rtx_package.artifact("cmsis_rtx").getEmittedIncludeTree().path(b, "cmsis_rtx/include"));
    exe.addIncludePath(cmsis_6_package.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/core/include"));
    exe.addIncludePath(cmsis_6_package.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/rtos2/include"));
    exe.addIncludePath(cmsis_6_package.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/device/st/stm32g4xx/include"));

    //exe.addIncludePath(b.path("Drivers/stm32_hal/STM32G4xx_HAL_Driver/Inc"));
    //exe.addIncludePath(b.path("Drivers/CMSIS/Device/ST/STM32G4xx/Include"));
    //exe.addIncludePath(b.path("Platform/CMSIS_6/CMSIS_6/CMSIS/Core/Include"));
    // exe.addIncludePath(b.path("Platform/CMSIS_6/CMSIS_6/CMSIS/RTOS2/Include"));
    //exe.addIncludePath(b.path("Platform/CMSIS-RTX/CMSIS-RTX/Include"));
    exe.addIncludePath(b.path("picolibc/include"));

    exe.addAssemblyFile(b.path("Core/Startup/startup_stm32g474retx.s"));

    exe.addCSourceFiles(.{ .files = &.{
        "Core/Src/stm32g4xx_hal_timebase_tim.c",
        "Core/Src/stm32g4xx_hal_msp.c",
        "Core/Src/stm32g4xx_it.c",
        "Core/Src/system_stm32g4xx.c",
    }, .flags = &.{
        "-std=c99",
        "-Og",
        "-DCMSIS_device_header=\"stm32g4xx.h\"",
        "-DSTM32G474xx",
        "-DUSE_HAL_DRIVER",
        "-ffunction-sections",
        "-fdata-sections",
    } });

    exe.root_module.addImport("cmsis_rtx", cmsis_rtx_package.module("cmsis_rtx"));
    exe.addObjectFile(core_package.artifact("Core").getEmittedBin());
    exe.addObjectFile(stm32_hal_package.artifact("stm32_hal").getEmittedBin());
    exe.addObjectFile(cmsis_rtx_package.artifact("cmsis_rtx").getEmittedBin());

    exe.addObjectFile(b.path("picolibc/libc.a"));

    exe.setLinkerScript(b.path("STM32G474_picolibc.ld"));

    b.installArtifact(exe);

    // const lib_module = b.addModule("core", .{ .root_source_file = b.path("src/root.zig"), .target = target, .optimize = optimize });

}
