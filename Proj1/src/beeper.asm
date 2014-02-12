$NOLIST

ISR_timer0:
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
	setb TR0
	lcall waitOneSec
	clr TR0
	ret

longBeep:
	setb TR0
	lcall waitThreeSec
	clr TR0
	ret

firstBeep:
	mov TH0, #high(61992)
    mov TL0, #low(61992)
    setb TR0
    ret
secondBeep:
	mov TH0, #high(60227)
    mov TL0, #low(60227)
    setb TR0
    ret
thirdBeep:
	mov TH0, #high(60806)
    mov TL0, #low(60806)
    setb TR0
    ret
fourthBeep:
	mov TH0, #high(62379)
    mov TL0, #low(62379)
    setb TR0
    ret
fifthBeep:
	mov TH0, #high(60227)
    mov TL0, #low(60227)
    setb TR0
    ret
sixthBeep:
	mov TH0, #high(61992)
    mov TL0, #low(61992)
    setb TR0
    ret

sixBeeps:
	lcall firstBeep
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	lcall secondBeep
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	lcall thirdBeep
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	lcall fourthBeep
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	lcall fifthBeep
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	
	lcall sixthBeep
	lcall waitHalfSec
	clr TR0
	lcall waitHalfSec
	ret
	
$LIST
