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
	LDRB R3, [R2], #1	;Loads first byte from HexStr into TwosComp
	CMP  R3, #0		
	BLO  DoneRead		;Branches to DoneRead if TwosComp is full
	CMP  R3, #9
	BLS  IsADigit
	CMP  R3, #0xA
	BLO  DoneRead
	CMP  R3, #0xF
	BHI  DoneRead
	SUB  R3, #0xA
	ADD  R3, #0xA
	B    ValidHexSym
	
IsADigit
	SUB R3, #0
	
ValidHexSym
	LSL R4, R4, #4
	ADD R4, R3
	B   ReadTwos

DoneRead 				
	LDR R3,= TwosComp
	STR R4, [R3]
	LDR R5,= RvsDecStr
	LDR R6,= DecStr
	TST R4, #0x80000000
	BEQ IsPos
	MOV R3, #"-"
	STRB R3, [R6], #1
	MVN R4, R4
	ADD R4, #1
	
IsPos
	BL DivByTen
	ADD R7, #0
	STRB R7, [R5]
	ADD R5, #1
	CMP R4, #0x0
	BNE IsPos
	;B   DoneRvsDecStr


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
	
	;...
	;...
	SVC #0x11
	
; this is THE place for subroutine	
	
	
;Subroutine
DivByTen
	MOV R3, #0x0
	CMP R4, #0xA
	BLO DoneSubByTen
	SUB R4, #0xA
	ADD R3, #1
	B   DivByTen
; end of this piece


	;  subroutine 2nd piece
DoneSubByTen
	MOV R7, R4	;Remainder in R4 moves to R7
	MOV R4, R3	;Quotient in R3 moves to R4
	BX  LR
; end of 2nd piece
	
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
	
HexStr    DCB "0xA8F"
TwosComp  DCB "0"
DecStr    DCB "0"
RvsDecStr DCB "0"

	ALIGN
	
	END
