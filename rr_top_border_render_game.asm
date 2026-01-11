; timining-critical flipping of top border colours
; 224 t-states per row
TOP_BORDER_RENDER_GAME:		
	LD		C, $FE
	LD 		HL, TOP_BORDER_BUFFER_GAME

	LD 		B, 56		; 56 top border without contention
TOP_BORDER_RENDER_LOOP_GAME:	
	;11 cols
	LD 		A, B

	OUTI	
	OUTI	
	OUTI	
	OUTI	

	OUTI	
	OUTI	
	OUTI	
	OUTI	

	OUTI	
	OUTI	
	OUTI	


	; hblank & timing desu...
	.5 NOP
	LD  	B, A
	LD 		A, (HL)

	DJNZ    TOP_BORDER_RENDER_LOOP_GAME

	LD  	A, 4		; green
	OUT		($FE), A

	ret								; TOP_BORDER_RENDER


