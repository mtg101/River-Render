
	INCLUDE		"rr_game_banks.asm"




GAME_PROCGEN:
	; banks always move
	CALL 	BANK_MOVE_BANKS

	; ev 8*2=16 frames... before stack does on 0, so %00001111
	LD 		A, (SCREEN_FRAME)
	AND 	%00001111
	CP 		%00001111
	JP 		NZ, GAME_NOT_ATTR_TIME

	CALL 	GAME_ROB_COUNTDOWN_SCOREBOARD_COUNTDOWN

	CALL 	GAME_ADD_RAPIDS
	CALL 	GAME_ADD_FISH
	CALL 	GAME_ADD_ROCK

	CALL 	GAME_ADD_RAPIDS
	CALL 	GAME_ADD_FISH
	CALL 	GAME_ADD_ROCK

	JP 		BANK_ADD_BOBS

GAME_ADD_BOB_DONE:

GAME_NOT_ATTR_TIME:

	RET 						; GAME_PROCGEN

GAME_ROB_COUNTDOWN_SCOREBOARD_COUNTDOWN:
	LD 		B, 8				; 8 cols
	LD 		HL, GAME_ROB_COUNTDOWN_SCOREBOARD
GAME_ROB_COUNTDOWN_SCOREBOARD_COUNTDOWN_LOOP:
	LD 		A, (HL)
	CP 		0					; skip if already zero
	JP 		Z, GAME_ROB_COUNTDOWN_SCOREBOARD_COUNTDOWN_LOOP_NEXT

	DEC 	A
	LD 		(HL), A

GAME_ROB_COUNTDOWN_SCOREBOARD_COUNTDOWN_LOOP_NEXT:
	INC 	HL
	DJNZ 	GAME_ROB_COUNTDOWN_SCOREBOARD_COUNTDOWN_LOOP


	RET 						; 	GAME_ROB_COUNTDOWN_SCOREBOARD_COUNTDOWN


GAME_ADD_FISH:
	; 1 in 32 chance
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00011111			; 0-31
	CP 		%00011111
	RET 	NZ					; 1 in 32

	; which col
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

	LD 		D, 0
	LD 		E, A				; 0-7 in DE

	; check not clashing with existing object
	LD 		HL, GAME_ROB_COUNTDOWN_SCOREBOARD
	ADD 	HL, DE
	LD 		A, (HL)
	CP 		0
	RET		NZ					; skip if it clashes

	; update scorboard
	LD 		HL, GAME_ROB_COUNTDOWN_SCOREBOARD
	ADD 	HL, DE
	LD 		(HL), 2				; double block

	; which colour fish
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-8
	CP 		0					; i in 8

	LD 		A, %00001000		; black on blue

	JP 		NZ, GAME_ADD_FISH_GOT_COLOUR

	LD 		A, %00001110		; yellow on blue

GAME_ADD_FISH_GOT_COLOUR:

	; attr in buffer
	LD 		HL, ATTR_BASE_24
	ADD		HL, DE				
	LD 		(HL), A

	; extra for scroll
	LD 		HL, ATTR_BASE_25
	ADD		HL, DE				
	LD 		(HL), A

	; which fish
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000011			; 0-3

	; LUT
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		BC, GAME_FISH_PIXELS_LUT

	ADD 	HL, BC				; points to where pixels are

	LD 		A, (HL)				; low byte of addr
	INC 	HL
	LD		B, (HL)				; high byte
	LD 		C, A				; BC now points to pixels

	CALL	GAME_ADD_8x8_PIXELS
	RET							; GAME_ADD_FISH


GAME_ADD_ROCK:
	; 1 in 8 chance
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7
	CP 		%00000111
	RET 	NZ					; 1 in 8

	; which col
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

	LD 		D, 0
	LD 		E, A				; 0-7 in DE

	; check not clashing with existing object
	LD 		HL, GAME_ROB_COUNTDOWN_SCOREBOARD
	ADD 	HL, DE
	LD 		A, (HL)
	CP 		0
	RET		NZ					; skip if it clashes

	; update scorboard
	LD 		HL, GAME_ROB_COUNTDOWN_SCOREBOARD
	ADD 	HL, DE
	LD 		(HL), 2				; double  block

	; which colour rock
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-8
	CP 		0					; i in 8

	LD 		A, %00001011		; mag on blue

	JP 		NZ, GAME_ADD_ROCK_GOT_COLOUR

	LD 		A, %00001010		; red on blue

