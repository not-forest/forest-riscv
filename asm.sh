#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
ASBDIR="$DIR/asm"

# Defines file names
ASSEMBLY_FILE="$ASBDIR/program.s"
OBJECT_FILE="$ASBDIR/program.o"
EXECUTABLE_FILE="$ASBDIR/program.elf"
BINARY_FILE="$ASBDIR/program.bin"
INTEL_HEX_FILE="$ASBDIR/program.hex"

# Assembles the assembly file to object file (base RV32I instruction set.)
riscv32-unknown-elf-as -march=rv32i -o $OBJECT_FILE $ASSEMBLY_FILE
riscv32-unknown-elf-ld -o $EXECUTABLE_FILE $OBJECT_FILE -Ttext=0x0 --entry=_start
riscv32-unknown-elf-objcopy -O binary $EXECUTABLE_FILE $BINARY_FILE

# Convert the binary file to Intel Hex format (little-endian)
srec_cat $BINARY_FILE -binary -byte-swap 4 -o $INTEL_HEX_FILE -Intel

# Clean up intermediate files if needed
rm $OBJECT_FILE $EXECUTABLE_FILE $BINARY_FILE

echo "Conversion completed. Intel Hex file: $INTEL_HEX_FILE"
