$NOLIST

Decision:
	Load_x(0)
	Load_y(0)
	mov x+1, tempi
	mov y+0, tempa+0
	mov y+1, tempa+1
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionOff 
DecisionOn:
	Load_x(0)
	Load_y(0)
	mov x+1, tempi
	mov y+0, tempa+0
	mov y+1, tempa+1
	lcall sub32
	Load_y(TATOL)
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionEnd
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
	clr SSR
	sjmp DecisionEnd
DecisionEnd:
	ret
$LIST