.ORIG x3000
    ;number stored in x300A, we want to check its sign and store
    ;the result in x300B, x300A = 0, store 0, x300A positive; store
    ;+1, x300A negative store -1
    
    ;get the number in x300A
    LD R1, number

    ;test sign of number
    ADD R1, R1, 0                   ; sets the PSR without changing the value.
    
    ;store result of test into x300B
    
    ;execute this block when result is zero
    BRnp notzero
        AND R0, R0, 0 
        ST, R0, result
        BR fin
    notzero
    
    ;execute this block when the result is positive
    BRn notpositive
        AND R0, R0, 0
        ADD R0, R0, 1
        ST R0, result
    notpositive
    
    ;execute this block when the result is negative
        AND R0, R0, 0
        ADD R0, R0, -1
        ST R0, result
        
fin
    HALT
    
    .FILL 10
    .BLKW 1
    
.END