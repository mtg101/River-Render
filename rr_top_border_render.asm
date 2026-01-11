; timining-critical flipping of top border colours
; 224 t-states per row
TOP_BORDER_RENDER:		
	LD		C, $FE
	LD 		HL, TOP_BORDER_BUFFER

	LD 		B, 56		; 56 top border without contention
TOP_BORDER_RENDER_LOOP:	
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

	DJNZ    TOP_BORDER_RENDER_LOOP


	; LD B, 31 is annoying 7 t-states, and 4 for LD A, B
	; so have to do first horizon line by hand before loop

	; timings
	NOP

	; left
	OUTI	
	OUTI	

	; screen draw
	.28 NOP

	; right
	OUTI	
	OUTI	

	; hblank & timing desu...
	.7 NOP
	LD  	B, A
	LD 		A, (HL)

	LD 		B, 31		; either side of screen, with memory contention
TOP_BORDER_HORIZON_RENDER_LOOP:	
	;11 cols
	LD 		A, B

	; left
	OUTI	
	OUTI	

	; screen draw
	.28 NOP

	; right
	OUTI	
	OUTI	

	; hblank & timing desu...
	;.1 NOP
	LD  	B, A
	.3 LD 		A, (HL)
	

	DJNZ    TOP_BORDER_HORIZON_RENDER_LOOP:	

	LD  	A, 4		; green
	OUT		($FE), A

	ret								; TOP_BORDER_RENDER


