;Program AddNear
;   Add two numbers stored at x4000 and x4001
;   Put result at x4002
;   Your program must be at x3000
    .ORIG x3000
    LD  R3, ptData
    LDR R1, R3, #0    ;Num 1 into R1
    LDR R2, R3, #1      ;Num 2 into R2, offset of #1 because 
    ADD R0, R1, R2
    STR R0, R3, #2      ;Reusing address that was used before. This has fewer memory access than LDI
    Halt
ptData  .FILL x4000 ;Address of Data

    .END
    
    ; Data Stored here
    .ORIG x4000
    Num1 .FIll #42
    Num2 .FILL #-13
    Sum  .BLKW #1
    .END 