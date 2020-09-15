; Recitation: 10/22/2019 
; Program: Find the length of a string.
; strlen.asm - length of null-terminated string

    .ORIG x3000
    
    ;initial stage
        AND R2, R2, #0 ; Clear R2 as our counter for the string
        LEA R0, string ; LEA stands for Load Effective Address, takes address of label "string" and puts into R0
    
    ; check sentinel
    check
        LDR R1, R0, #0   ; does LDR set condition code in new LC3??
        BRz conclusion
        
    ; body
    body
        ADD R2, R2, #1  ; R2 has length of string, so we are incrementing
        ADD R0, R0, #1  ; incrementing to next character of the string
        BR  check       ; unconditional branch back to the LDR to continue counting 
    ;conclusion
    conclusion
        ST R2, result   ;stores length into result 
    
        HALT    ; Always make sure DATA is after HALT

    result  .BLKW   #1
    string  .STRINGZ "hello_world!"

    .END