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

clearAll:
	mov tempa+0, #0
	mov tempa+1, #0
	mov tempa+2, #0
	mov tempo+0, #0
	mov tempo+1, #0
	mov tempi, #0
	mov tempm+0, #0
	mov tempm+1, #0
	mov tempm+2, #0
	mov time, #0
	mov time+1, #0
	mov timer2_interrupt_count, #0
	mov heating_state, INITIAL
	mov soak_temp, #0
	mov soak_time, #0
	mov max_temp, #0
	mov dutycycle, #0
	clr stateChange
	clr run	
MyProgram:
	LCALL InitDE2
    LCALL InitSerialPort
	LCALL Init_timer2
	LCALL Init_SPI
	LCALL InitSSR
	clr run
	mov heating_state, INITIAL
	mov soak_temp, #50
	mov soak_time, #30
	mov reflow_temp, #120
	mov reflow_time, #30
	mov max_temp, #150
	setb P0.7   

Forever:
	jb key.1, keep_going
	jnb key.1, $
	cpl run
	jb run, keep_going
	ljmp clearAll
	
	keep_going:
	lcall Read335
	lcall ReadThermo
	lcall OFFSET
	lcall CommsMain
	lcall CommsCmd
	lcall beeper
	mov LEDRA, heating_state
    SJMP Forever
    
END
