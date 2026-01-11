

MAIN_GAME_LOOP: 
	CALL	UPDATE_BORDER_BUFFER
	CALL 	USER_INPUT
	CALL 	SPRITE_RENDER
	RET


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