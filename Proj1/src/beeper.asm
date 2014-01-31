$NOLIST

ISR_timer0:
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
    setb TR0 ; Enable timer 0
    setb ET0 ; Enable timer 0 interrupt	
    orl P0MOD, #00010000b ; Set beeper pin as out
    ret
    
; KEY.3 is the temporary start button
beeper:
	jnb KEY.3, shortBeep
	
checkState:
	mov a, heating_state
	clr c
	subb a, SOAK
	jz shortBeep
	add a, SOAK
	
	clr c
	subb a, REFLOW
	jz shortBeep
	add a, REFLOW
	
	clr c
	subb a, COOLDOWN
	jz longBeep
	add a, COOLDOWN
	
	clr c
	subb a, SAFE
	jz sixBeeps
	clr a
	
	ret
	
shortBeep:
	lcall inittimer0
	lcall waitOneSec
	clr TR0
	clr TF0
	ret

longBeep:
	lcall initTimer0
	lcall waitOneSec
	clr TR0
	clr TF0
	ret

sixBeeps:
	lcall initTimer0
	lcall waitHalfSec
	clr TR0
	clr TF0
	lcall waitHalfSec
	
	lcall initTimer0
	lcall waitHalfSec
	clr TR0
	clr TF0
	lcall waitHalfSec
	
	lcall initTimer0
	lcall waitHalfSec
	clr TR0
	clr TF0
	lcall waitHalfSec
	
	lcall initTimer0
	lcall waitHalfSec
	clr TR0
	clr TF0
	lcall waitHalfSec
	
	lcall initTimer0
	lcall waitHalfSec
	clr TR0
	clr TF0
	lcall waitHalfSec
	
	lcall initTimer0
	lcall waitHalfSec
	clr TR0
	clr TF0
	lcall waitHalfSec
	
	ret
	
$LIST
