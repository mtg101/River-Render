



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
	LD 		HL, SCREEN_BASE_199	+1			; leftmost bank
	LD 		(HL), D							; pixels

	INC 	HL								; inner left bank
	LD 		(HL), E							; pixels


	LD 		A, (BANK_BANK_RIGHT)			; 0-16

	CALL 	GET_16_PIXEL_BAR_RIGHT			; Output: D = Left Byte, E = Right Byte

	; render right
	LD 		HL, SCREEN_BASE_199 + 11		; inner right
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

; add Bank OBjects :)
BANK_ADD_BOBS:
	; left bank
	LD 		DE, 0
	LD 		HL, BANK_LEFT_BANK_DONE	
	PUSH	HL					; 'fake' return address
	JP 		BANK_ADD_COL_GOT

BANK_LEFT_BANK_DONE:
	; right bank
	LD 		E, 13
	LD 		HL, BANK_RIGHT_BANK_DONE	
	PUSH	HL					; 'fake' return address
	JP 		BANK_ADD_COL_GOT

BANK_RIGHT_BANK_DONE:
	JP 		GAME_ADD_BOB_DONE	


BANK_ADD_COL_GOT:
	; which BOB
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00001111			; 0-15

	; jump table
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		BC, BANK_ADD_BOB_JUMP_TABLE

	ADD 	HL, BC				; points to where to call

	LD 		A, (HL)				; low byte of addr
	INC 	HL
	LD		H, (HL)				; high byte
	LD 		L, A				; HL now has dest addr

	JP  	(HL)				; quick jump



BANK_ADD_GRASS:
	; which grass
    CALL  	RNG
    LD    	A, (NEXT_RNG)
	AND 	%00000111			; 0-7

	; LUT
	RLCA 						; 16bit, so shift left to double
	LD 		H, 0
	LD		L, A				; offset in HL
	LD 		BC, BANK_GRASS_PIXELS_LUT

	ADD 	HL, BC				; points to where pixels are

	LD 		A, (HL)				; low byte of addr
	INC 	HL
	LD		B, (HL)				; high byte
	LD 		C, A				; BC now points to pixels

	CALL 	BANK_ADD_8x8_PIXELS
	RET 						; back to fake return

BANK_ADD_SIGN:
	LD 		BC, BANK_SIGN_PIXELS
	CALL	BANK_ADD_8x8_PIXELS
	RET 						; back to fake return


	; DE is pixels
	MACRO Line_Xor	col_offset
		LD		HL, SCREEN_BASE_192 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		LD		HL, SCREEN_BASE_193 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		LD		HL, SCREEN_BASE_194 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		LD		HL, SCREEN_BASE_195 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		LD		HL, SCREEN_BASE_196 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		LD		HL, SCREEN_BASE_197 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		LD		HL, SCREEN_BASE_198 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		LD		HL, SCREEN_BASE_199 + col_offset
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in C
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back

	ENDM


BANK_ADD_FISHER:
	LD 		BC, BANK_FISHER_LEFT_PIXELS
	LD 		A, E 				; col offset
	CP 		0					
	JP 		Z, BANK_ADD_FISHER_LEFT

	LD 		BC, BANK_FISHER_RIGHT_PIXELS

	; xor fishing lines right
	PUSH 	BC 
	PUSH 	DE 
	LD 		DE, BANK_LINE_RIGHT_RIGHT_PIXELS
	Line_Xor 	12
	LD 		DE, BANK_LINE_RIGHT_LEFT_PIXELS
	Line_Xor 	11
	POP 	DE 
	POP 	BC

	JP 			BANK_ADD_FISHER_DONE

BANK_ADD_FISHER_LEFT:
	PUSH 	BC 
	PUSH 	DE 
	; xor fishing lines left
	LD 		DE, BANK_LINE_LEFT_LEFT_PIXELS
	Line_Xor 	1
	LD 		DE, BANK_LINE_LEFT_RIGHT_PIXELS
	Line_Xor 	2
	POP 	DE 
	POP 	BC

