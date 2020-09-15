; 12.3.2019 Recitation, ISR practice 
;a program that exits when you hit any 3 keys
; implemented using keyboard interrupts

; populate the IVT
    .ORIG x0180
    .FILL x2600
    .END
    
;KBD_ISR
    .ORIG x2600                     ; the main is only interrupted for 6 clock cycles, so a few nanoseconds 
    ST R0, str0_loc                 ; 1:10 ratio from main to ISR clock cycles is ideal
    LDI R0, kbdr_loc
    LDI R0, global_loc 
; This won't work in the new simulator because you have to read before you do anything else.
    ADD R0, R0, #1
    STI R0, global_loc
    LD R0, str0_loc
    RTI
    
    global_loc .FILL x4000
    kbdr_loc   .FILL xFE02
    str0_loc    .BLKW #1         ; a place to store R0

    .END

;main
    .ORIG x3000
    AND R0, R0, #0
    STI R0, main_global_loc 
    LDI R0, kbsr_loc
    LD R1, kbsr_mask
            ; OR R0 and R1 -> R0 
            NOT R0, R0
            NOT R1, R1
            AND R0, R1, R0
            NOT R0, R0

    STI R0, kbsr_loc 
    
Loop
    LDI R0, main_global_loc
    ADD R0, R0, #-3
    BRnp Loop
    HALT
    
    main_global_loc .FILL x4000
    kbsr_loc        .FILL xFE00 
    kbsr_mask       .FILL x4000     ; although main and kbsr are the same, for good practice, maintain 
    .END 