GAME_ADD_ROCK_GOT_COLOUR:

	; attr in buffer
	LD 		HL, ATTR_BASE_24
	ADD		HL, DE				
	LD 		(HL), A

	; extra for scroll
	LD 		HL, ATTR_BASE_25
	ADD		HL, DE				
	LD 		(HL), A

	; which rock
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000011			; 0-3

	; LUT
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		BC, GAME_ROCK_PIXELS_LUT

	ADD 	HL, BC				; points to where pixels are

	LD 		A, (HL)				; low byte of addr
	INC 	HL
	LD		B, (HL)				; high byte
	LD 		C, A				; BC now points to pixels

	CALL	GAME_ADD_8x8_PIXELS
	RET							; GAME_ADD_ROCK

; DE is col offset, BC points to pixels
GAME_ADD_8x8_PIXELS:
	; row 0
	LD 		HL, SCREEN_BASE_192 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	; row 1
	INC 	BC
	LD 		HL, SCREEN_BASE_193 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	; row 2
	INC 	BC
	LD 		HL, SCREEN_BASE_194 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	; row 3
	INC 	BC
	LD 		HL, SCREEN_BASE_195 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	; row 4
	INC 	BC
	LD 		HL, SCREEN_BASE_196 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	; row 5
	INC 	BC
	LD 		HL, SCREEN_BASE_197 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	; row 6
	INC 	BC
	LD 		HL, SCREEN_BASE_198 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	; row 7
	INC 	BC
	LD 		HL, SCREEN_BASE_199 + 3
	ADD		HL, DE				
	LD 		A, (BC)
	LD 		(HL), A

	RET 						; GAME_ADD_8x8_PIXELS

GAME_ADD_RAPIDS:
	; 1 in 4 chance
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000011			; 0-3
	CP 		%00000011
	RET 	NZ					; 1 in 4

	; which col
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

	LD 		D, 0
	LD 		E, A				; 0-7 in DE

	; check not clashing with existing object
	LD 		HL, GAME_ROB_COUNTDOWN_SCOREBOARD
	ADD 	HL, DE
	LD 		A, (HL)
	CP 		0
	RET		NZ					; skip if it clashes

	; update scorboard
	LD 		HL, GAME_ROB_COUNTDOWN_SCOREBOARD
	ADD 	HL, DE
	LD 		(HL), 2				; bouble block

	; which colour rapid
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-8
	CP 		0					; i in 8

	LD 		A, %00001111		; white on blue

	JP 		NZ, GAME_ADD_RAPID_GOT_COLOUR

	LD 		A, %00001101		; cyan on blue

GAME_ADD_RAPID_GOT_COLOUR:

	; attr in buffer
	LD 		HL, ATTR_BASE_24
	ADD		HL, DE				
	LD 		(HL), A

	; extra for scroll
	LD 		HL, ATTR_BASE_25
	ADD		HL, DE				
	LD 		(HL), A

	; how many rows down
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

	; LUT
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		BC, SCREEN_BASE_BUFFER_LUT

	ADD 	HL, BC				; points to 

	LD 		A, (HL)				; low byte of addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now points to pixels

	ADD		HL, DE				; add random col

	PUSH 	HL					; RNG trashes HL
	; random byte for rapid
    CALL  	RNG
    LD    	A, (NEXT_RNG)		

	POP 	HL					; restore HL
	INC 	HL
	INC 	HL 
	INC 	HL 					; +3 river offset

	LD 		(HL), A				; random byte into random position

	RET 						; GAME_ADD_RAPIDS

; any cyan on blue attrs in the boat rows need to be white
GAME_TOP_RAPIDS_WHITE:
	; first boat row
	LD 		B, 8				; 8 attr cols
	LD 		HL, ATTR_BASE_4
GAME_TOP_RAPIDS_WHITE_LOOP:
	LD 		A, (HL)
	CP 		%00001101			; cyan on blue
	JP 		NZ, GAME_TOP_RAPIDS_WHITE_LOOP_DONE

	LD 		A, %00001111		; white on blue
	LD 		(HL), A

