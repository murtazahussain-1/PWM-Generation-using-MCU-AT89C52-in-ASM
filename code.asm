	org 0000h	
	
	;P2.0 = RS
	;P2.1 = R / W
	;P2.2 = E
	;P3 = OUTPUT	
	;i am using scratch pad for temp variables 30h - 7fh
	
	jmp overthis
	
	ORG 000BH
	JMP T0ISR
	
	org 30h
overthis:
	
	;===============================================
LCDinitializer:
	mov a, #38h
	call CommandWriter
	mov a, #0Ch
	call CommandWriter
	mov a, #1h
	call CommandWriter
	;mov a, #06h
	;call CommandWriter
	mov a, #80h
	call CommandWriter
	;===============================================	
	
	; - - - - (Intro subroutine is called and our names and roll numbers are displayed for 5 seconds) - - - - 
	call INTRO
	call Delay5Seconds	
	
	;now we will ask the user to enter the frequency
checkpoint1:
	mov SP, #40h
	;MSB : 08H
	;LSB : 0BH
	
	;our new frequency will be in 0DH(upper byte) 0CH(lower byte)
	
	;clearing screen
	call screenclear	
	
	mov DPTR, #ENTER_FREQ
	call STRING_DISP
	mov a, #0C0h
	call CommandWriter
	; - - - - - - entering digits of frequency from keypad - - - - - - 
	
	
	
	;==========================================
inputdigit1:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', inputdigit1NOTHASH
	;hash has been pressed
	call inputdigit1
	
inputdigit1NOTHASH:
	mov 8h, r4
	mov a, 8h
	add a, #30h
	call DataWriter	
	
	;=================================
inputdigit2:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', inputdigit2NOTHASH
	;hash has been pressed
	call inputdigit2
	
inputdigit2NOTHASH:
	mov 9h, r4
	mov a, 9h
	add a, #30h
	call DataWriter	
	
	;=================================
inputdigit3:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', inputdigit3NOTHASH
	;hash has been pressed
	call inputdigit3
	
inputdigit3NOTHASH:
	mov 0Ah, r4
	mov a, 0Ah
	add a, #30h
	call DataWriter
	
	
	;=================================
inputdigit4:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', inputdigit4NOTHASH
	;hash has been pressed
	call inputdigit4
	
inputdigit4NOTHASH:
	mov 0Bh, r4
	mov a, 0Bh
	add a, #30h
	call DataWriter	
	
	;=================================
inputdigit5:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', inputdigit5NOTHASH
	;hash has been pressed
	call frequencychecker
	
inputdigit5NOTHASH:
	call inputdigit5
	
	
	;HERE WE WILL CHECK THE FREQUENCY AND CONCATENATE IT
frequencychecker:
	;our new frequency will be in 0DH(upper byte) 0CH(lower byte)
	
	mov a, #0
	CLR CY
	
	mov r0, 08h                  ;msb is now in r0
	cjne r0, #1, msbnotone	
	
	;msb is 1 .. now we will check the rest of the bits
	mov a, 09h
	jnz freqdown1                ;jump if 2nd digit is not zero
	jmp helloover1
freqdown1:
	call ERROR_DISPLAYER
	call Delay5Seconds
	jmp checkpoint1
	;if we are here then it means that the second digit was zero
	
	
helloover1:	
	mov a, 0Ah
	jnz freqdown2                ;jump if 3rd digit is not zero
	jmp helloover2
freqdown2:
	call ERROR_DISPLAYER
	call Delay5Seconds
helloover2:
	;if we are here then it means that the 3rd digit was zero	
	mov a, 0Bh
	
	jnz chotaywala               ;jump if 4th digit is not zero
	jmp adaythallay
chotaywala:
	call ERROR_DISPLAYER
	call Delay5Seconds
	jmp checkpoint1
adaythallay:
	;if we are here then it means that the 4th digit was zero
	
	
	;Frequency is 1000Hz upper byte = 03h lower byte = 0E8h
	mov 0dh, #03h
	mov 0ch, #0e8h
	jmp overthiss
	;========================	
	
