; given an array of positive numbers, find the max element
; if array is empty, return 0

    .ORIG x3000
    
    init
    LEA R0, array   ; load effective address
    AND R2, R2, #0  ; R2 will have the maximum number 
    
    check
    LDR R1, R0, #0  ; sets the condition code
    BRn conclusion  ; -1 is our sentinel 
    
    body
    ; negative of array element
    NOT R3, R1      ; scratch register, preserving R1, negative of R1 -> R3
    ADD R3, R3, #1  
    
    ; compare array element and maximum Number
    ADD R3, R2, R3          ; adding the NOT number compares which element is more negative. 
    BRzp increment
        ; replace the elements 
        ADD R2, R1, #0      ; moves the value of R1 into R2
    increment 
    ADD R0, R0, #1
    BR check                ; unconditionally branch back to check 
    
    conclusion 
    ST R2, result
    
    HALT
    
   
result .BLKW   #1 
array  .FILL   #1
       .FILL   #2
       .FILL   #1
       .FILL   #5
       .FILL   #1
       .FILL   #3
       .FILL   #2
       .FILL   #9
       .FILL   #5
       .FILL   #6
       .FILL   #-1     ; sentinel 
    
    .END
    
    
    
    
    