	INCLUDE 	"rr_stack_render_data.asm"
	INCLUDE 	"rr_stack_render_macros.asm"



; caller has to save SP before calling
; and ensure return address (main loop) is on top of stack
; for the 'fake' return
STACK_RENDER_LOOP:		
	Stack_Row_Pixel	0	,	192		; buffer for loop

STACK_RENDER_JUST_SCROLL:
; hack border to see timings
	; PUSH 	AF
	; LD 		A, COL_BLK			
	; OUT		($FE), A		
	; POP		AF

	Stack_Row_Pixel	1	,	0
	Stack_Row_Pixel	2	,	1
	Stack_Row_Pixel	3	,	2
	Stack_Row_Pixel	4	,	3
	Stack_Row_Pixel	5	,	4
	Stack_Row_Pixel	6	,	5
	Stack_Row_Pixel	7	,	6
	Stack_Row_Pixel	8	,	7
	Stack_Row_Pixel	9	,	8
	Stack_Row_Pixel	10	,	9
	Stack_Row_Pixel	11	,	10
	Stack_Row_Pixel	12	,	11
	Stack_Row_Pixel	13	,	12
	Stack_Row_Pixel	14	,	13
	Stack_Row_Pixel	15	,	14
	Stack_Row_Pixel	16	,	15
	Stack_Row_Pixel	17	,	16
	Stack_Row_Pixel	18	,	17
	Stack_Row_Pixel	19	,	18
	Stack_Row_Pixel	20	,	19
	Stack_Row_Pixel	21	,	20
	Stack_Row_Pixel	22	,	21
	Stack_Row_Pixel	23	,	22
	Stack_Row_Pixel	24	,	23
	Stack_Row_Pixel	25	,	24
	Stack_Row_Pixel	26	,	25
	Stack_Row_Pixel	27	,	26
	Stack_Row_Pixel	28	,	27
	Stack_Row_Pixel	29	,	28
	Stack_Row_Pixel	30	,	29
	Stack_Row_Pixel	31	,	30
	Stack_Row_Pixel	32	,	31
	Stack_Row_Pixel	33	,	32
	Stack_Row_Pixel	34	,	33
	Stack_Row_Pixel	35	,	34
	Stack_Row_Pixel	36	,	35
	Stack_Row_Pixel	37	,	36
	Stack_Row_Pixel	38	,	37
	Stack_Row_Pixel	39	,	38
	Stack_Row_Pixel	40	,	39
	Stack_Row_Pixel	41	,	40
	Stack_Row_Pixel	42	,	41
	Stack_Row_Pixel	43	,	42
	Stack_Row_Pixel	44	,	43
	Stack_Row_Pixel	45	,	44
	Stack_Row_Pixel	46	,	45
	Stack_Row_Pixel	47	,	46
	Stack_Row_Pixel	48	,	47
	Stack_Row_Pixel	49	,	48
	Stack_Row_Pixel	50	,	49
	Stack_Row_Pixel	51	,	50
	Stack_Row_Pixel	52	,	51
	Stack_Row_Pixel	53	,	52
	Stack_Row_Pixel	54	,	53
	Stack_Row_Pixel	55	,	54
	Stack_Row_Pixel	56	,	55
	Stack_Row_Pixel	57	,	56
	Stack_Row_Pixel	58	,	57
	Stack_Row_Pixel	59	,	58
	Stack_Row_Pixel	60	,	59
	Stack_Row_Pixel	61	,	60
	Stack_Row_Pixel	62	,	61
	Stack_Row_Pixel	63	,	62
	Stack_Row_Pixel	64	,	63
	Stack_Row_Pixel	65	,	64
	Stack_Row_Pixel	66	,	65
	Stack_Row_Pixel	67	,	66
	Stack_Row_Pixel	68	,	67
	Stack_Row_Pixel	69	,	68
	Stack_Row_Pixel	70	,	69
	Stack_Row_Pixel	71	,	70
	Stack_Row_Pixel	72	,   71
	Stack_Row_Pixel	73	,	72
	Stack_Row_Pixel	74	,	73
	Stack_Row_Pixel	75	,	74
	Stack_Row_Pixel	76	,	75
	Stack_Row_Pixel	77	,	76
	Stack_Row_Pixel	78	,	77
	Stack_Row_Pixel	79	,	78
	Stack_Row_Pixel	80	,	79
	Stack_Row_Pixel	81	,	80
	Stack_Row_Pixel	82	,	81
	Stack_Row_Pixel	83	,	82
	Stack_Row_Pixel	84	,	83
	Stack_Row_Pixel	85	,	84
	Stack_Row_Pixel	86	,	85
	Stack_Row_Pixel	87	,	86
	Stack_Row_Pixel	88	,	87
	Stack_Row_Pixel	89	,	88
	Stack_Row_Pixel	90	,	89
	Stack_Row_Pixel	91	,	90
	Stack_Row_Pixel	92	,	91
	Stack_Row_Pixel	93	,	92
	Stack_Row_Pixel	94	,	93
	Stack_Row_Pixel	95	,	94
	Stack_Row_Pixel	96	,	95
	Stack_Row_Pixel	97	,	96
	Stack_Row_Pixel	98	,	97
	Stack_Row_Pixel	99	,	98
	Stack_Row_Pixel	100	,	99
	Stack_Row_Pixel	101	,	100
	Stack_Row_Pixel	102	,	101
	Stack_Row_Pixel	103	,	102
	Stack_Row_Pixel	104	,	103
	Stack_Row_Pixel	105	,	104
	Stack_Row_Pixel	106	,	105
	Stack_Row_Pixel	107	,	106
	Stack_Row_Pixel	108	,	107
	Stack_Row_Pixel	109	,	108
	Stack_Row_Pixel	110	,	109
	Stack_Row_Pixel	111	,	110
	Stack_Row_Pixel	112	,	111
	Stack_Row_Pixel	113	,	112
	Stack_Row_Pixel	114	,	113
	Stack_Row_Pixel	115	,	114
	Stack_Row_Pixel	116	,	115
	Stack_Row_Pixel	117	,	116
	Stack_Row_Pixel	118	,	117
	Stack_Row_Pixel	119	,	118
	Stack_Row_Pixel	120	,	119
	Stack_Row_Pixel	121	,	120
	Stack_Row_Pixel	122	,	121
	Stack_Row_Pixel	123	,	122
	Stack_Row_Pixel	124	,	123
	Stack_Row_Pixel	125	,	124
	Stack_Row_Pixel	126	,	125
	Stack_Row_Pixel	127	,	126
	Stack_Row_Pixel	128	,	127
	Stack_Row_Pixel	129	,	128
	Stack_Row_Pixel	130	,	129
	Stack_Row_Pixel	131	,	130
	Stack_Row_Pixel	132	,	131
	Stack_Row_Pixel	133	,	132
	Stack_Row_Pixel	134	,	133
	Stack_Row_Pixel	135	,	134
	Stack_Row_Pixel	136	,	135
	Stack_Row_Pixel	137	,	136
	Stack_Row_Pixel	138	,	137
	Stack_Row_Pixel	139	,	138
	Stack_Row_Pixel	140	,	139
	Stack_Row_Pixel	141	,	140
	Stack_Row_Pixel	142	,	141
	Stack_Row_Pixel	143	,	142
	Stack_Row_Pixel	144	,	143
	Stack_Row_Pixel	145	,	144
	Stack_Row_Pixel	146	,	145
	Stack_Row_Pixel	147	,	146
	Stack_Row_Pixel	148	,	147
	Stack_Row_Pixel	149	,	148
	Stack_Row_Pixel	150	,	149
	Stack_Row_Pixel	151	,	150
	Stack_Row_Pixel	152	,	151
	Stack_Row_Pixel	153	,	152
	Stack_Row_Pixel	154	,	153
	Stack_Row_Pixel	155	,	154
	Stack_Row_Pixel	156	,	155
	Stack_Row_Pixel	157	,	156
	Stack_Row_Pixel	158	,	157
	Stack_Row_Pixel	159	,	158
	Stack_Row_Pixel	160	,	159
	Stack_Row_Pixel	161	,	160
	Stack_Row_Pixel	162	,	161
	Stack_Row_Pixel	163	,	162
	Stack_Row_Pixel	164	,	163
	Stack_Row_Pixel	165	,	164
	Stack_Row_Pixel	166	,	165
	Stack_Row_Pixel	167	,	166
	Stack_Row_Pixel	168	,	167
	Stack_Row_Pixel	169	,	168
	Stack_Row_Pixel	170	,	169
	Stack_Row_Pixel	171	,	170
	Stack_Row_Pixel	172	,	171
	Stack_Row_Pixel	173	,	172
	Stack_Row_Pixel	174	,	173
	Stack_Row_Pixel	175	,	174
	Stack_Row_Pixel	176	,	175
	Stack_Row_Pixel	177	,	176
	Stack_Row_Pixel	178	,	177
	Stack_Row_Pixel	179	,	178
	Stack_Row_Pixel	180	,	179
	Stack_Row_Pixel	181	,	180
	Stack_Row_Pixel	182	,	181
	Stack_Row_Pixel	183	,	182
	Stack_Row_Pixel	184	,	183
	Stack_Row_Pixel	185	,	184
	Stack_Row_Pixel	186	,	185
	Stack_Row_Pixel	187	,	186
	Stack_Row_Pixel	188	,	187
	Stack_Row_Pixel	189	,	188
	Stack_Row_Pixel	190	,	189
	Stack_Row_Pixel	191	,	190
	
	Stack_Row_Pixel	192	,	191		; buffer
	Stack_Row_Pixel	193	,	192		; buffer
	Stack_Row_Pixel	194	,	193		; buffer
	Stack_Row_Pixel	195	,	194		; buffer
	Stack_Row_Pixel	196	,	195		; buffer
	Stack_Row_Pixel	197	,	196		; buffer
	Stack_Row_Pixel	198	,	197		; buffer
	Stack_Row_Pixel	199	,	198		; buffer

	Stack_Row_Pixel	200	,	199		; clears buffer with one simple trick :)

	; restore SP
	LD 			SP, (STACK_POINTER_BACKUP)		

