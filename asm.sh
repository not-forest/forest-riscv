#!/bin/bash

# Define file names
ASSEMBLY_FILE="asm/program.s"
OBJECT_FILE="asm/program.o"
EXECUTABLE_FILE="asm/program.elf"
BINARY_FILE="asm/program.bin"
INTEL_HEX_FILE="asm/program.hex"

# Assemble the assembly file to object file
riscv32-unknown-linux-gnu-as -o $OBJECT_FILE $ASSEMBLY_FILE

# Link the object file to create an executable
riscv32-unknown-linux-gnu-ld -o $EXECUTABLE_FILE $OBJECT_FILE

# Convert the executable to a binary file
riscv32-unknown-linux-gnu-objcopy -O binary $EXECUTABLE_FILE $BINARY_FILE

# Convert the binary file to Intel Hex format
srec_cat $BINARY_FILE -binary -o $INTEL_HEX_FILE -Intel

# Clean up intermediate files if needed
rm $OBJECT_FILE $EXECUTABLE_FILE $BINARY_FILE

echo "Conversion completed. Intel Hex file: $INTEL_HEX_FILE"

