





GAME_PROCGEN:
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00001111			; 1 in 16

	CALL 	Z, GAME_ADD_RAPIDS

	CALL 	GAME_MOVE_BANKS

	RET 						; GAME_PROCGEN

GAME_MOVE_BANKS:
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000011			; 0-3 

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, GAME_BANK_JUMP_TABLE_LEFT

	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump

GAME_MOVE_BANKS_LEFT_DONE:
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000011			; 0-3 

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, GAME_BANK_JUMP_TABLE_RIGHT

	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump

GAME_MOVE_BANKS_RIGHT_DONE:
	CALL 	GAME_RENDER_BANKS

	RET 						; GAME_MOVE_BANKS


GAME_INC_BANK_LEFT:
	LD 		A, (GAME_BANK_LEFT)
	CP 		16
	JP 		Z, GAME_MOVE_BANKS_LEFT_DONE	; max

	INC 	A
	LD 		(GAME_BANK_LEFT), A

	JP 		GAME_MOVE_BANKS_LEFT_DONE

GAME_DEC_BANK_LEFT:
	LD 		A, (GAME_BANK_LEFT)
	CP 		0
	JP 		Z, GAME_MOVE_BANKS_LEFT_DONE	; min

	DEC 	A
	LD 		(GAME_BANK_LEFT), A

	JP 		GAME_MOVE_BANKS_LEFT_DONE

GAME_INC_BANK_RIGHT:
	LD 		A, (GAME_BANK_RIGHT)
	CP 		16
	JP 		Z, GAME_MOVE_BANKS_RIGHT_DONE	; max

	INC 	A
	LD 		(GAME_BANK_RIGHT), A

	JP 		GAME_MOVE_BANKS_RIGHT_DONE

GAME_DEC_BANK_RIGHT:
	LD 		A, (GAME_BANK_RIGHT)
	CP 		0
	JP 		Z, GAME_MOVE_BANKS_RIGHT_DONE	; min

	DEC 	A
	LD 		(GAME_BANK_RIGHT), A

	JP 		GAME_MOVE_BANKS_RIGHT_DONE


GAME_RENDER_BANKS:
	LD 		A, (GAME_BANK_LEFT)				; 0-16

	CALL 	GET_16_PIXEL_BAR_LEFT			; Output: D = Left Byte, E = Right Byte

	; render left
	LD 		HL, SCREEN_BASE_191				; leftmost bank
	LD 		(HL), D							; pixels

	INC 	HL								; inner left bank
	LD 		(HL), E							; pixels


	LD 		A, (GAME_BANK_RIGHT)			; 0-16

	CALL 	GET_16_PIXEL_BAR_RIGHT			; Output: D = Left Byte, E = Right Byte

	; render right
	LD 		HL, SCREEN_BASE_191 + 12		; inner right
	LD 		(HL), E							; pixels

	INC 	HL								; rightmost
	LD 		(HL), D							; pixels

	

	RET 						; GAME_RENDER_BANKS


; Input: A = 0 to 16
; Output: D = Left Byte, E = Right Byte
GET_16_PIXEL_BAR_LEFT:
    CP 		9                ; Is the value 8 or less?
    JR 		NC, .more_than_8

    ; --- Case: Value is 0 to 8 ---
    LD 		E, $00		    ; Right byte is river on
    CALL 	GET_TABLE_VAL_LEFT  	; HL points to table value
    LD 		D, (HL)         ; Put result in Left byte
    RET

.more_than_8:
    ; --- Case: Value is 9 to 16 ---
    LD 		D, $FF  		; left byte is all bank off
    
    SUB 	8               ; Subtract the 8 pixels we put in the left byte
    CALL 	GET_TABLE_VAL_LEFT  	; HL points to remainder (1 to 8) for the right byte
	LD 		E, (HL)			; right byte
    RET

; Helper to find the byte in the table - HL points to it
GET_TABLE_VAL_LEFT:
    LD 		HL, BAR_TABLE_LEFT
    ADD 	A, L
    LD 		L, A
    RET 	NC
    INC 	H
    RET

BAR_TABLE_LEFT: 
	DEFB %00000000
	DEFB %10000000
	DEFB %11000000
	DEFB %11100000
	DEFB %11110000
	DEFB %11111000
	DEFB %11111100
	DEFB %11111110
	DEFB %11111111

; Input: A = 0 to 16
; Output: D = Left Byte, E = Right Byte
GET_16_PIXEL_BAR_RIGHT:
    CP 		9                ; Is the value 8 or less?
    JR 		NC, .more_than_8

    ; --- Case: Value is 0 to 8 ---
    LD 		E, $00		    ; Right byte is river on
    CALL 	GET_TABLE_VAL_RIGHT  	; HL points to table value
    LD 		D, (HL)         ; Put result in Left byte
    RET

.more_than_8:
    ; --- Case: Value is 9 to 16 ---
    LD 		D, $FF  		; left byte is all bank off
    
    SUB 	8               ; Subtract the 8 pixels we put in the left byte
    CALL 	GET_TABLE_VAL_RIGHT  	; HL points to remainder (1 to 8) for the right byte
	LD 		E, (HL)			; right byte
    RET

; Helper to find the byte in the table - HL points to it
GET_TABLE_VAL_RIGHT:
    LD 		HL, BAR_TABLE_RIGHT
    ADD 	A, L
    LD 		L, A
    RET 	NC
    INC 	H
    RET


BAR_TABLE_RIGHT: 
	DEFB %00000000
	DEFB %00000001
	DEFB %00000011
	DEFB %00000111
	DEFB %00001111
	DEFB %00011111
	DEFB %00111111
	DEFB %01111111
	DEFB %11111111



GAME_ADD_RAPIDS:
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

	LD 		D, 0
	LD 		E, A				; 0-7 in DE

    CALL  	RNG
    LD    	A, (NEXT_RNG)

	LD 		HL, SCREEN_BASE_191 + 2
	ADD		HL, DE				; random bottom row

	LD 		(HL), A				; random byte into random position

; attr hack test
;	LD 		HL, ATTR_BASE_23 + 2
;	ADD		HL, DE				; random bottom row
;	LD 		(HL), A				; random attr into random position



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


	RET 							; USER_INPUT


GAME_BANK_LEFT:
	DEFB 	0

GAME_BANK_RIGHT:
	DEFB 	0


; jump tables
GAME_BANK_JUMP_TABLE_LEFT:
	DEFW 	GAME_INC_BANK_LEFT
	DEFW 	GAME_DEC_BANK_LEFT
	DEFW 	GAME_MOVE_BANKS_LEFT_DONE
	DEFW 	GAME_MOVE_BANKS_LEFT_DONE

GAME_BANK_JUMP_TABLE_RIGHT:
	DEFW 	GAME_INC_BANK_RIGHT
	DEFW 	GAME_DEC_BANK_RIGHT
	DEFW 	GAME_MOVE_BANKS_RIGHT_DONE
	DEFW 	GAME_MOVE_BANKS_RIGHT_DONE

