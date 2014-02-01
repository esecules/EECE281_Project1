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
	LCALL InitSSR
	setb run
	mov heating_state, INITIAL
	mov soak_temp, #50
	mov soak_time, #30
	mov max_temp, #150
	setb P0.7
	
Forever:
	lcall Read335
	lcall ReadThermo
	lcall OFFSET
;	lcall decision ;new decision is in ISR because duty cycle is hard to do in main loop
	lcall CommsMain
	lcall CommsCmd
	mov LEDRA, heating_state
    SJMP Forever
    
END
