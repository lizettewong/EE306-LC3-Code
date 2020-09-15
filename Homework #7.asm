; R0 is the pointer to the beginning of the array
; R1 is the pointer to the end of the array

.ORIG x3000
LD R0, StartArray
LD R1, EndArray

loop	LDR R2, R0, #0  	; load contents of array start into R2
   	LDR R3, R1, #0	; load contents of array end into R3
   	STR R2, R1, #0	; initiate the swappy boi
   	STR R3, R0, #0
   	ADD R0, R0, #1	; increment R0
   	ADD R1, R1, #-1	; decrement R1
   	NOT R2, R2		; Find when R1=R0
	ADD R2, R2, #1	; Incomplete Two’s Complement
   	ADD R3, R2, R0	
   	BRnp loop		; for all cases when sum ≠ 0, loop 
	
TRAP x25
StartArray
.FILL x4000
EndArray
.FILL x4004
.END 
