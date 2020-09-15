; Programming Assignment 2
; Student Name: Lizette Wong
; UT Eid: lmw3352
; Linked List creation from array. Insertion into the list
; You are given an array of student records starting at location x3500.
; The array is terminated by a sentinel. Each student record in the array
; has two fields:
;      Score -  A value between 0 and 100
;      Address of Name  -  A value which is the address of a location in memory where
;                          this student's name is stored.
; The end of the array is indicated by the sentinel record whose Score is -1
; The array itself is unordered meaning that the student records dont follow
; any ordering by score or name.
; You are to perform two tasks:
; Task 1: Sort the array in decreasing order of Score. Highest score first.
; Task 2: You are given a name (string) at location x6000, You have to lookup this student 
;         in the linked list (post Task1) and put the student's score at x5FFF (i.e., in front of the name)
;         If the student is not in the list then a score of -1 must be written to x5FFF
; Notes:
;       * If two students have the same score then keep their relative order as
;         in the original array.
;       * Names are case-sensitive.

	.ORIG	x3000   
    AND R0, R0, #0
    AND R1, R1, #0
    AND R2, R2, #0
    AND R3, R3, #0
    AND R4, R4, #0
    AND R5, R5, #0
    AND R6, R6, #0
    AND R7, R7, #0
    LD  R0, Stud    ; R0 holds x3500
OuterLoop
    LDR R1, R0, #0  ; offset is zero because we are already at x3500
    BRn Sort
    ADD R0, R0, #2  ; accounting for student name and grade 
    BRnzp OuterLoop ; R0 contains address of sentinel
    
Sort
    ADD R0, R0, #-2 ; R0 at end of array 
    LD R2, Stud     ; R2 holds address x3500
    NOT R7, R0      ; R7 now contains R0
    ADD R7, R7, #1  ; Two's complement
    ADD R7, R7, R2  ; compare with R2
    BRz Task2
    ADD R2, R2, #-2
                    
InnerLoop
    ADD R2, R2, #2  ; increment R2 pointer to next address
    NOT R7, R0      ; R7 now contains R0
    ADD R7, R7, #1  ; Two's complement
    ADD R7, R7, R2  ; compare with R2
    BRZ Sort 
    ADD R3, R2, #2  ; R3 holds next address
    LDR R4, R2, #0  ; load data into R4
    LDR R5, R3, #0  ; load data into R5
    ;BRn InnerLoop   ; If m[R3] is -1, go back to the start for the next pass through bubble sort 
                    ; how to compare R4 and R5???
    NOT R5, R5      ; Turn R5 into negative two's complement to compare addresses
    ADD R5, R5, #1  ; R5 is now negative 
    ADD R4, R4, R5  ; Compare sizes of R4 and R5
    BRP InnerLoop   ; If R4 is postive, can keep processing array 
    LDR R4, R2, #0  ; Reload data into R4
    LDR R5, R3, #0  ; Reload data into R5
    LDR R6, R2, #3  ; load name into R6
    LDR R7, R3, #-1 ; load name into R7
    STR R5, R2, #0  ; Swap names AND grades if R4<R5 false 
    STR R4, R2, #2
    STR R6, R3, #-1
    STR R7, R2, #3
    BR InnerLoop
   
Task2               ; Replace Done with Task 2    
    AND R0, R0, #0  ; initialize 
    AND R1, R1, #0
    AND R2, R2, #0
    AND R3, R3, #0
    AND R4, R4, #0
    AND R5, R5, #0
    AND R6, R6, #0
    AND R7, R7, #0
    LD R0, LookUp       ;R0 is at x6000
    LD R1, Array        ;R1 is at x3501
    LDR R5, R1, #-1     ;if array is empty 
    BRn FinalNoMatch    ;branch to end if array empty 
    LDR R4, R1, #0      ;loading address of string into R4
Loop
    LDR R2, R0, #0      ;R2 holds characters at x6000
    LDR R3, R4, #0      ;R3 holds characters at x3501
    BRz CheckMatch
    NOT R2, R2          ; make character comparison by subtraction, two's complement
    ADD R2, R2, #1
    ADD R3, R2, R3      ; compare
    BRnp NoMatch
    ADD R0, R0, #1      ; addresses of names 
    ADD R4, R4, #1
    BR Loop
NoMatch
    ADD R1, R1, #2
    LDR R7, R1, #-1     ;checks for sentinel
    BRn FinalNoMatch
    LD R0, Lookup
    LDR R4, R1, #0      ;loading address of string into R4
    BR Loop
CheckMatch 
    ADD R2, R2, #0      ; confirms value of R2
    BRNP NoMatch          ; not a match, next name 
MatchFound
    ADD R1, R1, #-1     ; goes back to grade 
    LDR R6, R1, #0
    BR StoreResult
FinalNoMatch
    ADD R6, R6, #-1     ;R6 becomes -1 
StoreResult
    LD R0, LookUp
    STR R6, R0, #-1
	TRAP	x25

LookUp
    .FILL x6000
Array
    .FILL x3501

    
Stud 
    .FILL	x3500
	.END
	
	.ORIG	x4100
	.STRINGZ "Bat Man"
	.END
	
	.ORIG   x4700
	.STRINGZ "Joe"
	.END
	
	.ORIG   x4200
	.STRINGZ "Wonder Woman"
	.END
	
	.ORIG   x6000
	.STRINGZ "Batman"
	.END
