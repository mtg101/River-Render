	
GAME_MAIN:
	CALL 	GAME_CLEAR_RIVER
	CALL 	SPRITE_XOR_RENDER_ON			; show it initially
	JP  	USER_AND_BUFFER

GAME_ANIMATE_MAIN:
	; update screen counter
	LD 		A, (SCREEN_FRAME)
	INC 	A
	LD 		(SCREEN_FRAME), A

	HALT							; wait for vsync (fired after bottom border, start of vblank)

	CALL	VBLANK_PERIOD_WORK		; 8 scanline * 224 = 1952 t-states (minus some for alignment timing)
	CALL	TOP_BORDER_RENDER_GAME	; timining-critical flipping of top border colours

	; boarder or screen scroll
    LD    	A, (SCREEN_FRAME)
	AND		%00000001			; 0-1

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, GAME_JUMP_TABLE
	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byte of addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump


; 	JP		GAME_ANIMATE_MAIN


USER_AND_BUFFER:
	CALL 	UPDATE_DISTANCE_SCORE
 	CALL	UPDATE_BORDER_BUFFER_GAME
 	CALL 	USER_INPUT
	CALL  	GAME_PROCGEN


	JP 		GAME_ANIMATE_MAIN	

UPDATE_DISTANCE_SCORE:
	LD 		A, (SCREEN_FRAME)
	AND 	%00111111
	CP 		%00111111
	RET 	NZ 						; only every 1 in 64

	CALL 	BORDER_BUFFER_SCORE_INC

	RET								; UPDATE_DISTANCE_SCORE


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
	; ev 8*2=16 frames... 
	LD 		A, (SCREEN_FRAME)
	AND 	%00001111
	CP 		0
	JP 		NZ, NOT_ATTR_TIME

	CALL 	STACK_RENDER_ATTRS		; no tricks just call
	CALL 	UPDATE_ATTR_SCOREBOARD	; countdown until can do next colour


NOT_ATTR_TIME:
 	CALL 	SPRITE_XOR_RENDER_OFF

 	LD 		A, (SPRITE_X_NEW)		
 	LD		(SPRITE_X), A			; move to new position

	CALL 	SPRITE_XOR_RENDER_ON

	; hack border to see timings
	; LD 		A, COL_WHT		
	; OUT		($FE), A		

	JP 		GAME_ANIMATE_MAIN




; jump table
GAME_JUMP_TABLE:
	DEFW 	GAME_STACK_RENDER
	DEFW 	USER_AND_BUFFER

; screen frame counter
SCREEN_FRAME:
	DEFB 	0

SPRITE_SCREEN_ADDR_OLD:
	DEFW 	0

SPRITE_FRAME_ADDR_OLD:
	DEFW 	0