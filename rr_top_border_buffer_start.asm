
UPDATE_BORDER_BUFFER_START:
	CALL 	UPDATE_BORDER_BUFFER_START_SCROLL
	CALL 	UPDATE_BORDER_BUFFER_START_NEW_COL
;	RET 					; UPDATE_BORDER_BUFFER
	JP		START_ANIMATE_MAIN



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

; river width
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND		%00000110			; 0-3 * 2 for 16bit addr

	; jump table
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, RIVER_WIDTH_JUMP_TABLE
	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump
RIVER_WIDTH_DONE:


; top bank
    LD    	A, (NEXT_RNG)
	RRA 
	RRA 						; different bits from RNG
	AND		%00000110			; 0-3 * 2 for 16bit

	; jump table
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, TOP_BANK_WIDTH_JUMP_TABLE
	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump
TOP_BANK_WIDTH_DONE:


; bottom bank
	; what's left...
	LD 		A, (TOP_BANK_WIDTH)
	LD 		B, A				; top heigh in B
	LD 		A, (RIVER_WIDTH)
	ADD 	A, B				
	LD 		B, A 				; B now has top+river width

	LD 		A, 48				; 48 potential river rows
	SUB 	B 					; sub the top+river, leaving bottom width in A

	LD 		(BOTTOM_BANK_WIDTH), A	; store in mem

; all values updated ready to go...
	LD 		HL, TOP_BORDER_BUFFER_START_RIVER + 10	; first row right 11th col index 10
	LD 		DE, 11				; to step to next row

; top bank new col
	LD 		A, (TOP_BANK_WIDTH)
	CP 		0
	JP 		Z, TOP_BANK_NEW_DONE

	LD 		B, A
TOP_BANK_LOOP:
	LD		(HL), COL_GRN
	ADD 	HL, DE
	DJNZ	TOP_BANK_LOOP

TOP_BANK_NEW_DONE:

; river new col
	LD 		A, (RIVER_WIDTH)
	LD 		B, A
RIVER_LOOP:
	LD		(HL), COL_BLU
	ADD 	HL, DE
	DJNZ	RIVER_LOOP

; bottom bank new col
	LD 		A, (BOTTOM_BANK_WIDTH)
	CP    	0
	JP  	Z, BOTTOM_BANK_NEW_DONE

	LD 		B, A
BOTTOM_BANK_LOOP:
	LD		(HL), COL_GRN
	ADD 	HL, DE
	DJNZ	BOTTOM_BANK_LOOP

BOTTOM_BANK_NEW_DONE:

	RET 					; UPDATE_BORDER_BUFFER_START_NEW_COL


; inc river
RIVER_WIDTH_INC:
	LD 		A, (RIVER_WIDTH)
	CP 		48
	JP  	Z, RIVER_WIDTH_INC_DONE		; max 48

	INC 	A
	LD 		(RIVER_WIDTH), A			; inc and save

RIVER_WIDTH_INC_DONE:
	JP 		RIVER_WIDTH_DONE			; 'return'

; dec river
RIVER_WIDTH_DEC:
	LD 		A, (RIVER_WIDTH)
	CP 		12
	JP  	Z, RIVER_WIDTH_DEC_DONE		; min 12

	DEC 	A
	LD 		(RIVER_WIDTH), A			; inc and save

RIVER_WIDTH_DEC_DONE:
	JP 		RIVER_WIDTH_DONE			; 'return'

; inc top bank
TOP_BANK_WIDTH_INC:
	LD 		A, (TOP_BANK_WIDTH)
	INC 	A
	LD 		(TOP_BANK_WIDTH), A			; dec and save
	JP 		TOP_BANK_WIDTH_CHECK		; check top bank not too big before continuing to TOP_BANK_WIDTH_DONE

; dec top bank
TOP_BANK_WIDTH_DEC:
	LD 		A, (TOP_BANK_WIDTH)
	CP 		0 
	JP 		Z, TOP_BANK_WIDTH_DEC_DONE	; can't be less than 0

	DEC 	A
	LD 		(TOP_BANK_WIDTH), A			; dec and save

TOP_BANK_WIDTH_DEC_DONE:
	JP 		TOP_BANK_WIDTH_DONE			; 'return'

; check top bank
; river might force it to go smaller...
TOP_BANK_WIDTH_CHECK:
	LD 		A, (RIVER_WIDTH)
	LD 		B, A						; B is river width
	LD 		A, 48
	SUB 	B							; A is what's left after river width

	LD 		B, A 						; B is what's left after river width

	LD 		A, (TOP_BANK_WIDTH)
	LD 		C, A 						; C is top bank width

	LD 		A, B 						; A is what's left after river

	CP 		C 							; is what's left > top bank size?
	JP 		NC, TOP_BANK_WIDTH_CHECK_DONE

	LD 		(TOP_BANK_WIDTH), A 		; top bank is what's left

TOP_BANK_WIDTH_CHECK_DONE:
	JP 		TOP_BANK_WIDTH_DONE			; 'return'


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
TOP_BANK_WIDTH:
	DEFB 	0

RIVER_WIDTH:
	DEFB 	48

BOTTOM_BANK_WIDTH:
	DEFB 	0


; jump tables
RIVER_WIDTH_JUMP_TABLE:
	DEFW 	RIVER_WIDTH_DONE
	DEFW	RIVER_WIDTH_DONE
	DEFW	RIVER_WIDTH_INC
	DEFW 	RIVER_WIDTH_DEC

TOP_BANK_WIDTH_JUMP_TABLE:
	DEFW 	TOP_BANK_WIDTH_CHECK
	DEFW	TOP_BANK_WIDTH_CHECK
	DEFW	TOP_BANK_WIDTH_INC
	DEFW 	TOP_BANK_WIDTH_DEC


