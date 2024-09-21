/*
 *  File: script.ld.
 *  Desc: Main default linker script file for Forest-RISC-V CPU. This script is intended for main
 *  program area. Main memory regions such as 'code' and 'data' should be provided above this script.
 *  STACK_SIZE and HEAP_SIZE should be overwritten above if used.
 * */

/* Entry point symbol */
ENTRY(_start)

/* Must be overwritten by memory configuration. */
STACK_SIZE = 0x0;
HEAP_SIZE  = 0x0;

/* Memory areas definitions. All custom linker scripts should also use this. */
INCLUDE memory.ld

SECTIONS {
    . = ORIGIN(isrtable);                   /* ISR entries could be loaded on compile time or runtime. */

    /* Up to 256 interrupt entries. */
    .isr_vector : {
        . = ALIGN(4);
        KEEP(*(.isr_vector));
        . = ALIGN(4);
    } > isrtable

    . = ORIGIN(bootrom) + LENGTH(bootrom);  /* Omitting bootloader's code. */

    /* Main program text. */
    .text : {
        . = ALIGN(4);

        _stext = .;
        *(.text .text*)
        *(.rodata .rodata*)
        . = ALIGN(4);
        _etext = .;
    } > code

    /* Initialized data. */
    .data : {
        . = ALIGN(4);
        _sdata = .;
        *(.data .data*) 
        . = ALIGN(4);
        _edata = .;
    } > data AT > code

    /* Uninitialized data. */
    .bss : {
        . = ALIGN(4);
        _sbss = .;
        *(.bss .bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > data

    /* Stack (if STACK_SIZE != 0) */
    .stack (NOLOAD) : {
        . = ALIGN(4);
        _sstack = .;
        . += STACK_SIZE;
        . = ALIGN(4);
        _estack = .;
    } > data

    /* Heap (if HEAP_SIZE != 0) */
    .heap (NOLOAD) : {
        . = ALIGN(4);
        _sheap = .;
        . += HEAP_SIZE;
        . = ALIGN(4);
        _eheap = .;
    } > data

    /DISCARD/ : {
        *(.comment) 
        *(.note)    
        *(.debug*)  
        *(.eh_frame)
        *(.stack)   
    }
}

/* Additional. */
PROVIDE(stext = _stext);
PROVIDE(etext = _etext);
PROVIDE(sdata = _sdata);
PROVIDE(edata = _edata);
PROVIDE(sbss = _sbss);
PROVIDE(ebss = _ebss);
PROVIDE(sstack = _stack);
PROVIDE(estack = _etack);
PROVIDE(sheap = _sheap);
PROVIDE(eheap = _eheap);
