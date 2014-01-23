$NOLIST
	
BinFrac2BCD:
	push AR7
	push AR6
	push ACC
	push PSW
	mov R7, A
	mov x+0, #0
	mov x+1, #0
	mov y+0, #low(5000)
	mov y+1, #high(5000)
	mov R6, #8
	
BinFrac2BCD_l:
	mov A, R7
	rlc A
	mov R7, A
	jnc BinFrac2BCD_noadd
	mov A, x+0
	add A, y+0
	mov x+0, A
	mov A, x+1
	addc A, y+1
	mov x+1, A
BinFrac2BCD_noadd:
	clr C
	mov A, y+1
	rrc A
	mov y+1, A
	mov A, y+0
	rrc A
	mov y+0, A
	djnz R6, BinFrac2BCD_l
	
	lcall hex2bcd
	
	
	pop PSW
	pop ACC
	pop AR6
	pop AR7
	ret
$LIST