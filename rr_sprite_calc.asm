

; if sprite has moved, update it
SPRITE_RENDER:
	LD 		A, (SPRITE_X_NEW)
	LD 		B, A
	LD 		A, (SPRITE_X)
	CP 		B
	RET 	Z			; return if no movement

	CALL 	SPRITE_XOR

	CALL 	SPRITE_FLIP
	CALL 	SPRITE_SHIFT

	LD 		A, (SPRITE_FACING_NEW)
	LD		(SPRITE_FACING), A		; update facing
	LD 		A, (SPRITE_X_NEW)
	LD		(SPRITE_X), A			; move to new position

	CALL 	SPRITE_XOR

	RET 							; SPRITE_RENDER

	MACRO Sprite_Flip_Row
	; flip first byte
	LD 		A, (HL) 				; get byte
	EXX 							; flip out HL and friends 
	LD 		HL, SPRITE_FLIP_LUT		; LUT
	LD 		D, 0
	LD 		E, A 					; DE is now index for offset
	ADD 	HL, DE					; HL points to flipped byte
	LD 		A, (HL) 				; A has flipped byte
	EXX 							; flip back to old HL and friends
	LD 		(HL), A 				; replace with flipped byte

	INC 	HL
	; flip second byte
	LD 		A, (HL) 				; get byte
	EXX 							; flip out HL and friends 
	LD 		HL, SPRITE_FLIP_LUT		; LUT
	LD 		D, 0
	LD 		E, A 					; DE is now index for offset
	ADD 	HL, DE					; HL points to flipped byte
	LD 		A, (HL) 				; A has flipped byte
	EXX 							; flip back to old HL and friends
	LD 		(HL), A 				; replace with flipped byte

	INC 	HL
	; flip 3rd byte
	LD 		A, (HL) 				; get byte
	EXX 							; flip out HL and friends 
	LD 		HL, SPRITE_FLIP_LUT		; LUT
	LD 		D, 0
	LD 		E, A 					; DE is now index for offset
	ADD 	HL, DE					; HL points to flipped byte
	LD 		A, (HL) 				; A has flipped byte
	EXX 							; flip back to old HL and friends
	LD 		(HL), A 				; replace with flipped byte

	; swap bytes 0 and 2
	LD 		D, A 					; D has 3rd byte
	DEC 	HL 
	DEC 	HL 						; HL points to 1st byte
	LD 		A, (HL)					; A has first byte
	LD 		E, A 					; E has first byte

	LD 		(HL), D					; first byte now has 3rd
	INC 	HL 	
	INC 	HL 						; HL points to 3rd byte

	LD 		(HL), E					; 3rd byte now has first

; HL points to 3rd byte 2 (right) of first row
.SPRITE_FLIP_CORRECT:
	; correct shift for SPRITE_X position (pixel offset)
	LD 		A, (SPRITE_X)
	AND 	%00000111				; 0-7 'offset' in A

	; don't need this CP, will fall through at end
	; CP  	0
	; JP 		Z, SPRITE_FLIP_CORRECT_0

	CP  	1
	JP 		Z, .SPRITE_FLIP_CORRECT_1

	CP  	2
	JP 		Z, .SPRITE_FLIP_CORRECT_2

	CP  	3
	JP 		Z, .SPRITE_FLIP_CORRECT_3

	CP  	4
	JP 		Z, .SPRITE_FLIP_CORRECT_4

	CP  	5
	JP 		Z, .SPRITE_FLIP_CORRECT_5

	CP  	6
	JP 		Z, .SPRITE_FLIP_CORRECT_6

	CP  	7
	JP 		Z, .SPRITE_FLIP_CORRECT_7

	; so it's 0, fall through to
