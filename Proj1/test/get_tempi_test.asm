$MODDE2
;Tests the function of the timer lookup table with chosen time inputs against the expected output
;Load this on the DE2 board if it passes ledg.0 will light up, if fail ledra.0 will light
org 0h
	ljmp start_test
$include(../src/var.asm)
$include(../src/temp_lookup.asm)

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
	mov time, #low(100)
	mov time+1, #high(100)
	lcall get_tempi
	mov a, tempi
	clr c
	subb a, #95
	jz Test3_pass
	inc fail_count
Test3_pass: 
	mov a, fail_count
	jz all_pass
	setb ledra.0
	jmp forever
all_pass:
	setb ledg.0
forever:
sjmp forever

end
