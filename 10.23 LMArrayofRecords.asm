; Find the leftmost 1 in each item
; of an array of records stored at x4000
; Each record has 2 attributes: num, lmb (left most bit)
; Put positions at corresponding attributes within record
    .ORIG x3000
    LD  R0, ptRecs      ; R0 <- x4000
    AND R5, R5, #0
    ADD R5, R5, #5      ; Counter of how many items are in the Array
OLoop
    LDR R2, R0,#0       ; R2 <- Recs[0].num (which attribute of record we are looking at)
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
    STR  R1, R0, #1     ; not #0 because we don't want to overwrite     
    ADD  R0, R0, #2     ; Move to next item by incrementing in steps of the size of the record. 
    ADD  R3, R3, #1
    ADD  R5, R5, #-1
    BRp  OLoop
    
    HALT
ptRecs  .FILL   x4000
ptPoss  .FILL   x5000
    .END
; Here be the numbers
    .ORIG   x4000
    .FILL   x1000
    .BLKW   #1
    .FILL   x1123
    .BLKW   #1
    .FILL   x000F
    .BLKW   #1
    .FILL   xABCD
    .BLKW   #1
    .FILL   x0AA0
    .BLKW   #1
    .END