.SPRITE_FLIP_CORRECT_0:
	DEC 	HL						; move to middle byte 1
	LD 		A, (HL)
	DEC 	HL 
	LD 		(HL), A 				; moved byte 1 to byte 0

	INC 	HL
	INC 	HL
	LD 		A, (HL)
	DEC 	HL 
	LD 		(HL), A 				; moved byte 2 to byte 1

	INC 	HL
	LD 		(HL), 0					; blank byte 2 / 3rd

	JP  	.SPRITE_FLIP_CORRECT_DONE

.SPRITE_FLIP_CORRECT_1:				; shift 6 left
; shift 2 left
	SLA 	(HL)					; shift 3rd byte left, 0 in bit0, leaving in carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry

	INC 	HL
	INC 	HL						; back to 3rd byte

	SLA 	(HL)					; shift 3rd byte left, 0 in bit0, leaving in carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry

	INC 	HL
	INC 	HL						; back to 3rd byte

	; 1 falls through into...
.SPRITE_FLIP_CORRECT_2:				; shift 4 left
; RLD 4bit shift
									; HL already point to 3rd byte
	LD 		A, $00 					; blank out on right of right, A has $WX 00
	RLD								; (HL) was $YZ us now $ZX (X from A)

									; A has shifted out value
	DEC 	HL 						; 2nd byte
	RLD 							; rotates second byte

									; A has shifted out value
	DEC 	HL 						; 1st byte
	RLD 							; rotates first byte

	INC 	HL 						
	INC 	HL 						; back to pointing at 3rd byte

	JP  	.SPRITE_FLIP_CORRECT_DONE

.SPRITE_FLIP_CORRECT_3:				; shift 2 left
	SLA 	(HL)					; shift 3rd byte left, 0 in bit0, leaving in carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry

	INC 	HL
	INC 	HL						; back to 3rd byte

	SLA 	(HL)					; shift 3rd byte left, 0 in bit0, leaving in carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry
	DEC 	HL 						; previous byte in buffer
	RL 		(HL)					; shift byte using carry for bit0, and leaving into carry

	INC 	HL
	INC 	HL						; back to 3rd byte

	JP  	.SPRITE_FLIP_CORRECT_DONE

.SPRITE_FLIP_CORRECT_4:
; we're good at half way, no change needed
	JP  	.SPRITE_FLIP_CORRECT_DONE

.SPRITE_FLIP_CORRECT_5:				; shift right 2
	DEC 	HL 						; 
	DEC 	HL						; move to 1st byte

	SRL 	(HL)					; shift first byte right, 0 in bit7, leaving in carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry

	DEC 	HL 						; 
	DEC 	HL						; move to 1st byte

	SRL 	(HL)					; shift first byte right, 0 in bit7, leaving in carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry

	JP  	.SPRITE_FLIP_CORRECT_DONE

.SPRITE_FLIP_CORRECT_7:				; shift right 6
; shift 2 right
	DEC 	HL 						; 
	DEC 	HL						; move to 1st byte

	SRL 	(HL)					; shift first byte right, 0 in bit7, leaving in carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry

	DEC 	HL 						; 
	DEC 	HL						; move to 1st byte

	SRL 	(HL)					; shift first byte right, 0 in bit7, leaving in carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry
	INC 	HL 						; next byte in buffer
	RR 		(HL)					; shift byte using carry for bit7, and leaving into carry

	; 7 fall through into...
.SPRITE_FLIP_CORRECT_6:				; shift right 4
; 4bit RRD shift
	DEC 	HL 						; 
	DEC 	HL						; move to 1st byte

	LD 		A, $00 					; blank out, A has $WX 00
	RRD								; (HL) was $YZ us now $XY (X from A)

									; A has shifted out value
	INC 	HL 						; 2nd byte
	RRD 							; rotates second byte

									; A has shifted out value
	INC 	HL 						; 3rd
	RRD 							; rotates 3rd byte

	; falls into...
.SPRITE_FLIP_CORRECT_DONE:
	INC 	HL						; next row
	DEC 	B

	ENDM



