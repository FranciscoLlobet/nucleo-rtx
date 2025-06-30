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

    exe.addObjectFile(stm32_hal_package.artifact("stm32_hal").getEmittedBin());
    exe.addObjectFile(cmsis_rtx_package.artifact("cmsis_rtx").getEmittedBin());
    exe.addObjectFile(core_package.artifact("Core").getEmittedBin());
    exe.addObjectFile(b.path("picolibc/libc.a"));
    exe.addObjectFile(b.path("picolibc/libcrt0.a"));

    exe.setLinkerScript(b.path("STM32G474_picolibc.ld"));

    b.installArtifact(exe);

    // const lib_module = b.addModule("core", .{ .root_source_file = b.path("src/root.zig"), .target = target, .optimize = optimize });

}
