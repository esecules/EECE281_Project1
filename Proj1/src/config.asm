$NOLIST
Config:
	clr TR2
ConfigSoakTemp:
	mov a, config_state
	cjne a, #0, ConfigSoakTime
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgSoakTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, soak_temp
	
	lcall ConfigInputs
	
	mov soak_temp, x+0
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigSoakTime:
	mov a, config_state
	cjne a, #1, ConfigReflowTemp
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgSoakTime
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, soak_time
	
	lcall ConfigInputs
	
	mov soak_time, x+0
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigReflowTemp:
	mov a, config_state
	cjne a, #2, ConfigDone
	

	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgReflowTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, reflow_temp
	
	lcall ConfigInputs
	
	mov reflow_temp, x+0
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigDone:
	setb TR2
	lcall LCD_clear
	pop acc
	pop acc
	ljmp Forever ;jump directly to Forever
	
ConfigInputs: ;back
	jb KEY.3, ConfigInputs1 
	jnb KEY.3, $
	mov a, config_state
	dec a
	mov config_state, a
	cjne a, #255, ConfigInputsE
	mov config_state, #0
	ret
ConfigInputs1: ;next
	jb KEY.2, ConfigInputs2 
	jnb KEY.2, $
	inc config_state ;no overflow check because when state overflows config terminates
	ret
ConfigInputs2: ;number
	jnb swup, ConfigInputs20
	mov a, SWA
	orl a, SWB
	jnz ConfigInputsE
	clr swup
ConfigInputs20:
	mov a, SWA
	orl a, SWB
	jz	ConfigInputsE
	setb swup
	mov R7, #16
	mov z+0, SWA
	mov z+1, SWB
ConfigInputs21:
	mov a, z+0
	rlc a
	mov z+0, a
	mov a, z+1
	rlc a
	mov z+1, a
	jc ConfigInputs22
	djnz R7, ConfigInputs21
ConfigInputs22:
	dec R7
	mov a, r7
	clr c
	subb a, #10
	jnc ConfigInputsE
	
	lcall hex2bcd
	mov a, bcd+1
	swap a
	anl a, #0xf0
	mov bcd+1, a
	mov a, bcd+0
	swap a
	anl a, #0x0f
	orl a, bcd+1
	mov bcd+1, a
	mov a, bcd+0
	swap a
	anl a, #0xf0
	orl a, r7
	mov bcd+0, a
	lcall bcd2hex
	mov a, x+1
	jz ConfigInputsE
	mov x+0, #0
	mov x+1, #0
ConfigInputsE:
	ret
	
$LIST