SPRITE_FLIP:
	LD 		A, (SPRITE_FACING_NEW)	
	LD 		B, A 					; store new facing in B
	LD 		A, (SPRITE_FACING)
	CP 		B 						; has direction changed?
	RET 	Z						; no - so we're done

	LD 		HL, SPRITE_ROW_BUFFER	; start of buffer

	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row

	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row

	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row
	Sprite_Flip_Row

	Sprite_Flip_Row
	Sprite_Flip_Row


	RET 							; SPRITE_FLIP


	MACRO 	Sprite_Shift_Right
		SRL 	(HL)					; shift first byte right, 0 in bit7, leaving in carry
		INC 	HL 						; next byte in buffer
		RR 		(HL)					; shift byte using carry for bit7, and leaving into carry
		INC 	HL 						; next byte in buffer
		RR 		(HL)					; shift byte using carry for bit7, and leaving into carry
		INC 	HL 						; next byte in buffer for next loop
	ENDM

	MACRO Sprite_Shift_Byte_Right_7
		LD 		A, (HL)					; get byte on left
		INC 	HL 						; move right
		LD 		(HL), A					; write byte

		DEC 	HL 		
		DEC 	HL						; move to first byte

		LD 		A, (HL)					; get it
		INC 	HL 						; move forward
		LD 		(HL), A					; write

		DEC 	HL						; move to first byte again
		LD 		(HL), 0					; blank it

		INC 	HL
		INC 	HL						; back at right byte 2

		SLA 	(HL)					; shift 3rd byte left, 0 in bit0, leaving in carry
		DEC 	HL 						; previous byte in buffer
		RL 		(HL)					; shift byte using carry for bit0, and leaving into carry
		DEC 	HL 						; previous byte in buffer
		RL 		(HL)					; shift byte using carry for bit0, and leaving into carry

		INC 	HL 						; back to middle
		INC 	HL 						; back to right
		INC 	HL						; move to next row
		INC 	HL 						; move to middle byte
	ENDM

	MACRO Sprite_Shift_Left 
		INC 	HL
		INC 	HL						; shifting left, so start from the right
		SLA 	(HL)					; shift 3rd byte left, 0 in bit0, leaving in carry
		DEC 	HL 						; previous byte in buffer
		RL 		(HL)					; shift byte using carry for bit0, and leaving into carry
		DEC 	HL 						; previous byte in buffer
		RL 		(HL)					; shift byte using carry for bit0, and leaving into carry

		INC 	HL
		INC 	HL
		INC 	HL						; step to next row
	ENDM

	MACRO Sprite_Shift_Byte_Left_7
		SRL 	(HL)					; shift first byte right, 0 in bit7, leaving in carry
		INC 	HL 						; next byte in buffer
		RR 		(HL)					; shift byte using carry for bit7, and leaving into carry
		INC 	HL 						; next byte in buffer
		RR 		(HL)					; shift byte using carry for bit7, and leaving into carry

		DEC 	HL 						; back to middle byte

		LD 		A, (HL)					; get byte on right
		DEC 	HL 						; move left
		LD 		(HL), A					; write byte

		INC 	HL 		
		INC 	HL						; move to last byte

		LD 		A, (HL)					; get it
		DEC 	HL 						; move back
		LD 		(HL), A					; write

		INC 	HL						; move to last byte again
		LD 		(HL), 0					; blank it

		INC 	HL 						; next row
	ENDM


SPRITE_SHIFT:
	LD 		A, (SPRITE_X)			; current x
	AND 	%00000111				; get just 0-7 offset
	LD 		B, A 					; B has current offset

	LD 		A, (SPRITE_X_NEW)		; new x
	AND 	%00000111				; get just 0-7 offset

	SUB 	B 						; A = new A - old B
	RET 	Z 						; no change, return
	JP 		C, SPRITE_SHIFT_LEFT	; new A is < old B

