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
        .cpu_features_add = std.Target.arm.featureSet(&.{.vfp4d16sp}),
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

    const threadx_package = b.dependency("threadx", .{
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
    exe.addIncludePath(threadx_package.artifact("threadx").getEmittedIncludeTree().path(b, "threadx/include"));

    exe.addIncludePath(b.path("picolibc/include"));

    exe.addAssemblyFile(b.path("Core/Startup/startup_stm32g474retx.s"));

    exe.root_module.addImport("cmsis_rtx", cmsis_rtx_package.module("cmsis_rtx"));
    exe.root_module.addImport("threadx", threadx_package.module("threadx"));
    exe.addObjectFile(core_package.artifact("Core").getEmittedBin());
    exe.addObjectFile(stm32_hal_package.artifact("stm32_hal").getEmittedBin());
    exe.addObjectFile(cmsis_rtx_package.artifact("cmsis_rtx").getEmittedBin());
    exe.addObjectFile(threadx_package.artifact("threadx").getEmittedBin());

    exe.addObjectFile(b.path("picolibc/libc.a"));

    exe.setLinkerScript(b.path("STM32G474_picolibc.ld"));

    const bin = b.addObjCopy(exe.getEmittedBin(), .{
        .format = .bin,
    });
    const hex = b.addObjCopy(exe.getEmittedBin(), .{ .format = .hex });
    b.installArtifact(exe);

    b.getInstallStep().dependOn(&b.addInstallBinFile(bin.getOutput(), "app.bin").step);
    b.getInstallStep().dependOn(&b.addInstallBinFile(hex.getOutput(), "app.hex").step);
}
