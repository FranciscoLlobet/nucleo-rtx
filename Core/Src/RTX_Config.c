/*
 * Copyright (c) 2013-2023 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * -----------------------------------------------------------------------------
 *
 * $Revision:   V5.2.0
 *
 * Project:     CMSIS-RTOS RTX
 * Title:       RTX Configuration
 *
 * -----------------------------------------------------------------------------
 */
 
#include "rtx_os.h"
 
#include "stm32g4xx_hal.h"

extern WWDG_HandleTypeDef hwwdg;

// OS Idle Thread
__NO_RETURN void osRtxIdleThread (void *argument) {
  (void)argument;
  volatile osStatus_t os_status = osError;

  for (;;) {
	 // os_status = HAL_WWDG_Refresh(&hwwdg);
	 // if(os_status != osOK)
	 // {
	//	  __BKPT(1);
	//  }
  }
}
 
// OS Error Callback function
uint32_t osRtxErrorNotify (uint32_t code, void *object_id) {
  (void)object_id;

  switch (code) {
    case osRtxErrorStackOverflow:
      // Stack overflow detected for thread (thread_id=object_id)
      break;
    case osRtxErrorISRQueueOverflow:
      // ISR Queue overflow detected when inserting object (object_id)
      break;
    case osRtxErrorTimerQueueOverflow:
      // User Timer Callback Queue overflow detected for timer (timer_id=object_id)
      break;
    case osRtxErrorClibSpace:
      // Standard C/C++ library libspace not available: increase OS_THREAD_LIBSPACE_NUM
      break;
    case osRtxErrorClibMutex:
      // Standard C/C++ library mutex initialization failed
      break;
    case osRtxErrorSVC:
      // Invalid SVC function called (function=object_id)
      break;
    default:
      // Reserved
      break;
  }
  for (;;) {}
//return 0U;
}

#ifndef RTX_EXECUTION_ZONE
#define RTX_EXECUTION_ZONE
#endif

#ifdef RTX_EXECUTION_ZONE

#define FLASH_BASE_ADDRESS	FLASH_BASE /* 512kB*/
#define SRAM_BASE_ADDRESS	SRAM1_BASE /* 80+16kB */
#define PERIPHERAL_BASE_ADDRESS	PERIPH_BASE

/* Protect this table */
const ARM_MPU_Region_t mpu_table[4][8] = {
		/* First Zone */
		{
			/* Flash Memory as RO */
			{.RBAR = ARM_MPU_RBAR(0, FLASH_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_RO, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512KB)},
			/* SRAM Memory as Full Access */
			{.RBAR = ARM_MPU_RBAR(1, SRAM_BASE_ADDRESS),  .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0xC0, ARM_MPU_REGION_SIZE_128KB)},
			/* Peripheral Base Address */
			{.RBAR = ARM_MPU_RBAR(2, PERIPHERAL_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512MB)},
			{.RBAR = ARM_MPU_RBAR(3, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(4, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(5, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(6, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(7, 0), .RASR = 0}
		},
		/* Second Zone*/
		{
			/* Flash Memory as RO */
			{.RBAR = ARM_MPU_RBAR(0, FLASH_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_RO, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512KB)},
			/* SRAM Memory as Full Access*/
			{.RBAR = ARM_MPU_RBAR(1, SRAM_BASE_ADDRESS),  .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0xC0, ARM_MPU_REGION_SIZE_128KB)},
			/* Peripheral Base Address */
			{.RBAR = ARM_MPU_RBAR(2, PERIPHERAL_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512MB)},
			{.RBAR = ARM_MPU_RBAR(3, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(4, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(5, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(6, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(7, 0), .RASR = 0}
		},
		{
			/* Flash Memory as RO */
			{.RBAR = ARM_MPU_RBAR(0, FLASH_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_RO, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512KB)},
			/* SRAM Memory as Full Access*/
			{.RBAR = ARM_MPU_RBAR(1, SRAM_BASE_ADDRESS),  .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0xC0, ARM_MPU_REGION_SIZE_128KB)},
			/* Peripheral Base Address */
			{.RBAR = ARM_MPU_RBAR(2, PERIPHERAL_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512MB)},
			{.RBAR = ARM_MPU_RBAR(3, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(4, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(5, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(6, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(7, 0), .RASR = 0}
		},
		{
			/* Flash Memory as RO */
			{.RBAR = ARM_MPU_RBAR(0, FLASH_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_RO, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512KB)},
			/* SRAM Memory as Full Access*/
			{.RBAR = ARM_MPU_RBAR(1, SRAM_BASE_ADDRESS),  .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0xC0, ARM_MPU_REGION_SIZE_128KB)},
			/* Peripheral Base Address */
			{.RBAR = ARM_MPU_RBAR(2, PERIPHERAL_BASE_ADDRESS), .RASR = ARM_MPU_RASR_EX(0, ARM_MPU_AP_FULL, ARM_MPU_ACCESS_NORMAL(ARM_MPU_CACHEP_NOCACHE, ARM_MPU_CACHEP_NOCACHE, 1), 0x00, ARM_MPU_REGION_SIZE_512MB)},
			{.RBAR = ARM_MPU_RBAR(3, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(4, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(5, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(6, 0), .RASR = 0},
			{.RBAR = ARM_MPU_RBAR(7, 0), .RASR = 0}
		},
	};



// Default Zone Setup Function.
void osZoneSetup_Callback (uint32_t zone) {
	// Check Zone parameter

	if(zone < 4)
	{
		ARM_MPU_Disable();
		ARM_MPU_Load(mpu_table[(size_t)zone], 8);
		ARM_MPU_Enable(MPU_CTRL_PRIVDEFENA_Msk);
	}
	else{
		// Fallback configuration
		ARM_MPU_Disable();
		ARM_MPU_Load(mpu_table[(size_t)0], 8);
		ARM_MPU_Enable(MPU_CTRL_PRIVDEFENA_Msk);
	}

	//ARM_MPU_Disable();
}
#endif
