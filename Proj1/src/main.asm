$MODDE2
org 0000H
   ljmp MyProgram
org 000BH
	ljmp ISR_Timer0
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
$include(beeper.asm)

    
	
MyProgram:
	LCALL InitDE2
    LCALL InitSerialPort
	LCALL Init_timer2
	LCALL initTimer0
	LCALL Init_SPI
	
Forever:
	lcall Read335
	lcall decision
	lcall CommsMain
	lcall CommsCmd
	lcall beeper
    SJMP Forever
    
END
