$MODDE2
org 0000H
   ljmp MyProgram

$include(var.asm)

$include(math16.asm)

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
	mov a, bcd+2
	anl a, #0x0f
	add a, #0x30
	lcall putchar
SBCDone3:
	ret
    
nlcr:
	DB 0AH, 0DH, 0

getchar:
    jnb RI, getchar
    clr RI
    mov a, SBUF
    lcall putchar
    ret
    
MyProgram:
    MOV SP, #7FH
    mov LEDRA, #0
    mov LEDRB, #0
    mov LEDRC, #0
    mov LEDG, #0
    LCALL InitSerialPort
    
    ;ljmp ASCII
    
    mov x+0, #250
    mov x+1, #0
    mov y+0, #222
    mov y+1, #0
    


	mov dptr, #SERmsg1
	lcall SendString
	
	lcall hex2bcd
	lcall SendBCD3
	
	mov dptr, #SERmsg2
	lcall SendString
	
	lcall xchg_xy
	lcall hex2bcd
	lcall SendBCD3
	lcall xchg_xy
	
	mov dptr, #SERmsg3
	lcall SendString
	
    
Forever:
    SJMP Forever
    
ASCII:
	mov R7, #0xD0
	mov A, #0x31
ASCII1:
	lcall putchar
	inc A
	djnz R7, ASCII1
	sjmp Forever
END
