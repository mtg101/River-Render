

START_RESTART:
	CALL 	START_CLEAR_RIVER

START_MAIN:
	LD		A, 0
	LD		(PRINT_AT_Y), A
	LD		A, 10
	LD		(PRINT_AT_X), A
	LD		HL, START_PRINT_STRING

	CALL 	PRINT_HL_STRING_AT_Y_X

	LD 		A, (START_LAST_GAME_STAUS)
	CP 		0
	JP 		Z, START_ANIMATE_MAIN

	CP 		1
	JP 		Z, START_SHOW_LOST

; show win
	LD		A, 3
	LD		(PRINT_AT_Y), A
	LD		A, 12
	LD		(PRINT_AT_X), A
	LD		HL, START_WON_STRING

	CALL 	PRINT_HL_STRING_AT_Y_X

	JP 		START_SHOW_SCORE

START_SHOW_LOST:
	LD		A, 3
	LD		(PRINT_AT_Y), A
	LD		A, 12
	LD		(PRINT_AT_X), A
	LD		HL, START_DIED_STRING

	CALL 	PRINT_HL_STRING_AT_Y_X

START_SHOW_SCORE:
	LD		A, 6
	LD		(PRINT_AT_Y), A
	LD		A, 10
	LD		(PRINT_AT_X), A
	LD		HL, START_SCORE_STRING

	CALL 	PRINT_HL_STRING_AT_Y_X

	; left
	LD 		A, (BORDER_BUFFER_SCORE)
	AND 	%11110000	; left BCD
	SRL 	A
	SRL 	A
	SRL 	A
	SRL 	A			; shifted so just the number

	ADD		A, $30		; start of ASCII numbers

	LD 		(PRINT_CHAR), A
	LD		A, 6
	LD		(PRINT_AT_Y), A
	LD		A, 10+10
	LD		(PRINT_AT_X), A

	CALL 	PRINT_CHAR_AT_Y_X

	; right
	LD 		A, (BORDER_BUFFER_SCORE)
	AND 	%00001111		; right BCD

	ADD		A, $30		; start of ASCII numbers

	LD 		(PRINT_CHAR), A
	LD		A, 6
	LD		(PRINT_AT_Y), A
	LD		A, 10+11
	LD		(PRINT_AT_X), A

	CALL 	PRINT_CHAR_AT_Y_X

START_ANIMATE_MAIN:
	HALT							; wait for vsync (fired after bottom border, start of vblank)

	CALL	VBLANK_PERIOD_WORK		; 8 scanline * 224 = 1952 t-states (minus some for alignment timing)
	CALL	TOP_BORDER_RENDER_START	; timining-critical flipping of top border colours

	; check for space pressed
	LD		BC, $7FFE				; space to b (b in bit 4)
	IN		A, (C)					; read keys
	BIT		4, A					; b is bit 4 (1 means key not pressed, 0 pressed)
	JP		Z, GAME_MAIN			; go to the game...

	; boarder or screen scroll
    LD    	A, (START_FRAME)
	LD 		B, A				; store in B for incrementing later
	AND		%00000001			; 0-1

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, START_JUMP_TABLE
	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	INC 	B 
	LD 		A, B
	LD 		(START_FRAME), A 	; increment frame counter

	JP  	(HL)				; quick jump

;	JP		START_ANIMATE_MAIN


START_STACK_RENDER:
	; DIY for RET
	LD 		HL, START_ANIMATE_MAIN
	PUSH 	HL

	; preserve SP
	LD 		(STACK_POINTER_BACKUP), SP		

	JP	 	STACK_RENDER_LOOP
	; stack render will return to START_ANIMATE_MAIN


START_CLEAR_RIVER:
	; attrs blank
	LD 		A, %00001001			; blue on blue river
	LD 		C, %00100100			; green on green bank

	LD 		HL, ATTR_START + 9

	LD 		B, 24 					; 24 attr rows
	LD 		DE, 19					; 18 along, plus one to avoid an INC :)

START_CLEAR_RIVER_ATTR_LOOP:
	; LD 14 attrs
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

	ADD 	HL, DE

	DJNZ 	START_CLEAR_RIVER_ATTR_LOOP


	; pixels
	LD 		HL, SCREEN_START + 9

	LD 		A, 0

	LD 		B, 192 					; 24 pixel rows
	LD 		DE, 19					; 18 along, plus one to avoid an INC :)

START_CLEAR_RIVER_PIXEL_LOOP:
	; LD 14 pixel bytes
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

	LD 		(HL), A
	INC 	HL
	LD 		(HL), A

	ADD 	HL, DE

	DJNZ 	START_CLEAR_RIVER_PIXEL_LOOP

	; clear pixel buffers
	LD 		HL, RENDER_ROW_BUFFER
	LD 		B, 14*3						; 2*14 buffer size + magic buf
START_CLEAR_RIVER_PIXEL_BUFFER_LOOP:
	LD 		(HL), 0
	INC 	HL
	DJNZ	START_CLEAR_RIVER_PIXEL_BUFFER_LOOP

	; attrs correct
	LD 		A, %00001111			; white on blue river
;	LD 		C, %00100100			; green on green bank
	LD 		C, %00001111			; green on green bank

	LD 		HL, ATTR_START + 9

	LD 		B, 24 					; 24 attr rows
	LD 		DE, 19					; 18 along, plus one to avoid an INC :)

START_CLEAR_RIVER_ATTR_LOOP_REAL:
	; LD 14 attrs
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

	ADD 	HL, DE

	DJNZ 	START_CLEAR_RIVER_ATTR_LOOP_REAL

	; clear attr buffers
	LD 		HL, ATTR_ROW_BUFFER

	; 8 bytes first attr row
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

	; 8 bytes second attr row
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

	; 8 bytes third attr row
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

	RET 							; START_CLEAR_RIVER


; jump table
START_JUMP_TABLE:
	DEFW 	UPDATE_BORDER_BUFFER_START
	DEFW 	START_STACK_RENDER



; frame counter
START_FRAME:
	DEFB 	0

START_PRINT_STRING:
	DEFB	"B RIDES BOAT", 0

START_WON_STRING:
	DEFB	"WINNING!", 0

START_DIED_STRING:
	DEFB	"WASTED !", 0

START_SCORE_STRING:
	DEFB	"Distance: ", 0

START_LAST_GAME_STAUS:
	DEFB 	0 			; 0 new, 1 lost, 2 won