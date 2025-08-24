/**************************************************************************/
/*                                                                        */
/*       Copyright (c) Microsoft Corporation. All rights reserved.        */
/*                                                                        */
/*       This software is licensed under the Microsoft Software License   */
/*       Terms for Microsoft Azure RTOS. Full text of the license can be  */
/*       found in the LICENSE file at https://aka.ms/AzureRTOS_EULA       */
/*       and in the root directory of this software.                      */
/*                                                                        */
/**************************************************************************/


/**************************************************************************/
/**************************************************************************/
/**                                                                       */ 
/** ThreadX Component                                                     */
/**                                                                       */
/**   User Specific                                                       */
/**                                                                       */
/**************************************************************************/
/**************************************************************************/


/**************************************************************************/ 
/*                                                                        */ 
/*  PORT SPECIFIC C INFORMATION                            RELEASE        */ 
/*                                                                        */ 
/*    tx_user.h                                           PORTABLE C      */ 
/*                                                           6.0          */ 
/*                                                                        */
/*  AUTHOR                                                                */ 
/*                                                                        */ 
/*    William E. Lamie, Microsoft Corporation                             */ 
/*                                                                        */ 
/*  DESCRIPTION                                                           */ 
/*                                                                        */ 
/*    This file contains user defines for configuring ThreadX in specific */ 
/*    ways. This file will have an effect only if the application and     */ 
/*    ThreadX library are built with TX_INCLUDE_USER_DEFINE_FILE defined. */ 
/*    Note that all the defines in this file may also be made on the      */ 
/*    command line when building ThreadX library and application objects. */ 
/*                                                                        */ 
/*  RELEASE HISTORY                                                       */
/*                                                                        */
/*    DATE              NAME                      DESCRIPTION             */
/*                                                                        */
/*  05-19-2020     William E. Lamie         Initial Version 6.0           */
/*                                                                        */
/**************************************************************************/

#ifndef TX_USER_H
#define TX_USER_H

//#include CMSIS_device_header

/* FPU support configuration for Cortex-M4 */
/* Note: Temporarily disabled due to compiler compatibility issues */
/* 
 * The Zig compiler doesn't properly set the ARM VFP preprocessor defines
 * that ThreadX requires for FPU support. This can be re-enabled once
 * the build system is configured to properly define the VFP macros.
 */
// #define TX_ENABLE_FPU_SUPPORT

/* Cortex-M4 optimized configuration for embedded systems */

/* Set maximum priorities to 32 for good balance between functionality and memory usage */
#define TX_MAX_PRIORITIES                       32

/* Set minimum stack size appropriate for Cortex-M4 (in bytes) */
#define TX_MINIMUM_STACK                        256

/* Timer thread configuration - keep stack small for memory constrained systems */
#define TX_TIMER_THREAD_STACK_SIZE              512
#define TX_TIMER_THREAD_PRIORITY                0

/* Performance optimizations for Cortex-M4 */
/* Disable preemption threshold to reduce overhead */
#define TX_DISABLE_PREEMPTION_THRESHOLD

/* Disable redundant clearing since startup code handles .bss */
#define TX_DISABLE_REDUNDANT_CLEARING

/* Enable timer processing in ISR for better real-time performance */
#define TX_TIMER_PROCESS_IN_ISR

/* Enable inline timer reactivation for faster timer processing */
#define TX_REACTIVATE_INLINE

/* Enable inline thread resume/suspend for better performance */
#define TX_INLINE_THREAD_RESUME_SUSPEND

/* Memory optimization for embedded systems */
/* Disable notify callbacks if not needed to save memory */
#define TX_DISABLE_NOTIFY_CALLBACKS

/* Stack checking options - enable for debug, disable for production */
#ifdef DEBUG
    /* Enable stack checking in debug builds */
    #define TX_ENABLE_STACK_CHECKING
#else
    /* Disable stack filling in release builds to save memory and improve performance */
    #define TX_DISABLE_STACK_FILLING
#endif

/* Optional features - uncomment if needed */

/* Event tracing support - disable for production to save memory */
/*
#define TX_ENABLE_EVENT_TRACE
*/

/* Performance monitoring - enable only if profiling is needed */
/*
#define TX_THREAD_ENABLE_PERFORMANCE_INFO
#define TX_QUEUE_ENABLE_PERFORMANCE_INFO
#define TX_SEMAPHORE_ENABLE_PERFORMANCE_INFO
#define TX_MUTEX_ENABLE_PERFORMANCE_INFO
#define TX_EVENT_FLAGS_ENABLE_PERFORMANCE_INFO
#define TX_BLOCK_POOL_ENABLE_PERFORMANCE_INFO
#define TX_BYTE_POOL_ENABLE_PERFORMANCE_INFO
#define TX_TIMER_ENABLE_PERFORMANCE_INFO
*/

/* Advanced optimization - use with caution */
/* Makes ThreadX code non-interruptible - reduces overhead but increases interrupt latency */
/*
#define TX_NOT_INTERRUPTABLE
*/

/* Disable timers completely if not needed - saves significant memory */
/*
#define TX_NO_TIMER
#define TX_TIMER_PROCESS_IN_ISR
*/

#endif
