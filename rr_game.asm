
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
	CALL 	GAME_TOP_RAPIDS_WHITE

	JP	 	GAME_ADD_ROBS

GAME_ADD_ROB_DONE:
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


; add River OBjects :)
GAME_ADD_ROBS:
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
	JP 		NZ, GAME_ADD_ROB_DONE	; skip if it clashes


	; which ROB
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00001111			; 0-15

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		BC, GAME_ADD_ROB_JUMP_TABLE

	ADD 	HL, BC				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump


GAME_ADD_FISH:
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

	JP 		GAME_ADD_8x8_PIXELS

GAME_ADD_ROCK:
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

	JP 		GAME_ADD_8x8_PIXELS

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

	JP 		GAME_ADD_ROB_DONE


GAME_ADD_BLANK:
	JP 		GAME_ADD_ROB_DONE


GAME_ADD_RAPIDS:
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

	JP 		GAME_ADD_ROB_DONE

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

; jump table
GAME_ADD_ROB_JUMP_TABLE:
	DEFW 	GAME_ADD_BLANK
	DEFW 	GAME_ADD_BLANK
	DEFW 	GAME_ADD_BLANK
	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_RAPIDS

	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_ROCK
	DEFW 	GAME_ADD_ROCK
	DEFW 	GAME_ADD_ROCK
	DEFW 	GAME_ADD_ROCK	
	DEFW 	GAME_ADD_ROCK
	DEFW 	GAME_ADD_FISH	


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

