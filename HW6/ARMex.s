;Homework 6
;Drew Engberson

MAX_LEN EQU 100
	
	AREA	Homework6, CODE
	EXPORT	main
	ENTRY

main					
	MOV R7, #0
	LDR R2, =HCode
	MOV R3, #1
DaLoop
	LDRB R6, [R2, R3]
	CMP R6, #0
	BEQ IsZero
	CMP    R6, #1
	BNE    DoneErrDet
	EOR    R7, R7, R3
IsZero  
	ADD    R3, R3, #1
    B      DaLoop
DoneErrDet
	CMP    R7, #0x00
	BEQ    NoParityErr
	LDRB   R6, [R2, R7]
	CMP    R6, #'1'
	BEQ    IsEqual
	MOV    R6, #'1' 
	B      NotEqual
IsEqual       
	MOV    R6, #'0'
NotEqual       
	STRB   R6, [R2, R7]
NoParityErr 
	MOV    R3, #1
	LDR    R4, =SrcWord - 1
	MOV    R5, #1
	MOV    R8, #1
SecondLoop	
	LDRB   R6, [R2, R3]
	CMP    R6, #0x00
	BEQ    DoneSrcWord
	CMP    R3, R8
	BEQ    LogicalShift
	STRB   R6,  [R4, R5]
	ADD    R5, R5, #1
	B      SkipShift
LogicalShift
	LSL    R8, #1
SkipShift
	ADD    R3, R3, #1
	B      SecondLoop
DoneSrcWord
	MOV    R6, #0
	STRB   R6, [R4, R5]
	SVC	#0x11
	
	AREA	HomeworkNumber6, DATA, READWRITE
		
	EXPORT	adrHCode		;needed for displaying addr in command-window
	EXPORT  adrSrcWord

adrHCode      DCD HCode		;needed for displaying addr in command-window
adrSrcWord    DCD SrcWord
	
HCode    DCB "111111000001101"
SrcWord	 SPACE MAX_LEN

	ALIGN
	
	END
