$MODDE2
org 0000H
   ljmp MyProgram

$include(../src/var.asm)

$include(../src/math32.asm)

$include(../src/comms.asm)

$include(../src/utilities.asm)
    
MyProgram:
    MOV SP, #7FH
    mov LEDRA, #0
    mov LEDRB, #0
    mov LEDRC, #0
    mov LEDG, #0
    LCALL InitSerialPort
    
    ;ljmp ASCII

	mov dptr, #SERmsg1
	lcall SendString
	
	mov A, tempi
	mov x+0, A
	mov x+1, #0
	lcall hex2bcd
	lcall SendBCD3
	
	mov dptr, #SERmsg2
	lcall SendString
	
	mov A, tempa
	mov x+0, A
	mov x+1, #0
	lcall hex2bcd
	lcall SendBCD3
	
	mov A, #'.'
	lcall putchar
	
	mov A, #128
	lcall BinFrac2BCD
	
	lcall SendBCD4
	
	mov dptr, #SERmsg3
	lcall SendString
	
TestFrac:
	mov A, #1
	mov R5, #255
TestFrac1:
	push ACC
	lcall BinFrac2BCD
	lcall SendBCD4
	mov dptr, #nlcr
	lcall SendString
	pop ACC
	inc A
	
	djnz R5, TestFrac1
	
    
Forever:
    SJMP Forever
END
