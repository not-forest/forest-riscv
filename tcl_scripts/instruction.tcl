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
    switch -exact -- $opcode {
        51 {
            # R-type instructions (opcode = 51)
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

        19 {
            # I-type instructions (opcode = 19, 3, 103)
            set rd [expr {($instr >> 7) & 0x1F}]
            set funct3 [expr {($instr >> 12) & 0x7}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set imm [expr {($instr >> 20) & 0xFFF}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}] ;
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

        3 {
            # Load instructions (I-type, opcode = 3)
            set rd [expr {($instr >> 7) & 0x1F}]
            set funct3 [expr {($instr >> 12) & 0x7}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set imm [expr {($instr >> 20) & 0xFFF}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}]
            }

            switch $funct3 {
                0 { set text "lb   x$rd, $imm\(x$rs1\)" } 
                1 { set text "lh   x$rd, $imm\(x$rs1\)" }
                2 { set text "lw   x$rd, $imm\(x$rs1\)" }
                4 { set text "lbu  x$rd, $imm\(x$rs1\)" }
                5 { set text "lhu  x$rd, $imm\(x$rs1\)" }
            }
        }

        103 {
            # JALR instruction (I-type, opcode = 103)
            set rd [expr {($instr >> 7) & 0x1F}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set imm [expr {($instr >> 20) & 0xFFF}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}]
            }
            set text "jalr x$rd, $imm(x$rs1)"
        }

        35 {
            # S-type instructions (opcode = 35)
            set funct3 [expr {($instr >> 12) & 0x7}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set rs2 [expr {($instr >> 20) & 0x1F}]
            set imm [expr {(($instr >> 25) << 5) | (($instr >> 7) & 0x1F)}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}]
            }

            switch $funct3 {
                0 { set text "sb   x$rs2, $imm\(x$rs1\)" }
                1 { set text "sh   x$rs2, $imm\(x$rs1\)" }
                2 { set text "sw   x$rs2, $imm\(x$rs1\)" }
            }
        }

        99 {
            # B-type instructions (opcode = 99)
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

        55 {
            # U-type instructions (LUI, opcode = 55)
            set rd [expr {($instr >> 7) & 0x1F}]
            set imm [expr {$instr & 0xFFFFF000}]
            set text "lui  x$rd, $imm"
        }
        23 {
            # U-type instructions (AUIPC, opcode = 23)
            set rd [expr {($instr >> 7) & 0x1F}]
            set imm [expr {$instr & 0xFFFFF000}]
            set text "auipc x$rd, $imm"
        }

        111 {
            # JAL instruction (J-type, opcode = 111)
            set rd [expr {($instr >> 7) & 0x1F}]
            set imm [expr {(($instr >> 31) << 20) | (($instr >> 12) & 0xFF) << 12 | (($instr >> 20) & 0x1) << 11 | (($instr >> 21) & 0x3FF) << 1}]
            if {($imm & 0x100000) != 0} {
                set imm [expr {$imm | 0xFFE00000}]
            }
            set text "jal  x$rd, $imm"
        }

        103 {
            # JALR instruction (I-type, opcode = 103)
            set rd [expr {($instr >> 7) & 0x1F}]
            set rs1 [expr {($instr >> 15) & 0x1F}]
            set imm [expr {($instr >> 20) & 0xFFF}]
            if {($imm & 0x800) != 0} {
                set imm [expr {$imm | 0xFFFFF000}] ;
            }

            set text "jalr x$rd, $imm\(x$rs\)"
        }

        115 {
            # ECALL and EBREAK (opcode = 115)
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

    set funct3     [expr {$decoder & 0x7}]
    set opsel      [expr {($decoder >> 3) & 0xf}]
    set rs1        [expr {($decoder >> 7) & 0x1f}]
    set rs2        [expr {($decoder >> 12) & 0x1f}]
    set rd         [expr {($decoder >> 17) & 0x1f}]
    set mem_read   [expr {($decoder >> 22) & 0x1}]
    set pc_write   [expr {($decoder >> 23) & 0x1}]
    set alu_src    [expr {($decoder >> 24) & 0x1}]
    set env        [expr {($decoder >> 25) & 0x1}]
    set bad        [expr {($decoder >> 26) & 0x1}]

    # Print the values in the required format
    puts "-------Instruction-------"
    puts $text
    puts "-----Decoder-Output------"
    puts "Opsel: $opsel"
    puts "Funct3: $funct3"
    puts "RS1: $rs1"
    puts "RS2: $rs2"
    puts "Rd: $rd"
    puts "Is MEM read: $mem_read"
    puts "Is PC written: $pc_write"
    puts "Is immediate used: $alu_src"
    puts "Environment: $env"
    puts "BAD: $bad"
    puts "-------------------------"
}

# Reads the raw unparsed instruction from the RV32I decoder block.
proc read_decode_raw {} {
    global CLAIM_PATH PIO_CMD PIO_DATA CMD
    master_write_8 $CLAIM_PATH $PIO_CMD $CMD(READVALS)

    set r [master_read_32 $CLAIM_PATH $PIO_DATA 1]
    master_write_8 $CLAIM_PATH $PIO_CMD $CMD(NOP)
    return $r
}

# Reads the raw unparsed code straight from the program memory.
proc read_code_raw {} {
    global CLAIM_PATH PIO_CMD PIO_DATA CMD
    master_write_8 $CLAIM_PATH $PIO_CMD $CMD(READINSTR)

    set r [master_read_32 $CLAIM_PATH $PIO_DATA 1]
    master_write_8 $CLAIM_PATH $PIO_CMD $CMD(NOP)
    return $r
}
