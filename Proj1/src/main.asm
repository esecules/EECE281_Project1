$MODDE2
org 0000H
   ljmp ClearAll
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
$include(LCD_interface.asm)
$include(config.asm)
$include(flash.asm)

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
	clr SSR
MyProgram:
	LCALL InitDE2
    LCALL InitSerialPort
	LCALL Init_timer2
	LCALL Init_SPI
	LCALL InitSSR
	LCALL LCD_Init
	mov P3MOD, #0
	clr run
	mov config_state, #0
	mov heating_state, INITIAL
	lcall FlashRestoreAll

Setup:
	lcall CommsCmd
	mov a, SWC
	jnb acc.1, ManualConfig
	lcall ConfigPreset
ManualConfig:	
	lcall Config
	sjmp Setup

AndroidConnection:
	jb P3.7, runon
	runoff:
	mov a, heating_state
	cjne a, INITIAL, androidcontinue
	clr run
	sjmp keep_going
	runon:
	clr c
	mov a, heating_state
	subb a, INITIAL
	jz androidcontinue3
	clr c
	mov a, heating_state
	subb a, COOLDOWN
	jz androidcontinue2
	clr c
	mov a, heating_state
	subb a, SAFE
	jz androidcontinue2
	setb run
	ljmp keep_going
androidcontinue:
	clr run
	ljmp clearAll
androidcontinue2:
	clr run
	ljmp keep_going
androidcontinue3:
	setb run
	ljmp start
	

Forever:
	mov a, swc
	jb acc.0, Androidconnection
	jb key.1, keep_going
	jnb key.1, $
	mov a, heating_state
	cjne a, SAFE, notsafe
	ljmp clearAll
	notsafe:
	cpl run
	jb run, start
	ljmp clearAll
	
	start:
	mov time+0, #0
	mov time+1, #0
	keep_going:
	lcall CheckBackToSetup
	lcall Read335
	lcall ReadThermo
	lcall OFFSET
	lcall RunOnTick ;put your lcalls below to run them once per tick
	lcall CommsCmd
	lcall beeper
    SJMP Forever
    
    
RunOnTick:
	jb RotNextTime, RotNow
	mov A, RotLastTime
	cjne A, time, RotNext
	ret
RotNext: ;don't run immediately. wait till next round so stuff can
	setb RotNextTime
	ret
RotNow:
	mov RotLastTime, time
	;put your rotten functions here!
	lcall CommsSend
	lcall LCD_main
	;end of rotten functions
	clr RotNextTime
	ret
	
CheckBackToSetup:
	mov A, heating_state
	cjne A, INITIAL, CBTSE
	jb KEY.3, CBTSE
	jnb KEY.3, $
	mov config_state, #4
	lcall LCD_clear
	pop acc
	pop acc
	ljmp Setup
CBTSE:
	ret
END
