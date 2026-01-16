	
GAME_MAIN:

GAME_ANIMATE_MAIN:
	HALT							; wait for vsync (fired after bottom border, start of vblank)

	CALL	VBLANK_PERIOD_WORK		; 8 scanline * 224 = 1952 t-states (minus some for alignment timing)
	CALL	TOP_BORDER_RENDER_GAME	; timining-critical flipping of top border colours
	CALL	UPDATE_BORDER_BUFFER
	CALL 	USER_INPUT
; 	CALL 	SPRITE_RENDER
	JP		GAME_ANIMATE_MAIN

