####################################################################################################
#   File: regs.tcl
#   Desc: Defines functions to debug registers within the CPU design. 
####################################################################################################


# Formats the current status of all 32 general purpose registers and a PC register.
proc read_regs {} {
    set output "Register    Value\n"
    set output "$output-------------------------\n"
    
    for {set i 0} {$i < 32} {incr i} {
        set reg_value [read_reg $i]
        append output [format "x%-2d        0x%08X\n" $i $reg_value]
    }
    
    set pc_value [read_pc]
    append output [format "PC         0x%08X\n" $pc_value]
    
    puts $output
}

# Reads any register in range of [x0 ... x31] based on provided ID value. 
proc read_reg {reg_id} {
    global CLAIM_PATH PIO_REG_SELECT PIO_REG_BUS
    master_write_8 $CLAIM_PATH $PIO_REG_SELECT $reg_id
    return [master_read_32 $CLAIM_PATH $PIO_REG_BUS 1]
}

# Reads the value from PC register.
proc read_pc {} {
    global CLAIM_PATH PIO_PC
    return [master_read_32 $CLAIM_PATH $PIO_PC 1]
}
