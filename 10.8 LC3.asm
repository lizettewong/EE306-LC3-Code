.ORIG x3000
    ; clears r0 and sets r0 to 3
    ADD r0, r0 #0
    ADD r0, r0 #3
    AND r1, r1, #0
    ADD r1, r1, #2
    
    ; makes r1 to -r1
    NOT r1, r1
    ADD r1, r1, #1
    
    ADD r2, r1, r0
.END
;.ORIG x3000
;    LD r0, hello_loc
;    puts
    ; end of program
;hello_loc       .FILL hello_string
;hello_string    .STRINGZ "Hello World!"
;.END
