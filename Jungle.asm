; This file has the linked list for the
; Jungle's layout
; populates the jungle with characters
	.ORIG	x5000
	.FILL	Head    ; points to label with Head
blk2
	.FILL   blk4
    .FILL	#1
	.FILL   #1
	.FILL   x23     ; x23 is # so this is a hyena 

Head
    .FILL  	blk1   ;x5005
   .FILL   #0
	.FILL   #1
	.FILL   x23     ; hyena

blk1
	.FILL   blk3    ;x5009
	.FILL   #4
	.FILL   #7
	.FILL   x48     ; "H" character

blk3
	.FILL   blk2    ;x5013
	.FILL   #2
	.FILL   #1
	.FILL   x49     ; initial or "*" character

blk4
	.FILL   blk5    ;x5017
	.FILL   #6
	.FILL   #3
	.FILL   x23     ; hyena

blk7
    .FILL   #0      ;x5021
	.FILL   #5
	.FILL   #6
	.FILL   x23     ; hyena
blk6
	.FILL   blk7    ;x5025
	.FILL   #4
	.FILL   #4
	.FILL   x23     ; hyena
blk5
	.FILL   blk6    ;x5029    
	.FILL   #3
	.FILL   #5
	.FILL   x23     ; hyena
	.END	