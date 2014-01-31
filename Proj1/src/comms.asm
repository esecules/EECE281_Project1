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
	
;PUT ME IN THE LOOP!
COMMSMAIN:
	jb SERsendNextTime, CommsMainSend
	mov A, SERlasttime
	cjne A, time, CommsMainQueue
CommsMainNoSend:
	ret
CommsMainQueue: ;don't send immediately. wait till next round so tempi can update
	setb SERsendNextTime
	ret
CommsMainSend:
	mov SERlasttime, time
	lcall CommsSend
	clr SERsendNextTime
	ret
	
	
CommsSend:
	mov dptr, #SERmsg1
	lcall SendString
	
	Load_x(0)
	mov x+0, tempi
	lcall hex2bcd
	lcall SendBCD3
	
	mov dptr, #SERmsg2
	lcall SendString
	
	Load_x(0)
	mov x+0, tempa+1
	lcall hex2bcd
	lcall SendBCD3
	mov A, #'.'
	lcall putchar
	mov A, tempa+0
	lcall BinFrac2BCD
	lcall SendBCD4
	
	mov dptr, #SERmsg3
	lcall SendString
	
	Load_x(0)
	mov x+0, tempo+1
	lcall hex2bcd
	lcall SendBCD3
	mov A, #'.'
	lcall putchar
	mov A, tempo+0
	lcall BinFrac2BCD
	lcall SendBCD4
	
	mov dptr, #SERmsg4
	lcall SendString
	ret
	
CommsCmd:
	lcall getchar
	jnc CommsCmdE
	mov B, A
	
	anl A, #0xF8
	cjne A, #0x08, CommsCmdAppend
	lcall CommsProcCmd
	ret
CommsCmdAppend:
	mov A, B
	clr C
	subb A, #0x30 ;invalid char
	jc CommsCmdE
	mov A, B
	clr C
	subb A, #0x60 ;invaild char
	jnc CommsCmdE
	mov A, #SERCmd
	add A, SERCmdI
	mov R0, A
	mov A, B
	mov @R0, A
	mov A, SERCmdI
	inc A
	mov SERCmdI, A
CommsCmdE:
	ret
	
CommsProcCmd:
	dec SERCmdI
	mov z+0, #0
	mov z+1, #0
	mov z+2, #0
	mov z+3, #0
	Load_y(1)
CommsProcCmdL:
	mov A, #SERCmd
	add A, SERCmdI
	mov R0, A
	mov A, @R0
	clr C
	subb A, #0x30
	mov x+0, A
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	lcall mul32
	push y+0
	push y+1
	push y+2
	push y+3
	mov y+0, z+0
	mov y+1, z+1
	mov y+2, z+2
	mov y+3, z+3
	lcall add32
	mov z+0, x+0
	mov z+1, x+1
	mov z+2, x+2
	mov z+3, x+3
	pop y+3
	pop y+2
	pop y+1
	pop y+0
	Load_x(10)
	lcall mul32
	lcall xchg_xy
	djnz SERCmdI, CommsProcCmdL
	;testing, returns number directly
	;replace with proper value-putters once the protocol is decided
	mov x+0, z+0
	mov x+1, z+1
	mov x+2, z+2
	mov x+3, z+3
	lcall hex2bcd
	lcall SendBCD4
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
	clr C
    jnb RI, getcharE
    setb C
    clr RI
    mov a, SBUF
getcharE:
    ret
	
$LIST