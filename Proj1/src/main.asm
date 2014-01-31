$MODDE2
org 0000H
   ljmp MyProgram
org 002BH
	ljmp Timer2_ISR
	
$include(var.asm)

org 1337H
$include(math32.asm)

$include(Temp_lookup.asm)
$include(comms.asm)
$include(spi_adc.asm)
$include(decision.asm)
$include(utilities.asm)


    
	
MyProgram:
	LCALL InitDE2
    LCALL InitSerialPort
	LCALL Init_timer2
	LCALL Init_SPI
	
Forever:
	lcall Read335
	lcall decision
	lcall CommsMain
	lcall CommsCmd
    SJMP Forever
    
END