msbnotone:
	;can be zero or a number>1
	;MSB : 08H
	;2nd : 09h
	;3rd : 0Ah
	;LSB : 0BH
	
	mov a, #1
	clr cy
	cjne a, 8h, ifbiggercheck
ifbiggercheck:
	
	jnc zeroO
	;this means that number>1
	call ERROR_DISPLAYER
	call Delay5Seconds
	call checkpoint1
	
zeroO:
	;this means the msb is zero
	
	;now we will check the 2nd digit here
	;if 2nd digit is zero we have a problem
	mov a, 9h
	jnz notTTzero
	;2nd was zero .. error
	call ERROR_DISPLAYER
	call Delay5Seconds
	call checkpoint1
	
notTTzero:
	;means 2nd was non - zero
	;we don't need to check the third and the fourth
	;now we will concatenate the numbers
	call numberconcatenate
overthiss:	
	
	
	
checkpoint2:
	;duty cycle range 10 - 90 ;1 byte number
	
	;msb = 10h
	;lsb = 11h
	
	;duty cycle will be in - > 12h
	
	
	
	;we have stored our frequency, now we will input the duty cycle
	call screenclear
	mov dptr, #DUTYCYCLE         ;displaying enter duty cycle string
	call STRING_DISP
	mov a, #0c0h                 ;moving onto the next line
	call CommandWriter
	
	
Dutydigit1:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', Dutydigit1NOTHASH
	;hash has been pressed
	call Dutydigit1
	
Dutydigit1NOTHASH:
	mov 10h, r4
	mov a, 10h
	add a, #30h
	call DataWriter
	
	
Dutydigit2:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', Dutydigit2NOTHASH
	;hash has been pressed
	call Dutydigit2
	
Dutydigit2NOTHASH:
	mov 11h, r4
	mov a, 11h
	add a, #30h
	call DataWriter
	
Dutydigit3:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', Dutydigit3NOTHASH
	;hash has been pressed
	call dutyjump
	
Dutydigit3NOTHASH:
	;user has pressed something else other than hash
	call Dutydigit3
	
	
	; user has pressed hash after entering two digits
	;now we can proceed to check and concatenate the duty cycle
dutyjump:
	;msb = 10h
	;lsb = 11h
	
	;duty cycle will be in - > 12h
	
	
	mov 12h, 11h
	mov a, #10
	mov b, 10h
	mul ab
	add a, 12h
	
	mov 12h, a                   ; duty cycle stored
	;now we will check whether its in the range or not
	
	;range = 10 - 90
	clr cy
	mov r0, 12h
	cjne r0, #90, downbelow
	jmp saafrange
	
downbelow:
	jnc waswrong                 ;jump if duty cycle>90
	;this means duty cycle<=90
saafrange:
	;now we will check duty>=10 or not
	clr cy
	
	cjne r0, #10, downbelow2
	jmp saafrange2
downbelow2:
	jnc saafrange2
	
	jmp waswrong
	
	;here everything is clear
saafrange2:
	
	jmp checkpoint3
	
waswrong:
	call ERROR_DISPLAYER
	call Delay5Seconds
	call checkpoint2
	
	;here we have checked the duty cycle and it is present in 12h register bank 2
	
	
	;========WAVELIFE ENTRY POINT===============
checkpoint3:
	;wave life range 10 - 30 ;1 byte number
	
	;msb = 18h
	;lsb = 19h
	;wave life will be in - > 1Ah
	
	
	
	call screenclear
	mov dptr, #WAVE_LIFE         ;displaying enter duty cycle string
	call STRING_DISP
	mov a, #0C0h                 ;moving onto the next line
	call CommandWriter
	
	
	
Wavedigit1:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', Wavedigit1NOTHASH
	;hash has been pressed
	call Wavedigit1
	
Wavedigit1NOTHASH:
	mov 18h, r4
	mov a, 18h
	add a, #30h
	call DataWriter
	
	
Wavedigit2:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', Wavedigit2NOTHASH
	;hash has been pressed
	call Wavedigit2
	
