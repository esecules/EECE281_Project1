$NOLIST
DSEG at 30H

;math32
x: ds 4
y: ds 4
bcd: ds 5

;adc
adc: ds 2

;Temperature and time
time: ds 2
tempa: ds 1
tempi: ds 1
timer2_interrupt_count: ds 1
heating_state: ds 1
soak_temp:		ds 1
soak_time:		ds 1
max_temp:		ds 1
;comms private
SERlasttime: ds 1

FREQ   EQU 33333333
BAUD   EQU 57600
T1LOAD EQU 256-(FREQ/(192*BAUD))

FREQ_2		   EQU 100
TIMER2_RELOAD  EQU 65536-(FREQ/(12*FREQ_2))

MISO   EQU  P0.0 
MOSI   EQU  P0.1 
SCLK   EQU  P0.2
CE_ADC EQU  P0.3

;Temperature Constants
;state constants
PREHEAT 	EQU 0
SOAK 		EQU 1
REFLOW		EQU 2
COOLDOWN	EQU 3
SAFE		EQU 4 
;rate costants
PREHEAT_R	EQU 1
REFLOW_R	EQU 2
;temp constants
COOLDOWN_temp	EQU 60
BSEG

;math32
mf: dbit 1

;comms private
SERsendNextTime: dbit 1

CSEG

;COMMS=========================================================================
SERmsg1: DB 'Target: ', 0
SERmsg2: DB 0xB0, 'C , Actual: ', 0
SERmsg3: DB 0xB0, 'C', 0AH, 0DH, 0

;LCD===========================================================================
;------------------------------------------------------------------------------
; look up table of floating numbers 
;------------------------------------------------------------------------------

floating_numbers:
db '1.0', '1.1', '1.2', '1.3', '1.4', '1.5', '1.6', '1.7', '1.8', '1.9'
db '2.0', '2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9'
db '3.0', '3.1', '3.2', '3.3', '3.4', '3.5', '3.6', '3.7', '3.8', '3.9'
db '4.0', '4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9'
db '5.0', '5.0'

;------------------------------------------------------------------------------
; look up tables for strings example, REMENBER on 16 char long in ASCII 
;------------------------------------------------------------------------------
message1:
	db 'ECEE 281 PROJECT',0
message2:
	db 'Reflow-soldering',0
message3:
	db '!@#$%^&*()_+',0
message4:
	db 'LCD-DISPLAY TEST',0

$LIST
