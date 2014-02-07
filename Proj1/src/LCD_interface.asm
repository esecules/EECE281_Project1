$NOLIST
;By Erik Dandanell (2014)
; LCD_interface.asm: 
;	This program is used to interface with the LCD display on the DE2.
; 	it has the functions:
;	send a char,a string,a float number, custom characters  and commands to the LCD display.

	
;------------------------------------------------------------------------------
; 40 micro-second delay subroutine 
;------------------------------------------------------------------------------
Wait40us:
	mov R0, #149
Wait40us_L0: 
	nop
	nop
	nop
	nop
	nop
	nop
	djnz R0, Wait40us_L0 ; 9 machine cycles-> 9*30ns*149=40us
    ret
    
;------------------------------------------------------------------------------
; sends a command to the LCD subrutine	
;------------------------------------------------------------------------------
LCD_command:
	mov	LCD_DATA, A
	clr	LCD_RS
	nop
	nop
	setb LCD_EN ; Enable pulse should be at least 230 ns
	nop
	nop
	nop
	nop
	nop
	nop
	clr	LCD_EN
	ljmp Wait40us

;------------------------------------------------------------------------------
; sends a char via to the LCD subrutine	
;------------------------------------------------------------------------------
LCD_put:
	mov	LCD_DATA, A
	setb LCD_RS
	nop
	nop
	setb LCD_EN ; Enable pulse should be at least 230 ns
	nop
	nop
	nop
	nop
	nop
	nop
	clr	LCD_EN
	ljmp Wait40us
	
;------------------------------------------------------------------------------
; sends a string via dtpr to the LCD subrutine	
;------------------------------------------------------------------------------
LCD_string:
	mov r1, #0
loop_1: 
	mov a, r1
	movc a,@a+dptr
	jz done_1 
	lcall LCD_put
	inc r1
	ljmp loop_1
done_1:
	ret

LCD_BCD3:
 mov a, bcd+1
 anl a, #0x0f
 orl a, #0x30
 lcall LCD_put
 mov a, bcd+0
 swap a
 anl a, #0x0f
 orl a, #0x30
 lcall LCD_put
 mov a, bcd+0
 anl a, #0x0f
 orl a, #0x30
 lcall LCD_put
 ret

;------------------------------------------------------------------------------
; clears the LCD.
;------------------------------------------------------------------------------
LCD_clear:
	mov a, #01H ; Clear screen (Warning, very slow command!)
	lcall LCD_command
    ; Delay loop needed for 'clear screen' command above (1.6ms at least!)
    mov R1, #40
Clr_loop:
	lcall Wait40us
	djnz R1, Clr_loop
	ret

;------------------------------------------------------------------------------
; custom character initializer via commaing modification of the CGRAM (stikymanup and stickymandown)
;------------------------------------------------------------------------------
custom_character_init:
	mov a, #0x40 
	lcall LCD_command
	
;first custom character
		mov a,#0x4
	lcall LCD_put
		mov a,#0xe
	lcall LCD_put
		mov a,#0x15
	lcall LCD_put
		mov a,#0xe
	lcall LCD_put
		mov a,#0x4
	lcall LCD_put
		mov a,#0xa
	lcall LCD_put
		mov a,#0xa 
	lcall LCD_put
		mov a,#0
	lcall LCD_put	
	
;second custom character		
		mov a,#0x4
	lcall LCD_put
		mov a,#0xe
	lcall LCD_put
		mov a,#0x4
	lcall LCD_put
		mov a,#0x1f
	lcall LCD_put
		mov a,#0x4
	lcall LCD_put
		mov a,#0xa
	lcall LCD_put
		mov a,#0xa 
	lcall LCD_put
		mov a,#0
	lcall LCD_put
	
		mov a, #80h
	lcall LCD_command
	ret
	
;------------------------------------------------------------------------------
; LCD initializer subrutine 
;------------------------------------------------------------------------------
LCD_Init:
; Turn LCD on, and wait a bit.
    setb LCD_ON
    clr LCD_EN  ; Default state of enable must be zero
    lcall Wait40us
    
    mov LCD_MOD, #0xff ; Use LCD_DATA as output port
    clr LCD_RW ;  Only writing to the LCD in this code.

;use top display	
;	mov a, #0C0H
;	lcall LCD_command
;use bottom display
;	mov a, #80H
;	lcall LCD_command

;use to Display on command
	mov a, #0ch 
	lcall LCD_command
;use to state 8-bits interface, 2 lines, 5x7 characters
	mov a, #38H 
	lcall LCD_command
;use to turn on cursor auto advance
;	mov A, #06h		
;	lcall lcd_command
	lcall LCD_clear
	ret
	
LCD_printState:
	mov a, heating_state
	cjne a, INITIAL, LCD_printStatePREHEAT
LCD_printStateINITIAL:
	mov dptr, #LCDmsgSTOP
	ljmp LCD_printStatePrint
LCD_printStatePREHEAT:
	mov a, heating_state
	cjne a, PREHEAT, LCD_printStateSOAK
	mov dptr, #LCDmsgPREHEAT
	ljmp LCD_printStatePrint
LCD_printStateSOAK:
	mov a, heating_state
	cjne a, SOAK, LCD_printStateREFLOW
	mov dptr, #LCDmsgSOAK
	ljmp LCD_printStatePrint
LCD_printStateREFLOW:
	mov a, heating_state
	cjne a, REFLOW, LCD_printStateCOOLDOWN
	mov dptr, #LCDmsgREFLOW
	ljmp LCD_printStatePrint
LCD_printStateCOOLDOWN:
	mov a, heating_state
	cjne a, COOLDOWN, LCD_printStateSAFE
	mov dptr, #LCDmsgCOOLING
	ljmp LCD_printStatePrint
LCD_printStateSAFE:
	mov a, heating_state
	cjne a, SAFE, LCD_printStateEND
	mov dptr, #LCDmsgSAFE
	ljmp LCD_printStatePrint
LCD_printStatePrint:
	lcall lcd_string
LCD_printStateEND:
	ret

LCD_main:
 mov a, #0x80
 lcall lcd_command
 
 lcall lcd_printState

 mov dptr, #LCDmsgTi
 lcall lcd_string
 
 Load_x(0)
 mov x+0, tempi
 lcall hex2bcd
 lcall LCD_BCD3
 
 mov a, #0xc0
 lcall lcd_command
 
 Load_x(0)
 mov x+1, time+1
 mov x+0, time+0
 lcall hex2bcd
 lcall LCD_BCD3
 mov a, #'s'
 lcall LCD_put
 
 mov a, #0xc8
 lcall lcd_command
 mov dptr, #LCDmsgTa
 lcall lcd_string
 
 Load_x(0)
 mov x+0, tempa+1
 lcall hex2bcd
 lcall LCD_BCD3
 
 ret

$LIST