Wavedigit2NOTHASH:
	mov 19h, r4
	mov a, 19h
	add a, #30h
	call DataWriter
	
	
	
	
Wavedigit3:
	call KEYPADSCANNER           ;value will be in r4
	
	cjne r4, #'#', Wavedigit3NOTHASH
	;hash has been pressed
	call WAVEjump
	
Wavedigit3NOTHASH:
	;user has pressed something else other than hash
	call Wavedigit3
	
	
	; user has pressed hash after entering two digits
	;now we can proceed to check and concatenate the duty cycle
WAVEjump:
	;wave life range 10 - 30 ;1 byte number
	
	;msb = 18h
	;lsb = 19h
	;wave life will be in - > 1Ah
	
	
	
	mov 1ah, 19h
	mov a, #10
	mov b, 18h
	mul ab
	add a, 1ah
	
	mov 1ah, a                   ; wave life stored
	;now we will check whether its in the range or not
	
	;range = 10 - 30
	clr cy
	mov r0, 1ah
	cjne r0, #30, Adownbelow
	jmp Asaafrange
	
Adownbelow:
	jnc waswrong12               ;jump if wave life>30
	;this means wave life<=30
Asaafrange:
	;now we will check wave life >=10 or not
	clr cy
	
	cjne r0, #10, ABdownbelow
	jmp ABsaafrange
ABdownbelow:
	jnc ABsaafrange
	
	jmp waswrong12
	
	;here everything is clear
ABsaafrange:
	
	jmp AllChecksCleared
	
waswrong12:
	call ERROR_DISPLAYER
	call Delay5Seconds
	call checkpoint3
	
	;here we have checked the wave life and it is present in 1AH register bank 3
	
	
	
AllChecksCleared:
	;now we will calculate the ON and OFF time for our wave
	
	;we are going to use this formula to calculate delays:
	;delay=65536 - (Duty x (9216 / freq) )
	
	
	;first of all we will find the on time of our wave
	call div16_16                ; 9216 / frequency
	;answer = r2(lower byte)
	;D cycle will be in - > 12h
	
	mov a, r2
	mov b, 12h                   ; (Duty x (9216 / freq) )
	mul ab                       ;A has the lower byte B has the upper byte
	mov r1, a
	mov r0, b
	;now we will subtract from 65535
	call SUBB16_16               ;65535 - (Duty x (9216 / freq) )
	;Return - answer now resides in R2 upper and R3 lower.
	call ADD16_16                ; 1 + 65535 - (Duty x (9216 / freq) )
	;Return - answer now resides in R2 upper, and R3 lower.
	mov 3bh, r2                  ;upper byte of on time
	mov 3ah, r3                  ;lower byte of on time stored
	
	
	;NOW WE WILL CALCULATE THE OFF TIME
	
	call div16_16                ; 9216 / frequency
	;answer = r2(lower byte)
	;D cycle will be in - > 12h
	mov a, #100
	subb a, 12h
	
	mov b, r2
	; (Duty x (9216 / freq) )
	mul ab                       ;A has the lower byte B has the upper byte
	mov r1, a
	mov r0, b
	
	
	;now we will subtract from 65535
	call SUBB16_16               ;65535 - (Duty x (9216 / freq) )
	;Return - answer now resides in R2 upper and R3 lower.
	call ADD16_16                ; 1 + 65535 - (Duty x (9216 / freq) )
	;Return - answer now resides in R2 upper, and R3 lower.
	mov 3dh, r2                  ;upper byte of off time
	mov 3ch, r3                  ;lower byte of off time stored
	
	mov 30h, #20                 ; this is just a constant
	;wave life will be in - > 1Ah
	mov 31h, 1ah

	
	;=====================================================
PWM:
	;FIRST TIME INITIALIZATION
	mov TMOD, #00010001B
	MOV TL0, #00H                ; 50 MILI SEC STARTING POINT
	MOV TH0, #4CH
	SETB EA                      ;INTERRUPT IS ENABLED
	SETB ET0                     ; TIMER 0 INTERRUPT
	CLR TF0
	SETB TR0                     ; TIMER 0 IS STARTED
	
	;HERE IS THE MAIN TASK RUNNING PARALLEL TO TIMER 0 INTERRUPT
