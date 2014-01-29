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
ReadADC0_64L:
	lcall Read_ADC_Channel
	mov y+0, R6
	mov y+1, R7
	lcall add32
	djnz R4, ReadADC0_64L
	
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
	
$LIST