BANK_ADD_FISHER_DONE:
	CALL 	BANK_ADD_8x8_PIXELS

	RET							; back to fake return

; DE contains row, BC points to pixels
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

	RET 						; BANK_ADD_8x8_PIXELS		

BANK_ADD_BLANK:
	RET 						; back to faked return



; jump table
BANK_ADD_BOB_JUMP_TABLE:
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_BLANK
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS

	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_GRASS
	DEFW 	BANK_ADD_FISHER
	DEFW 	BANK_ADD_SIGN	

BANK_SIGN_PIXELS:
	DEFB 	%11111111
	DEFB 	%10000001
	DEFB 	%10101101
	DEFB	%10000001
	DEFB 	%11111111
	DEFB 	%00011000
	DEFB 	%00011000
	DEFB 	%00011000

BANK_FISHER_LEFT_PIXELS:
	DEFB 	%00000001
	DEFB 	%01110010
	DEFB 	%01100100
	DEFB	%01101000
	DEFB 	%11110000
	DEFB 	%11110000
	DEFB 	%11110000
	DEFB 	%11110000

BANK_LINE_LEFT_LEFT_PIXELS:
	DEFB 	%10000000
	DEFB 	%00100000
	DEFB 	%00001000
	DEFB 	%00000010
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000

BANK_LINE_LEFT_RIGHT_PIXELS:
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%10000000
	DEFB 	%00100000
	DEFB 	%00001000
	DEFB 	%00000010

BANK_FISHER_RIGHT_PIXELS:
	DEFB 	%10000000
	DEFB 	%01001110
	DEFB 	%00100110
	DEFB	%00010110
	DEFB 	%00001111
	DEFB 	%00001111
	DEFB 	%00001111
	DEFB 	%00001111

BANK_LINE_RIGHT_RIGHT_PIXELS:
	DEFB 	%00000001
	DEFB 	%00000100
	DEFB 	%00010000
	DEFB 	%01000000
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000

BANK_LINE_RIGHT_LEFT_PIXELS:
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000000
	DEFB 	%00000001
	DEFB 	%00000100
	DEFB 	%00010000
	DEFB 	%01000000

BANK_GRASS_PIXELS_LUT:
	DEFW	BANK_GRASS_PIXELS_1
	DEFW	BANK_GRASS_PIXELS_2
	DEFW	BANK_GRASS_PIXELS_3
	DEFW	BANK_GRASS_PIXELS_4
	DEFW	BANK_GRASS_PIXELS_5
	DEFW	BANK_GRASS_PIXELS_6
	DEFW	BANK_GRASS_PIXELS_7
	DEFW	BANK_GRASS_PIXELS_8

BANK_GRASS_PIXELS_1:
	DEFB 	%00000000
	DEFB 	%00001000
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00010000

BANK_GRASS_PIXELS_2:
	DEFB 	%00000000
	DEFB 	%00001000
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00011110

BANK_GRASS_PIXELS_3:
	DEFB 	%00000100
	DEFB 	%00001000
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00111000

BANK_GRASS_PIXELS_4:
	DEFB 	%00000000
	DEFB 	%00101000
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00011100

BANK_GRASS_PIXELS_5:
	DEFB 	%00000001
	DEFB 	%00001010
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00011110

BANK_GRASS_PIXELS_6:
	DEFB 	%00000000
	DEFB 	%00011000
	DEFB 	%01000100
	DEFB 	%00110010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00011100

BANK_GRASS_PIXELS_7:
	DEFB 	%00000000
	DEFB 	%10000000
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00011000

BANK_GRASS_PIXELS_8:
	DEFB 	%00000000
	DEFB 	%10000011
	DEFB 	%01000100
	DEFB 	%00100010
	DEFB 	%00100100
	DEFB 	%00101000
	DEFB 	%00011000
	DEFB 	%00011100



