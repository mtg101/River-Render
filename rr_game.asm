





GAME_PROCGEN:
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00001111			; 1 in 16

	CALL 	Z, GAME_ADD_RAPIDS

	RET 						; GAME_PROCGEN


GAME_ADD_RAPIDS:
    CALL  	RNG
    LD    	A, (NEXT_RNG)





	LD L, A             ; Put random byte in L
    LD H, 0             ; HL = 0 to 255
    
    ; We want to do (HL * 12) / 256
    ; Multiplying by 12:
    ADD HL, HL          ; HL * 2
    ADD HL, HL          ; HL * 4
    LD D, H             ; Save (val * 4) in DE
    LD E, L
    ADD HL, HL          ; HL * 8
    ADD HL, DE          ; HL = (val * 8) + (val * 4) = val * 12

	; Dividing by 256 is just taking the High Byte (H)
    ; H now contains a value from 0 to 11.

	LD 		D, 0
	LD 		E, H				; 0-11 in DE

    CALL  	RNG
    LD    	A, (NEXT_RNG)

	LD 		HL, SCREEN_BASE_191 + 2
	ADD		HL, DE				; random bottom row

	LD 		(HL), A				; random byte into random position


	RET 						; GAME_ADD_RAPIDS




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
	LD 		A, 0
	LD 		(USER_INPUT_ACTION), A	; clear it

	LD 		BC, $FEFE				; SHIFT	Z	X	C	V
	IN 		A, (C)

	PUSH	AF
	BIT 	1, A 					; z
	CALL 	Z, BORDER_BUFFER_LIVES_DEC
	POP 	AF

	BIT 	2, A 					; z
	CALL 	Z, BORDER_BUFFER_LIVES_INC

	LD 		BC, $FBFE				; Q	W	E	R	T
	IN 		A, (C)

	PUSH	AF
	BIT 	1, A 					; w
	CALL 	Z, SPRITE_MOVE_RIGHT
	POP 	AF

	BIT 	0, A 					; q
	CALL 	Z, SPRITE_MOVE_LEFT

	LD 		BC, $DFFE				; P	O	I	U	Y
	IN 		A, (C)

	PUSH	AF
	BIT 	1, A 					; o
	CALL 	Z, BORDER_BUFFER_SCORE_INC
	POP 	AF

	BIT 	0, A 					; p
	CALL 	Z, BORDER_BUFFER_ENERGY_INC

	LD 		BC, $BFFE				; ENTER	L	K	J	H
	IN 		A, (C)

	PUSH	AF
	BIT 	2, A 					; k
	CALL 	Z, BORDER_BUFFER_SCORE_DEC
	POP 	AF

	BIT 	1, A 					; l
	CALL 	Z, BORDER_BUFFER_ENERGY_DEC

	LD 		A, (USER_INPUT_ACTION)
	CP 		0						
	CALL 	Z, MAIN_GAME_NO_ACTION	; nothing else done, so pad timing


	RET 							; USER_INPUT

; used to pad timings when nothing is pressed
USER_INPUT_ACTION:
	DEFB	0

; used to pad timing when nothing has been pressed
MAIN_GAME_NO_ACTION:				; #timing
	LD		B, 255
MAIN_GAME_NO_ACTION_LOOP:
	DJNZ	MAIN_GAME_NO_ACTION_LOOP

	; fiddling #timing
	.8 NOP
	RET 							; MAIN_GAME_NO_ACTION