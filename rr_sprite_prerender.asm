

; if sprite has moved, update it
SPRITE_RENDER:
	LD 		A, (SPRITE_X_NEW)
	LD 		B, A
	LD 		A, (SPRITE_X)
	CP 		B
	RET 	Z			; return if no movement

	CALL 	SPRITE_XOR

	LD 		A, (SPRITE_FACING_NEW)
	LD		(SPRITE_FACING), A		; update facing
	LD 		A, (SPRITE_X_NEW)
	LD		(SPRITE_X), A			; move to new position

	CALL 	SPRITE_XOR

	RET 							; SPRITE_RENDER


	MACRO Sprite_Xor
									; col 0
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in B
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		INC 	HL 					; col 1
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in B
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		INC 	HL 					; col 2
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in B
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		DEC 	HL
		DEC 	HL					; back to first column ready to move to next row

	; inline version of Pixel_Address_Down from vector_output.asm
		INC 	H					; Go down onto the next pixel line
		LD 		A, H				; Check if we have gone onto next character boundary
		AND 	7
		JP 		NZ, .PIXEL_XOR_DONE ; No, so skip the next bit
		LD 		A, L				; Go onto the next character line
		ADD 	A, 32
		LD 		L, A
		JP	 	C, .PIXEL_XOR_DONE	; Check if we have gone onto next third of screen
		LD 		A, H				; Yes, so go onto next third
		SUB 	8
		LD 		H, A
.PIXEL_XOR_DONE:

	ENDM


SPRITE_XOR:
	LD 		A, (SPRITE_FACING)		; 0 left, 1 right
	CP 		0
	JP 		Z, SPRITE_XOR_LEFT

SPRITE_XOR_RIGHT: 	
	LD 		DE, SPRITE_ROW_BUFFER_LUT
	JP 		SPRITE_XOR_DONE_LR

SPRITE_XOR_LEFT: 	
	LD 		DE, SPRITE_ROW_BUFFER_FLIPPED_LUT
	JP 		SPRITE_XOR_DONE_LR

SPRITE_XOR_DONE_LR:
	LD		A, (SPRITE_X)
	AND 	%00000111			; 0-7 offset
	ADD 	A 					; 2 byte addresses
	LD 		H, 0
	LD 		L, A 
	ADD 	HL, DE				; HL points to address of sprite frame

	LD 		A, (HL)
	LD 		E, A
	INC 	HL
	LD 		A, (HL)
	LD 		D, A				; DE points to sprite frame

	LD		A, (SPRITE_Y)
	LD 		B, A 
	LD 		A, (SPRITE_X)
	LD 		C, A
	CALL 	Get_Pixel_Address ; HL now has screen address

; 32 rows
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor

	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor

	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor

	Sprite_Xor
	Sprite_Xor

	RET 						; SPRITE_XOR

SPRITE_MOVE_LEFT:
	LD 		A, 1					
	LD 		(USER_INPUT_ACTION), A	; something was pressed

	LD 		A, (SPRITE_X_NEW)
	CP 		0 
	JP	 	Z, SPRITE_MOVE_NO_WRAP_TIMING	; don't wrap

	DEC 	A 
	LD 		(SPRITE_X_NEW), A
	LD 		A, 0					; facing left
	LD 		(SPRITE_FACING_NEW), A
	RET								; SPRITE_MOVE_LEFT

SPRITE_MOVE_RIGHT:
	LD 		A, 1					
	LD 		(USER_INPUT_ACTION), A	; something was pressed

	LD 		A, (SPRITE_X_NEW)
	CP 		239						; 255 - 16
	JP	 	Z, SPRITE_MOVE_NO_WRAP_TIMING	; don't wrap

	INC 	A 
	LD 		(SPRITE_X_NEW), A
	LD 		A, 1					; facing right
	LD 		(SPRITE_FACING_NEW), A
	RET								; SPRITE_MOVE_RIGHT

SPRITE_MOVE_NO_WRAP_TIMING:			; #timing
	.3 NOP
	RET 							; SPRITE_MOVE_NO_WRAP_TIMING


; draw initial sprite and any other setup
SPRITE_INIT:	
	CALL 	SPRITE_XOR				; make sure initial SPRITE_X is on byte boundary
	RET 							; SPRITE_INIT

SPRITE_X:
	DEFB 	64

; keys will control this new X
SPRITE_X_NEW:
	DEFB	64

; 0 left, 1 right
SPRITE_FACING:
	DEFB 	1
SPRITE_FACING_NEW:
	DEFB 	1

SPRITE_Y:
	DEFB 	102

	INCLUDE "rr_sprite_prerender_pixels.asm"


