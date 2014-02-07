$NOLIST
Config:
ConfigSoakTemp:
	mov a, heating_state
	cjne a, INITIAL, ConfigSoakTime
	;what to do with the buttons or switches
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
	mov a, heating_state
	cjne a, SOAK, ConfigReflowTemp
	;what to do with the buttons or switches
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
	;what to do with the buttons or switches
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
$LIST