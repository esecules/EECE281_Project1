$MODDE2
org 0000H
   ljmp MyProgram

$include(../src/var.asm)
$include(../src/math32.asm)
$include(../src/spi_adc.asm)

MyProgram:
	mov sp, #07FH
	clr a
	mov LEDG,  a
	mov LEDRA, a
	mov LEDRB, a
	mov LEDRC, a
	orl P0MOD, #00111000b ; make all CEs outputs

	setb CE_ADC

	lcall INIT_SPI
	
Forever:
	lcall ReadADC0_64
	
	mov A, adc+0
	mov LEDRB, A
	mov A, adc+1
	mov LEDRA, A
	
	lcall Delay
	lcall wait50ms
	
	sjmp Forever
	
END