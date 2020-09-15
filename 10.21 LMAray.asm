; Find the leftmost 1 in each item
; of an array of 10 items stored at x4000
; Put positions at x5000
    .ORIG x3000
    LD  R0, ptNums      ; R0 <- x4000
    LD  R3, ptPoss      ; R3 <- x5000
    AND R5, R5, #0
    ADD R5, R5, #5      ; Counter of how many items are in the Array
OLoop
    LDR R2, R0,#0       ; R2 <- Nums[0]
    BRz Exception
    AND R1, R1, #0
    ADD R1, R1, #15     ; R1 <- 15
ILoop 
    ADD R2, R2, #0
    BRn DoneItem
    ADD R1, R1, #-1
    ADD R2, R2, R2  ; Left shift
    BRnzp ILoop
Exception
    AND R1, R1, #0
    ADD R1, R1, #-1
DoneItem
    STR  R1, R3, #0
    ADD  R0, R0, #1     ; Move to next item
    ADD  R3, R3, #1
    ADD  R5, R5, #-1
    BRp  OLoop
    
    HALT
ptNums  .FILL   x4000
ptPoss  .FILL   x5000
    .END
; Here be the numbers
    .ORIG   x4000
    .FILL   x1000
    .FILL   x1123
    .FILL   x000F
    .FILL   xABCD
    .FILL   x0AA0
    .END
; Here be the results
    .ORIG   x5000
    .BLKW   #5
    .END