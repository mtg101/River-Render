


; this is now done split around stack render...
; SPRITE_RENDER:
; 	CALL 	SPRITE_XOR

; 	LD 		A, (SPRITE_X_NEW)
; 	LD		(SPRITE_X), A			; move to new position

; 	CALL 	SPRITE_XOR

; 	RET 							; SPRITE_RENDER


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




SPRITE_XOR_PREP:
	LD 		DE, SPRITE_ROW_BUFFER_LUT

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

	LD 		(SPRITE_FRAME_ADDR), DE


	LD		A, (SPRITE_Y)
	LD 		B, A 
	LD 		A, (SPRITE_X)
	LD 		C, A
	CALL 	Get_Pixel_Address 	; HL now has screen address

	LD 		(SPRITE_SCREEN_ADDR), HL

	RET 						; SPRITE_XOR_PREP



SPRITE_XOR_RENDER:
	LD 		HL, (SPRITE_SCREEN_ADDR)
	LD 		DE, (SPRITE_FRAME_ADDR)

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

	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor
	; Sprite_Xor

	; Sprite_Xor
	; Sprite_Xor

	RET 						; SPRITE_XOR_RENDER

SPRITE_MOVE_LEFT:
	LD 		A, (SPRITE_X_NEW)
	CP 		80								; 8 * 10 = 80
	RET	 	Z								; edge - SPRITE_MOVE_LEFT

	DEC 	A 
	LD 		(SPRITE_X_NEW), A
	RET										; SPRITE_MOVE_LEFT

SPRITE_MOVE_RIGHT:
	LD 		A, (SPRITE_X_NEW)
	CP 		159								; 255 - 80 from above - 16 width = 159
	RET	 	Z								; edge - SPRITE_MOVE_RIGHT

	INC 	A 
	LD 		(SPRITE_X_NEW), A
	RET										; SPRITE_MOVE_RIGHT


SPRITE_X:
	DEFB 	100

; keys will control this new X
SPRITE_X_NEW:
	DEFB	100

SPRITE_Y:
	DEFB 	4

SPRITE_SCREEN_ADDR:
	DEFW 	0

SPRITE_FRAME_ADDR:
	DEFW 	0

	INCLUDE "rr_sprite_prerender_pixels.asm"


