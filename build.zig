const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
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

    // Common dependencies
    const stm32_hal_package = b.dependency("stm32_hal", .{
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

    // RTOS-specific dependencies
    const cmsis_rtx_package = b.dependency("cmsis_rtx", .{
        .optimize = optimize,
        .target = target,
    });

    const threadx_package = b.dependency("threadx", .{
        .optimize = optimize,
        .target = target,
    });

    // RTX Build
    const rtx_exe = b.addExecutable(.{
        .name = "nucleo-rtx.elf",
        .root_source_file = b.path("src/rtx/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add common includes to RTX
    addCommonIncludes(rtx_exe, b, core_package, stm32_hal_package, cmsis_6_package);

    // Add RTX-specific includes
    rtx_exe.addIncludePath(cmsis_rtx_package.artifact("cmsis_rtx").getEmittedIncludeTree().path(b, "cmsis_rtx/include"));
    rtx_exe.addIncludePath(cmsis_6_package.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/rtos2/include"));

    // Add common objects to RTX
    addCommonObjects(rtx_exe, b, core_package, stm32_hal_package);

    // Add RTX-specific objects
    rtx_exe.root_module.addImport("cmsis_rtx", cmsis_rtx_package.module("cmsis_rtx"));
    rtx_exe.addObjectFile(cmsis_rtx_package.artifact("cmsis_rtx").getEmittedBin());

    rtx_exe.setLinkerScript(b.path("STM32G474_picolibc.ld"));

    // ThreadX Build
    const threadx_exe = b.addExecutable(.{
        .name = "nucleo-threadx.elf",
        .root_source_file = b.path("src/threadx/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add common includes to ThreadX
    addCommonIncludes(threadx_exe, b, core_package, stm32_hal_package, cmsis_6_package);

    // Add ThreadX-specific includes
    threadx_exe.addIncludePath(threadx_package.artifact("threadx").getEmittedIncludeTree().path(b, "threadx/include"));

    // Add common objects to ThreadX
    addCommonObjects(threadx_exe, b, core_package, stm32_hal_package);

    // Add ThreadX-specific objects
    threadx_exe.root_module.addImport("threadx", threadx_package.module("threadx"));
    threadx_exe.addObjectFile(threadx_package.artifact("threadx").getEmittedBin());

    threadx_exe.setLinkerScript(b.path("STM32G474_picolibc.ld"));

    // Create binary and hex outputs for RTX
    const rtx_bin = b.addObjCopy(rtx_exe.getEmittedBin(), .{ .format = .bin });
    const rtx_hex = b.addObjCopy(rtx_exe.getEmittedBin(), .{ .format = .hex });

    // Create binary and hex outputs for ThreadX
    const threadx_bin = b.addObjCopy(threadx_exe.getEmittedBin(), .{ .format = .bin });
    const threadx_hex = b.addObjCopy(threadx_exe.getEmittedBin(), .{ .format = .hex });

    // Install steps
    const rtx_step = b.step("rtx", "Build RTX project");
    rtx_step.dependOn(&b.addInstallArtifact(rtx_exe, .{}).step);
    rtx_step.dependOn(&b.addInstallBinFile(rtx_bin.getOutput(), "nucleo-rtx.bin").step);
    rtx_step.dependOn(&b.addInstallBinFile(rtx_hex.getOutput(), "nucleo-rtx.hex").step);

    const threadx_step = b.step("threadx", "Build ThreadX project");
    threadx_step.dependOn(&b.addInstallArtifact(threadx_exe, .{}).step);
    threadx_step.dependOn(&b.addInstallBinFile(threadx_bin.getOutput(), "nucleo-threadx.bin").step);
    threadx_step.dependOn(&b.addInstallBinFile(threadx_hex.getOutput(), "nucleo-threadx.hex").step);

    // Default step builds both
    const all_step = b.step("all", "Build both RTX and ThreadX projects");
    all_step.dependOn(rtx_step);
    all_step.dependOn(threadx_step);

    // Make "all" the default
    b.default_step = all_step;
}

fn addCommonIncludes(exe: *std.Build.Step.Compile, b: *std.Build, core_package: *std.Build.Dependency, stm32_hal_package: *std.Build.Dependency, cmsis_6_package: *std.Build.Dependency) void {
    exe.addIncludePath(core_package.artifact("Core").getEmittedIncludeTree().path(b, "core/include"));
    exe.addIncludePath(stm32_hal_package.artifact("stm32_hal").getEmittedIncludeTree().path(b, "stm32_hal/include"));
    exe.addIncludePath(cmsis_6_package.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/core/include"));
    exe.addIncludePath(cmsis_6_package.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/device/st/stm32g4xx/include"));
    exe.addIncludePath(b.path("picolibc/include"));
}

fn addCommonObjects(exe: *std.Build.Step.Compile, b: *std.Build, core_package: *std.Build.Dependency, stm32_hal_package: *std.Build.Dependency) void {
    exe.addAssemblyFile(b.path("Core/Startup/startup_stm32g474retx.s"));
    exe.addObjectFile(core_package.artifact("Core").getEmittedBin());
    exe.addObjectFile(stm32_hal_package.artifact("stm32_hal").getEmittedBin());
    exe.addObjectFile(b.path("picolibc/libc.a"));
}
