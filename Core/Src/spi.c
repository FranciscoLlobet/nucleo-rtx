/*
 * fresh_spi.c
 *
 *  Created on: Jun 23, 2025
 *      Author: Francisco
 */

#include <stdint.h>
#include <stdlib.h>

#include "cmsis_os2.h"
#include "Driver_SPI.h"

#include "stm32g4xx_hal.h"

#include "stm32g4xx_hal_spi.h"
#include "stm32g4xx_hal_gpio.h"
//

struct spi_cs_gpio_s {
	GPIO_TypeDef * GPIO;
	uint16_t GPIO_Pin;
	GPIO_PinState active;
	GPIO_PinState inactive;
};


struct spi_ctrl_s{
	SPI_HandleTypeDef * handle;
	ARM_SPI_SignalEvent_t cb_event;
	osEventFlagsId_t event;
	struct spi_cs_gpio_s cs;
};

typedef struct spi_ctrl_s spi_ctrl_t;


struct spi_ctrl_s SPI1_Ctrl;

extern SPI_HandleTypeDef hspi1;

int32_t SPI1_Initialize(ARM_SPI_SignalEvent_t cb_event);
int32_t SPI1_Send(const void *data, uint32_t num);
int32_t SPI1_Receive (void *data, uint32_t num);
int32_t SPI1_Control(uint32_t control, uint32_t arg);

ARM_DRIVER_SPI SPI1_Driver = {
		.GetVersion = NULL,
		.GetCapabilities = NULL,
		.Initialize = SPI1_Initialize,
		.Uninitialize = NULL,
		.PowerControl = NULL,
		.Send = SPI1_Send,
		.Receive = SPI1_Receive,
		.GetDataCount = NULL,
		.Control = SPI1_Control,
		.GetStatus = NULL,
};

int32_t spi_master_init(spi_ctrl_t *spi, SPI_HandleTypeDef * handle, ARM_SPI_SignalEvent_t cb_event);
int32_t spi_master_send(spi_ctrl_t * spi, const uint8_t * pData, uint32_t size);
int32_t spi_master_receive(spi_ctrl_t * spi, uint8_t * pData, uint32_t size);
int32_t spi_master_control(spi_ctrl_t *spi, uint32_t control, uint32_t arg);

int32_t SPI1_Initialize(ARM_SPI_SignalEvent_t cb_event)
{
	int32_t ret = spi_master_init(&SPI1_Ctrl, &hspi1, cb_event);

	if(ret == ARM_DRIVER_OK)
	{
		SPI1_Ctrl.cs.GPIO = GPIOB;
		SPI1_Ctrl.cs.GPIO_Pin = GPIO_PIN_6;
		SPI1_Ctrl.cs.active = GPIO_PIN_RESET;
		SPI1_Ctrl.cs.inactive = GPIO_PIN_SET;

		HAL_GPIO_WritePin(SPI1_Ctrl.cs.GPIO, SPI1_Ctrl.cs.GPIO_Pin, SPI1_Ctrl.cs.inactive);
	}

	return ret;
}

int32_t SPI1_Send(const void *data, uint32_t num)
{
	return spi_master_send(&SPI1_Ctrl , (uint8_t *)data, num);
}

int32_t SPI1_Receive (void *data, uint32_t num)
{
	return spi_master_receive(&SPI1_Ctrl, (uint8_t *)data, num);
}

int32_t SPI1_Control(uint32_t control, uint32_t arg)
{
	return spi_master_control(&SPI1_Ctrl, control, arg);
}

int32_t spi_master_init(spi_ctrl_t *spi, SPI_HandleTypeDef * handle, ARM_SPI_SignalEvent_t cb_event)
{
	int32_t ret = (int32_t)ARM_DRIVER_OK;

	if(spi != NULL)
	{
		spi->handle = handle;
		spi->cb_event = cb_event;

		spi->event = osEventFlagsNew(NULL);
		if(spi->event == NULL)
		{
			ret = (int32_t)ARM_DRIVER_ERROR;
		}
	}

	return ret;
}