GAME_TOP_RAPIDS_WHITE_LOOP_DONE:
	INC 	HL
	DJNZ 	GAME_TOP_RAPIDS_WHITE_LOOP

	RET 						; GAME_TOP_RAPIDS_WHITE

GAME_ROCK_DAMAGE:
	; only 2 main rows count as damage...

	; get base sprite col
	LD		A, (SPRITE_X)
	SRL		A
	SRL     A
	SRL     A            		; pixels / 8 is bytes

	SUB 	12					; river starts 12 in

	LD		D, 0
	LD		E, A				; DE is col offset

	; top left
	LD 		HL, ATTR_BASE_2
	ADD		HL, DE				; HL points to an attr

	LD 		A, (HL)				; A has the ATTR
	CP 		%00001011			; mag on blue
	JP		Z, GAME_DAMAGE_TOP_LEFT
	CP 		%00001010			; red on blue
	JP		Z, GAME_DAMAGE_TOP_LEFT_X2
	JP		GAME_NO_DAMAGE_TOP_LEFT

GAME_DAMAGE_TOP_LEFT_X2:
	CALL 	BORDER_BUFFER_HEALTH_DEC
GAME_DAMAGE_TOP_LEFT:
	CALL 	BORDER_BUFFER_HEALTH_DEC

GAME_NO_DAMAGE_TOP_LEFT:
	INC 	HL
	LD 		A, (HL)				; A has the ATTR
	CP 		%00001011			; mag on blue

	JP		NZ, GAME_NO_DAMAGE_TOP_MID

	CALL 	BORDER_BUFFER_HEALTH_DEC

GAME_NO_DAMAGE_TOP_MID:
	LD		A, (SPRITE_X)
	AND 	%00000111
	CP 		0					; are we byte aliged?
	JP 		Z, GAME_NO_DAMAGE_TOP_RIGHT

	INC 	HL
	LD 		A, (HL)				; A has the ATTR
	CP 		%00001011			; mag on blue
	JP		Z, GAME_DAMAGE_TOP_RIGHT
	CP 		%00001010			; red on blue
	JP		Z, GAME_DAMAGE_TOP_RIGHT_X2
	JP		GAME_NO_DAMAGE_TOP_RIGHT

GAME_DAMAGE_TOP_RIGHT_X2:
	CALL 	BORDER_BUFFER_HEALTH_DEC
GAME_DAMAGE_TOP_RIGHT:
	CALL 	BORDER_BUFFER_HEALTH_DEC

GAME_NO_DAMAGE_TOP_RIGHT:
	; bot left
	LD 		HL, ATTR_BASE_3
	ADD		HL, DE				; HL points to an attr

	LD 		A, (HL)				; A has the ATTR
	CP 		%00001011			; mag on blue
	JP		Z, GAME_DAMAGE_BOT_LEFT
	CP 		%00001010			; red on blue
	JP		Z, GAME_DAMAGE_BOT_LEFT_X2
	JP		GAME_NO_DAMAGE_BOT_LEFT

GAME_DAMAGE_BOT_LEFT_X2:
	CALL 	BORDER_BUFFER_HEALTH_DEC
GAME_DAMAGE_BOT_LEFT:
	CALL 	BORDER_BUFFER_HEALTH_DEC

GAME_NO_DAMAGE_BOT_LEFT:
	INC 	HL
	LD 		A, (HL)				; A has the ATTR
	CP 		%00001011			; mag on blue
	JP		Z, GAME_DAMAGE_BOT_MID
	CP 		%00001010			; red on blue
	JP		Z, GAME_DAMAGE_BOT_MID_X2
	JP		GAME_NO_DAMAGE_BOT_MID

GAME_DAMAGE_BOT_MID_X2:
	CALL 	BORDER_BUFFER_HEALTH_DEC
GAME_DAMAGE_BOT_MID:
	CALL 	BORDER_BUFFER_HEALTH_DEC

GAME_NO_DAMAGE_BOT_MID:
	LD		A, (SPRITE_X)
	AND 	%00000111
	CP 		0					; are we byte aliged?
	JP 		Z, GAME_NO_DAMAGE_BOT_RIGHT

	INC 	HL
	LD 		A, (HL)				; A has the ATTR
	CP 		%00001011			; mag on blue
	JP		Z, GAME_DAMAGE_BOT_RIGHT
	CP 		%00001010			; red on blue
	JP		Z, GAME_DAMAGE_BOT_RIGHT_X2
	JP		GAME_NO_DAMAGE_BOT_RIGHT

