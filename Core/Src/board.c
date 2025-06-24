/*
 * board.c
 *
 *  Created on: Dec 3, 2023
 *      Author: Francisco
 */

#ifndef SRC_BOARD_C_
#define SRC_BOARD_C_

#include "main.h"
#include "stm32g4xx_hal.h"
#include "cmsis_os2.h"

extern osEventFlagsId_t button_event;

/**
 * GPIO Callback Dispatcher
 */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	GPIO_PinState pin_state = GPIO_PIN_RESET;
	switch(GPIO_Pin)
	{
	case (B1_Pin):
		{
			pin_state = HAL_GPIO_ReadPin(B1_GPIO_Port, B1_Pin);
			if(pin_state == GPIO_PIN_SET)
			{
				//(void)osEventFlagsSet(button_event, 0x1);
			}
			else
			{
				//(void)osEventFlagsSet(button_event, 0x2);
			}
		}
		break;
	default:
		{
			__BKPT(1);
		}
	}
}


#endif /* SRC_BOARD_C_ */
