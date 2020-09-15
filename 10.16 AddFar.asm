;Program AddNear
;   Add two numbers stored at x4000 and x4001
;   Put result at x4002
;   Your program must be at x3000
    .ORIG x3000
    LDI R1, ptNum1    ;Num 1 into R1
    LDI R2, ptNum2     ;Num 2 into R2, offset of #1 because 
    ADD R0, R1, R2
    STI R0, ptSum      ;Reusing address that was used before. This has fewer memory access than LDI
    Halt
ptNum1 .FILL x4000      ;Address of Data
ptNum2 .FILL x4001
ptSum  .FILL x4002

    .END
    
    ; Data Stored here
    .ORIG x4000
Num1 .FIll #42
Num2 .FILL #-13
Sum  .BLKW #1
    .END 