	
GAME_MAIN:
	CALL 	GAME_CLEAR_RIVER

GAME_ANIMATE_MAIN:
	HALT							; wait for vsync (fired after bottom border, start of vblank)

	CALL	VBLANK_PERIOD_WORK		; 8 scanline * 224 = 1952 t-states (minus some for alignment timing)
	CALL	TOP_BORDER_RENDER_GAME	; timining-critical flipping of top border colours


	; boarder or screen scroll
    LD    	A, (GAME_FRAME)
	LD 		B, A				; store in B for incrementing later
	AND		%00000001			; 0-1

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, GAME_JUMP_TABLE
	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	INC 	B 
	LD 		A, B
	LD 		(GAME_FRAME), A 	; increment frame counter

	JP  	(HL)				; quick jump


; 	JP		GAME_ANIMATE_MAIN


USER_AND_BUFFER:
 	CALL	UPDATE_BORDER_BUFFER_GAME
 	CALL 	USER_INPUT
	CALL  	GAME_PROCGEN
; 	CALL 	SPRITE_RENDER
	JP 		GAME_ANIMATE_MAIN	

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

	; clear buffer
	LD 		HL, RENDER_ROW_BUFFER

	; 16 bytes...
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


	RET 							; GAME_CLEAR_RIVER


GAME_STACK_RENDER:
	; DIY for RET
	LD 		HL, GAME_ANIMATE_MAIN
	PUSH 	HL

	; preserve SP
	LD 		(STACK_POINTER_BACKUP), SP		

	CALL 	STACK_RENDER_JUST_SCROLL
	; stack render will return to GAME_ANIMATE_MAIN


; jump table
GAME_JUMP_TABLE:
	DEFW 	USER_AND_BUFFER
	DEFW 	GAME_STACK_RENDER

; frame counter
GAME_FRAME:
	DEFB 	0