;By Erik Dandanell (2014)
; LCD_interface.asm: 
;	This program is used to interface with the LCD display on the DE2.
; 	it has the functions:
;	send a char,a string,a float number, custom characters  and commands to the LCD display.

$MODDE2 
org 0000H 
 ljmp myprogram 

;JASON: MOVED DEFINITIONS
$include(var.asm)
;------------------------------------------------------------------------------
; a half seconds delay subroutine 
;------------------------------------------------------------------------------
WaithalfSec:
	mov R2, #90
L8: mov R1, #250
L7: mov R0, #250
L6: djnz R0, L6 ; 3 machine cycles-> 3*30ns*250=22.5us
	djnz R1, L7 ; 22.5us*250=5.625ms
	djnz R2, L8 ; 5.625ms*90=0.5s (approximately)
	ret
;------------------------------------------------------------------------------
; a 5 seconds delay subroutine 
;------------------------------------------------------------------------------
WaitfiveSec:
	mov r3, #5
l5:	mov R2, #180
L4: mov R1, #250
L3: mov R0, #250
L2: djnz R0, L2 ; 3 machine cycles-> 3*30ns*250=22.5us
	djnz R1, L3 ; 22.5us*250=5.625ms
	djnz R2, L4 ; 5.625ms*90=0.5s (approximately)
	djnz r3, l5
	ret
	
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

;------------------------------------------------------------------------------
; sends a float number  via dtpr to the LCD subrutine	
;------------------------------------------------------------------------------
LCD_float_number:
	mov r1, #0  
loop_2: 
	mov a, r1
	movc a,@a+dptr
	call LCD_put
	inc r1
	cjne r1,#3, loop_2 ;(number size of floating number including zeros,decimal points and units[if needed]).
done_2:
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
; converts binary numbers from a dtpr to a coresponding string
;------------------------------------------------------------------------------
convert_binary_to_string:
	mov dptr, #floating_numbers
	mov a, r7
	mov b, #3  ; number of chars inside the subb-division of db lookuptable
	mul ab
	add a, dpl
	mov dpl, a
	
	mov a,b
	addc a, dph
	mov dph,a 
	
	clr a
	movc a, @a+dptr
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
	
;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------
myprogram: 
 mov SP, #7FH ; Set the stack pointer 
 mov LEDRA, #0 ; Turn off all LEDs 
 mov LEDRB, #0 
 mov LEDRC, #0 
 mov LEDG, #0 
 lcall LCD_Init
 lcall custom_character_init
 ;JASON: BUGFIX

;initialize char sending
	mov a, #80H
	lcall LCD_command
	
	mov a, #'E'
	lcall LCD_put
	mov a, #'E'
	lcall LCD_put
	mov a, #'C'
	lcall LCD_put
	mov a, #'E'
	lcall LCD_put
	mov a, #'2'
	lcall LCD_put
	mov a, #'8'
	lcall LCD_put
	mov a, #'1'
	lcall LCD_put
	
	lcall WaitfiveSec
	lcall LCD_clear

;initialize messages one trough four
	mov a, #80H
	lcall LCD_command
	mov dptr, #message1
	lcall LCD_string

	mov a, #0C0H
	lcall LCD_command
	mov dptr, #message2
	lcall LCD_string
	
	lcall WaitfiveSec
	lcall LCD_clear
	
	mov a, #80H
	lcall LCD_command
	mov dptr, #message3
	lcall LCD_string

	mov a, #0C0H
	lcall LCD_command
	mov dptr, #message4
	lcall LCD_string
	
	lcall WaitfiveSec
	lcall LCD_clear

	
;initialize floating number sequence and custom character	
	mov r7, #0
sumup:	
	mov a, #0C0H
	lcall LCD_command
	lcall convert_binary_to_string
	lcall LCD_float_number
	
	lcall stikyman
	
	inc r7
	cjne r7, #41 ,sumup
	lcall WaitfiveSec
	lcall LCD_clear
		
loop:
	ljmp loop


stikyman:
	cpl mf
	jb mf, handsdown	
handsup:
	mov a, #80H
	lcall LCD_command
	mov a, #0  
	lcall LCD_put
	lcall waithalfsec
	ljmp done
handsdown:	
	mov a, #80H
	lcall LCD_command
	mov a, #1
	lcall LCD_put
	lcall waithalfsec
done:	
	ret
	
end