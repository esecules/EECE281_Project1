$NOLIST
FlashW:
	mov FLASH_MOD, #0ffh ; Set data port for output
	mov FLASH_ADD0, dpl
	mov FLASH_ADD1, dph
	mov FLASH_ADD2, #FLASHSECTOR
	mov FLASH_DATA, a
	mov FLASH_CMD, #0111B ; FL_CE_N=0, FL_WE_N=1
	mov FLASH_CMD, #0101B ; FL_CE_N=0, FL_WE_N=0
	mov FLASH_CMD, #0111B ; FL_CE_N=0, FL_WE_N=1
	mov FLASH_CMD, #1111B ; FL_CE_N=1, FL_WE_N=1
	ret
FlashR:
	mov FLASH_MOD, #0x00
	mov FLASH_ADD0, dpl
	mov FLASH_ADD1, dph
	mov FLASH_ADD2, #FLASHSECTOR
	mov FLASH_CMD, #0111b
	mov FLASH_CMD, #0011b
	nop
	mov a, FLASH_DATA
	nop
	mov FLASH_CMD, #0111b
	mov FLASH_CMD, #1111b
	ret

FlashEraseSector:
	mov dptr, #0x0AAA
	mov a, #0xAA
	lcall flashW
	mov dptr, #0x0555
	mov a, #0x55
	lcall flashW
	mov dptr, #0x0AAA
	mov a, #0x80
	lcall flashW
	mov dptr, #0x0AAA
	mov a, #0xAA
	lcall flashW
	mov dptr, #0x0555
	mov a, #0x55
	lcall flashW
	mov dptr, #0x0000
	mov a, #0x30
	lcall flashW
FlashEraseSector_L0: ; Check using DQ7 Data# polling when the erasing is done
	mov dptr, #0
	lcall FlashR
	cpl a
	jnz FlashEraseSector_L0
	ret

FlashByte:
	push dph
	push dpl
	push acc
	mov dptr, #0x0AAA
	mov a, #0xAA
	lcall FlashW
	mov dptr, #0x0555
	mov a, #0x55
	lcall FlashW
	mov dptr, #0x0AAA
	mov a, #0xA0
	lcall FlashW
	pop acc
	pop dpl
	pop dph
	mov r0, a ; Used later when checking...
	lcall FlashW
	;Check using DQ7 Data# polling when operation is done
Flash_Byte_L0:
	lcall FlashR
	clr c
	subb a, r0
	jnz Flash_Byte_L0
	ret

FlashSaveAll:
	mov dptr, #FLASH_SOAK_TEMP
	mov a, soak_temp
	lcall FlashByte
	mov dptr, #FLASH_SOAK_TIME
	mov a, soak_time
	lcall FlashByte
	mov dptr, #FLASH_REFL_TEMP
	mov a, reflow_temp
	lcall FlashByte
	mov dptr, #FLASH_REFL_TIME
	mov a, reflow_time
	lcall FlashByte
	mov dptr, #FLASH_MAXX_TEMP
	mov a, max_temp
	lcall FlashByte
	ret

FlashRestoreAll:
	mov dptr, #FLASH_SOAK_TEMP
	lcall flashR
	mov soak_temp, a
	mov dptr, #FLASH_SOAK_TIME
	lcall flashR
	mov soak_time, a
	mov dptr, #FLASH_REFL_TEMP
	lcall flashR
	mov reflow_temp, a
	mov dptr, #FLASH_REFL_TIME
	lcall flashR
	mov reflow_time, a
	mov dptr, #FLASH_MAXX_TEMP
	lcall flashR
	mov max_temp, a
	ret
$LIST