
.ORIG x4000
AND R0, R0, #0	; this is the printer
AND R1, R1, #0	; contains address pointer
LEA  R1, Words	; R1 now holds address of string
Loopity
LDR R0, R1, #0	; loads contents into R0
BRz	Done		; if 0 is null-terminated, branch to done
TRAP x21
ADD R1, R1, #1	; increment pointer 
BR Loopity
Done
TRAP x25

Words
.STRINGZ "This is the string"

.END