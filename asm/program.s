    .section .data
    .section .text               
    .globl _start                

_start:
    # Initialize registers with immediate values
    addi x1, x0, 0xff    # x1 = 0xff (255 in decimal)
    addi x2, x0, 0x0f    # x2 = 0x0f (15 in decimal)
    addi x3, x0, 25      # x3 = 25
    
    # Perform bitwise AND, OR, XOR operations
    and x4, x1, x2       # x4 = x1 & x2 -> (0xff & 0x0f) = 0x0f
    or  x5, x1, x2       # x5 = x1 | x2 -> (0xff | 0x0f) = 0xff
    xor x6, x1, x2       # x6 = x1 ^ x2 -> (0xff ^ 0x0f) = 0xf0
    
    # Perform subtraction
    sub x1, x4, x3       # x1 = x4 - x3 -> (0x0f - 25) = -16 (0xFFF0)
    
    # Add branch instructions to halt program execution based on the results
    beq x1, x0, end      # If x1 == 0, jump to end (halt the program)
    bne x1, x3, continue # If x1 != x3, skip halt and continue
   

continue:
    addi x7, x0, 1    # Set x7 to 1 (as an indicator of continuing)
    j end             # Jump to the end of the program

end:
    nop               # No operation (program halt point)
               
