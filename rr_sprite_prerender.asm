


; this is now done split around stack render...
; SPRITE_RENDER:
; 	CALL 	SPRITE_XOR

; 	LD 		A, (SPRITE_X_NEW)
; 	LD		(SPRITE_X), A			; move to new position

; 	CALL 	SPRITE_XOR

; 	RET 							; SPRITE_RENDER


	MACRO Sprite_Xor	screen_addr	
		LD		HL, screen_addr
		LD 		BC, (SPRITE_X_BLOCK)
		ADD 	HL, BC

		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		INC 	HL 					; col 1
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		INC 	HL 					; col 2
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		DEC 	HL
		DEC 	HL					; back to first column ready to move to next row

	ENDM

SPRITE_XOR_RENDER_OFF:
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

	LD  	A, (SPRITE_X)
	SRL 	A
	SRL 	A
	SRL 	A					; pixels / 8 is bytes
	LD 		(SPRITE_X_BLOCK), A

	Sprite_Xor 	$4700

	Sprite_Xor 	$4020
	Sprite_Xor 	$4120
	Sprite_Xor 	$4220
	Sprite_Xor 	$4320
	Sprite_Xor 	$4420
	Sprite_Xor 	$4520
	Sprite_Xor 	$4620

	Sprite_Xor 	$4720

	Sprite_Xor 	$4040
	Sprite_Xor 	$4140
	Sprite_Xor 	$4240
	Sprite_Xor 	$4340
	Sprite_Xor 	$4440
	Sprite_Xor 	$4540
	Sprite_Xor 	$4640

	Sprite_Xor 	$4740
	Sprite_Xor 	$4060
	Sprite_Xor 	$4160
	Sprite_Xor 	$4260

	RET 						; SPRITE_XOR_RENDER_OFF

SPRITE_XOR_RENDER_ON:
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

	LD  	A, (SPRITE_X)
	SRL 	A
	SRL 	A
	SRL 	A					; pixels / 8 is bytes
	LD 		(SPRITE_X_BLOCK), A

	Sprite_Xor 	$4020
	Sprite_Xor 	$4120
	Sprite_Xor 	$4220
	Sprite_Xor 	$4320
	Sprite_Xor 	$4420
	Sprite_Xor 	$4520
	Sprite_Xor 	$4620
	Sprite_Xor 	$4720

	Sprite_Xor 	$4040
	Sprite_Xor 	$4140
	Sprite_Xor 	$4240
	Sprite_Xor 	$4340
	Sprite_Xor 	$4440
	Sprite_Xor 	$4540
	Sprite_Xor 	$4640
	Sprite_Xor 	$4740

	Sprite_Xor 	$4060
	Sprite_Xor 	$4160
	Sprite_Xor 	$4260
	Sprite_Xor 	$4360

	RET 						; SPRITE_XOR_RENDER_ON

SPRITE_MOVE_LEFT:
	LD 		A, (SPRITE_X_NEW)
	CP 		88								; 8 * 11 = 88
	RET	 	Z								; edge - SPRITE_MOVE_LEFT

	DEC 	A 
	LD 		(SPRITE_X_NEW), A
	RET										; SPRITE_MOVE_LEFT

SPRITE_MOVE_RIGHT:
	LD 		A, (SPRITE_X_NEW)
	CP 		152								; 255 - 88 from above - 16 width = 151 + 1
	RET	 	Z								; edge - SPRITE_MOVE_RIGHT

	INC 	A 
	LD 		(SPRITE_X_NEW), A
	RET										; SPRITE_MOVE_RIGHT


SPRITE_X:
	DEFB 	120

SPRITE_X_BLOCK:
	DEFW 	15

; keys will control this new X
SPRITE_X_NEW:
	DEFB	120

	INCLUDE "rr_sprite_prerender_pixels.asm"