SPRITE_SHIFT_RIGHT:					; new A is > old B
	CP 		7
	JP 		Z, SPRITE_SHIFT_BYTE_RIGHT_7

; only ever single shift, so we're just dong 32 unrolled shifts...
	LD 		HL, SPRITE_ROW_BUFFER	; start of buffer

; 32 rows
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right

	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right

	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right
	Sprite_Shift_Right

	Sprite_Shift_Right
	Sprite_Shift_Right

	RET								; SPRITE_SHIFT / SPRITE_SHIFT_RIGHT

SPRITE_SHIFT_BYTE_RIGHT_7:			; bytes right, then shift left 1
									; bytes right
	LD 		HL, SPRITE_ROW_BUFFER+1	; one to copy right

	; 32 rows
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7

	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7

	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7

	Sprite_Shift_Byte_Right_7
	Sprite_Shift_Byte_Right_7

	RET								; SPRITE_SHIFT / SPRITE_SHIFT_BYTE_RIGHT_7

SPRITE_SHIFT_LEFT:					; new A is < old B
	NEG								; A was negative
	CP 		7
	JP 		Z, SPRITE_SHIFT_BYTE_LEFT_7

; only ever single, so it's just 32 unrolled rows of shifting..
	LD 		HL, SPRITE_ROW_BUFFER	; start of buffer


	; 32 rows
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left

	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left

	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left
	Sprite_Shift_Left

	Sprite_Shift_Left
	Sprite_Shift_Left


	RET								; SPRITE_SHIFT / SPRITE_SHIFT_LEFT

SPRITE_SHIFT_BYTE_LEFT_7:			; shift right one, then bytes left
	LD 		HL, SPRITE_ROW_BUFFER	; start of buffer

	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	

	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	

	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	

	Sprite_Shift_Byte_Left_7	
	Sprite_Shift_Byte_Left_7	


	RET								; SPRITE_SHIFT / SPRITE_SHIFT_BYTE_LEFT_7

	MACRO Sprite_Xor
									; col 0
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in B
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		INC 	HL 					; col 1
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in B
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		INC 	HL 					; col 2
		LD 		A, (HL) 			; current pixels
		LD 		C, A 				; store in B
		LD 		A, (DE)				; sprite pixels
		XOR 	C 					; XOR together
		LD 		(HL), A 			; write result back
		INC 	DE					; next sprite byte

		DEC 	HL
		DEC 	HL					; back to first column ready to move to next row

	; inline version of Pixel_Address_Down from vector_output.asm
		INC 	H					; Go down onto the next pixel line
		LD 		A, H				; Check if we have gone onto next character boundary
		AND 	7
		JP 		NZ, .PIXEL_XOR_DONE ; No, so skip the next bit
		LD 		A, L				; Go onto the next character line
		ADD 	A, 32
		LD 		L, A
		JP	 	C, .PIXEL_XOR_DONE	; Check if we have gone onto next third of screen
		LD 		A, H				; Yes, so go onto next third
		SUB 	8
		LD 		H, A
.PIXEL_XOR_DONE:

	ENDM


SPRITE_XOR:
	LD		A, (SPRITE_Y)
	LD 		B, A 
	LD 		A, (SPRITE_X)
	LD 		C, A
	CALL 	Get_Pixel_Address ; HL now has screen address

	LD 		DE, SPRITE_ROW_BUFFER	; start of sprite buffer

; 32 rows
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor

	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor

	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor
	Sprite_Xor

	Sprite_Xor
	Sprite_Xor

	RET 						; SPRITE_XOR

SPRITE_MOVE_LEFT:
	LD 		A, (SPRITE_X_NEW)
	CP 		0 
	RET 	Z					; don't wrap

	DEC 	A 
	LD 		(SPRITE_X_NEW), A
	LD 		A, 0				; facing left
	LD 		(SPRITE_FACING_NEW), A
	RET							; SPRITE_MOVE_LEFT

