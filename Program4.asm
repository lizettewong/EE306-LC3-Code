;***********************************************************
; Programming Assignment 4
; Student Name: Lizette Wong
; UT Eid: lmw3352
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

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
HOMEBOUND
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BR    HOMEBOUND
VALID_INPUT                 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   IS_SIMBA_HOME      
        ADD   R2, R2, #0                 ; R2 will be zero if Simba reached Home
        BRnp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
PROMPT .STRINGZ "\nEnter Move \n\t(up(i) left(j),down(k),right(l)): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\nYou Saved Simba !Goodbye!\n"
BLOCKS               .FILL x5000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
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
; Your Program 3 code goes here
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
LD R0, NewLine      ; ENTER
TRAP x21
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
; Your Program 3 code goes here
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
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS     
; Your Program 3 code goes here
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
;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID
; Your New (Program4) code goes here
ST R1, StoreR1
AND R1, R1, #0
AND R2, R2, #0

LD R1, LetterI          ; place letters into R1
ADD R1, R1, R0          ; checks if valid
BRz Valid

LD R1, LetterJ 
ADD R1, R1, R0
BRz Valid

LD R1 LetterK
ADD R1, R1, R0 
BRz Valid

LD R1, LetterL
ADD R1, R1, R0
BRz Valid 

ADD R2, R2, #-1         ; return negative one if invalid 

Valid
LD R1, StoreR1
JMP R7

LetterI .FILL x-69      ; these are the hex values for ASCII print
LetterJ .FILL x-6A
LetterK .FILL x-6B
LetterL .FILL x-6C
StoreR1 .BLKW #1
;***********************************************************
; SAFE_MOVE
; Input: R0 has 'i','j','k','l'
; Output: R1, R2 have the new row and col if the move is safe
;         If the move is unsafe, that is, the move would 
;         take Simba to a Hyena or outside the Grid then 
;         return R1=-1 
; Notes: Translates user entered move to actual row and column
;        Also checks the contents of the intended space to
;        move to in determining if the move is safe
;        Calls GRID_ADDRESS
;        This subroutine does not check if the input (R0) is 
;        valid. This functionality is implemented elsewhere.
;***********************************************************

SAFE_MOVE      
; Your New (Program4) code goes here
ST R2, StorR2                      ; Simba's Column
ST R3, StorR3                      ; scratch registers
ST R4, StorR4               
ST R7, StorR7    
LDI R1, SimbaRow                    ; R1 has Simba's Row
LDI R2, SimbaCol                    ; R2 has Simba's Col

LD R3, CharI                       ; Case One, if I
ADD R3, R0, R3                     
BRz Up 
LD R3, CharK                       ; Case Two, if K
ADD R3, R0, R3                     
BRz Down
LD R3, CharJ                       ; Case Three, if J              
ADD R3, R0, R3    
BRz Left
LD R3, CharL                       ; Case Four, if L
ADD R3, R0, R3
BRz Right 

Up 
ADD R1, R1, #-1                    ; updates new row based on input
BR CarryOn

Down 
ADD R1, R1 #1                 
BR CarryOn

Left 
ADD R2, R2, #-1
BR CarryOn

Right 
ADD R2, R2, #1
BR CarryOn

CarryOn                           ; Check if Simba is out of bounds
ADD R3, R1, #-7                   ; If R1 is still positive, out of bounds
BRp SimbaBye
ADD R3, R1, #0                    ; If R1 is still negative, also out of bounds 
BRn SimbaBye
ADD R3, R2, #-7
BRp SimbaBye
ADD R3, R2, #0
BRn SimbaBye

JSR GRID_ADDRESS                   ; GRID takes new R1 and R2 and converts it to memory location in R0
LDR R3, R0, #0                     ; check the contents of R0 
LD R4, HyenaBoi                    ; R4 has negative ASCII value of Hyena
ADD R4, R3, R4
BRz SimbaBye
BR Good

SimbaBye                            ; invalid, returns -1 in R1 
AND R1, R1, #0
ADD R1, R1, #-1
LD R2, StorR2

Good
LD R3, StorR3
LD R4, StorR4
LD R7, StorR7
    JMP R7

SimbaRow .FILL CURRENT_ROW
SimbaCol .FILL CURRENT_COL
CharI .FILL x-69                  ; these are the hex values for ASCII print
CharJ .FILL x-6A
CharK .FILL x-6B
CharL .FILL x-6C
HyenaBoi   .FILL x-23             
StorR2 .BLKW #1
StorR3 .BLKW #1
StorR4 .BLKW #1
StorR7 .BLKW #1


;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is safe by calling 
; SAFE_MOVE which returns the coordinates of where the move 
; goes (or -1 if movement is unsafe as detailed below). 
; If the move is Safe then this routine moves the player 
; symbol to the new coordinates and clears any walls (|�s and -�s) 
; as necessary for the movement to take place. 
; If the movement is unsafe, output a console message of your 
; choice and return. 
; Input:  
;         R0 has move (i or j or k or l)
; Output: None; However must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
; Notes:  Calls SAFE_MOVE and GRID_ADDRESS
;***********************************************************

