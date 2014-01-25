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
	LCALL InitDE2
    LCALL InitSerialPort
	LCALL Init_timer2
	
Forever:
	lcall get_tempi
	lcall CommsMain
    SJMP Forever
    
END
