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
        .name = "stm32_hal",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.addCSourceFiles(.{ .files = &.{
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_cortex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_dma_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_dma.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_exti.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_flash_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_flash_ramfunc.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_flash.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_gpio.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_pwr_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_pwr.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_rcc_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_rcc.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_rtc_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_rtc.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_spi_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_spi.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_tim_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_tim.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_uart_ex.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_uart.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_wwdg.c",
        "STM32G4xx_HAL_Driver/Src/stm32g4xx_hal.c",
    }, .flags = &.{
        "-std=c99",
        "-O2",
        "-DCMSIS_device_header=\"stm32g4xx.h\"",
        "-DSTM32G474xx",
        "-DUSE_HAL_DRIVER",
        "-ffunction-sections",
        "-fdata-sections",
    } });

    lib.addIncludePath(b.path("../../Core/Inc"));
    lib.addIncludePath(b.path("STM32G4xx_HAL_Driver/Inc"));
    lib.addIncludePath(b.path("../CMSIS/Device/ST/STM32G4xx/Include"));
    lib.addIncludePath(b.path("../../Middlewares/Third_Party/CMSIS_6/CMSIS/Core/Include"));
    //   lib.addIncludePath(b.path("../../picolibc/include"));
    b.installArtifact(lib);
}
