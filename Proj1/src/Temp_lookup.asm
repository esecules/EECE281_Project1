;$include(var.asm) ;only uncomment when checking to see if this file compiles by itself

;--------------------------------------------
;	Function: initializes timer2 in auto
;				reload mode to interrupt every 10 ms
;	Reads: TIMER2_RELOAD
; 	Modifies: T2CON, TR2, TF2, RCAP2H, RCAP2L, 
;				ET2, EA
;---------------------------------------------

Init_timer2:
	mov time+0, #0
	mov time+1, #0
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
	cjne a, #100, ret_timer2_isr
	mov timer2_interrupt_count, #0
	mov a, time
	add a, #1
	mov time, a
	mov a, time+1
	addc a, #0
	mov time+1, a
	lcall get_tempi
	ret_timer2_isr:
	pop psw
	pop acc
	reti
;---------------------------------------------------------
;Get Ideal Temp - private function 
; Function: gets the current ideal temp once every second
; Reads: time
; Modifies: tempi heating_state x and y
; Requires: time must be 16 bits 
;---------------------------------------------------------	
get_tempi:
	push acc
	push psw
	
	;find current state	
	mov a, heating_state
	subb a, PREHEAT
	jz get_preheat_temp
	mov a, heating_state
	subb a, SOAK
	jz get_soak_temp
	mov a, heating_state
	subb a, REFLOW
	jz get_reflow_temp
	mov a, heating_state
	subb a, COOLDOWN
	jz get_cooldown_temp	
	;update next state and temp based on current state
	get_preheat_temp:
		mov a, tempi
		add a, #PREHEART_R
		mov tempi, a
		
		mov a, tempa
		subb a, soak_temp
		jnz return_get_tempi
		mov heating_state, SOAK
		jmp return_get_tempi
		
	get_soak_temp:
		mov tempi, soak_temp	
		djnz soak_time, return_get_tempi
		mov heating_state, REFLOW
		jmp return_get_tempi
		
	get_reflow_temp:
		mov a, tempi
		add a, #REFLOW_R
		mov tempi, a
		
		mov a, tempa
		subb a, max_temp
		jnz return_get_tempi
		mov heating_state, COOLDOWN
		jmp return_get_tempi
	get_cooldown_temp:
		mov tempi, COOLDOWN_temp
		
		mov a, tempa
		subb a, #COOLDOWN_temp
		jnz return_get_tempi
		mov heating_state, SAFE
		jmp return_get_tempi
	return_get_tempi:
	pop psw
	pop acc	
	ret
	

	