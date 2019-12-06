/******************************************************************************

* file: 6_part1.s

* Author: Pawan Bathe (CS18M519)

* TA: G S Nitesh Narayana

* Guide: Prof. Madhumutyam IITM, PACE

******************************************************************************/

/*
### Part 1
Write an assembly program for searching a given integer number in an
array of integer numbers. Assume that the numbers in the array are not in
sorted order. The program must ask the user to enter the number of
elements of the array and accept each element of the array through
keyboard (for this, you need to use software interrupts). Also, the user must
enter the element to be searched through keyboard. You must pass the
array and the searching element as parameters to a subroutine, **SEARCH**.
The program outputs the position of the given element, if it is present in the
array, otherwise, it outputs **-1**.

For example:

|         |           |             |
|:-------:|:---------:|:-----------:|
|  Input: |   A |43,25,100,10,9|
|  Search Element:|   N |      10     |
|  Output:|    |      4    |
|  Search Element:|   N |      26     |
|  Output:|    |      -1    |

*/

.bss
	
.data
	SIZE: .word 0       
	ARRAY: .skip 80         
	KEY: .word 0          
	POSITION: .word -1    
	ARRAY_SIZE_STRING: .asciz "Enter Array Length:\n"
	ARRAY_STRING: .asciz "Enter Array Elements \n"
	KEY_STRING: .asciz "Enter Search Element \n"
	POSITION_STRING: .asciz "Key Found At: "


.global _main
.text
	.equ SWI_STR, 0x69
	.equ SWI_INT, 0x6b
	.equ SWI_INPUT, 0x6c
	.equ SWI_EXIT, 0x11
	ReadN: .word 0

_main:

	MOV R0, #1                              
	LDR R1, =ARRAY_SIZE_STRING
	SWI SWI_STR

	LDR R0, =ReadN                        
	LDR R0, [R0]                             
	SWI SWI_INPUT
	LDR R9, =SIZE
	STR R0, [R9]
	
	MOV R0, #1                               
	LDR R1, =ARRAY_STRING
	SWI SWI_STR

	LDR R1, [R9]
	MOV R6, R1                               
	LDR R2, =ARRAY                           
LOOP_INPUT:                         
	LDR R0, =ReadN
	LDR R0, [R0]
	SWI SWI_INPUT
	STR R0, [R2], #4
	SUBS R6, R6, #1
	BGT LOOP_INPUT

	MOV R0, #1                              
	LDR R1, =KEY_STRING
	SWI SWI_STR

	LDR R0, =ReadN                        
	LDR R0, [R0]                            
	SWI SWI_INPUT
	MOV R3, R0                              
	LDR R0, =KEY
	STR R3, [R0]							

	LDR R9, =SIZE
	LDR R1, [R9]							
	LDR R2, =ARRAY							
	BL SEARCH                               
	LDR R5, =POSITION                                    
	MOV R9, R0                              
	STR R9, [R5]                            

	MOV R0, #1
	LDR R1, =POSITION_STRING               
	SWI SWI_STR
	MOV R0,#1
	MOV R1, R9                              
	SWI SWI_INT

	SWI SWI_EXIT

.text	
SEARCH:
	STMFD SP!,{R1,R2,R3,LR}                
	MOV R4, R1                             
	
LOOP_SEARCH: 
	LDR R9, [R2], #4                       
	CMP R9, R3                             
	BEQ STORE_POS                       
	SUBS R4, R4, #1                        
	BGT LOOP_SEARCH                    
    B EXIT                            

STORE_POS:                              
	SUB R0, R1, R4                         
	ADD R0, #1                             
	B GOTO_MAIN

EXIT:                                 
	MOV R0, #-1                            
GOTO_MAIN:
	LDMFD SP!,{R1,R2,R3,PC}                
