$NOLIST

Decision:
	lcall Load_x(0)
	lcall Load_y(0)
	mov x+1, tempi
	mov y+0, tempa+0
	mov y+1, tempa+1
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionOff 
DecisionOn:
	lcall Load_x(0)
	lcall Load_y(0)
	mov x+1, tempi
	mov y+0, tempa+0
	mov y+1, tempa+1
	lcall sub32
	lcall Load_y(384) ;1.5 degC
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionEnd
	setb SSR
	sjmp DecisionEnd
DecisionOff:
	lcall Load_x(0)
	lcall Load_y(0)
	mov x+0, tempa+0
	mov x+1, tempa+1
	mov y+1, tempi
	lcall sub32
	lcall Load_y(384) ;1.5 degC
	lcall sub32
	mov A, x+2
	jb ACC.7, DecisionEnd
	clr SSR
	sjmp DecisionEnd
DecisionEnd:
	ret
$LIST