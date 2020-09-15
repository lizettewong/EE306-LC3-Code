; The Main program sets up the system to make Interrupts possible:
; 1. Assume System Stack is at x 2FFF and grows upwards
; 2. Puts the ISR address in the keyboard Interrupt Vector Entry of the Interrupt Vector Table.
; 3. Enables the Keyboard Interrupt by setting bit 14 of KBSR 

.ORIG x4000
LD R0, KBISR
STI R0, KBIVE       ; M[x01080]<- x5000
LDI R0, KBSR 
LD R1, KBIEN        ; R0 <- R0 OR R1
NOT R0, R0          ; apply D'Morgan's laws 
NOT R1, R1
AND R0, R0, R1
NOT R0, R0 
STI R0, KBSR        ; "friendly way" to set bit 14
loop 
    BRnzp loop

KBIVE .FILL x0180   ; Address of the KB Vector Table Entry 
KBISR .FILL x5000
KBSR .FILL xFE00
KBIEN .FILL x4000

.END

;KB ISR is here
.ORIG x5000

.END 