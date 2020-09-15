.ORIG x3000
LEA R0, First
TRAP x22
LD R0, ENDLINE      ; R0 = the value of ENDLINE which is .FIll x0A
PUTc                ; Prints the char in R0
LEA R0, Second
TRAP x22
TRAP x25

ENDLINE 
    .FILL x0A       ; A decimal 10, or a hex 'A'
First
    .STRINGZ "It was love at first sight, at last sight,"
Second
    .STRINGZ "at ever and ever sight."
    
    .END