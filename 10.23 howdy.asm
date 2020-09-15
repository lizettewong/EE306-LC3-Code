    .ORIG x3000
    LEA R0, Greet       ; Load Effective Address
    PUTs                ; A TRAP service that expects R0 to hold the address of a null-terminated string  
                        ; Prints it out to the console 
    HALT
Greet   .STRINGZ "Howdy"
    .END