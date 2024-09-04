####################################################################################################
#   File: startup.tcl
#   Desc: Initializes the debug environment to analyze register's values and manage the processor's status.
####################################################################################################

puts "Initializing Forest-RiscV CPU debug environment..."

# Obtaining all service paths.
set SERVICE_PATHS [get_service_paths master]
if { [llength $SERVICE_PATHS] == 0 } {
    puts "Error: No service paths found. Ensure the design is loaded correctly and the JTAG connection is established."
    exit 1
}
puts "Obtaining service paths. \[DONE\]"

# Obtaining the MM master.
set MASTER_SERVICE_PATH [lindex $SERVICE_PATHS 0]
if { $MASTER_SERVICE_PATH == "" } {
    puts "Error: Could not retrieve the master service path."
    exit 1
}
puts "Obtaining the MM master service path. \[DONE\]"

# Claim the master.
if { [catch {set CLAIM_PATH [claim_service master $MASTER_SERVICE_PATH mylib]} result] } {
    puts "Error: Failed to claim the master service: $result"
    exit 1
}

if { $CLAIM_PATH == "" } {
    puts "Error: Claiming the master service failed. The returned claim path is empty."
    exit 1
}
puts "Claiming the MM master service. \[DONE\]"

set PIO_CLK             0x00
set PIO_REG_SELECT      0x10
set PIO_REG_BUS         0x20
set PIO_PC              0x30

source ./tcl_scripts/clock.tcl
source ./tcl_scripts/regs.tcl

puts "Initialization \[DONE\]"

# Prints the help message.
proc help {} {
    set instructions "\nForest-RiscV CPU Debug Environment Usage:\n"
    append instructions "-----------------------------------------\n"
    append instructions "1. Tick the CPU for a specified number of cycles:\n"
    append instructions "   Usage: tick \[n\]\n"
    append instructions "   - \[n\] (optional): Number of cycles to tick the CPU. Default is 1 cycle.\n"
    
    append instructions "2. Print all registers (x0...x31) and the PC register:\n"
    append instructions "   Usage: read_regs\n"

    append instructions "3. Do one step and then print all registers status.:\n"
    append instructions "   Usage: step\n"
    
    append instructions "-----------------------------------------\n"
    
    # Print the instructions
    puts $instructions
}

# Performs one CPU step and provides the current register's status.
proc step {} {
    tick
    read_regs
}

help
