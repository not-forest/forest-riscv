####################################################################################################
#   File: branchj.s
#   Desc: Peforms a branch operation to debug the pipelining ability of the CPU.
####################################################################################################

.section .text
.globl _start

_start:
    addi x1, x0, 0xff           # Loading byte 0xff
    beq x1, x0, failed_branch   # This must always fail, but cause PC to wait a bit.
    xor x1, x1, x1              # Clearing the register
    beq x1, x0, succeed_branch  # This must always succeed and cause a proper branch op.

end:
    nop
    j end

failed_branch:
    addi x31, x0, 0xff
    j end

succeed_branch:
    addi x2, x0, 0xff
    j end
