$NOLIST

ISR_timer0:
	cpl LEDRA.5
	clr TF0
	cpl BEEP
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
	reti
	
initTimer0:
	mov A, TMOD
	orl A, #00000001B
	anl A, #11110001B
	mov TMOD, A
	clr TR0 ; Disable timer 0
	clr TF0
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
    setb ET0 ; Enable timer 0 interrupt	
    setb EA
    orl P0MOD, #00010000b ; Set beeper pin as out
    ret
    

beeper:
	jb statechange, checkstate
	ret
	
checkState:
	lcall initTimer0
	clr stateChange
	mov a, heating_state
	clr c
	subb a, PREHEAT
	jz shortBeep
	mov a, heating_state

	mov a, heating_state
	clr c
	subb a, SOAK
	jz shortBeep
	mov a, heating_state
	
	clr c
	subb a, REFLOW
	jz shortBeep
	mov a, heating_state
	
	clr c
	subb a, COOLDOWN
	jz longBeep
	mov a, heating_state
	
	clr c
	subb a, SAFE
	jz sixBeeps	
	
	ret
	
shortBeep:
	MOV LEDRB, #0FFH
	setb TR0
	lcall waitOneSec
	clr TR0
	MOV LEDRB, #0H
	ret

longBeep:
	setb TR0
	lcall waitThreeSec
	clr TR0
	ret

sixBeeps:
	mov ledrb, #0abH
	setb TR0
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	setb TR0
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	setb TR0
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	setb TR0
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	setb TR0
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	setb TR0
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	mov ledrb, #0h
	ret
	
$LIST