ITERATE:
	MOV TL1, 3AH
	MOV TH1, 3BH                 ; STARTING POINT CALCULATED FOR ON TIME DELAY
	CLR TF1
	SETB P2.7                    ;PWM AT PIN P1.0
	SETB TR1                     ; START TIMER 1
	JNB TF1, $                   ;POLL THE TF1
	
	CLR TR1                      ; TIMER 1 OFF
	MOV TL1, 3CH                 ; SET VALUES FOR OFF TIME
	MOV TH1, 3DH
	CLR TF1                      ; CLEAR FLAG
	
	CLR P2.7
	SETB TR1                     ; START TIMER AGAIN
	JNB TF1, $
	CLR TR1                      ;TIMER 1 OFF
	JMP ITERATE
	
	
	
	
	;==========================================================
	; FOREGROUND TASK ENDS HERE
	; THIS IS THE INTERRUPT SERVICE ROUTINE
T0ISR:
	CLR TR0
	MOV A, 30H                   ; IT
	JZ CHECK_LIFE
	DEC A
	MOV 30H, A
GO_AGAIN:
	MOV TL0, #00H
	MOV TH0, #4CH
	SETB EA
	SETB ET0
	CLR TF0
	SETB TR0                     ; TIMER 0 IS STARTED AGAIN
	JMP ENDI
CHECK_LIFE:
	MOV A, 31H
	JZ TIME_UP
	DEC A
	MOV 31H, A
	mov 30h, #20
	; - - - - - - - - - - - - - - - - DISPLAYING REMAINING TIME ON LCD - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	;mov p3, a; is line ko delete na karin shaid ye kaam ajaye
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	JMP GO_AGAIN
TIME_UP:
	;THE DESIGNATED WAVELIFE TIME IS UP
	clr tr1                      ; stop timer 1
	clr tr0
	clr tf0
	clr tf1                      ; clear timer 1 flag
	mov 30h, #0
	mov 31h, #0
	JMP checkpoint1              ;REPLACE ENDD BY MURTAZA'S STARTING POINT
ENDI:
	RETI
	

	
	;======================(SUBROUTINES)=========================
	
INTRO:
	MOV DPTR, #NAMES
	CALL STRING_DISP
	MOV A, #0C0H
	CALL CommandWriter           ; NEW LINE
	MOV DPTR, #ROLL_NUM
	CALL STRING_DISP
	RET
	
screenclear:
	mov a, #1h
	call CommandWriter
	mov a, #80h
	call CommandWriter
	ret
	
	
numberconcatenate:
	mov r0, 0BH
	mov a, #10
	mov b, 0ah
	mul ab
	add a, r0
	mov r0, a
	
	mov b, #100
	mov a, 09h
	mul ab
	mov r1, b
	clr cy
	add a, r0
	mov r0, a
	;our new frequency will be in 0DH(upper byte) 0CH(lower byte)
	mov 0dh, r1
	mov 0ch, r0
	ret
	
ERROR_DISPLAYER:
	;clearing screen
	call screenclear
	
	mov dptr, #ERROR
	call STRING_DISP
	RET
	
STRING_DISP:
	MOV R7, #0
REDO:
	MOV A, R7
	MOVC A, @A + DPTR
	JZ END_OF_STRING
	CALL DataWriter
	INC R7
	JMP REDO
END_OF_STRING:
	RET
	
CommandWriter:
	;command has to be present in the accumulator
	clr p2.1                     ; clearing the r / w register because we will never read from lcd
	clr p2.0                     ; rs=0
	mov p0, a
	setb p2.2                    ; falling edge
	clr p2.2
	;call BusyOrNot
	call Delay10ms
	ret
	
DataWriter:
	;data has to be present in the accumulator
	clr p2.1                     ; clearing the r / w register because we will never read from lcd
	setb p2.0                    ; rs=1
	mov p0, a
	setb p2.2                    ; falling edge
	clr p2.2
	;call BusyOrNot
	call Delay10ms
	ret
	
	
	
	