SPRITE_MOVE_RIGHT:
	LD 		A, (SPRITE_X_NEW)
	CP 		239					; 255 - 16
	RET 	Z 					; don't wrap

	INC 	A 
	LD 		(SPRITE_X_NEW), A
	LD 		A, 1				; facing right
	LD 		(SPRITE_FACING_NEW), A
	RET							; SPRITE_MOVE_RIGHT

; draw initial sprite and any other setup
SPRITE_INIT:	
	CALL 	SPRITE_XOR			; make sure initial SPRITE_X is on byte boundary
	RET 						; SPRITE_INIT

SPRITE_X:
	DEFB 	64

; keys will control this new X
SPRITE_X_NEW:
	DEFB	64

; 0 left, 1 right
SPRITE_FACING:
	DEFB 	1
SPRITE_FACING_NEW:
	DEFB 	1

SPRITE_Y:
	DEFB 	100

; 3 blocks/bytes wide, sprite starts in left two only
; 4 blocks tall * 8 = 32 rows
SPRITE_ROW_BUFFER:
;SPRITE_ROW_0:
	DEFB 	%00000000, %00000000, %00000000
;SPRITE_ROW_1:
	DEFB 	%00000011, %11100000, %00000000
;SPRITE_ROW_2:
	DEFB 	%00000111, %11110000, %00000000
;SPRITE_ROW_3:
	DEFB 	%00001100, %00011000, %00000000
;SPRITE_ROW_4:
	DEFB 	%00011001, %01000100, %00000000
;SPRITE_ROW_5:
	DEFB 	%00011000, %00001100, %00000000
;SPRITE_ROW_6:
	DEFB 	%00011011, %01101100, %00000000
;SPRITE_ROW_7:
	DEFB 	%00011000, %00001100, %00000000
;SPRITE_ROW_8:
	DEFB 	%00011001, %01001100, %00000000
;SPRITE_ROW_9:
	DEFB 	%00011100, %00011100, %00000000
;SPRITE_ROW_10:
	DEFB 	%00001110, %00011000, %00000000
;SPRITE_ROW_11:
	DEFB 	%00001111, %00111000, %00000000
;SPRITE_ROW_12:
	DEFB 	%00000111, %11110000, %00000000
;SPRITE_ROW_13:
	DEFB 	%00000011, %11110000, %00000000
;SPRITE_ROW_14:
	DEFB 	%00000011, %11100000, %00000000
;SPRITE_ROW_15:
	DEFB 	%00000111, %11100000, %00000000
;SPRITE_ROW_16:
	DEFB 	%00001111, %11100000, %00000000
;SPRITE_ROW_17:
	DEFB 	%00001111, %11110000, %00000000
;SPRITE_ROW_18:
	DEFB 	%00001111, %11110000, %00000000
;SPRITE_ROW_19:
	DEFB 	%00001111, %11110000, %00000000
;SPRITE_ROW_20:
	DEFB 	%00001111, %11100000, %00000000
;SPRITE_ROW_21:
	DEFB 	%00001111, %11100000, %00000000
;SPRITE_ROW_22:
	DEFB 	%00001111, %11100000, %00000000
;SPRITE_ROW_23:
	DEFB 	%00001111, %11100000, %00000000
;SPRITE_ROW_24:
	DEFB 	%00001111, %11100000, %00000000
;SPRITE_ROW_25:
	DEFB 	%00011111, %11100000, %00000000
;SPRITE_ROW_26:
	DEFB 	%00011111, %11100000, %00000000
;SPRITE_ROW_27:
	DEFB 	%00011111, %11110000, %00000000
;SPRITE_ROW_28:
	DEFB 	%00011111, %11110000, %00000000
;SPRITE_ROW_29:
	DEFB 	%00111111, %11110000, %00000000
;SPRITE_ROW_30:
	DEFB 	%01111111, %11100000, %00000000
;SPRITE_ROW_31:
	DEFB 	%00000001, %11000000, %00000000