GAME_DAMAGE_BOT_RIGHT_X2:
	CALL 	BORDER_BUFFER_HEALTH_DEC
GAME_DAMAGE_BOT_RIGHT:
	CALL 	BORDER_BUFFER_HEALTH_DEC

GAME_NO_DAMAGE_BOT_RIGHT:

	RET 						; GAME_ROCK_DAMAGE


GAME_CATCH_FISH:
	; get base sprite col
	LD		A, (SPRITE_X)
	SRL		A
	SRL     A
	SRL     A            		; pixels / 8 is bytes

	SUB 	12					; attr river starts 12 in

	LD		D, 0
	LD		E, A				; DE is col offset

	; mid/main left
	LD 		HL, ATTR_BASE_4
	ADD		HL, DE				; HL points to an attr

	LD 		A, (HL)				; A has the ATTR
	CP 		%00001000			; black on blue
	JP		Z, GAME_CATCH_FISH_MID_LEFT
	CP 		%00001110			; yellow on blue
	JP		Z, GAME_CATCH_FISH_MID_LEFT_X2
	JP		GAME_CATCH_FISH_NO_MID_LEFT

GAME_CATCH_FISH_MID_LEFT_X2:
	CALL 	BORDER_BUFFER_FISH_INC
GAME_CATCH_FISH_MID_LEFT:
	CALL 	BORDER_BUFFER_FISH_INC
	LD 		(HL), %00001111		; white on blue
	CALL 	GAME_CLEAR_FISH_PIXELS	

GAME_CATCH_FISH_NO_MID_LEFT:
	INC 	HL
	INC 	DE					; for fish pixel call
	LD 		A, (HL)				; A has the ATTR
	CP 		%00001000			; black on blue
	JP		Z, GAME_CATCH_FISH_MID_MID
	CP 		%00001110			; yellow on blue
	JP		Z, GAME_CATCH_FISH_MID_MID_X2
	JP		GAME_CATCH_FISH_NO_MID_MID

GAME_CATCH_FISH_MID_MID_X2:
	CALL 	BORDER_BUFFER_FISH_INC
GAME_CATCH_FISH_MID_MID:
	CALL 	BORDER_BUFFER_FISH_INC
	LD 		(HL), %00001111		; white on blue
	CALL 	GAME_CLEAR_FISH_PIXELS	

GAME_CATCH_FISH_NO_MID_MID:
	LD		A, (SPRITE_X)
	AND 	%00000111
	CP 		0					; are we byte aliged?
	JP 		Z, GAME_CATCH_FISH_NO_RIGHT_MID

	INC 	HL
	INC 	DE					; for fish pixel call
	LD 		A, (HL)				; A has the ATTR
	CP 		%00001000			; black on blue
	JP		Z, GAME_CATCH_FISH_RIGHT_MID
	CP 		%00001110			; yellow on blue
	JP		Z, GAME_CATCH_FISH_RIGHT_MID_X2
	JP		NZ, GAME_CATCH_FISH_NO_RIGHT_MID

GAME_CATCH_FISH_RIGHT_MID_X2:
	CALL 	BORDER_BUFFER_FISH_INC
GAME_CATCH_FISH_RIGHT_MID:
	CALL 	BORDER_BUFFER_FISH_INC
	LD 		(HL), %00001111		; white on blue
	CALL 	GAME_CLEAR_FISH_PIXELS	

GAME_CATCH_FISH_NO_RIGHT_MID:

	RET 						; GAME_CATCH_FISH


; DE is attr col offset, so +3 for river pixelsxz
GAME_CLEAR_FISH_PIXELS:
	PUSH 	HL

	; row 0
	LD 		HL, SCREEN_BASE_24 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	; row 1
	LD 		HL, SCREEN_BASE_25 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	; row 2
	LD 		HL, SCREEN_BASE_26 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	; row 3
	LD 		HL, SCREEN_BASE_27 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	; row 4
	LD 		HL, SCREEN_BASE_28 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	; row 5
	LD 		HL, SCREEN_BASE_29 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	; row 6
	LD 		HL, SCREEN_BASE_30 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	; row 7
	LD 		HL, SCREEN_BASE_31 + 3
	ADD		HL, DE				
	LD 		(HL), 0

	POP 	HL

	RET 						; GAME_CLEAR_FISH


