/*
 *  File: memory.ld.
 *  Desc: Defines Forest-RISC-V CPU common memory regions.
 *
 *  Bootloader is executed from the very start. It can include short test code or real initialization
 *  code for loading the main program. Memory mapped regions (memmap1, memmap2) are general purpose
 *  memory mapped registers for peripheral I/O.
 *
 *  For each application additional 'code' and 'data' memory regions are expected. Besides that STACK_SIZE and
 *  HEAP_SIZE symbols are expected.
 * */

MEMORY {
    isrtable(rw)    : ORIGIN = 0x0000_0400, LENGTH = 1K     /* Interrupt service routine table. Holds up to 256 entries */
    bootrom (x)     : ORIGIN = 0x0000_0600, LENGTH = 512    /* Bootloader's memory region.                              */
    /* All memory between those regions can be used for general purpose programs. (text + data)                         */

    reserved        : ORIGIN = 0xffff_0000, LENGTH = 3K     /* Reserved for future use.                                 */
    memmap1 (r)     : ORIGIN = 0xffff_0c00, LENGTH = 6K     /* Read-only memory mapped register file.                   */
    memmap2 (rw)    : ORIGIN = 0xffff_1800, LENGTH = 54K    /* Read-write memory mapped I/O register file.              */
}