; index goes to flip version
; index 1 aka $00000001 looks up %00000001
SPRITE_FLIP_LUT:
	; 0-7
	DEFB	%00000000
	DEFB	%10000000
	DEFB	%01000000
	DEFB	%11000000
	DEFB	%00100000
	DEFB	%10100000
	DEFB	%01100000
	DEFB	%11100000

	; 8-15
	DEFB	%00010000
	DEFB	%10010000
	DEFB	%01010000
	DEFB	%11010000
	DEFB	%00110000
	DEFB	%10110000
	DEFB	%01110000
	DEFB	%11110000

	; 16-23
	DEFB	%00001000
	DEFB	%10001000
	DEFB	%01001000
	DEFB	%11001000
	DEFB	%00101000
	DEFB	%10101000
	DEFB	%01101000
	DEFB	%11101000

	; 24-31
	DEFB	%00011000
	DEFB	%10011000
	DEFB	%01011000
	DEFB	%11011000
	DEFB	%00111000
	DEFB	%10111000
	DEFB	%01111000
	DEFB	%11111000

	; 32-39
	DEFB	%00000100
	DEFB	%10000100
	DEFB	%01000100
	DEFB	%11000100
	DEFB	%00100100
	DEFB	%10100100
	DEFB	%01100100
	DEFB	%11100100

	; 40-47
	DEFB	%00010100
	DEFB	%10010100
	DEFB	%01010100
	DEFB	%11010100
	DEFB	%00110100
	DEFB	%10110100
	DEFB	%01110100
	DEFB	%11110100

	; 48-55
	DEFB	%00001100
	DEFB	%10001100
	DEFB	%01001100
	DEFB	%11001100
	DEFB	%00101100
	DEFB	%10101100
	DEFB	%01101100
	DEFB	%11101100

	; 56-63
	DEFB	%00011100
	DEFB	%10011100
	DEFB	%01011100
	DEFB	%11011100
	DEFB	%00111100
	DEFB	%10111100
	DEFB	%01111100
	DEFB	%11111100

	; 64-71
	DEFB	%00000010
	DEFB	%10000010
	DEFB	%01000010
	DEFB	%11000010
	DEFB	%00100010
	DEFB	%10100010
	DEFB	%01100010
	DEFB	%11100010

	; 72-79
	DEFB	%00010010
	DEFB	%10010010
	DEFB	%01010010
	DEFB	%11010010
	DEFB	%00110010
	DEFB	%10110010
	DEFB	%01110010
	DEFB	%11110010

	; 80-87
	DEFB	%00001010
	DEFB	%10001010
	DEFB	%01001010
	DEFB	%11001010
	DEFB	%00101010
	DEFB	%10101010
	DEFB	%01101010
	DEFB	%11101010

	; 88-95
	DEFB	%00011010
	DEFB	%10011010
	DEFB	%01011010
	DEFB	%11011010
	DEFB	%00111010
	DEFB	%10111010
	DEFB	%01111010
	DEFB	%11111010

	; 96-103
	DEFB	%00000110
	DEFB	%10000110
	DEFB	%01000110
	DEFB	%11000110
	DEFB	%00100110
	DEFB	%10100110
	DEFB	%01100110
	DEFB	%11100110

	; 104-111
	DEFB	%00010110
	DEFB	%10010110
	DEFB	%01010110
	DEFB	%11010110
	DEFB	%00110110
	DEFB	%10110110
	DEFB	%01110110
	DEFB	%11110110

	; 112-119
	DEFB	%00001110
	DEFB	%10001110
	DEFB	%01001110
	DEFB	%11001110
	DEFB	%00101110
	DEFB	%10101110
	DEFB	%01101110
	DEFB	%11101110

	; 119-127
	DEFB	%00011110
	DEFB	%10011110
	DEFB	%01011110
	DEFB	%11011110
	DEFB	%00111110
	DEFB	%10111110
	DEFB	%01111110
	DEFB	%11111110

	; 128-135
	DEFB	%00000001
	DEFB	%10000001
	DEFB	%01000001
	DEFB	%11000001
	DEFB	%00100001
	DEFB	%10100001
	DEFB	%01100001
	DEFB	%11100001

	; 136-143
	DEFB	%00010001
	DEFB	%10010001
	DEFB	%01010001
	DEFB	%11010001
	DEFB	%00110001
	DEFB	%10110001
	DEFB	%01110001
	DEFB	%11110001

	; 144-151
	DEFB	%00001001
	DEFB	%10001001
	DEFB	%01001001
	DEFB	%11001001
	DEFB	%00101001
	DEFB	%10101001
	DEFB	%01101001
	DEFB	%11101001

	; 152-159
	DEFB	%00011001
	DEFB	%10011001
	DEFB	%01011001
	DEFB	%11011001
	DEFB	%00111001
	DEFB	%10111001
	DEFB	%01111001
	DEFB	%11111001

	; 160-167
	DEFB	%00000101
	DEFB	%10000101
	DEFB	%01000101
	DEFB	%11000101
	DEFB	%00100101
	DEFB	%10100101
	DEFB	%01100101
	DEFB	%11100101

	; 168-175
	DEFB	%00010101
	DEFB	%10010101
	DEFB	%01010101
	DEFB	%11010101
	DEFB	%00110101
	DEFB	%10110101
	DEFB	%01110101
	DEFB	%11110101

	; 176-183
	DEFB	%00001101
	DEFB	%10001101
	DEFB	%01001101
	DEFB	%11001101
	DEFB	%00101101
	DEFB	%10101101
	DEFB	%01101101
	DEFB	%11101101

	; 184-191
	DEFB	%00011101
	DEFB	%10011101
	DEFB	%01011101
	DEFB	%11011101
	DEFB	%00111101
	DEFB	%10111101
	DEFB	%01111101
	DEFB	%11111101

	; 192-199
	DEFB	%00000011
	DEFB	%10000011
	DEFB	%01000011
	DEFB	%11000011
	DEFB	%00100011
	DEFB	%10100011
	DEFB	%01100011
	DEFB	%11100011

	; 200-207
	DEFB	%00010011
	DEFB	%10010011
	DEFB	%01010011
	DEFB	%11010011
	DEFB	%00110011
	DEFB	%10110011
	DEFB	%01110011
	DEFB	%11110011

	; 208-215
	DEFB	%00001011
	DEFB	%10001011
	DEFB	%01001011
	DEFB	%11001011
	DEFB	%00101011
	DEFB	%10101011
	DEFB	%01101011
	DEFB	%11101011

	; 216-223
	DEFB	%00011011
	DEFB	%10011011
	DEFB	%01011011
	DEFB	%11011011
	DEFB	%00111011
	DEFB	%10111011
	DEFB	%01111011
	DEFB	%11111011

	; 224-231
	DEFB	%00000111
	DEFB	%10000111
	DEFB	%01000111
	DEFB	%11000111
	DEFB	%00100111
	DEFB	%10100111
	DEFB	%01100111
	DEFB	%11100111

	; 232-239
	DEFB	%00010111
	DEFB	%10010111
	DEFB	%01010111
	DEFB	%11010111
	DEFB	%00110111
	DEFB	%10110111
	DEFB	%01110111
	DEFB	%11110111

	; 240-247
	DEFB	%00001111
	DEFB	%10001111
	DEFB	%01001111
	DEFB	%11001111
	DEFB	%00101111
	DEFB	%10101111
	DEFB	%01101111
	DEFB	%11101111

	; 248-255
	DEFB	%00011111
	DEFB	%10011111
	DEFB	%01011111
	DEFB	%11011111
	DEFB	%00111111
	DEFB	%10111111
	DEFB	%01111111
	DEFB	%11111111


