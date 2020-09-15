; Programming Project 1 starter file
; Student Name  : Lizette Wong
; UTEid:lmw3352

	.ORIG	x3000   ; Initial starting point
	AND	R0,R0,#0	; Initialize
	LD	R2, A		; Load from x2FF0
	LD  R1, B       ; Load from x2FF1, R1 is decremented/incremented so R1 is the number of times R2 is multiplied
	
    BRn Loop2       ; If R1 is negative, Branch to Loop 2
    BRz Done        ; If R1 is 0, 0*n=0, so automatically store 
   
Loop	
    ADD	R0,R0,R2	;If R1 is positive, Branch to Loop or if unfinished looping
	ADD	R1,R1,#-1	; Decrement R1 b/c we added the number one more time 
	BRp	Loop		; Branch back to Check if the decremented value in R1 is still positive
    BR  Done        ;  Unconditional Loop 

Loop2               ;If R1 is negative, Branch here
    ADD	R0,R0,R2	 
	ADD	R1,R1,#1    ;Instead of decrementing, add until 0 which is finished
	BRn Loop2       ;Branch back to start if unfinished 
	NOT R0, R0      ;2's complement, flip bits
	ADD R0, R0, #1  ;Add 1, no need for unconditional loop because it will 'fall' through

Done    ST  R0, C   ;If finished, store final value
    	TRAP	x25 ;LC3Tools is garbage make sure to manually put in a breakpoint

.END                ;yeah boiii we done

    .ORIG   x2FF0   ;LC3Tools can have a second origin point, no need to calculate offset yayaya
A   .FILL   #-20    ;x2FF0, sample numbers
B   .FILL   #-10    ;x2FF1, sample numbers
C   .BLKW   #1      ;Reserved spot for result
	.END            ;.ORIG and .END act as curly brackets 
			

