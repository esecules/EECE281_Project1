;$include(var.asm) ;only uncomment when checking to see if this file compiles by itself

;--------------------------------------------
;	Function: initializes timer2 in auto
;				reload mode to interrupt every 10 ms
;	Reads: TIMER2_RELOAD
; 	Modifies: T2CON, TR2, TF2, RCAP2H, RCAP2L, 
;				ET2, EA
;---------------------------------------------

Init_timer2:
	mov T2CON, #00H ; Autoreload is enabled, work as a timer
 	clr TR2
 	clr TF2
 	; Set up timer 2 to interrupt every 10ms
	mov RCAP2H,#high(TIMER2_RELOAD) 
 	mov RCAP2L,#low(TIMER2_RELOAD)
 	setb TR2 ;start timer
 	setb ET2 ;enable timer2 interrupt
 	setb EA  ;enable all interrupts
	ret
;--------------------------------------------
;	Function: increment the time register every 
;				half second rolls back to zero.
;				after 511.
;	Reads: TF2, timer2_interrupt_count , time
; 	Modifies: TF2, timer2_interrupt_count , time
;---------------------------------------------
Timer2_ISR:
	push acc
	push psw
	clr TF2
	inc timer2_interrupt_count
	mov a, timer2_interrupt_count
	cjne a, #50, ret_timer2_isr
	mov timer2_interrupt_count, #0
	mov a, time
	add a, #1
	mov time, a
	mov a, time+1
	addc a, #0
	subb a, #2
	jnc rollover
	mov time+1, a
	jmp ret_Timer2_isr
	rollover:
	mov time, #0
	mov time+1,#0
	ret_timer2_isr:
	pop psw
	pop acc
	reti
;---------------------------------------------------------
;Get Ideal Temp 
; Function: gets the current ideal temp based on time
; Reads: time and LUT at address 50H
; Modifies: tempi
; Requires: time must be 16 bits 
;---------------------------------------------------------	
get_tempi:
	push acc
	push psw
	mov dptr, #Temp_LUT1
	mov a, DPH
	add a, time+1
	mov DPH, a
	mov a, DPL
	add a, time
	mov DPL, a
	clr a
	movc a, @a+dptr
	mov tempi, a	
	get_tempi_done:
	pop psw
	pop acc	
	ret
	