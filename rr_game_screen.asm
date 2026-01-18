	
GAME_MAIN:
	CALL 	GAME_CLEAR_RIVER
	CALL 	SPRITE_XOR_PREP
	CALL 	SPRITE_XOR_RENDER			; show it initially

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

	JP 		GAME_ANIMATE_MAIN	

GAME_CLEAR_RIVER:
	; attrs blank
	LD 		A, %00001001			; blue on blue river
	LD 		C, %00100100			; green on green bank


	LD 		HL, ATTR_START + 9

	LD 		B, 24 					; 24 attr rows
	LD 		DE, 19					; 18 along, plus one to avoid an INC :)

GAME_CLEAR_RIVER_ATTR_LOOP:
	; LD 14 attrs
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

	ADD 	HL, DE

	DJNZ 	GAME_CLEAR_RIVER_ATTR_LOOP


	; pixels
	; get row 0 + 8 addr
	LD 		HL, SCREEN_START + 8

	LD 		B, 192 					; 24 pixel rows
	LD 		DE, 19					; 18 along, plus one to avoid an INC :)

GAME_CLEAR_RIVER_PIXEL_LOOP:
	; LD 14 pixel bytes
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
	LD 		C, %00001100			; green on blue bank


	LD 		HL, ATTR_START + 9

	LD 		B, 24 					; 24 attr rows
	LD 		DE, 19					; 18 along, plus one to avoid an INC :)

GAME_CLEAR_RIVER_ATTR_LOOP_REAL:
	; LD 14 attrs
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

	LD 		(HL), C
	INC 	HL
	LD 		(HL), C

	ADD 	HL, DE

	DJNZ 	GAME_CLEAR_RIVER_ATTR_LOOP_REAL

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
	LD 		HL, GAME_STACK_RENDER_DONE
	PUSH 	HL

	; preserve SP
	LD 		(STACK_POINTER_BACKUP), SP		

	JP	 	STACK_RENDER_JUST_SCROLL

GAME_STACK_RENDER_DONE:
	; get where old sprite will be after scroll
	LD 		A, (SPRITE_Y)
	DEC 	A
	LD 		(SPRITE_Y), A

	CALL 	SPRITE_XOR_PREP
	; xor sprite off
 	CALL 	SPRITE_XOR_RENDER

	; restore y
	LD 		A, (SPRITE_Y)
	INC 	A
	LD 		(SPRITE_Y), A

	; now for xor on...
 	LD 		A, (SPRITE_X_NEW)		
 	LD		(SPRITE_X), A			; move to new position

	CALL 	SPRITE_XOR_PREP			
	CALL 	SPRITE_XOR_RENDER		; xor on

	; hack border to see timings
	; LD 		A, COL_RED		
	; OUT		($FE), A		


	JP 		GAME_ANIMATE_MAIN




; jump table
GAME_JUMP_TABLE:
	DEFW 	USER_AND_BUFFER
	DEFW 	GAME_STACK_RENDER

; frame counter
GAME_FRAME:
	DEFB 	0

SPRITE_SCREEN_ADDR_OLD:
	DEFW 	0

SPRITE_FRAME_ADDR_OLD:
	DEFW 	0