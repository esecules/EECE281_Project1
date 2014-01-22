$MODDE2
;Tests the function of the timer lookup table with chosen time inputs against the expected output
$include(../src/var.asm)
$include(../src/temp_lookup.asm)
org oh
	ljmp start_test
fail_count EQU R3

start_test:
	mov time, #low(500)
	mov time+1, #high(500)
	lcall get_tempi
	mov a, tempi
	clr c
	subb a, #191
	jz Test1_pass
	inc fail_count
Test1_pass:
	mov time, #low(5500)
	mov time+1, #high(550)
	lcall get_tempi
	mov a, tempi
	jz Test2_pass
	inc fail_count
Test2_pass:	 

end