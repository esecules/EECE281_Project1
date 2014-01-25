$MODDE2
org 0000H
   ljmp MyProgram
org 002BH
	ljmp Timer2_ISR
$include(var.asm)

$include(math32.asm)

$include(Temp_lookup.asm)
$include(comms.asm)

$include(utilities.asm)


    
	
MyProgram:
    MOV SP, #7FH
    mov LEDRA, #0
    mov LEDRB, #0
    mov LEDRC, #0
    mov LEDG, #0
    LCALL InitSerialPort
	LCALL Init_timer2
	
Forever:
	lcall get_tempi
	lcall CommsMain
    SJMP Forever
    
END
