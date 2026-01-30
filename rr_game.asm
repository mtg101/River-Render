
	INCLUDE		"rr_game_banks.asm"




GAME_PROCGEN:
	; banks always move
	CALL 	GAME_MOVE_BANKS

	; ev 8*2=16 frames... before stack does on 0, so %00001111
	LD 		A, (SCREEN_FRAME)
	AND 	%00001111
	CP 		%00001111
	JP 		NZ, GAME_NOT_ATTR_TIME

	JP	 	GAME_ADD_ROB

GAME_ADD_ROB_DONE:
GAME_NOT_ATTR_TIME:

	RET 						; GAME_PROCGEN


; add River OBject :)
GAME_ADD_ROB:
	; which col
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

	LD 		D, 0
	LD 		E, A				; 0-7 in DE

	; which ROB
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

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
	; attr in buffer
	LD 		HL, ATTR_BASE_24
	ADD		HL, DE				
	LD 		(HL), %00001000		; black on blue

	LD 		BC, GAME_FISH_PIXELS

	; row 0
	LD 		HL, SCREEN_BASE_192 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 1
	INC 	BC
	LD 		HL, SCREEN_BASE_193 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 2
	INC 	BC
	LD 		HL, SCREEN_BASE_194 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 3
	INC 	BC
	LD 		HL, SCREEN_BASE_195 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 4
	INC 	BC
	LD 		HL, SCREEN_BASE_196 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 5
	INC 	BC
	LD 		HL, SCREEN_BASE_197 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 6
	INC 	BC
	LD 		HL, SCREEN_BASE_198 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 7
	INC 	BC
	LD 		HL, SCREEN_BASE_199 + 3
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A



	JP 		GAME_ADD_ROB_DONE


GAME_ADD_BLANK:
	JP 		GAME_ADD_ROB_DONE


GAME_ADD_RAPIDS:
	; attr in buffer
	LD 		HL, ATTR_BASE_24
	ADD		HL, DE				
	LD 		(HL), %00001111		; white on blue

    CALL  	RNG
    LD    	A, (NEXT_RNG)

	LD 		HL, SCREEN_BASE_192 + 3
	ADD		HL, DE				; random bottom row
	LD 		(HL), A				; random byte into random position

	JP 		GAME_ADD_ROB_DONE


; jump table
GAME_ADD_ROB_JUMP_TABLE:
	DEFW 	GAME_ADD_BLANK
	DEFW 	GAME_ADD_BLANK
	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_RAPIDS
	DEFW 	GAME_ADD_FISH	
	DEFW 	GAME_ADD_FISH	
	DEFW 	GAME_ADD_FISH	
	DEFW 	GAME_ADD_FISH	

GAME_FISH_PIXELS:
	DEFB 	%00001000
	DEFB 	%00011100
	DEFB 	%00111100
	DEFB	%00111110
	DEFB 	%01111100
	DEFB 	%00111000
	DEFB 	%00011100
	DEFB 	%00001110

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
	LD 		BC, $FBFE				; Q	W	E	R	T
	IN 		A, (C)

	PUSH	AF
	BIT 	1, A 					; w
	CALL 	Z, SPRITE_MOVE_RIGHT
	POP 	AF

	BIT 	0, A 					; q
	CALL 	Z, SPRITE_MOVE_LEFT

	RET 							; USER_INPUT