BusyOrNot:
	clr p2.0                     ;Select command register
	setb p2.1                    ;we are reading
BusyOrNotcheck:
	clr p2.2                     ;Enable H - >
	setb p2.2
	jb p3.7, BusyOrNotcheck      ;read busy flag again and again till it becomes 0
	ret
	
	
	
	
div16_16:
	mov r0, #00h                 ;lower byte of 9216
	mov r1, #24h                 ;higher byte of 9216
	
	;frequency will be in 0DH(upper byte) 0CH(lower byte)
	mov r2, 0Ch                  ;lower byte of frequency
	mov r3, 0dh                  ;higher byte of frequency
	
	
	
	CLR C                        ;Clear carry initially
	MOV R4, #00h                 ;Clear R4 working variable initially
	MOV R5, #00h                 ;CLear R5 working variable initially
	MOV B, #00h                  ;Clear B since B will count the number of left - shifted bits
div1:
	INC B                        ;Increment counter for each left shift
	MOV A, R2                    ;Move the current divisor low byte into the accumulator
	RLC A                        ;Shift low - byte left, rotate through carry to apply highestbit to high - byte
	MOV R2, A                    ;Save the updated divisor low - byte
	MOV A, R3                    ;Move the current divisor high byte into the accumulator
	RLC A                        ;Shift high - byte left high, rotating in carry from low - byte
	MOV R3, A                    ;Save the updated divisor high - byte
	JNC div1                     ;Repeat until carry flag is set from high - byte
div2:                         ;Shift right the divisor
	MOV A, R3                    ;Move high - byte of divisor into accumulator
	RRC A                        ;Rotate high - byte of divisor right and into carry
	MOV R3, A                    ;Save updated value of high - byte of divisor
	MOV A, R2                    ;Move low - byte of divisor into accumulator
	RRC A                        ;Rotate low - byte of divisor right, with carry from high - byte
	MOV R2, A                    ;Save updated value of low - byte of divisor
	CLR C                        ;Clear carry, we don't need it anymore
	MOV 07h, R1                  ;Make a safe copy of the dividend high - byte
	MOV 06h, R0                  ;Make a safe copy of the dividend low - byte
	MOV A, R0                    ;Move low - byte of dividend into accumulator
	SUBB A, R2                   ;Dividend - shifted divisor = result bit (no factor, only 0or 1)
	MOV R0, A                    ;Save updated dividend
	MOV A, R1                    ;Move high - byte of dividend into accumulator
	SUBB A, R3                   ;Subtract high - byte of divisor (all together 16 - bitsubstraction)
	MOV R1, A                    ;Save updated high - byte back in high - byte of divisor
	JNC div3                     ;If carry flag is NOT set, result is 1
	MOV R1, 07h                  ;Otherwise result is 0, save copy of divisor to undosubtraction
	MOV R0, 06h
div3:
	CPL C                        ;Invert carry, so it can be directly copied into result
	MOV A, R4
	RLC A                        ;Shift carry flag into temporary result
	MOV R4, A
	MOV A, R5
	RLC A
	MOV R5, A
	DJNZ B, div2                 ;Now count backwards and repeat until "B" is zero
	MOV R3, 05h                  ;Move result to R3 / R2
	MOV R2, 04h                  ;Move result to R3 / R2
	RET
	
	
	
	
ADD16_16:
	;Return - answer now resides in R2 upper and R3 lower.
	;Step 1 of the process
	MOV A, #1                    ;Move the low - byte into the accumulator
	ADD A, R3                    ;Add the second low - byte to the accumulator
	MOV R3, A                    ;Move the answer to the low - byte of the result
	;Step 2 of the process
	MOV A, #00                   ;Move the high - byte into the accumulator
	ADDC A, R2                   ;Add the second high - byte to the accumulator, pluscarry.
	MOV R2, A                    ;Move the answer to the high - byte of the result
	;Step 3 of the process
	MOV A, #00h                  ;By default, the highest byte will be zero.
	ADDC A, #00h                 ;Add zero, plus carry from step 2.
	MOV R1, A                    ;Move the answer to the highest byte of the result
	;Return - answer now resides in R1, R2, and R3.
	RET
	
	
	
	
