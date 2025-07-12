const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    //const target = b.resolveTargetQuery(.{
    //    .cpu_arch = .thumb,
    //    .os_tag = .freestanding,
    //    .abi = .eabi,
    //    .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
    //});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "Core",
        .root_source_file = b.path("Src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const stm32_hal = b.dependency("stm32_hal", .{});
    const cmsis_6 = b.dependency("cmsis_6", .{});
    // const cmsis_rtx = b.dependency("cmsis_rtx", .{});

    lib.addCSourceFiles(.{ .files = &.{
        "Src/main.c",

        "Src/RTX_Config.c",
        "Src/spi.c",
        "Src/stm32g4xx_hal_timebase_tim.c",
        "Src/stm32g4xx_hal_msp.c",
        "Src/stm32g4xx_it.c",
        "Src/system_stm32g4xx.c",
        "../sensors/no-OS/drivers/adc/ad7124/ad7124.c",
        "../sensors/no-OS/drivers/adc/ad7124/ad7124_regs.c",
        "../sensors/no-OS/util/no_os_util.c",
    }, .flags = &.{
        "-std=c99",
        "-Og",
        "-DCMSIS_device_header=\"stm32g4xx.h\"",
        "-DSTM32G474xx",
        "-DUSE_HAL_DRIVER",
        "-ffunction-sections",
        "-fdata-sections",
    } });

    lib.addIncludePath(b.path("Inc"));

    lib.addIncludePath(stm32_hal.artifact("stm32_hal").getEmittedIncludeTree().path(b, "stm32_hal/include"));
    lib.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/core/include"));
    lib.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/device/st/stm32g4xx/include"));
    //lib.addIncludePath(b.path("../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));
    //lib.addIncludePath(b.path("../Platform/CMSIS_6/CMSIS_6/CMSIS/Core/Include"));
    lib.addIncludePath(b.path("../Platform/CMSIS_6/CMSIS_6/CMSIS/RTOS2/Include"));
    lib.addIncludePath(b.path("../Platform/CMSIS-RTX/CMSIS-RTX/Include"));
    lib.addIncludePath(b.path("../picolibc/include"));
    lib.addIncludePath(b.path("../sensors/no-OS/include"));
    lib.addIncludePath(b.path("../sensors/no-OS/drivers/adc/ad7124"));

    lib.installHeadersDirectory(b.path("Inc"), "core/include", .{});
    b.installArtifact(lib);
}
