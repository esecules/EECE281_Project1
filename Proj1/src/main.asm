$MODDE2
org 0000H
   ljmp MyProgram
;org 002BH
;	ljmp Timer2_ISR
$include(var.asm)

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
;	lcall get_tempi the ideal temperature is updated each second by the interrupt and put into tempi
;	lcall wait50ms ;delete when timer2 is fixed
	lcall Read335
	lcall decision
	lcall CommsSend ;change to CommsMain when timer2 is fixed
    SJMP Forever
    
END
