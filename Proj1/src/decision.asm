$NOLIST

InitSSR:
	mov A, P0MOD
	orl A, #0x80
	mov P0MOD, A
	ret

Decision: ;DEPRECATED!!! DEPRECATED!!! DEPRECATED!!! DEPRECATED!!!
	jnb run, DecisionForceOff
	Load_x(0)
	mov a, tempa+2
	jnz DecisionForceOff
	mov x+1, tempi
	mov y+0, tempa+0
	mov y+1, tempa+1
	mov y+2, #0
	mov y+3, #0
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionOff 
DecisionOn:
	Load_y(TATOL)
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionEnd
	mov LEDG, #0xff
	setb SSR
	sjmp DecisionEnd
DecisionOff:
	Load_y(0)
	mov x+0, tempa+0
	mov x+1, tempa+1
	mov x+2, #0
	mov x+3, #0
	mov y+1, tempi
	lcall sub32
	Load_y(TATOL)
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionEnd
DecisionForceOff:
	mov LEDG, #0
	clr SSR
	sjmp DecisionEnd	
DecisionEnd:
	ret
	
DecisionNewISR:
	push x+0
	push x+1
	push x+2
	push x+3
	push y+0
	push y+1
	push y+2
	push y+3
	push acc
	push psw
	jnb run, DNISRoff
	Load_x(0)
	mov a, tempa+2
	jnz DNISRoff
	mov x+1, tempi
	mov y+0, tempa+0
	mov y+1, tempa+1
	mov y+2, #0
	mov y+3, #0
	lcall sub32
	mov A, x+2
	jb ACC.7, DNISRoff
DNISRon:
	mov dutycycle, x+1
	mov LEDG, #0xff
	setb SSR
	sjmp DNE
DNISRoff:
	mov dutycycle, #0
	mov LEDG, #0
	clr SSR
DNE:
	pop psw
	pop acc
	pop y+3
	pop y+2
	pop y+1
	pop y+0
	pop x+3
	pop x+2
	pop x+1
	pop x+0
	ret

DecisionNewDCC:
	push ACC
	push PSW
	djnz dutycycle, DNDCCE
DNDCCOFF:
	mov LEDG, #0
	clr SSR
DNDCCE:
	pop PSW
	pop ACC
	ret
$LIST