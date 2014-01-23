$MODDE2
;Case1: Tests the function of the timer lookup table with chosen time inputs against the expected output
;Load this on the DE2 board if it passes ledg.0 will light up, if fail ledra.0 will light. press key 1 to advance to the next test
org 0h
	ljmp start_test
org 02bh
	ljmp choose_isr
BSEG at 20H
case2: dbit 1
$include(../src/var.asm) ;Pulls current versions of these files
$include(../src/temp_lookup.asm) 

fail_count EQU R3

myLUT:
    DB 0C0H, 0F9H, 0A4H, 0B0H, 099H        ; 0 TO 4
    DB 092H, 082H, 0F8H, 080H, 090H        ; 4 TO 9
    DB 088H, 083H, 0C6H, 0A1H, 086H, 08EH  ; A to F

Display_time:
	mov dptr, #myLUT
	; Display Digit 0
    mov A, time+0
    anl a, #0fh
    movc A, @A+dptr
    mov HEX1, A
	; Display Digit 1
    mov A, time+0
    swap a
    anl a, #0fh
    movc A, @A+dptr
    mov HEX2, A
    ; Display Digit 2
    mov A, time+1
    anl a, #0fh
    movc A, @A+dptr
    mov HEX3, A
	; Display Digit 3
    mov A, time+1
    swap a
    anl a, #0fh
    movc A, @A+dptr
    mov HEX4, A
    ret	

choose_isr:
	jb case2, Timer2_ISR_Test2
	ljmp Timer2_ISR
	
Timer2_ISR_Test2:
	clr TF2
	setb ledg.0 
	clr ledra.0
	reti

start_test:
	mov SP, #7FH ; Set the stack pointer 
 	mov LEDRA, #0 ; Turn off all LEDs 
 	mov LEDRB, #0 
 	mov LEDRC, #0 
 	mov LEDG, #0 
 	 
	clr case2
	mov fail_count, #0
	
	mov time, #low(500) 
	mov time+1, #high(500)
	lcall get_tempi
	mov a, tempi
	clr c
	subb a, #191
	jz Test1_pass
	inc fail_count
Test1_pass:
	mov time, #low(550)
	mov time+1, #high(550)
	lcall get_tempi
	mov a, tempi
	jz Test2_pass
;	inc fail_count
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
	mov ledra, fail_count
	jmp wait_for_case2
all_pass:
	setb ledg.0
wait_for_case2:
	jb key.1, wait_for_case2

;Case2 tests the functionality of init_timer2 
;will display red until the timer2 interrupt is triggered
	setb case2
	setb ledra.0
wait_for_key_case2:
	jb key.2, wait_for_key_case2 

;Test3 tests the timer2 ISR The value of the current time is displayed in hex
;it should increment twice a second and roll back to 0 afer it hits 511 (decimal)
	clr case2
case3:
	lcall display_time
	jnb key.1, clear_all
	sjmp case3
clear_all:
 	mov LEDRA, #0 ; Turn off all LEDs 
 	mov LEDRB, #0 
 	mov LEDRC, #0 
 	mov LEDG, #0 
	
end
