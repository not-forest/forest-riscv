####################################################################################################
#   File: program.s
#   Desc: Performs all 39 base integer (RV32I) non-pseudo instructions in a single program. All pseudo
#   instructions covered by RV32I are guaranteed to provide a desired result.
####################################################################################################

.section .text
.globl _start

_start:
    # Initialize registers with immediate values
    addi x1, x0, 0xff    # x1 = 0xff (255 in decimal)
    addi x2, x0, 0x0f    # x2 = 0x0f (15 in decimal)
    addi x3, x0, 25      # x3 = 25

    # R-Type Instructions
    add x4, x1, x2       # x4 = x1 + x2 -> 255 + 15 = 270
    sub x5, x1, x3       # x5 = x1 - x3 -> 255 - 25 = 230
    and x6, x1, x2       # x6 = x1 & x2 -> 255 & 15 = 15
    or  x7, x1, x2       # x7 = x1 | x2 -> 255 | 15 = 255
    xor x8, x1, x2       # x8 = x1 ^ x2 -> 255 ^ 15 = 240
    sll x9, x1, x2       # x9 = x1 << x2 -> 255 << 15 = 0x7FFFFFFF0000
    srl x10, x1, x2      # x10 = x1 >> x2 -> 255 >> 15 = 0
    sra x11, x1, x2      # x11 = x1 >> x2 (arithmetic shift) -> 255 >> 15 = 0
    slt x12, x1, x2      # x12 = (x1 < x2) ? 1 : 0 -> 0
    sltu x13, x1, x2     # x13 = (x1 < x2) unsigned ? 1 : 0 -> 0
    slti x14, x1, 0x100  # x14 = (x1 < 0x100) ? 1 : 0 -> 1
    sltiu x15, x1, 0x100 # x15 = (x1 < 0x100) unsigned ? 1 : 0 -> 1

    # I-Type Instructions
    addi x16, x1, 5      # x16 = x1 + 5 -> 255 + 5 = 260
    andi x17, x1, 0x0f   # x17 = x1 & 0x0f -> 255 & 15 = 15
    ori  x18, x1, 0x10   # x18 = x1 | 0x10 -> 255 | 16 = 271
    xori x19, x1, 0x0f   # x19 = x1 ^ 0x0f -> 255 ^ 15 = 240
    slli x20, x2, 3      # x20 = x2 << 3 -> 15 << 3 = 120
    srli x21, x1, 4      # x21 = x1 >> 4 -> 255 >> 4 = 15
    srai x22, x1, 4      # x22 = x1 >> 4 (arithmetic shift) -> 255 >> 4 = 15

    # I-Type loads
    lb   x23, 0(x1)      # Load byte from address in x1 into x23 (x1 address must be valid)
    lh   x24, 0(x1)      # Load halfword from address in x1 into x24 (x1 address must be valid)
    lw   x25, 0(x1)      # Load word from address in x1 into x25 (x1 address must be valid)
    lbu  x26, 0(x1)      # Load byte unsigned from address in x1 into x26 (x1 address must be valid)
    lhu  x27, 0(x1)      # Load halfword unsigned from address in x1 into x27 (x1 address must be valid)

    # S-Type Instructions
    sb   x28, 0(x1)      # Store byte from x28 into address in x1 (x1 address must be valid)
    sh   x29, 0(x1)      # Store halfword from x29 into address in x1 (x1 address must be valid)
    sw   x30, 0(x1)      # Store word from x30 into address in x1 (x1 address must be valid)

    # B-Type Instructions
    beq  x5, x0, beq_target    # If x5 == x0, jump to beq_target
    bne  x5, x0, bne_target    # If x5 != x0, jump to bne_target
    blt  x5, x0, blt_target    # If x5 < x0, jump to blt_target
    bge  x5, x0, bge_target    # If x5 >= x0, jump to bge_target
    bltu x5, x0, bltu_target   # If x5 < x0 (unsigned), jump to bltu_target
    bgeu x5, x0, bgeu_target   # If x5 >= x0 (unsigned), jump to bgeu_target

    # J-Type Instructions
    jal  x0, jal_target        # Jump to jal_target and link (x0 is used to ignore the link register)
    jalr x0, x0, 0             # Jump to address in x0 with offset 0 (ignore the link register)

    # U-Type Instructions
    lui  x31, 0x10000          # Load upper immediate (x31 = 0x10000000)
    auipc x31, 0x10000         # Add upper immediate to PC (x31 = PC + 0x10000000)

    # ECALL and EBREAK Instructions
    ecall                     # Environment call
    ebreak                    # Breakpoint 

    # Ensure execution reaches these points
    j end                     # Jump to end to halt

beq_target:
    nop                      

bne_target:
    nop                      

blt_target:
    nop                      

bge_target:
    nop                      

bltu_target:
    nop                      

bgeu_target:
    nop                      

jal_target:
    nop                      

end:
    nop                      # No operation (program halt point)
    j end

