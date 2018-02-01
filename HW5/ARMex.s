;Homework 5
;Drew Engberson
;This program takes a 32-bit 2's complement number
;and converts it into a signed decimal string.

	
	AREA	Homework5, CODE
	EXPORT	main
	ENTRY

main					
	LDR R2, =HexStr		;Declaration of null-terminated string
	MOV R4, #0x0
	
ReadTwos
	LDRB R3, [R2], #1	;Loads first byte from HexStr into temp. register R3 and increments
	CMP  R3, #'0'		
	BLO  DoneRead
	CMP  R3, #'9'
	BLS  IsADigit
	CMP  R3, #'A'
	BLO  DoneRead
	CMP  R3, #'F'
	BHI  DoneRead
	SUB  R3, #'A'
	ADD  R3, #0xA
	B    ValidHexSym
	

IsADigit
	SUB R3, #'0'

;Makes a 4-bit space so the next piece of HexStr 
;can be stored in R4
ValidHexSym
	LSL R4, R4, #4
	ADD R4, R3
	B   ReadTwos

;Reads the twos complement number and checks to see if the
;first bit is a 1. If so, a negative sign is added to the beginning
;of the number. Otherwise, branch to IsPos
DoneRead 				
	LDR R3,= TwosComp
	STR R4, [R3]
	LDR R5,= RvsDecStr
	LDR R6,= DecStr
	TST R4, #0x80000000
	BEQ IsPos
	MOV R3, "-"
	STRB R3, [R6], #1
	MVN R4, R4
	ADD R4, #1

;Do-while loop which executes until
;our number is fully converted into decimal.
IsPos
	BL DivByTen
	ADD R7, #0
	STRB R7, [R5]
	ADD R5, #1
	CMP R4, #0x0
	BNE IsPos

;Do-while loop that reads reversed decimal number from R8 into R5
;and branches to DoneDecStr once it is completely read.
DoneRvsDecStr
	SUB R5, #1
	LDR R8,=RvsDecStr
	CMP R5, R8
	BLO DoneDecStr
	LDRB R3, [R5]
	SUB R5, #1
	STRB R3, [R6]
	ADD R6, #1
	B   DoneRvsDecStr


DoneDecStr
	MOV R3, #0x0
	STRB R3, [R6]
	
	MOV	R0, #0x18      ; angel_SWIreason_ReportException
	LDR	R1, =0x20026   ; ADP_Stopped_ApplicationExit
	SVC	#0x11	; previously SWI
	;BKPT #0xAB for semihosting isn't supported in Keil's uV

;END main routine
	
;Subroutine part A to convert our binary
;number into decimal.
DivByTen
	MOV R3, #0x0
	CMP R4, #0xA
	BLO DoneSubByTen
	SUB R4, #0xA
	ADD R3, #1
	B   DivByTen

;Subroutine part B to convert our binary
;number into decimal.
DoneSubByTen
	MOV R7, R4	;Remainder in R4 moves to R7
	MOV R4, R3	;Quotient in R3 moves to R4
	BX  LR
	
	ALIGN
	
	AREA	HomeworkNumber5, DATA, READWRITE
		
	EXPORT	adrHexStr		;needed for displaying addr in command-window
	EXPORT  adrTwosComp
	EXPORT  adrDecStr
	EXPORT  adrRvsDecStr

adrHexStr      DCD HexStr		;needed for displaying addr in command-window
adrTwosComp    DCD TwosComp
adrDecStr      DCD DecStr
adrRvsDecStr   DCD RvsDecStr
	
HexStr    DCB "12341234"	;Input
	ALIGN
TwosComp  DCD 0		;Output
	ALIGN
DecStr    SPACE 11		;Output
	ALIGN
RvsDecStr SPACE 12		;Output
	ALIGN
	
	END
