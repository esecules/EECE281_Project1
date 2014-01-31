$MODDE2

$include(var.asm)

CLK EQU 33333333
FREQ_0 EQU 2000
TIMER0_RELOAD EQU 65536-(CLK/(12*2*FREQ_0))

org 0000H
	ljmp myprogram
	
org 000BH
	ljmp ISR_timer0

ISR_timer0:
	cpl P0.0
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
	reti
	
;For a 33.33MHz clock, one cycle takes 30ns
waitHalfSec:
	mov R2, #90
L3: mov R1, #250
L2: mov R0, #250
L1: djnz R0, L1
	djnz R1, L2
	djnz R2, L3
	ret
	
waitOneSec:
	mov R2, #180
M3: mov R1, #250
M2: mov R0, #250
M1: djnz R0, M1
	djnz R1, M2
	djnz R2, M3
	ret
	
waitThreeSec:
	mov R3, #3
N4:	mov R2, #180
N3: mov R1, #250
N2: mov R0, #250
N1: djnz R0, N1
	djnz R1, N2
	djnz R2, N3
	djnz R3, N4
	ret
    
initTimer0:
	mov LEDRA, #0FFH
	mov LEDRB, #0FFH
	mov LEDRC, #03H
    mov TMOD,  #00000001B ; GATE=0, C/T*=0, M1=0, M0=1: 16-bit timer
	clr TR0 ; Disable timer 0
	clr TF0
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
    setb TR0 ; Enable timer 0
    setb ET0 ; Enable timer 0 interrupt	
    ret
    
; KEY.3 is the temporary start button
startButton:
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
	
myProgram:
	lcall startButton
	
forever:
	sjmp forever
	
END