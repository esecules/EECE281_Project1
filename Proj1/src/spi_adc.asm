$NOLIST

INIT_SPI:
    orl P0MOD, #00111110b ; Set SCLK, MOSI, CE as outputs
    anl P0MOD, #11111110b ; Set MISO as input
    clr SCLK              ; For mode (0,0) SCLK is zero
    setb CE_ADC
	ret

SPIDelay:
	mov R3, #20
SPIDelay_loop:
	djnz R3, SPIDelay_loop
	ret
	
DO_SPI_G:
	push acc
    mov R1, #0            ; Received byte stored in R1
    mov R2, #8            ; Loop counter (8-bits)
DO_SPI_G_LOOP:
    mov a, R0             ; Byte to write is in R0
    rlc a                 ; Carry flag has bit to write
    mov R0, a
    mov MOSI, c
    setb SCLK             ; Transmit
    mov c, MISO           ; Read received bit
    mov a, R1             ; Save received bit in R1
    rlc a
    mov R1, a
    clr SCLK
    lcall SPIDelay_loop
    djnz R2, DO_SPI_G_LOOP
    pop acc
    ret

; Channel to read passed in register b
Read_ADC_Channel:
	clr CE_ADC
	mov R0, #00000001B ; Start bit:1
	lcall DO_SPI_G
	
	mov a, b
	swap a
	anl a, #0F0H
	setb acc.7 ; Single mode (bit 7).
	
	mov R0, a ;  Select channel
	lcall DO_SPI_G
	mov a, R1          ; R1 contains bits 8 and 9
	anl a, #03H
	mov R7, a
	
	mov R0, #55H ; It doesn't matter what we transmit...
	lcall DO_SPI_G
	mov a, R1    ; R1 contains bits 0 to 7
	mov R6, a
	setb CE_ADC
	ret
	
ReadADC_64:
	push ACC
	push PSW
	push AR4
	push AR6
	push AR7
	mov x+0, #0
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	mov y+2, #0
	mov y+3, #0
	mov R4, #64
ReadADC_64L:
	lcall Read_ADC_Channel
	mov y+0, R6
	mov y+1, R7
	lcall add32
	djnz R4, ReadADC_64L
	
	mov A, x+0
	mov adc+0, A
	mov A, x+1
	mov adc+1, A
	
	pop AR7
	pop AR6
	pop AR4
	pop PSW
	pop ACC
	ret

Read335:
	mov b, #LM335
	lcall ReadADC_64
	
	mov x+3, #0
	mov x+2, #0
	mov x+1, adc+1
	mov x+0, adc+0
	Load_y(500)
	lcall mul32
	;/256
	mov x+0, x+1
	mov x+1, x+2
	mov x+2, x+3
	mov x+3, #0	
	Load_y(69926) ;273.15*256
	lcall sub32
	mov tempo+0, x+0
	mov tempo+1, x+1
	ret
	
ReadThermo:
	mov b, #THERMO
	lcall ReadADC_64	
	mov x+3, #0
	mov x+2, #0
	mov x+1, adc+1
	mov x+0, adc+0
	Load_y(304)
	lcall mul32
	;/256
	mov x+0, x+1
	mov x+1, x+2
	mov x+2, x+3
	mov x+3, #0	
	mov tempm+0, x+0
	mov tempm+1, x+1
	mov tempm+2, x+2
	ret	
	
OFFSET:
	mov x+0, tempm+0
	mov x+1, tempm+1
	mov x+2, tempm+2
	mov y+0, tempo+0
	mov y+1, tempo+1
	lcall add32
	mov tempa+0, x+0
	mov tempa+1, x+1
	mov tempa+2, x+2
	ret	
$LIST