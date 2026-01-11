; character codes 
C_ENTER			= $0D
C_SPACE			= $20

; colours
COL_BLK			= $0            ; 000
COL_BLU			= $1            ; 001
COL_RED			= $2            ; 010
COL_MAG			= $3            ; 011
COL_GRN			= $4            ; 100
COL_CYN			= $5            ; 101
COL_YEL			= $6            ; 110
COL_WHT			= $7            ; 111

; f b ppp iii (flash, bright, paper, ink)

; ROM calls
ROM_CLS			= $0DAF					; cls and open Channel 2 
ROM_BORDER		= $229B					; set border to value in a
ROM_BEEPER      = $03B5                 ; hl pitch, de duration (based on pitch...)
                                        ; HL = Pitch = 437500 / Frequency – 30.125
                                        ; DE = Duration = Frequency * Seconds

; system vars
ATTR_START		= $5800
ATTR_END        = $5AFF
SCREEN_START	= $4000
ROM_CHARS		= $3D00					; pixels

