$NOLIST

InitSerialPort:
	; Configure serial port and baud rate
	clr TR1 ; Disable timer 1
	mov A, TMOD
	orl A, #0xF0
	anl A, #0x2F
	mov TMOD, A
	mov TH1, #T1LOAD
	mov TL1, #T1LOAD
	setb TR1 ; Enable timer 2
	mov SCON, #52H
	mov A, PCON
	setb ACC.7
	mov PCON, A
	ret

putchar:
    JNB TI, putchar
    CLR TI
    MOV SBUF, a
    RET

SendString:
    CLR A
    MOVC A, @A+DPTR
    JZ SSDone
    LCALL putchar
    INC DPTR
    SJMP SendString
SSDone:
    ret
    
SendBCD3:
	mov a, bcd+1
	anl a, #0x0f
	add a, #0x30
	lcall putchar
	mov a, bcd+0
	swap a
	anl a, #0x0f
	add a, #0x30
	lcall putchar
	mov a, bcd+0
	anl a, #0x0f
	add a, #0x30
	lcall putchar
SBCDone3:
	ret
	
SendBCD4:
	mov a, bcd+1
	swap a
	anl a, #0x0f
	add a, #0x30
	lcall putchar
	mov a, bcd+1
	anl a, #0x0f
	add a, #0x30
	lcall putchar
	mov a, bcd+0
	swap a
	anl a, #0x0f
	add a, #0x30
	lcall putchar
	mov a, bcd+0
	anl a, #0x0f
	add a, #0x30
	lcall putchar
SBCDone4:
	ret
    
nlcr:
	DB 0AH, 0DH, 0

getchar:
    jnb RI, getchar
    clr RI
    mov a, SBUF
    lcall putchar
    ret
	
    
ASCII:
	mov R7, #0xD0
	mov A, #0x31
ASCII1:
	lcall putchar
	inc A
	djnz R7, ASCII1
	sjmp $
$LIST