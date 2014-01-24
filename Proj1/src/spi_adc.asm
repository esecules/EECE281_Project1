$NOLIST

INIT_SPI:
    orl P0MOD, #00111110b ; Set SCLK, MOSI as outputs
    anl P0MOD, #11111110b ; Set MISO as input
    clr SCLK              ; For mode (0,0) SCLK is zero
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
    djnz R2, DO_SPI_G_LOOP
    pop acc
    ret

Delay:
	mov R3, #20
Delay_loop:
	djnz R3, Delay_loop
	ret
	
WAIT50MS:
	MOV R2, #9
L3: MOV R1, #250
L2: MOV R0, #250
L1: DJNZ R0, L1
	DJNZ R1, L2
	DJNZ R2, L3
	RET

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
	
ReadADC0_64:
	push ACC
	push B
	push PSW
	push AR4
	mov x+0, #0
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	mov y+2, #0
	mov y+3, #0
	mov R4, #64
	mov B, #0
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
	
	pop AR4
	pop PSW
	pop B
	pop ACC
	ret
	
$LIST