APPLY_MOVE   
; Your New (Program4) code goes here
    ST R1, StoR1 
    ST R2, StoR2 
    ST R3, StoR3 
    ST R4, StoR4
    ST R5, StoR5
    ST R7, StoR7 

ADD R5, R0, #0          ; place the input of R0 into R5
JSR SAFE_MOVE           ; Outputs of R1 and R2, the NEW row and column 
ADD R1, R1, #0      
BRn YouFail             ; if it was invalid, R1 gets -1 and ends
STI R1, NewSimRow       ; update new Row and Column 
STI R2, NewSimCol
JSR GRID_ADDRESS        ; call Grid Address, which takes R1 & R2 from Safe Move computes address in R0

MoveSimba              
LD R3, AsteriskBoi
STR R3, R0, #0          ; places Simba into the computed adddress. We move Simba THEN clear pipes 

LD R3, ASCiiI                     
ADD R3, R5, R3                     
BRz CaseI
LD R3, ASCiiK                     
ADD R3, R5, R3                     
BRz CaseK
LD R3, ASCiiJ                                    
ADD R3, R5, R3    
BRz CaseJ
LD R3, ASCiiL                      
ADD R3, R5, R3
BRz CaseL 

CaseI
LD R3, IOffset          ; R3 gets I offset which is #18
ADD R3, R0, R3          ; now we get the memory address of the bar relative to the new location
LD R4, SpaceyBoi2       ; R4 now has the space which will "clear" the bar 
STR R4, R3, #0          ; The space overwrites the bar that was previously in R3
LD R3, ThirtySix_1
ADD R3, R0, R3
STR R4, R3, #0          ; kills the old Simba relative to the new position 
BR FinishLine

CaseK
LD R3, KOffset          
ADD R3, R0, R3
LD R4, SpaceyBoi2
STR R4, R3, #0
LD R3, NegThirtySix
ADD R3, R0, R3
STR R4, R3, #0
BR FinishLine

CaseJ
AND R3, R3, #0          ; Clears R4
ADD R3, R3, #1          ; JOffset
ADD R3, R0, R3          ; new address
LD R4, SpaceyBoi2
STR R4, R3, #0
STR R4, R3, #1          ; clears old Simba 
BR FinishLine

CaseL
AND R3, R3, #0
ADD R3, R3, #-1
ADD R3, R0, R3
LD R4, SpaceyBoi2
STR R4, R3, #0
STR R4, R3, #-1         ; kills the old Simba, offest of #-1 because it is one past the cleared bar
BR FinishLine

YouFail
LD R0, ENTER      
TRAP x21
LEA R0, FailMessage
TRAP x22
LD R0, ENTER      
TRAP x21

FinishLine
    LD R1, StoR1
    LD R2, StoR2 
    LD R3, StoR3 
    LD R4, StoR4
    LD R5, StoR5
    LD R7, StoR7

    JMP R7

ASCiiI .FILL x-69                  
ASCiiJ .FILL x-6A
ASCiiK .FILL x-6B
ASCiiL .FILL x-6C
IOffset .FILL #18
KOffset .FILL #-18
ThirtySix_1 .FILL #36
NegThirtySix .FILL #-36
SpaceyBoi2 .FILL x0020
AsteriskBoi .FILL x002A
NewSimRow .FILL CURRENT_ROW
NewSimCol .FILL CURRENT_COL
ENTER .FILL x000A
FailMessage .STRINGZ "Simba can't go there!"
StoR1 .BLKW #1
StoR2 .BLKW #1
StoR3 .BLKW #1
StoR4 .BLKW #1
StoR5 .BLKW #1
StoR7 .BLKW #1

;***********************************************************
; IS_SIMBA_HOME
; Checks to see if the Simba has reached Home.
; Input:  None
; Output: R2 is zero if Simba is Home; -1 otherwise
; 
;***********************************************************

IS_SIMBA_HOME     
    ; Your code goes here
LDI R1, SimRow 
LDI R2, SimCol 
LDI R3, HomRow
LDI R4, HomCol

NOT R3, R3                  ; negate Home Position
ADD R3, R3 #1
ADD R3, R3, R1              ; check if HomRow = SimRow
BRnp NoMatch

NOT R4, R4                  ; negate HomeCol
ADD R4, R4, #1              
ADD R4, R4, R2              ; check if HomCol = SimCol
BRnp NoMatch

AND R2, R2, #0              ; returns 0 if Simba has reached home
BR Finale

NoMatch
AND R2, R2, #0
ADD R2, R2, #-1             ; returns -1 if Simba is not home yet 

Finale
    JMP R7

SimRow .FILL CURRENT_ROW    ; save position if Simba
SimCol .FILL CURRENT_COL
HomRow .FILL HOME_ROW
HomCol .FILL HOME_COL
.END

	