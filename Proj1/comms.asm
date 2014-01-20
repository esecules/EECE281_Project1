$MODDE2
org 0000H
   ljmp MyProgram

DSEG at 30H

x: ds 2
y: ds 2
bcd: ds 3
FREQ   EQU 33333333
BAUD   EQU 115200
T2LOAD EQU 65536-(FREQ/(32*BAUD))

BSEG

mf: dbit 1

CSEG

$include(math16.asm)

MSG1: DB 'Target: ', 0
MSG2: DB 0xB0, 'C , Actual: ', 0
MSG3: DB 0xB0, 'C', 0AH, 0DH, 0

InitSerialPort:
	; Configure serial port and baud rate
	clr TR2 ; Disable timer 2
	mov T2CON, #30H ; RCLK=1, TCLK=1 
	mov RCAP2H, #high(T2LOAD)  
	mov RCAP2L, #low(T2LOAD)
	setb TR2 ; Enable timer 2
	mov SCON, #52H
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
    


	mov dptr, #MSG1
	lcall SendString
	
	lcall hex2bcd
	lcall SendBCD3
	
	mov dptr, #MSG2
	lcall SendString
	
	lcall xchg_xy
	lcall hex2bcd
	lcall SendBCD3
	lcall xchg_xy
	
	mov dptr, #MSG3
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
