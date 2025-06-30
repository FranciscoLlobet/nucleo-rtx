const std = @import("std");
const c_rtx = @cImport({
    //@cInclude("CMSIS-RTX/Include/rtx_os.h");
    @cInclude("cmsis_os2.h");
});

pub const osStatus_t = c_rtx.osStatus_t;
pub const osThreadFunc_t = c_rtx.osThreadFunc_t;
pub const osThreadAttr_t = c_rtx.osThreadAttr_t;
pub const osThreadId_t = c_rtx.osThreadId_t;

pub const osKernelInitialize = c_rtx.osKernelInitialize;
pub const osDelay = c_rtx.osDelay;
pub const osKernelStart = c_rtx.osKernelStart;
pub const osThreadNew = c_rtx.osThreadNew;
