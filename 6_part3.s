/******************************************************************************

* file: 6_part3.s

* Author: Pawan Bathe (CS18M519)

* TA: G S Nitesh Narayana

* Guide: Prof. Madhumutyam IITM, PACE

******************************************************************************/

/*
#### Part 3
Fibonacci number sequence is defined as 1, 1, 2, 3, 5, 8, 13, 21, ... A number
in the Fibonacci sequence is the sum of the immediate two previous
numbers, i.e., Fn = F{n-1}+F{n-2}, n>2. Note that F1 = F2 = 1. Write an assembly
language program that accepts an integer number, N, through keyboard and
computes the Nth Fibonacci number in recursive way.

For example:

|         |           |             |
|:-------:|:---------:|:-----------:|
|  Input: |   N       |   10        |
|  Output:|   F_N     |   55        |

*/
	.bss
	
	.data
	N: .word 0                   
	F_N: .word 1             

	INPUT_NUMBER: .asciz "Enter Number:\n"
	OUTPUT_STRING: .asciz "Fibonacci Number:\n"

	.equ SWI_STR, 0x69
	.equ SWI_INT, 0x6b
	.equ SWI_INPUT, 0x6c
	.equ SWI_EXIT, 0x11

.global _main
.text
	ReadN: .word 0

_main:

	MOV R0, #1                               
	LDR R1, =INPUT_NUMBER
	SWI SWI_STR

	LDR R0, =ReadN                         
	LDR R0, [R0]                             
	SWI SWI_INPUT
	LDR R6, =N
	STR R0, [R6]
	MOV R1, R0

	MOV R2, #1							
	MOV R3, #1
	MOV R6, #1
	CMP R1, #1
	BEQ PRINT_OUTPUT
	CMP R1, #2
	BEQ PRINT_OUTPUT
	MOV R5, #2							 
		
	BL LOOP_FIB                        

PRINT_OUTPUT:
	MOV R0, #1
	LDR R1, =OUTPUT_STRING       
	SWI SWI_STR
	MOV R0,#1
	MOV R1, R6                          
	SWI SWI_INT
	LDR R5, =F_N                                    
	STR R6, [R5]                        
	SWI SWI_EXIT

.text
LOOP_FIB:
	STMFD SP!,{R1,LR}            		
	ADD R5, R5, #1				
	ADD R6, R2, R3						
	MOV R2, R3							
	MOV R3, R6
	CMP R5, R1
	BEQ PRINT_OUTPUT
	BL LOOP_FIB
	LDMFD SP!,{R1,PC}            
