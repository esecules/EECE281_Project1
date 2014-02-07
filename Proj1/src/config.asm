$NOLIST
Config:
ConfigSoakTemp:
	mov a, config_state
	cjne a, #0, ConfigSoakTime
	
	lcall ConfigInputs
	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgSoakTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, soak_temp
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigSoakTime:
	mov a, config_state
	cjne a, #1, ConfigReflowTemp
	
	lcall ConfigInputs
	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgSoakTime
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, soak_time
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigReflowTemp:
	mov a, config_state
	cjne a, #2, ConfigDone
	
	lcall ConfigInputs
	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgReflowTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, soak_temp
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigDone:
	setb TR2
	lcall LCD_clear
	pop acc
	pop acc
	ljmp Forever ;jump directly to Forever
	
ConfigInputs:
	jb KEY.3, ConfigInputs1 ;back
	jnb KEY.3, $
	mov a, config_state
	dec a
	mov config_state, a
	cjne a, #255, ConfigInputsE
	mov config_state, #0
	ret
ConfigInputs1:
	jb KEY.2, ConfigInputs2 ;next
	jnb KEY.2, $
	inc config_state ;no overflow check because when state overflows config terminates
	ret
ConfigInputs2:
ConfigInputsE:
	ret
	
$LIST