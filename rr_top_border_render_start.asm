; timining-critical flipping of top border colours
; 224 t-states per row
TOP_BORDER_RENDER_START:		
	LD		C, $FE
	LD 		HL, TOP_BORDER_BUFFER_START

	LD 		B, 56		; 56 top border without contention
TOP_BORDER_RENDER_LOOP_START:	
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

	DJNZ    TOP_BORDER_RENDER_LOOP_START

	LD  	A, COL_GRN
	OUT		($FE), A

	RET								; TOP_BORDER_RENDER