; hack border to see timings
	; LD 		A, COL_YEL		
	; OUT		($FE), A		

	RET			; STACK_RENDER


STACK_RENDER_ATTRS:
	; store SP
	LD 			(STACK_POINTER_BACKUP)		, SP

	Stack_Row_Attr		1, 0
	Stack_Row_Attr		2, 1
	Stack_Row_Attr		3, 2
	Stack_Row_Attr		4, 3
	Stack_Row_Attr		5, 4
	Stack_Row_Attr		6, 5
	Stack_Row_Attr		7, 6
	Stack_Row_Attr		8, 7

	Stack_Row_Attr		9, 8
	Stack_Row_Attr		10, 9
	Stack_Row_Attr		11, 10
	Stack_Row_Attr		12, 11
	Stack_Row_Attr		13, 12
	Stack_Row_Attr		14, 13
	Stack_Row_Attr		15, 14
	Stack_Row_Attr		16, 15

	Stack_Row_Attr		17, 16
	Stack_Row_Attr		18, 17
	Stack_Row_Attr		19, 18
	Stack_Row_Attr		20, 19
	Stack_Row_Attr		21, 20
	Stack_Row_Attr		22, 21
	Stack_Row_Attr		23, 22

	Stack_Row_Attr		24, 23		; buffer
	Stack_Row_Attr		25, 24		; clear buffer with this one simple trick


	; restore SP
	LD 			SP, (STACK_POINTER_BACKUP)		

; hack border to see timings
	; LD 		A, COL_CYN
	; OUT		($FE), A		

	RET 						; STACK_RENDER_ATTRS

STACK_POINTER_BACKUP:
	DEFW 		0

