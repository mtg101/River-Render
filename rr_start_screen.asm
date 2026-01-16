	
START_MAIN:

START_ANIMATE_MAIN:
	HALT							; wait for vsync (fired after bottom border, start of vblank)

	CALL	VBLANK_PERIOD_WORK		; 8 scanline * 224 = 1952 t-states (minus some for alignment timing)
	CALL	TOP_BORDER_RENDER_START	; timining-critical flipping of top border colours

;	CALL	UPDATE_BORDER_BUFFER_START
;	CALL	STACK_RENDER

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



; jump table
START_JUMP_TABLE:
	DEFW 	UPDATE_BORDER_BUFFER_START
	DEFW 	STACK_RENDER

; frame counter
START_FRAME:
	DEFB 	0