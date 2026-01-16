
UPDATE_BORDER_BUFFER_START:
	CALL 	UPDATE_BORDER_BUFFER_START_SCROLL
	CALL 	UPDATE_BORDER_BUFFER_START_NEW_COL
	RET 					; UPDATE_BORDER_BUFFER


UPDATE_BORDER_BUFFER_START_SCROLL:
	; scroll everything left and we'll overwrite the right col later
	LD 		DE, TOP_BORDER_BUFFER_START_RIVER
	LD 		HL, TOP_BORDER_BUFFER_START_RIVER + 1

	LD 		B, 48
UPDATE_BORDER_BUFFER_START_SCROLL_LOOP:	
	PUSH 	BC
	.11 LDI
	POP 	BC
	DJNZ 	UPDATE_BORDER_BUFFER_START_SCROLL_LOOP

	RET 					; UPDATE_BORDER_BUFFER_START_SCROLL


UPDATE_BORDER_BUFFER_START_NEW_COL:

; top bank
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND		%00000011			; 0-3

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, TOP_BANK_JUMP_TABLE
	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump
TOP_BANK_DONE:


; bottom bank
    LD    	A, (NEXT_RNG)
	RRA 
	RRA 						; different bits from RNG
	AND		%00000011			; 0-3

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, BOTTOM_BANK_JUMP_TABLE
	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump
BOTTOM_BANK_DONE:


; river
	; cal from banks...
	LD 		A, (TOP_BANK_HEIGHT)
	LD 		B, A				; top heigh in B
	LD 		A, (BOTTOM_BANK_HEIGHT)
	ADD 	A, B				
	LD 		B, A 				; B now has top+bottom height

	LD 		A, 48				; 48 potential river rows
	SUB 	B 					; sub the banks, leaving river size in A

	LD 		(RIVER_HEIGHT), A	; store in mem

; all values updated ready to go...
	LD 		HL, TOP_BORDER_BUFFER_START_RIVER + 10	; first row right 11th col index 10
	LD 		DE, 11				; to step to next row

; top bank new col
	LD 		A, (TOP_BANK_HEIGHT)
	CP 		0
	JP 		Z, TOP_BANK_NEW_DONE

	LD 		B, A
TOP_BANK_LOOP:
	LD		(HL), COL_GRN
	ADD 	HL, DE
	DJNZ	TOP_BANK_LOOP

TOP_BANK_NEW_DONE:

; river new col
	LD 		A, (RIVER_HEIGHT)
	LD 		B, A
RIVER_LOOP:
	LD		(HL), COL_BLU
	ADD 	HL, DE
	DJNZ	RIVER_LOOP

; bottom bank new col
	LD 		A, (BOTTOM_BANK_HEIGHT)
	CP    	0
	JP  	Z, BOTTOM_BANK_NEW_DONE

	LD 		B, A
BOTTOM_BANK_LOOP:
	LD		(HL), COL_GRN
	ADD 	HL, DE
	DJNZ	BOTTOM_BANK_LOOP

BOTTOM_BANK_NEW_DONE:

	RET 					; UPDATE_BORDER_BUFFER_START_NEW_COL


; inc top, max 18
TOP_BANK_INC:
	LD 		A, (TOP_BANK_HEIGHT)
	CP 		18
	JP 		Z, TOP_BANK_INC_DONE

	INC 	A
	LD 		(TOP_BANK_HEIGHT), A
TOP_BANK_INC_DONE:
	JP 		TOP_BANK_DONE			; 'return'

; dec top, min 0
TOP_BANK_DEC:
	LD 		A, (TOP_BANK_HEIGHT)
	CP 		0
	JP 		Z, TOP_BANK_DEC_DONE	; can't go below 8

	DEC 	A
	LD 		(TOP_BANK_HEIGHT), A	; dec and store

TOP_BANK_DEC_DONE:
	JP 		TOP_BANK_DONE			; 'return'

; inc bottom, max 18
BOTTOM_BANK_INC:
	LD 		A, (BOTTOM_BANK_HEIGHT)
	CP  	18 
	JP 		Z, BOTTOM_BANK_INC_DONE

	INC 	A
	LD 		(BOTTOM_BANK_HEIGHT), A
BOTTOM_BANK_INC_DONE	
	JP 		BOTTOM_BANK_DONE		; 'return'

; dec bottom, min 0
BOTTOM_BANK_DEC:
	LD 		A, (BOTTOM_BANK_HEIGHT)
	CP 		0
	JP 		Z, BOTTOM_BANK_DEC_DONE	; can't go below 0

	DEC 	A
	LD 		(BOTTOM_BANK_HEIGHT), A ; dec and save


	LD 		(BOTTOM_BANK_HEIGHT), A

BOTTOM_BANK_DEC_DONE:
	JP 		BOTTOM_BANK_DONE		; 'return'




; 56 x 11
TOP_BORDER_BUFFER_START:
	DEFS 	11 * 4, COL_GRN	; top bank

TOP_BORDER_BUFFER_START_RIVER:
	DEFS 	11 * 8, COL_BLU	; river bank
	DEFS 	11 * 8, COL_BLU	; river bank
	DEFS 	11 * 8, COL_BLU	; river bank
	DEFS 	11 * 8, COL_BLU	; river bank
	DEFS 	11 * 8, COL_BLU	; river bank
	DEFS 	11 * 8, COL_BLU	; river bank

	DEFS 	11 * 4, COL_GRN	; bottom bank

; procgen vars
TOP_BANK_HEIGHT:
	DEFB 	0

BOTTOM_BANK_HEIGHT:
	DEFB 	0

RIVER_HEIGHT:
	DEFB 	0

; jump tables
TOP_BANK_JUMP_TABLE:
	DEFW 	TOP_BANK_DONE
	DEFW	TOP_BANK_DONE
	DEFW	TOP_BANK_INC
	DEFW 	TOP_BANK_DEC

BOTTOM_BANK_JUMP_TABLE:
	DEFW 	BOTTOM_BANK_DONE
	DEFW	BOTTOM_BANK_DONE
	DEFW	BOTTOM_BANK_INC
	DEFW 	BOTTOM_BANK_DEC

