



BANK_MOVE_BANKS:
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000011			; 0-3 

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, BANK_BANK_JUMP_TABLE_LEFT

	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump

BANK_MOVE_BANKS_LEFT_DONE:
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000011			; 0-3 

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		DE, BANK_BANK_JUMP_TABLE_RIGHT

	ADD 	HL, DE				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump

BANK_MOVE_BANKS_RIGHT_DONE:
	CALL 	BANK_RENDER_BANKS

	RET 						; BANK_MOVE_BANKS


BANK_INC_BANK_LEFT:
	LD 		A, (BANK_BANK_LEFT)
	CP 		16
	JP 		Z, BANK_MOVE_BANKS_LEFT_DONE	; max

	INC 	A
	LD 		(BANK_BANK_LEFT), A

	JP 		BANK_MOVE_BANKS_LEFT_DONE

BANK_DEC_BANK_LEFT:
	LD 		A, (BANK_BANK_LEFT)
	CP 		0
	JP 		Z, BANK_MOVE_BANKS_LEFT_DONE	; min

	DEC 	A
	LD 		(BANK_BANK_LEFT), A

	JP 		BANK_MOVE_BANKS_LEFT_DONE

BANK_INC_BANK_RIGHT:
	LD 		A, (BANK_BANK_RIGHT)
	CP 		16
	JP 		Z, BANK_MOVE_BANKS_RIGHT_DONE	; max

	INC 	A
	LD 		(BANK_BANK_RIGHT), A

	JP 		BANK_MOVE_BANKS_RIGHT_DONE

BANK_DEC_BANK_RIGHT:
	LD 		A, (BANK_BANK_RIGHT)
	CP 		0
	JP 		Z, BANK_MOVE_BANKS_RIGHT_DONE	; min

	DEC 	A
	LD 		(BANK_BANK_RIGHT), A

	JP 		BANK_MOVE_BANKS_RIGHT_DONE


BANK_RENDER_BANKS:
	LD 		A, (BANK_BANK_LEFT)				; 0-16

	CALL 	GET_16_PIXEL_BAR_LEFT			; Output: D = Left Byte, E = Right Byte

	; render left
	LD 		HL, SCREEN_BASE_191	+1			; leftmost bank
	LD 		(HL), D							; pixels

	INC 	HL								; inner left bank
	LD 		(HL), E							; pixels


	LD 		A, (BANK_BANK_RIGHT)			; 0-16

	CALL 	GET_16_PIXEL_BAR_RIGHT			; Output: D = Left Byte, E = Right Byte

	; render right
	LD 		HL, SCREEN_BASE_191 + 11		; inner right
	LD 		(HL), E							; pixels

	INC 	HL								; rightmost
	LD 		(HL), D							; pixels

	

	RET 						; BANK_RENDER_BANKS


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



BANK_BANK_LEFT:
	DEFB 	0

BANK_BANK_RIGHT:
	DEFB 	0


; jump tables
BANK_BANK_JUMP_TABLE_LEFT:
	DEFW 	BANK_INC_BANK_LEFT
	DEFW 	BANK_DEC_BANK_LEFT
	DEFW 	BANK_MOVE_BANKS_LEFT_DONE
	DEFW 	BANK_MOVE_BANKS_LEFT_DONE

BANK_BANK_JUMP_TABLE_RIGHT:
	DEFW 	BANK_INC_BANK_RIGHT
	DEFW 	BANK_DEC_BANK_RIGHT
	DEFW 	BANK_MOVE_BANKS_RIGHT_DONE
	DEFW 	BANK_MOVE_BANKS_RIGHT_DONE






; well this copy pasta from rr_game.asm is wasting memory but worry about that later...

; add Bank OBject :)
BANK_ADD_BOB:
	LD 		D, 0
	LD 		E, 0

	; which col
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000001			; 0-1

	CP 		0
	JP 		Z, BANK_ADD_COL_GOT
	; right bank
	LD 		E, 13

BANK_ADD_COL_GOT:

	; which ROB
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00001111			; 0-15

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		BC, BANK_ADD_BOB_JUMP_TABLE

	ADD 	HL, BC				; points to where to call

	LD 		A, (HL)				; low byt eof addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump


BANK_ADD_GRASS:
	; attr in buffer
	LD 		HL, ATTR_BASE_24
	ADD		HL, DE				
	LD 		(HL), %00001000		; black on blue

	; extra for scroll
	LD 		HL, ATTR_BASE_25
	ADD		HL, DE				
	LD 		(HL), %00001000		; black on blue

	LD 		BC, BANK_GRASS_PIXELS

	JP 		BANK_ADD_8x8_PIXELS

BANK_ADD_SIGN:
	; attr in buffer
	LD 		HL, ATTR_BASE_24
	ADD		HL, DE				
	LD 		(HL), %00001011		; red on blue

	; extra for scroll
	LD 		HL, ATTR_BASE_25
	ADD		HL, DE				
	LD 		(HL), %00001011		; red on blue

	LD 		BC, BANK_SIGN_PIXELS

	JP 		BANK_ADD_8x8_PIXELS

BANK_ADD_8x8_PIXELS:
	; row 0
	LD 		HL, SCREEN_BASE_192
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 1
	INC 	BC
	LD 		HL, SCREEN_BASE_193
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 2
	INC 	BC
	LD 		HL, SCREEN_BASE_194
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 3
	INC 	BC
	LD 		HL, SCREEN_BASE_195
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 4
	INC 	BC
	LD 		HL, SCREEN_BASE_196
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 5
	INC 	BC
	LD 		HL, SCREEN_BASE_197
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 6
	INC 	BC
	LD 		HL, SCREEN_BASE_198
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A

	; row 7
	INC 	BC
	LD 		HL, SCREEN_BASE_199
	ADD		HL, DE				; random bottom row
	LD 		A, (BC)
	LD 		(HL), A



	JP 		GAME_ADD_BOB_DONE


BANK_ADD_BLANK:
	JP 		GAME_ADD_BOB_DONE



; jump table
BANK_ADD_BOB_JUMP_TABLE:
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK

	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_SIGN	

BANK_GRASS_PIXELS:
	DEFB 	%00000000
	DEFB 	%00001000
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00010000

BANK_SIGN_PIXELS:
	DEFB 	%11111111
	DEFB 	%10000001
	DEFB 	%10101101
	DEFB	%10000001
	DEFB 	%11111111
	DEFB 	%00011000
	DEFB 	%00011000
	DEFB 	%00011000

