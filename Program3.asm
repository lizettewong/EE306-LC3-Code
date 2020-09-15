;;***********************************************************
; Programming Assignment 3
; Student Name: Lizette Wong
; UT Eid:lmw3352
; Simba in the Jungle
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.
; Note: Remember "Callee-Saves" (Cleans its own mess)

;***********************************************************

.ORIG x4000

;***********************************************************
; Main Program
;***********************************************************
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_INITIAL
    TRAP  x22 
    LDI   R0,BLOCKS
    JSR   LOAD_JUNGLE
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_LOADED
    TRAP  x22                        ; output end message
    TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
BLOCKS          .FILL x5000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"       ; stored at x400C
     .STRINGZ "| | | | | | | | |"       ; stored at x400D
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
                   

;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE      
ST R0, SavR0        ; callee saves
ST R1, SavR1           
ST R2, SavR2           
ST R3, SavR3
ST R4, SavR4
ST R5, SavR5
AND R0, R0, #0      ; printer
AND R1, R1, #0      ; Grid pointer
AND R2, R2, #0      ; row number
AND R3, R3, #0      ; Use R3 to convert decimal to printed ASCII 
AND R4, R4, #0      ; helps skip to next string
AND R5, R5, #0      ; counts the cycles
LEA R0, ColNo       ; print column numbers
TRAP x22
LD R0, NewLine      ; ENTER
TRAP x21
LD R1, GridOne      ; load Grid address
ADD R5, R5, #8      ; Number of cycles we want
LoopyBoi  
LD R0, SpaceyBoi    ; print space
TRAP x21
LD R0, SpaceyBoi    ; print space
TRAP x21
AND R0, R0, #0      ; puts R1 to R0
ADD R0, R0, R1      ; load Grid Address to printer
TRAP x22
LD R0, NewLine      ; ENTER
TRAP x21
LD R3, Convert      ; converts row number to ASCII then prints
ADD R0, R2, R3      ; okay y'all I know this is super inefficient but that's how my brain works
TRAP x21
LD R0, SpaceyBoi    ; print space
TRAP x21
ADD R2, R2, #1      ; increment row number
LD R4, Eighteen     ; eighteen into R4
ADD R1, R1, R4      ; continue to the next string 
AND R0, R0, #0      ; clear R0
ADD R0, R1, R0      ; Load next string to R0
TRAP x22            ; prints logic row
LD R4, Eighteen     
ADD R1, R1, R4      ; R1 points at next character string
LD R0, NewLine
TRAP x21
ADD R5, R5, #-1     ; decrement everytime we finish a cycle
BRnp LoopyBoi       ; if not = 8, continue looping
LD R0, SpaceyBoi    ; print space
TRAP x21
LD R0, SpaceyBoi    ; print space
TRAP x21
ADD R0, R1, #0      ; put last R1 into R0
TRAP x22            ; print last character string
LD R0, SavR0        ; restore
LD R1, SavR1        
LD R2, SavR2          
LD R3, SavR3
LD R4, SavR4
LD R5, SavR5
JMP R7              
 
ColNo
    .STRINGZ "   0 1 2 3 4 5 6 7 "
SpaceyBoi
    .FILL x0020
NewLine
    .FILL x000A
Convert
    .FILL x0030         ; this is 48 in hex
FortyEight
    .FILL #48
Eighteen
    .FILL #18
GridOne
    .FILL GRID
SavR0 .BLKW #1
SavR1 .BLKW #1
SavR2 .BLKW #1
SavR3 .BLKW #1
SavR4 .BLKW #1
SavR5 .BLKW #1

;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
    ST R1, StowR1           ;initialize, callee saves
    ST R2, StowR2           
    ST R3, StowR3
    ST R4, StowR4
    ST R5, StowR5
    ST R7, StowR7
    ADD R5, R0, #0      ; R5 now has the address of Head
 Start
    LDR R1, R5, #1      ; row no. pointer
    LDR R2, R5, #2      ; col no. pointer
    LDR R3, R5, #3      ; ASCII pointer
    JSR GRID_ADDRESS    ; call Grid Address subroutine to calculate positions
    JSR Simba           ; replaces I with asterisk and stores correct address
    JSR Home            ; checks for H and stores variables
    STR R3, R0, #0      ; most important step! This puts the character into the right place 
    LDR R5, R5, #0      ; loads next address into R0
    BRnp Start          ; if not null, traverse through linked list
    LD R1, StowR1       ; restore
    LD R2, StowR2           
    LD R3, StowR3
    LD R4, StowR4
    LD R5, StowR5
    LD R7, StowR7
    JMP  R7
    
    Home                
    ST R7, HomeSave      
    LD R4, homepos         
    ADD R4, R3, R4      ; check if the object is an H
    BRnp Leave          ; if not an "H" leave subroutine
    STI R1, HomeRow     ; saves HomeRow
    STI R2, HomeCol     ; saves HomeCol
    LD R7, HomeSave
    Leave
    RET
    
    Simba
    ST R7, SimbaSave       
    LD R4, initial
    ADD R4, R3, R4      ; check if object is an I
    BRnp GetOut
    LD R3, asterisk     ; if object is I, replace with asterisk
    STI R1, InitialRow  ; saves Simba's row
    STI R2, InitialCol  ; saves Simba's column 
    LD R7, SimbaSave       
    GetOut
    RET
    
initial .FILL #-73      ; value to check if row object is an "I"
asterisk .FILL #42      ; negative decimal value of asterisk ASCII
homepos .FILL #-72      ; negative decmal value of "H" in ASCII
SimbaSave .BLKW #1 
HomeSave .BLKW #1

InitialRow .FILL CURRENT_ROW    ; save position if Simba
InitialCol .FILL CURRENT_COL
HomeRow .FILL HOME_ROW          ; save position if Home
HomeCol .FILL HOME_COL

StowR1 .BLKW #1
StowR2 .BLKW #1
StowR3 .BLKW #1
StowR4 .BLKW #1
StowR5 .BLKW #1
StowR7 .BLKW #1

;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7) --> jump between rows add #36
;         R2 has the column number (0-7) --> jump between columns add #2
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS
ST R1, SaveR1           ; callee saves
ST R2, SaveR2         
ST R3, SaveR3
ST R4, SaveR4

LD R0, GridOne          ; address of the Grid is now in R0
LD R3, Nineteen         ; R3 and R4 now contain offsets to traverse through the grid
LD R4, ThirtySix
ADD R0, R0, R3          ; GRID + 19 since R0 points at the very first character
ADD R2, R2, R2          ; Double R2 to pace between columns
ADD R0, R2, R0
ADD R1, R1, #0          ; Check if Row number is 0
BRz Done
Loopity
ADD R0, R0, R4          ; if not, calculate moving between rows
ADD R1, R1, #-1         ; decrement row counter
ADD R1, R1, #0          ; check if R1 is 0
BRnp Loopity            ; if not zero, continue adding
Done
LD R1, SaveR1
LD R2, SaveR2
LD R3, SaveR3
LD R4, SaveR4
JMP R7

Nineteen .FILL #19
ThirtySix .FILL #36
SaveR0 .BLKW #1
SaveR1 .BLKW #1
SaveR2 .BLKW #1
SaveR3 .BLKW #1
SaveR4 .BLKW #1
.END