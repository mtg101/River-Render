	
GAME_MAIN:
	CALL 	GAME_CLEAR_RIVER

GAME_ANIMATE_MAIN:
	HALT							; wait for vsync (fired after bottom border, start of vblank)

	CALL	VBLANK_PERIOD_WORK		; 8 scanline * 224 = 1952 t-states (minus some for alignment timing)
	CALL	TOP_BORDER_RENDER_GAME	; timining-critical flipping of top border colours
	CALL	UPDATE_BORDER_BUFFER
	CALL 	USER_INPUT
; 	CALL 	SPRITE_RENDER
	JP		GAME_ANIMATE_MAIN


GAME_CLEAR_RIVER:

	; attrs blank
	LD 		A, %00001001			; blue on blue river
	LD 		C, %00100100			; green on green bank


	; get row 0 + 8 addr
	LD 		HL, ATTR_START + 8

	LD 		B, 24 					; 24 attr rows
	LD 		DE, 17					; 16 along, plus one to avoid an INC :)

GAME_CLEAR_RIVER_ATTR_LOOP:
	; LD 16 attrs
	LD 		(HL), C
	INC 	HL
	LD 		(HL), C
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), C
	INC 	HL
	LD 		(HL), C

	ADD 	HL, DE

	DJNZ 	GAME_CLEAR_RIVER_ATTR_LOOP


	; pixels
	; get row 0 + 8 addr
	LD 		HL, SCREEN_START + 8

	LD 		B, 192 					; 24 pixel rows
	LD 		DE, 17					; 16 along, plus one to avoid an INC :)

GAME_CLEAR_RIVER_PIXEL_LOOP:
	; LD 16 pixel bytes
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL

	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL

	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL

	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0
	INC 	HL
	LD 		(HL), 0

	ADD 	HL, DE

	DJNZ 	GAME_CLEAR_RIVER_PIXEL_LOOP

	; attrs correct
	LD 		A, %00001111			; white on blue river
	LD 		C, %00100001			; blue on green bank

	; get row 0 + 8 addr
	LD 		HL, ATTR_START + 8

	LD 		B, 21 					; 24 attr rows, 3 custom
	LD 		DE, 17					; 16 along, plus one to avoid an INC :)

GAME_CLEAR_RIVER_ATTR_LOOP_REAL:
	; LD 16 attrs
	LD 		(HL), C
	INC 	HL
	LD 		(HL), C
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), C
	INC 	HL
	LD 		(HL), C

	ADD 	HL, DE

	DJNZ 	GAME_CLEAR_RIVER_ATTR_LOOP_REAL

	; special rows
	LD 		B, %00000000			; black on black bridge (no loop)

	; 1/3
	; LD 16 attrs
	LD 		(HL), C
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), B
	INC 	HL

	LD 		(HL), B
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL
	LD 		(HL), A
	INC 	HL

	LD 		(HL), A
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), C

	ADD 	HL, DE

	; 2/3

	; LD 16 attrs
	LD 		(HL), C
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL

	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL

	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL

	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), C

	ADD 	HL, DE

	; 3/3

	; LD 16 attrs
	LD 		(HL), C
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL

	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL

	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL

	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), B
	INC 	HL
	LD 		(HL), C


	RET 							; GAME_CLEAR_RIVER