SUBB16_16:
	;r1 has the lower byte r0 has the upper byte
	;mov r1, a
	;mov r0, b
	;Step 1 of the process
	MOV A, #0ffh                 ;Move the low - byte into the accumulator
	CLR C                        ;Always clear carry before first subtraction
	SUBB A, R1                   ;Subtract the second low - byte from the accumulator
	MOV R3, A                    ;Move the answer to the low - byte of the result
	;Step 2 of the process
	MOV A, #0ffh                 ;Move the high - byte into the accumulator
	SUBB A, R0                   ;Subtract the second high - byte from the accumulator
	MOV R2, A                    ;Move the answer to the low - byte of the result
	;Return - answer now resides in R2 upper and R3 lower.
	RET

	
	
	;====================(PRE - DEFINED DELAY SUBROUTINES)==========
	
Delay10ms:
	mov 30h, r0                  ;saving the actuall values of r0 and r1
	mov 31h, r1
	mov r1, #20
here1:
	mov r0, #232
here:
	djnz r0, here
	djnz r1, here1
	mov r0, 30h                  ;restoring the values of r0 and r1
	mov r1, 31h
	ret
	
	
	
	
Delay5Seconds:
	mov r2, #129
Delay5Secondsloop3:
	mov r1, #132
Delay5Secondsloop2:
	mov r0, #133
Delay5Secondsloop1: djnz r0, Delay5Secondsloop1
	djnz r1, Delay5Secondsloop2
	djnz r2, Delay5Secondsloop3
	ret
	
	
	
	
	
KEYPADSCANNER:
	
	;p1 is used for input first 4 bits for rows and then 3 bits for cols
	MOV P1, #01110000B
	;;;;; start scanning
	mov r0, #01110000B           ; mask is in r0
again:
	mov r1, #01111110B           ; ground 0th row
	mov r2, #0                   ; INDEX OF ROW
	mov r3, #0                   ; INDEX OF COLUMN
	
	mov p1, r1
	mov a, p1
	anl a, r0
	cjne a, 0h, key_pressed
	
	MOV R1, #01111101B
	inc r2                       ; r2 will contain the row index
	mov p1, r1
	mov a, p1
	anl a, r0
	cjne a, 0h, key_pressed
	
	MOV R1, #01111011B
	inc r2                       ; r2 will contain the row index
	mov p1, r1
	mov a, p1
	anl a, r0
	cjne a, 0h, key_pressed
	
	MOV R1, #01110111B
	inc r2                       ; r2 will contain the row index
	mov p1, r1
	mov a, p1
	anl a, r0
	cjne a, 0h, key_pressed
	
	jmp again
	
	
key_pressed:
	call delay                   ; debounce time
	swap a
	clr c
again1:
	rrc a
	jnc findkey
	inc r3                       ; r3 contains the column index
	jmp again1
	
findkey:
	mov a, #3
	mov b, r2
	mul ab
	add a, r3
	mov dptr, #key
	movc a, @a + dptr
	mov r4, a                    ;<=================here final result has been stored in r4
	
release_key:
	mov a, p1
	anl a, r0
	cjne a, 0h, release_key
	call delay                   ; debounce time
	ret
	
delay:
	MOV R5, #45
lOOOP:
	MOV R6, #255
	DJNZ R6, $
	DJNZ R5, LOOOP
	
	ret

	;==========================(STRINGS)=========================
	
	
NAMES: db "Murtaza & Zohaib", 0
ROLL_NUM: db "16 - 4514 16 - 4487", 0
ENTER_FREQ: db "Enter Frequency:", 0
ERROR: db "OUT OF RANGE", 0
	
DUTYCYCLE: db "Enter Duty Cycle", 0
	
WAVE_LIFE: db "Enter Wave Life", 0
	
key: db 1, 2, 3, 4, 5, 6, 7, 8, 9, ' * ', 0, '#', 0
	
endd:
	END
