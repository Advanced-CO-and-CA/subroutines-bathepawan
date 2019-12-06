/******************************************************************************

* file: 6_part2.s

* Author: Pawan Bathe (CS18M519)

* TA: G S Nitesh Narayana

* Guide: Prof. Madhumutyam IITM, PACE

******************************************************************************/


/*
### Part 2
In the above problem, as the elements of the array are not in sorted order,
we have to search all the elements to find whether a given element is
present or not. Now, assume that the elements of the array are in sorted
order. Write an assembly language program that can efficiently search a
given element in the sorted array of elements. (Note that here we define the
efficiency in terms of the number of searches. )

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
	BL BINARY_SEARCH                               
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
BINARY_SEARCH:
	STMFD SP!,{R1,R2,R3,LR}            
	SUB R6, R1, #1                     
	MOV R5, #0						   
	MOV R4, #4
LOOP:
	ADD R7, R5, R6					   
	ASR R7, #1
	MLA R8, R7, R4, R2				   
	LDR R9, [R8]
	CMP R3, R9						   
	BEQ OUTPUT_POS				   
	BGT UPDATE_MIN			   
	B UPDATE_MAX				  
UPDATE_MIN:
	ADDGT R5, R7, #1
	CMP R6, R5
	BGE LOOP
UPDATE_MAX:
	SUB R6, R7, #1
	CMP R6, R5
	BGE LOOP
	B EXIT
	
OUTPUT_POS:                              
	ADD R0, R7, #1						
	B GOTO_MAIN

EXIT:                                 
	MOV R0, #-1         
GOTO_MAIN:
	LDMFD SP!,{R1,R2,R3,PC}
