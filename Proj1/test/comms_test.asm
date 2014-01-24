$MODDE2
org 0000H
   ljmp MyProgram
org 002BH
	ljmp Timer2_ISR
$include(../src/var.asm)

$include(../src/math32.asm)

$include(../src/comms.asm)

$include(../src/utilities.asm)

$include(../src/Temp_lookup.asm)
    
	
MyProgram:
    MOV SP, #7FH
    mov LEDRA, #0
    mov LEDRB, #0
    mov LEDRC, #0
    mov LEDG, #0
    LCALL InitSerialPort
	LCALL Init_timer2
    ;ljmp ASCII
	ljmp Forever
	
Forever:
	lcall CommsMain
    SJMP Forever
    
    
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
	
ASCII:
	mov R7, #0xD0
	mov A, #0x31
ASCII1:
	lcall putchar
	inc A
	djnz R7, ASCII1
	sjmp $
END
