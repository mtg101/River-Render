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
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND		%00001111			; 0-15
	INC 	A 					; don't want 0!

	LD 		B, A				; loop counter
	LD 		C, A				; store for bottom bank

	LD 		HL, TOP_BORDER_BUFFER_START_RIVER + 10	; first row right 11th col index 10
	LD 		DE, 11				; to step to next row
TOP_BANK_LOOP:
	LD		(HL), COL_GRN
	ADD 	HL, DE
	DJNZ	TOP_BANK_LOOP


	PUSH 	HL
	PUSH 	BC
    CALL  	RNG
	POP 	BC
	POP 	HL
    LD    	A, (NEXT_RNG)
	AND		%00011111			; 0-31
	INC 	A 					; can't be 0

	LD 		B, A				; loop counter

	ADD 	C					; top bank plus river
	LD 		C, A				; store for botom bank

RIVER_LOOP:
	LD		(HL), COL_BLU
	ADD 	HL, DE
	DJNZ	RIVER_LOOP


	LD 		A,  48				; total river rows
	SUB 	C 					; C is top bank plus river rows

	JP 		Z, RIVER_DONE

	LD 		B, A				; loop counter
BOTTOM_BANK_LOOP:
	LD		(HL), COL_GRN
	ADD 	HL, DE
	DJNZ	BOTTOM_BANK_LOOP

RIVER_DONE:
	RET 					; UPDATE_BORDER_BUFFER_START_NEW_COL