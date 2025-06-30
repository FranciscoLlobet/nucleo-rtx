const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {

    //const target = b.standardTargetOptions(.{});
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .eabi,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m33 },
    });

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "core",
        .root_source_file = b.path("Src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.addCSourceFiles(.{ .files = &.{
        "Src/main.c",
        "Src/system_stm32g4xx.c",
        "Src/RTX_Config.c",
        "Src/spi.c",
        "Src/stm32g4xx_hal_msp.c",
        "Src/stm32g4xx_hal_timebase_tim.c",
        "Src/stm32g4xx_it.c",
    }, .flags = &.{
        "-std=c99",
        "-DCMSIS_device_header=stm32g4xx.h",
        "-DSTM32G474xx",
        "-DEBUG -DUSE_HAL_DRIVER",
    } });

    lib.addIncludePath(b.path("Inc"));
    lib.addIncludePath(b.path("../Drivers/STM32G4xx_HAL_Driver/Inc"));
    lib.addIncludePath(b.path("../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));
    lib.addIncludePath(b.path("../Middlewares/Third_Party/CMSIS_6/CMSIS/Core/Include"));
    lib.addIncludePath(b.path("../Middlewares/Third_Party/CMSIS_6/CMSIS/RTOS2/Include"));
    lib.addIncludePath(b.path("../Middlewares/Third_Party/CMSIS-RTX/Include"));
    lib.addIncludePath(b.path("../picolibc/include"));
    lib.addIncludePath(b.path("../sensors/no-OS/include"));
    lib.addIncludePath(b.path("../sensors/no-OS/drivers/adc/ad7124"));
    b.installArtifact(lib);

    // const lib_module = b.addModule("core", .{ .root_source_file = b.path("src/root.zig"), .target = target, .optimize = optimize });

}