GAME_FISH_PIXELS_LUT:
	DEFW 	GAME_FISH_PIXELS_1
	DEFW 	GAME_FISH_PIXELS_2
	DEFW 	GAME_FISH_PIXELS_3
	DEFW 	GAME_FISH_PIXELS_4

GAME_FISH_PIXELS_1:
	DEFB 	%00001000
	DEFB 	%00011100
	DEFB 	%00111100
	DEFB	%00111110
	DEFB 	%01111100
	DEFB 	%00111000
	DEFB 	%00011100
	DEFB 	%00001110

GAME_FISH_PIXELS_2:
	DEFB 	%00001000
	DEFB 	%00011100
	DEFB 	%00111100
	DEFB	%00111110
	DEFB 	%01111100
	DEFB 	%00111000
	DEFB 	%00011100
	DEFB 	%01110000

GAME_FISH_PIXELS_3:
	DEFB 	%00001111
	DEFB 	%00011100
	DEFB 	%00111100
	DEFB	%00111110
	DEFB 	%01111100
	DEFB 	%00111000
	DEFB 	%00011100
	DEFB 	%00001110

GAME_FISH_PIXELS_4:
	DEFB 	%11111000
	DEFB 	%00011100
	DEFB 	%00111100
	DEFB	%00111110
	DEFB 	%01111100
	DEFB 	%00111000
	DEFB 	%00011100
	DEFB 	%00001110

GAME_ROCK_PIXELS_LUT:
	DEFW 	GAME_ROCK_PIXELS_1
	DEFW 	GAME_ROCK_PIXELS_2
	DEFW 	GAME_ROCK_PIXELS_3
	DEFW 	GAME_ROCK_PIXELS_4

GAME_ROCK_PIXELS_1:
	DEFB 	%00000000
	DEFB 	%00111000
	DEFB 	%00111100
	DEFB	%01111110
	DEFB 	%01111110
	DEFB 	%00111110
	DEFB 	%00111000
	DEFB 	%00000000

GAME_ROCK_PIXELS_2:
	DEFB 	%00110000
	DEFB 	%00111000
	DEFB 	%00111100
	DEFB	%01111110
	DEFB 	%01111110
	DEFB 	%00111110
	DEFB 	%00111000
	DEFB 	%00000000

GAME_ROCK_PIXELS_3:
	DEFB 	%00000000
	DEFB 	%00111000
	DEFB 	%00111100
	DEFB	%01111110
	DEFB 	%01111110
	DEFB 	%00111110
	DEFB 	%00111111
	DEFB 	%00000000

GAME_ROCK_PIXELS_4:
	DEFB 	%00000000
	DEFB 	%00111000
	DEFB 	%00111100
	DEFB	%01111110
	DEFB 	%01111110
	DEFB 	%00111110
	DEFB 	%00111000
	DEFB 	%01111000


; countdown scoreboard for when can draw next
GAME_ROB_COUNTDOWN_SCOREBOARD:
	DEFS	8



; Address (Hex)	Binary (High Byte)	Bit 0	Bit 1	Bit 2	Bit 3	Bit 4
; $FEFE	1111 1110	SHIFT	Z	X	C	V
; $FDFE	1111 1101	A	S	D	F	G
; $FBFE	1111 1011	Q	W	E	R	T
; $F7FE	1111 0111	1	2	3	4	5
; $EFFE	1110 1111	0	9	8	7	6
; $DFFE	1101 1111	P	O	I	U	Y
; $BFFE	1011 1111	ENTER	L	K	J	H
; $7FFE	0111 1111	SPACE	SYM	M	N	B
USER_INPUT:
	LD 		BC, $FEFE				; SHIFT	Z	X	C	V
	IN 		A, (C)

	PUSH	AF
	BIT 	1, A 					; z
	CALL 	Z, SPRITE_MOVE_LEFT
	POP 	AF

	BIT 	2, A 					; x
	CALL 	Z, SPRITE_MOVE_RIGHT

	RET 							; USER_INPUT

