.ORIG x3000

		AND R0, R0, #0      ; initialize 
		LD R3, Input		; R3 holds x4000
		LD R1, convert		; conversion factor of -30 from ASCII to octal
Loop	LDR R2, R3, #0      ; Puts x4000 to R2  M[R3+0]->R2 1
        BRz Done            ; sentinel
        ADD R2,R1,R2        ; converts it to number
		ADD R0, R0, R0		; shifting left? 
		ADD R0, R0, R0
		ADD R0, R0, R0
		ADD R0, R0, R2		;->Memory and conversion of 
		ADD R3, R3, #1
		BRnzp Loop

Done	STI R0, OUTPUTloc 
		HALT

		Input   	.FILL x4000
		convert 	.FILL x-30      ;if it's decimal it's negative 48
		OUTPUTloc	.FILL x5000
		
		.END
		
		.ORIG   x4000
		.STRINGZ    "172"           ; value given
        .END