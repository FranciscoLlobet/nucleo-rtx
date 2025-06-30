/*
******************************************************************************
**
** @file        : STM32G474_picolibc.ld
**
** @author      : Modified for picolibc compatibility
**
**  Abstract    : Linker script for NUCLEO-G474RE Board embedding STM32G474RETx Device from stm32g4 series
**                      512KBytes FLASH
**                      128KBytes RAM
**                Modified for picolibc runtime support
**
**  Target      : STMicroelectronics STM32
**
******************************************************************************
*/

/* Entry Point */
ENTRY(Reset_Handler)

/* Memories definition */
MEMORY
{
  RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 128K
  FLASH    (rx)    : ORIGIN = 0x8000000,   LENGTH = 512K
}

/* Highest address of the user mode stack */
_estack = ORIGIN(RAM) + LENGTH(RAM); /* end of "RAM" Ram type memory */
__stack = _estack; /* picolibc stack symbol */

_Min_Heap_Size = 0x200; /* required amount of heap */
_Min_Stack_Size = 0x400; /* required amount of stack */

/* Sections */
SECTIONS
{
  /* The startup code into "FLASH" Rom type memory */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
  } >FLASH

  /* The program code and other data into "FLASH" Rom type memory */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;        /* define a global symbols at end of code */
  } >FLASH

  /* Constant data into "FLASH" Rom type memory */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  .ARM.extab   : {
    . = ALIGN(4);
    *(.ARM.extab* .gnu.linkonce.armextab.*)
    . = ALIGN(4);
  } >FLASH

  .ARM : {
    . = ALIGN(4);
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
    . = ALIGN(4);
  } >FLASH

  .preinit_array     :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .init_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .fini_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
    . = ALIGN(4);
  } >FLASH

  /* TLS sections */
  .tdata :
  {
    . = ALIGN(4);
    __tdata_start = .;
    *(.tdata .tdata.* .gnu.linkonce.td.*)
    . = ALIGN(4);
    __tdata_end = .;
  } >RAM AT> FLASH

  .tbss :
  {
    . = ALIGN(4);
    __tbss_start = .;
    *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon)
    . = ALIGN(4);
    __tbss_end = .;
  } >RAM

  /* TLS symbols required by picolibc */
  __tdata_source = LOADADDR(.tdata);
  __tdata_size = SIZEOF(.tdata);
  __tbss_size = SIZEOF(.tbss);
  __tls_size = __tdata_size + __tbss_size;
  __tls_align = MAX(ALIGNOF(.tdata), ALIGNOF(.tbss));
  __tls_base = __tbss_start;
  __arm32_tls_tcb_offset = 0;

  /* Used by the startup to initialize data */
  _sidata = LOADADDR(.data);
  __data_source = _sidata;

  /* Initialized data sections into "RAM" Ram type memory */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    __data_start = _sdata;
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    *(.RamFunc)        /* .RamFunc sections */
    *(.RamFunc*)       /* .RamFunc* sections */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
    __data_end = _edata;

  } >RAM AT> FLASH

  /* Data size for picolibc */
  __data_size = SIZEOF(.data);

  /* Uninitialized data section into "RAM" Ram type memory */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss section */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    __bss_start = _sbss;  /* picolibc expects this symbol */
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
    __bss_end = _ebss;
  } >RAM

  /* BSS size for picolibc */
  __bss_size = SIZEOF(.bss);

  /* User_heap_stack section, used to check that there is enough "RAM" Ram  type memory left */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    __heap_start = .; /* picolibc heap start */
    . = . + _Min_Heap_Size;
    __heap_end = .; /* picolibc heap end */
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM

  /* Remove information from the compiler libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}