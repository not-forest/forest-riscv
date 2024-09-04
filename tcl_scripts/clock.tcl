####################################################################################################
#   File: clock.tcl
#   Desc: Defines clock related functions for preforming a CPU tick cycle. 
####################################################################################################


# Performs n CPU cycles. The default values is one.
proc tick {{n 1}} {
    global CLAIM_PATH PIO_CLK
    for {set i 0} {$i < 4 * $n} {incr i} {
        master_write_8 $CLAIM_PATH $PIO_CLK 1
        master_write_8 $CLAIM_PATH $PIO_CLK 0
    }
}
