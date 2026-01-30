

	MACRO 		Stack_Row_Pixel	   src_num, tar_num							
																			
		; start of source row
		LD 			SP, SCREEN_BASE_src_num								
																	

		; pop from source to registers
		POP 		AF 												
		POP 		BC 													
		POP 		DE 												
		POP 		HL													
																			

		; flip to shadow registers
		EXX 															
;		EX AF															
																			
		; pop from source to shadow registers
;		POP 		AF 													
		POP 		BC 													
		POP 		DE 													
		POP 		HL													
																			

		; end of target row
		LD 			SP, SCREEN_END_tar_num								
																			

		; push from shadow registers to screen
		PUSH 		HL 													
		PUSH 		DE 													
		PUSH 		BC 													
;		PUSH 		AF 													
																			

		; flip back to regular registers
		EXX 															
;		EX AF															
																			

		; push from registers to screen
		PUSH 		HL 													
		PUSH 		DE 													
		PUSH 		BC 													
		PUSH 		AF 													
																			
	ENDM 

; only 8 cols here, to give us more time for pixel buffers
	MACRO 		Stack_Row_Attr	   asrc_num, atar_num							
		; start of source row
		LD 			SP, ATTR_BASE_asrc_num								
																	
		; pop from source to registers
		POP 		AF 												
		POP 		BC 													
		POP 		DE 												
		POP 		HL													

		; end of target row
		LD 			SP, ATTR_END_atar_num								

		; push from registers to screen
		PUSH 		HL 													
		PUSH 		DE 													
		PUSH 		BC 													
		PUSH 		AF 													
																			
	ENDM 

