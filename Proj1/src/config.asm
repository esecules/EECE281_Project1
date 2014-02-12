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
	cjne a, #2, ConfigReflowTime
	

	
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
ConfigReflowTime:
	mov a, config_state
	cjne a, #3, ConfigMaxTemp
	

	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgReflowTime
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, reflow_time
	
	lcall ConfigInputs
	
	mov reflow_time, x+0
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigMaxTemp:
	mov a, config_state
	cjne a, #4, ConfigDone
	

	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDcfgMaxTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, max_temp
	
	lcall ConfigInputs
	
	mov max_temp, x+0
	lcall hex2bcd
	lcall LCD_BCD3
	ret
ConfigDone:
	setb TR2
	lcall LCD_clear
	lcall LCD_main
	lcall FlashEraseSector
	lcall FlashSaveAll
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

;-------------------------------------------------------------------;
ConfigPresetint2:
	jnb Key.1, ConfigPresetint2
	jnb Key.2, ConfigPresetint2
	jnb Key.3, ConfigPresetint2
	ljmp ConfigPreset2
	
ConfigPresetint3:
	jnb Key.1, ConfigPresetint3
	jnb Key.2, ConfigPresetint3
	jnb Key.3, ConfigPresetint3
	ljmp ConfigPreset3
	
ConfigPresetint1:
	jnb Key.1, ConfigPresetint1
	jnb Key.2, ConfigPresetint1
	jnb Key.3, ConfigPresetint1
	ljmp ConfigPreset1
		


ConfigPreset:
	clr TR2
	
ConfigPreset1:
	mov a, SWC
	jnb acc.1, PresetDone
	jnb key.2, ConfigPresetint2
	jnb key.3, ConfigPresetint3
	mov soak_time, PRESET1SOAKTIME
	mov soak_temp, PRESET1SOAKTEMP
	mov reflow_time, PRESET1REFLOWTIME
	mov reflow_temp, PRESET1REFLOWTEMP
	mov max_temp, PRESET1REFLOWTEMP
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDPreset1
	lcall LCD_string
	jb key.1, PresetExit
	sjmp ConfigPreset1
	
ConfigPreset2:
	mov a, SWC
	jnb acc.1, PresetDone
	jnb key.2, ConfigPresetint3
	jnb key.3, ConfigPresetint1
	mov soak_time, PRESET2SOAKTIME
	mov soak_temp, PRESET2SOAKTEMP
	mov reflow_time, PRESET2REFLOWTIME
	mov reflow_temp, PRESET2REFLOWTEMP
	mov max_temp, PRESET2REFLOWTEMP
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDPreset2
	lcall LCD_string
	jb key.1, PresetExit
	sjmp ConfigPreset2
	
ConfigPreset3:
	mov a, SWC
	jnb acc.1, PresetDone
	jnb key.2, ConfigPresetint1
	jnb key.3, ConfigPresetint2
	mov soak_time, PRESET3SOAKTIME
	mov soak_temp, PRESET3SOAKTEMP
	mov reflow_time, PRESET3REFLOWTIME
	mov reflow_temp, PRESET3REFLOWTEMP
	mov max_temp, PRESET3REFLOWTEMP
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDPreset3
	lcall LCD_string
	jb key.1, PresetExit
	sjmp ConfigPreset3	
		
PresetDone:
	ret		
	
PresetExit:
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDpreSoakTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, soak_temp
	lcall hex2bcd
	lcall LCD_BCD3
	
	lcall waithalfsec
	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDpreSoakTime
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, soak_time
	lcall hex2bcd
	lcall LCD_BCD3
	
	lcall waithalfsec
	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDpreReflowTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, reflow_temp	
	mov reflow_temp, x+0
	lcall hex2bcd
	lcall LCD_BCD3
	
	lcall waithalfsec
	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDpreReflowTime
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, reflow_time
	lcall hex2bcd
	lcall LCD_BCD3
	
	lcall waithalfsec
	
	mov a, #0x80
	lcall LCD_command
	mov dptr, #LCDpreMaxTemp
	lcall LCD_string
	mov a, #0xc0
	lcall LCD_command
	Load_x(0)
	mov x+0, max_temp
	lcall hex2bcd
	lcall LCD_BCD3
	
	lcall waithalfsec
	
	setb TR2
	pop acc
	pop acc
	ljmp forever		
		
	
$LIST