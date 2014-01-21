$MODDE2
;---------------------------------------------------------
;Get Ideal Temp 
; Function: gets the current ideal temp based on time
; Reads: time and LUT at address 50H
; Modifies: tempi
; Requires: time must be 16 bits 
;---------------------------------------------------------
dseg at 50h
$include(Temperature_LUTs.asm)
cseg
get_tempi:
	push acc
	push psw
	mov a, time+1
	clr c
	subb a, #2
	jnc Invalid_time
	mov a, time+1
	jz Use_low_half_lut
	mov dptr, #Temp_LUT_High
	jmp use_LUT
	Use_low_half_lut:
	mov dptr, #Temp_LUT_Low
	use_LUT:
	mov a, time
	movc a, @a+dptr
	mov tempi, a
	jmp get_tempi_done
	Invalid_time:
	mov tempi, #0
	get_tempi_done:
	pop psw
	pop acc	
	ret
	