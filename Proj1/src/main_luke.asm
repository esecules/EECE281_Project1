$MODDE2
org 0000H
   ljmp MyProgram
org 002BH
	ljmp Timer2_ISR
	
$include(var.asm)	

org 1337h	


$include(math32.asm)
$include(Temp_lookup.asm)
$include(decision.asm)
$include(spi_adc.asm)
$include(comms.asm)
$include(utilities.asm)
	
MyProgram:
	LCALL InitDE2
    LCALL InitSerialPort
	LCALL Init_timer2
	
Forever:
	jnb key.2, StopButton
	jnb key.3, StartButton
	LCALL Read335
	LCALL ReadThermo
	LCALL OFFSET
	lcall decision
	lcall CommsMain
	lcall CommsCmd
    SJMP Forever
    
StartButton:
	jnb key.3, StartButton
	setb run
	sjmp forever
	
StopButton:
	jnb key.2, StopButton
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
	mov timer2_interrrupt_count, #0
	mov heating_state, #0
	mov soak_temp, #0
	mov soak_time, #0
	mov max_temp, #0
	clr run
	sjmp forever    
END
