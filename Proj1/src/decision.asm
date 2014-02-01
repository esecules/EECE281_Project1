$NOLIST

InitSSR:
	mov A, P0MOD
	orl A, #0x80
	mov P0MOD, A
	ret

Decision:
	Load_x(0)
	Load_y(0)
	mov a, tempa+2
	jnz DecisionOffNoCheck
	mov x+1, tempi
	mov y+0, tempa+0
	mov y+1, tempa+1
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
	Load_x(0)
	Load_y(0)
	mov x+0, tempa+0
	mov x+1, tempa+1
	mov y+1, tempi
	lcall sub32
	Load_y(TATOL)
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionEnd
	mov LEDG, #0
	clr SSR
	sjmp DecisionEnd
DecisionOffnocheck:
	clr SSR
	sjmp DecisionEnd	
DecisionEnd:
	ret
$LIST