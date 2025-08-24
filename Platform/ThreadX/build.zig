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

// ThreadX Real-Time Operating System for STM32G4 Cortex-M4 Integration
//
// This build script creates a comprehensive ThreadX RTOS library optimized for
// STM32G4 Cortex-M4 targets with ARM GNU toolchain support. It includes:
// - Core ThreadX kernel implementation
// - Cortex-M4 GNU port with assembly optimizations
// - Error checking extensions (TXE_*)
// - Performance monitoring capabilities
// - STM32 HAL and CMSIS integration
//
// The build follows Microsoft's ThreadX architecture patterns while adapting
// to Zig's build system for seamless integration with embedded projects.

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the main ThreadX static library
    const lib = b.addStaticLibrary(.{
        .name = "threadx",
        .target = target,
        .optimize = optimize,
    });

    // Create Zig module for ThreadX API access
    const mod = b.addModule("threadx", .{
        .root_source_file = b.path("src/threadx.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Import dependencies for STM32G4 integration
    const stm32_hal = b.dependency("stm32_hal", .{});
    const Core = b.dependency("Core", .{});
    const cmsis_6 = b.dependency("cmsis_6", .{});

    // ThreadX Core Implementation - Common source files
    // These files implement the core ThreadX kernel functionality
    const threadx_core_sources = [_][]const u8{
        // Block Pool Management
        "threadx/common/src/tx_block_allocate.c",
        "threadx/common/src/tx_block_pool_cleanup.c",
        "threadx/common/src/tx_block_pool_create.c",
        "threadx/common/src/tx_block_pool_delete.c",
        "threadx/common/src/tx_block_pool_info_get.c",
        "threadx/common/src/tx_block_pool_initialize.c",
        "threadx/common/src/tx_block_pool_performance_info_get.c",
        "threadx/common/src/tx_block_pool_performance_system_info_get.c",
        "threadx/common/src/tx_block_pool_prioritize.c",
        "threadx/common/src/tx_block_release.c",

        // Byte Pool Management (Dynamic Memory)
        "threadx/common/src/tx_byte_allocate.c",
        "threadx/common/src/tx_byte_pool_cleanup.c",
        "threadx/common/src/tx_byte_pool_create.c",
        "threadx/common/src/tx_byte_pool_delete.c",
        "threadx/common/src/tx_byte_pool_info_get.c",
        "threadx/common/src/tx_byte_pool_initialize.c",
        "threadx/common/src/tx_byte_pool_performance_info_get.c",
        "threadx/common/src/tx_byte_pool_performance_system_info_get.c",
        "threadx/common/src/tx_byte_pool_prioritize.c",
        "threadx/common/src/tx_byte_pool_search.c",
        "threadx/common/src/tx_byte_release.c",

        // Event Flags (Thread Synchronization)
        "threadx/common/src/tx_event_flags_cleanup.c",
        "threadx/common/src/tx_event_flags_create.c",
        "threadx/common/src/tx_event_flags_delete.c",
        "threadx/common/src/tx_event_flags_get.c",
        "threadx/common/src/tx_event_flags_info_get.c",
        "threadx/common/src/tx_event_flags_initialize.c",
        "threadx/common/src/tx_event_flags_performance_info_get.c",
        "threadx/common/src/tx_event_flags_performance_system_info_get.c",
        "threadx/common/src/tx_event_flags_set.c",
        "threadx/common/src/tx_event_flags_set_notify.c",

        // Kernel Initialization and Control
        "threadx/common/src/tx_initialize_high_level.c",
        "threadx/common/src/tx_initialize_kernel_enter.c",
        "threadx/common/src/tx_initialize_kernel_setup.c",
        "threadx/common/src/tx_misra.c",

        // Mutex (Priority Inheritance)
        "threadx/common/src/tx_mutex_cleanup.c",
        "threadx/common/src/tx_mutex_create.c",
        "threadx/common/src/tx_mutex_delete.c",
        "threadx/common/src/tx_mutex_get.c",
        "threadx/common/src/tx_mutex_info_get.c",
        "threadx/common/src/tx_mutex_initialize.c",
        "threadx/common/src/tx_mutex_performance_info_get.c",
        "threadx/common/src/tx_mutex_performance_system_info_get.c",
        "threadx/common/src/tx_mutex_prioritize.c",
        "threadx/common/src/tx_mutex_priority_change.c",
        "threadx/common/src/tx_mutex_put.c",

        // Message Queues (Inter-thread Communication)
        "threadx/common/src/tx_queue_cleanup.c",
        "threadx/common/src/tx_queue_create.c",
        "threadx/common/src/tx_queue_delete.c",
        "threadx/common/src/tx_queue_flush.c",
        "threadx/common/src/tx_queue_front_send.c",
        "threadx/common/src/tx_queue_info_get.c",
        "threadx/common/src/tx_queue_initialize.c",
        "threadx/common/src/tx_queue_performance_info_get.c",
        "threadx/common/src/tx_queue_performance_system_info_get.c",
        "threadx/common/src/tx_queue_prioritize.c",
        "threadx/common/src/tx_queue_receive.c",
        "threadx/common/src/tx_queue_send.c",
        "threadx/common/src/tx_queue_send_notify.c",

        // Semaphores (Resource Counting)
        "threadx/common/src/tx_semaphore_ceiling_put.c",
        "threadx/common/src/tx_semaphore_cleanup.c",
        "threadx/common/src/tx_semaphore_create.c",
        "threadx/common/src/tx_semaphore_delete.c",
        "threadx/common/src/tx_semaphore_get.c",
        "threadx/common/src/tx_semaphore_info_get.c",
        "threadx/common/src/tx_semaphore_initialize.c",
        "threadx/common/src/tx_semaphore_performance_info_get.c",
        "threadx/common/src/tx_semaphore_performance_system_info_get.c",
        "threadx/common/src/tx_semaphore_prioritize.c",
        "threadx/common/src/tx_semaphore_put.c",
        "threadx/common/src/tx_semaphore_put_notify.c",

        // Thread Management (Core Threading)
        "threadx/common/src/tx_thread_create.c",
        "threadx/common/src/tx_thread_delete.c",
        "threadx/common/src/tx_thread_entry_exit_notify.c",
        "threadx/common/src/tx_thread_identify.c",
        "threadx/common/src/tx_thread_info_get.c",
        "threadx/common/src/tx_thread_initialize.c",
        "threadx/common/src/tx_thread_performance_info_get.c",
        "threadx/common/src/tx_thread_performance_system_info_get.c",
        "threadx/common/src/tx_thread_preemption_change.c",
        "threadx/common/src/tx_thread_priority_change.c",
        "threadx/common/src/tx_thread_relinquish.c",
        "threadx/common/src/tx_thread_reset.c",
        "threadx/common/src/tx_thread_resume.c",
        "threadx/common/src/tx_thread_shell_entry.c",
        "threadx/common/src/tx_thread_sleep.c",
        "threadx/common/src/tx_thread_stack_analyze.c",
        "threadx/common/src/tx_thread_stack_error_handler.c",
        "threadx/common/src/tx_thread_stack_error_notify.c",
        "threadx/common/src/tx_thread_suspend.c",
        "threadx/common/src/tx_thread_system_preempt_check.c",
        "threadx/common/src/tx_thread_system_resume.c",
        "threadx/common/src/tx_thread_system_suspend.c",
        "threadx/common/src/tx_thread_terminate.c",
        "threadx/common/src/tx_thread_time_slice.c",
        "threadx/common/src/tx_thread_time_slice_change.c",
        "threadx/common/src/tx_thread_timeout.c",
        "threadx/common/src/tx_thread_wait_abort.c",

        // Time Management
        "threadx/common/src/tx_time_get.c",
        "threadx/common/src/tx_time_set.c",

        // Timer Services (Application Timers)
        "threadx/common/src/tx_timer_activate.c",
        "threadx/common/src/tx_timer_change.c",
        "threadx/common/src/tx_timer_create.c",
        "threadx/common/src/tx_timer_deactivate.c",
        "threadx/common/src/tx_timer_delete.c",
        "threadx/common/src/tx_timer_expiration_process.c",
        "threadx/common/src/tx_timer_info_get.c",
        "threadx/common/src/tx_timer_initialize.c",
        "threadx/common/src/tx_timer_performance_info_get.c",
        "threadx/common/src/tx_timer_performance_system_info_get.c",
        "threadx/common/src/tx_timer_system_activate.c",
        "threadx/common/src/tx_timer_system_deactivate.c",
        "threadx/common/src/tx_timer_thread_entry.c",

        // Trace and Debug Support
        "threadx/common/src/tx_trace_buffer_full_notify.c",
        "threadx/common/src/tx_trace_disable.c",
        "threadx/common/src/tx_trace_enable.c",
        "threadx/common/src/tx_trace_event_filter.c",
        "threadx/common/src/tx_trace_event_unfilter.c",
        "threadx/common/src/tx_trace_initialize.c",
        "threadx/common/src/tx_trace_interrupt_control.c",
        "threadx/common/src/tx_trace_isr_enter_insert.c",
        "threadx/common/src/tx_trace_isr_exit_insert.c",
        "threadx/common/src/tx_trace_object_register.c",
        "threadx/common/src/tx_trace_object_unregister.c",
        "threadx/common/src/tx_trace_user_event_insert.c",
    };

    // ThreadX Error Checking Extensions - TXE functions
    // These provide parameter validation and error checking
    const threadx_error_check_sources = [_][]const u8{
        // Block Pool Error Checking
        "threadx/common/src/txe_block_allocate.c",
        "threadx/common/src/txe_block_pool_create.c",
        "threadx/common/src/txe_block_pool_delete.c",
        "threadx/common/src/txe_block_pool_info_get.c",
        "threadx/common/src/txe_block_pool_prioritize.c",
        "threadx/common/src/txe_block_release.c",

        // Byte Pool Error Checking
        "threadx/common/src/txe_byte_allocate.c",
        "threadx/common/src/txe_byte_pool_create.c",
        "threadx/common/src/txe_byte_pool_delete.c",
        "threadx/common/src/txe_byte_pool_info_get.c",
        "threadx/common/src/txe_byte_pool_prioritize.c",
        "threadx/common/src/txe_byte_release.c",

        // Event Flags Error Checking
        "threadx/common/src/txe_event_flags_create.c",
        "threadx/common/src/txe_event_flags_delete.c",
        "threadx/common/src/txe_event_flags_get.c",
        "threadx/common/src/txe_event_flags_info_get.c",
        "threadx/common/src/txe_event_flags_set.c",
        "threadx/common/src/txe_event_flags_set_notify.c",

        // Mutex Error Checking
        "threadx/common/src/txe_mutex_create.c",
        "threadx/common/src/txe_mutex_delete.c",
        "threadx/common/src/txe_mutex_get.c",
        "threadx/common/src/txe_mutex_info_get.c",
        "threadx/common/src/txe_mutex_prioritize.c",
        "threadx/common/src/txe_mutex_put.c",

        // Queue Error Checking
        "threadx/common/src/txe_queue_create.c",
        "threadx/common/src/txe_queue_delete.c",
        "threadx/common/src/txe_queue_flush.c",
        "threadx/common/src/txe_queue_front_send.c",
        "threadx/common/src/txe_queue_info_get.c",
        "threadx/common/src/txe_queue_prioritize.c",
        "threadx/common/src/txe_queue_receive.c",
        "threadx/common/src/txe_queue_send.c",
        "threadx/common/src/txe_queue_send_notify.c",

        // Semaphore Error Checking
        "threadx/common/src/txe_semaphore_ceiling_put.c",
        "threadx/common/src/txe_semaphore_create.c",
        "threadx/common/src/txe_semaphore_delete.c",
        "threadx/common/src/txe_semaphore_get.c",
        "threadx/common/src/txe_semaphore_info_get.c",
        "threadx/common/src/txe_semaphore_prioritize.c",
        "threadx/common/src/txe_semaphore_put.c",
        "threadx/common/src/txe_semaphore_put_notify.c",

        // Thread Error Checking
        "threadx/common/src/txe_thread_create.c",
        "threadx/common/src/txe_thread_delete.c",
        "threadx/common/src/txe_thread_entry_exit_notify.c",
        "threadx/common/src/txe_thread_info_get.c",
        "threadx/common/src/txe_thread_preemption_change.c",
        "threadx/common/src/txe_thread_priority_change.c",
        "threadx/common/src/txe_thread_relinquish.c",
        "threadx/common/src/txe_thread_reset.c",
        "threadx/common/src/txe_thread_resume.c",
        "threadx/common/src/txe_thread_suspend.c",
        "threadx/common/src/txe_thread_terminate.c",
        "threadx/common/src/txe_thread_time_slice_change.c",
        "threadx/common/src/txe_thread_wait_abort.c",

        // Timer Error Checking
        "threadx/common/src/txe_timer_activate.c",
        "threadx/common/src/txe_timer_change.c",
        "threadx/common/src/txe_timer_create.c",
        "threadx/common/src/txe_timer_deactivate.c",
        "threadx/common/src/txe_timer_delete.c",
        "threadx/common/src/txe_timer_info_get.c",
    };

    // Cortex-M4 GNU Port Assembly Sources
    // These files provide the low-level port-specific implementation
    const cortex_m4_asm_sources = [_][]const u8{
        "threadx/ports/cortex_m4/gnu/src/tx_thread_context_restore.S",
        "threadx/ports/cortex_m4/gnu/src/tx_thread_context_save.S",
        "threadx/ports/cortex_m4/gnu/src/tx_thread_interrupt_control.S",
        "threadx/ports/cortex_m4/gnu/src/tx_thread_interrupt_disable.S",
        "threadx/ports/cortex_m4/gnu/src/tx_thread_interrupt_restore.S",
        "threadx/ports/cortex_m4/gnu/src/tx_thread_schedule.S",
        "threadx/ports/cortex_m4/gnu/src/tx_thread_stack_build.S",
        "threadx/ports/cortex_m4/gnu/src/tx_thread_system_return.S",
        "threadx/ports/cortex_m4/gnu/src/tx_timer_interrupt.S",
        "threadx/ports/cortex_m4/gnu/src/tx_misra.S",
    };

    // Add ThreadX C source files with optimized compilation flags
    lib.addCSourceFiles(.{
        .files = &(threadx_core_sources ++ threadx_error_check_sources ++ cortex_m4_asm_sources),
        .flags = &.{
            "-std=c99",
            "-DCMSIS_device_header=\"stm32g4xx.h\"",
            "-DSTM32G474xx",
            "-DUSE_HAL_DRIVER",
            "-DTX_INCLUDE_USER_DEFINE_FILE",
            "-O2",
            "-ffunction-sections",
            "-fdata-sections",
            // Cortex-M4 CPU specification (without FPU to avoid VFP instruction issues)
            "-mcpu=cortex-m4",
            "-mfloat-abi=hard",
            "-mfpu=fpv4-sp-d16",
            // ThreadX specific optimizations
            "-DTX_TIMER_TICKS_PER_SECOND=1000",
        },
    });

    // Configure comprehensive include paths for STM32G4 integration

    // Core ThreadX headers
    lib.addIncludePath(b.path("threadx/common/inc"));
    lib.addIncludePath(b.path("threadx/ports/cortex_m4/gnu/inc"));

    // STM32 and CMSIS integration paths
    lib.addIncludePath(Core.artifact("Core").getEmittedIncludeTree().path(b, "core/include"));
    lib.addIncludePath(stm32_hal.artifact("stm32_hal").getEmittedIncludeTree().path(b, "stm32_hal/include"));
    lib.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/core/include"));
    lib.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/device/st/stm32g4xx/include"));

    // Legacy STM32 CMSIS paths for compatibility
    lib.addIncludePath(b.path("../../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));

    // C standard library (picolibc)
    lib.addIncludePath(b.path("../../picolibc/include"));

    // Install ThreadX headers for downstream consumption
    lib.installHeadersDirectory(b.path("threadx/common/inc"), "threadx/include", .{});
    lib.installHeadersDirectory(b.path("threadx/ports/cortex_m4/gnu/inc"), "threadx/port", .{});

    // Configure Zig module with same include paths
    mod.addIncludePath(Core.artifact("Core").getEmittedIncludeTree().path(b, "core/include"));
    mod.addIncludePath(stm32_hal.artifact("stm32_hal").getEmittedIncludeTree().path(b, "stm32_hal/include"));
    mod.addIncludePath(b.path("threadx/common/inc"));
    mod.addIncludePath(b.path("threadx/ports/cortex_m4/gnu/inc"));
    mod.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/core/include"));
    mod.addIncludePath(cmsis_6.artifact("CMSIS_6").getEmittedIncludeTree().path(b, "cmsis_6/device/st/stm32g4xx/include"));
    mod.addIncludePath(b.path("../../Drivers/CMSIS/Device/ST/STM32G4xx/Include"));
    mod.addIncludePath(b.path("../../picolibc/include"));

    // Install the library artifact
    b.installArtifact(lib);
}