int32_t spi_master_send(spi_ctrl_t * spi, const uint8_t * pData, uint32_t size)
{
	int32_t ret = (int32_t)ARM_DRIVER_OK;
	uint32_t flags = 0;

	if(HAL_OK == HAL_SPI_Transmit_IT(spi->handle, (const uint8_t *)pData, (uint16_t)size))
	{
		flags = osEventFlagsWait(spi->event, INT32_MAX, osFlagsWaitAny, osWaitForever);
		if(flags <= INT32_MAX)
		{
			//
		}
		osEventFlagsClear(spi->event, INT32_MAX);
	}
	else
	{
		ret = (int32_t)ARM_DRIVER_ERROR;
	}



	return ret;
}

int32_t spi_master_receive(spi_ctrl_t * spi, uint8_t * pData, uint32_t size)
{
	int32_t ret = (int32_t)ARM_DRIVER_OK;

	ret = (int32_t)HAL_SPI_Receive_IT(spi->handle, (uint8_t *)pData, (uint16_t)size);

	return ret;
}



int32_t spi_master_control(spi_ctrl_t *spi, uint32_t control, uint32_t arg)
{
	int32_t ret = (int32_t)ARM_DRIVER_OK;



	if((control & ARM_SPI_CONTROL_Msk) == ARM_SPI_CONTROL_SS)
	{
		if(arg == (uint32_t)ARM_SPI_SS_INACTIVE)
		{
			HAL_GPIO_WritePin(spi->cs.GPIO, spi->cs.GPIO_Pin, spi->cs.inactive);
		}
		else
		{
			HAL_GPIO_WritePin(spi->cs.GPIO, spi->cs.GPIO_Pin, spi->cs.active);
		}

		return (int32_t)ARM_DRIVER_OK;
	}

	if((control & ARM_SPI_CONTROL_Msk) == ARM_SPI_ABORT_TRANSFER )
	{
		//
	}

	return ret;
}










void HAL_SPI_TxCpltCallback(SPI_HandleTypeDef *hspi)
{
	if(SPI1_Ctrl.cb_event != NULL)
	{
		SPI1_Ctrl.cb_event(ARM_SPI_EVENT_TRANSFER_COMPLETE);
	}
	osEventFlagsSet(SPI1_Ctrl.event, 0x1);
}
void HAL_SPI_RxCpltCallback(SPI_HandleTypeDef *hspi)
{
	if(SPI1_Ctrl.cb_event != NULL)
	{
		SPI1_Ctrl.cb_event(ARM_SPI_EVENT_TRANSFER_COMPLETE);
	}
	osEventFlagsSet(SPI1_Ctrl.event, 0x1);
}
void HAL_SPI_TxRxCpltCallback(SPI_HandleTypeDef *hspi)
{
	if(SPI1_Ctrl.cb_event != NULL)
	{
		SPI1_Ctrl.cb_event(ARM_SPI_EVENT_TRANSFER_COMPLETE);
	}
	osEventFlagsSet(SPI1_Ctrl.event, 0x1);
}

void HAL_SPI_ErrorCallback(SPI_HandleTypeDef *hspi)
{
	if(SPI1_Ctrl.cb_event != NULL)
	{
		SPI1_Ctrl.cb_event(ARM_SPI_EVENT_DATA_LOST);
	}
	osEventFlagsSet(SPI1_Ctrl.event, 0x1);
}
void HAL_SPI_AbortCpltCallback(SPI_HandleTypeDef *hspi)
{
	if(SPI1_Ctrl.cb_event != NULL)
	{
		SPI1_Ctrl.cb_event(ARM_SPI_EVENT_DATA_LOST);
	}
	osEventFlagsSet(SPI1_Ctrl.event, 0x1);
}

void SPI1_IRQHandler(void)
{
    HAL_SPI_IRQHandler(&hspi1);
}




