####################################################################################################
#   File: instruction.tcl
#   Desc: Provides information about the oncoming CPU instruction and dissasebmles it. Provides additional
#   information about the source and destination registers. Allows to read the instruction's immediate.
####################################################################################################

# Dissasembles an upcoming code to human-readable risc-v assembly format and provides it to the console.
proc disassemble {} {
    set instr [read_code_raw]
    set decoder [read_decode_raw]

    set opcode [expr {$instr & 0x7F}]
    set text "(bad)"  ;# Default value if the instruction is unrecognized

    puts "-------------------------"
    puts "Raw: [format "0x%08x" $instr]\nOpcode: [format "0b%07b" $opcode]"

    # Matching is done in decimal, since Tcl treats everything as string.
    switch $opcode {
        # R-type instructions (opcode = 51)
        51 {
            set funct3 [expr {($instr >> 12) & 0x7}]
            set funct7 [expr {($instr >> 25) & 0x7F}]
            set rd [expr {($instr >> 7) & 0x1F}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set rs2 [expr {($instr >> 20) & 0x1F}]

            switch $funct3 {
                0 {
                    switch $funct7 {
                        0 { set text "add  x$rd, x$rs1, x$rs2" }
                        32 { set text "sub  x$rd, x$rs1, x$rs2" }
                    }
                }
                1 { set text "sll  x$rd, x$rs1, x$rs2" }
                2 { set text "slt  x$rd, x$rs1, x$rs2" }
                3 { set text "sltu x$rd, x$rs1, x$rs2" }
                4 { set text "xor  x$rd, x$rs1, x$rs2" }
                5 {
                    switch $funct7 {
                        0 { set text "srl  x$rd, x$rs1, x$rs2" }
                        32 { set text "sra  x$rd, x$rs1, x$rs2" }
                    }
                }
                6 { set text "or   x$rd, x$rs1, x$rs2" }
                7 { set text "and  x$rd, x$rs1, x$rs2" }
            }
        }

        # I-type instructions (opcode = 19, 3, 103)
        19 {
            set rd [expr {($instr >> 7) & 0x1F}]
            set funct3 [expr {($instr >> 12) & 0x7}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set imm [expr {($instr >> 20) & 0xFFF}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}] ;# Sign extension for negative immediate
            }

            switch $funct3 {
                0 { set text "addi x$rd, x$rs1, $imm" }
                2 { set text "slti x$rd, x$rs1, $imm" }
                3 { set text "sltiu x$rd, x$rs1, $imm" }
                4 { set text "xori x$rd, x$rs1, $imm" }
                6 { set text "ori  x$rd, x$rs1, $imm" }
                7 { set text "andi x$rd, x$rs1, $imm" }
                1 { set text "slli x$rd, x$rs1, [expr {($instr >> 20) & 0x1F}]" }
                5 {
                    set shamt [expr {($instr >> 20) & 0x1F}]
                    set funct7 [expr {($instr >> 25) & 0x7F}]
                    if {$funct7 == 0} {
                        set text "srli x$rd, x$rs1, $shamt"
                    } elseif {$funct7 == 32} {
                        set text "srai x$rd, x$rs1, $shamt"
                    }
                }
            }
        }

        # Load instructions (I-type, opcode = 3)
        3 {
            set rd [expr {($instr >> 7) & 0x1F}]
            set funct3 [expr {($instr >> 12) & 0x7}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set imm [expr {($instr >> 20) & 0xFFF}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}]
            }

            switch $funct3 {
                0 { set text "lb   x$rd, $imm(x$rs1)" }
                1 { set text "lh   x$rd, $imm(x$rs1)" }
                2 { set text "lw   x$rd, $imm(x$rs1)" }
                4 { set text "lbu  x$rd, $imm(x$rs1)" }
                5 { set text "lhu  x$rd, $imm(x$rs1)" }
            }
        }

        # JALR instruction (I-type, opcode = 103)
        103 {
            set rd [expr {($instr >> 7) & 0x1F}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set imm [expr {($instr >> 20) & 0xFFF}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}]
            }
            set text "jalr x$rd, $imm(x$rs1)"
        }

        # S-type instructions (opcode = 35)
        35 {
            set funct3 [expr {($instr >> 12) & 0x7}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set rs2 [expr {($instr >> 20) & 0x1F}]
            set imm [expr {(($instr >> 25) << 5) | (($instr >> 7) & 0x1F)}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}]
            }

            switch $funct3 {
                0 { set text "sb   x$rs2, $imm(x$rs1)" }
                1 { set text "sh   x$rs2, $imm(x$rs1)" }
                2 { set text "sw   x$rs2, $imm(x$rs1)" }
            }
        }

        # B-type instructions (opcode = 99)
        99 {
            set funct3 [expr {($instr >> 12) & 0x7}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set rs2 [expr {($instr >> 20) & 0x1F}]
            set imm [expr {(($instr >> 31) << 12) | (($instr >> 7) & 0x1) << 11 | (($instr >> 25) & 0x3F) << 5 | (($instr >> 8) & 0xF) << 1}]
            if {($imm & 0x1000) != 0} {
                set imm [expr {$imm | 0xFFFFE000}]
            }

            switch $funct3 {
                0 { set text "beq  x$rs1, x$rs2, $imm" }
                1 { set text "bne  x$rs1, x$rs2, $imm" }
                4 { set text "blt  x$rs1, x$rs2, $imm" }
                5 { set text "bge  x$rs1, x$rs2, $imm" }
                6 { set text "bltu x$rs1, x$rs2, $imm" }
                7 { set text "bgeu x$rs1, x$rs2, $imm" }
            }
        }

        # U-type instructions (LUI and AUIPC, opcode = 55, 23)
        55 {
            set rd [expr {($instr >> 7) & 0x1F}]
            set imm [expr {$instr & 0xFFFFF000}]
            set text "lui  x$rd, $imm"
        }
        23 {
            set rd [expr {($instr >> 7) & 0x1F}]
            set imm [expr {$instr & 0xFFFFF000}]
            set text "auipc x$rd, $imm"
        }

        # JAL instruction (J-type, opcode = 111)
        111 {
            set rd [expr {($instr >> 7) & 0x1F}]
            set imm [expr {(($instr >> 31) << 20) | (($instr >> 12) & 0xFF) << 12 | (($instr >> 20) & 0x1) << 11 | (($instr >> 21) & 0x3FF) << 1}]
            if {($imm & 0x100000) != 0} {
                set imm [expr {$imm | 0xFFE00000}]
            }
            set text "jal  x$rd, $imm"
        }

        # ECALL and EBREAK (opcode = 115)
        115 {
            set funct3 [expr {($instr >> 12) & 0x7}]
            if {$funct3 == 0} {
                if {($instr & 0xFFF00000) == 0} {
                    set text "ecall"
                } elseif {($instr & 0xFFF00000) == 1048576} {
                    set text "ebreak"
                }
            }
        }
    }    

    set is_alu_src      [expr {($decoder & 1) == 1}] 
    set is_pc_write     [expr {(($decoder >> 1) & 0x1) == 1}]
    set is_mem_write    [expr {(($decoder >> 2) & 0x1) == 1}]
    set is_mem_read     [expr {(($decoder >> 3) & 0x1) == 1}]
    set branch          [expr {($decoder >> 4) & 0x7}]
    set alu_op          [expr {($decoder >> 7) & 0xF}]

    puts "-------Instruction-------"
    puts $text
    puts "-----Decoder-Output------"
    puts "Is immediate used: $is_alu_src"
    puts "Is PC written: $is_pc_write"
    puts "Is MEM written: $is_mem_write"
    puts "Is MEM read: $is_mem_read"
    puts "Branch: $branch"
    puts "ALU operation: $alu_op"
    puts "-------------------------"
}

# Reads the raw unparsed instruction from the RV32I decoder block.
proc read_decode_raw {} {
    global CLAIM_PATH PIO_INSTR
    return [master_read_32 $CLAIM_PATH $PIO_INSTR 1]
}

# Reads the raw unparsed code straight from the program memory.
proc read_code_raw {} {
    global CLAIM_PATH PIO_CODE
    return [master_read_32 $CLAIM_PATH $PIO_CODE 1]
}
