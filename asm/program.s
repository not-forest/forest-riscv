    .section .data
    .section .text               
    .globl _start                

_start:
    # Initialize values
    li t0, 5                     
    li t1, 10                    
    li t2, 15                    
    li t3, 20                    

    # Additions
    add t4, t0, t1               
    add t5, t4, t2               
    add t6, t5, t3               

loop:
    j loop                       
