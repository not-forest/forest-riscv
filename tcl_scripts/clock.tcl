####################################################################################################
#   File: clock.tcl
#   Desc: Defines clock related functions for preforming a CPU tick cycle.
####################################################################################################

# Performs n CPU cycles. The default values is one. Because CPU is pipelined, clock must tick 3 times
# in a row for one instruction cycle.
proc tick {{n 1}} {
    global CLAIM_PATH PIO_CMD PIO_ARG CMD
    for {set i 0} {$i < $n} {incr i} {
        master_write_8 $CLAIM_PATH $PIO_CMD $CMD(WRITECLK)
        master_write_8 $CLAIM_PATH $PIO_ARG 0
        master_write_8 $CLAIM_PATH $PIO_ARG 1
        master_write_8 $CLAIM_PATH $PIO_ARG 0
        master_write_8 $CLAIM_PATH $PIO_ARG 1
        master_write_8 $CLAIM_PATH $PIO_CMD $CMD(NOP)
    }
}
