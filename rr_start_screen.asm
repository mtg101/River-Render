	
START_MAIN:
	LD		A, 0
	LD		(PRINT_AT_Y), A
	LD		A, 12
	LD		(PRINT_AT_X), A
	LD		HL, START_PRINT_STRING

	CALL 	PRINT_HL_STRING_AT_Y_X


START_ANIMATE_MAIN:
	HALT							; wait for vsync (fired after bottom border, start of vblank)

	CALL	VBLANK_PERIOD_WORK		; 8 scanline * 224 = 1952 t-states (minus some for alignment timing)
	CALL	TOP_BORDER_RENDER_START	; timining-critical flipping of top border colours

	; check for space pressed
	LD		BC, $7FFE				; space to b (b in bit 4)
	IN		A, (C)					; read keys
	BIT		4, A					; b is bit 4 (1 means key not pressed, 0 pressed)
	JP		Z, GAME_MAIN			; go to the game...

	; boarder or screen scroll
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


START_STACK_RENDER:
	; DIY for RET
	LD 		HL, START_ANIMATE_MAIN
	PUSH 	HL

	; preserve SP
	LD 		(STACK_POINTER_BACKUP), SP		

	JP	 	STACK_RENDER_LOOP
	; stack render will return to START_ANIMATE_MAIN


; jump table
START_JUMP_TABLE:
	DEFW 	UPDATE_BORDER_BUFFER_START
	DEFW 	START_STACK_RENDER



; frame counter
START_FRAME:
	DEFB 	0

START_PRINT_STRING:
	DEFB	"B TO BOAT", 0