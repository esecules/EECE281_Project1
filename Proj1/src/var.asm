$NOLIST
DSEG at 30H

;math32
x: ds 4
y: ds 4
bcd: ds 5

;public temporary
z: ds 4

;adc
adc: ds 2


;Temperature and time
time: ds 2
tempa: ds 3
tempo: ds 2
tempi: ds 1
tempm: ds 3
timer2_interrupt_count: ds 1
heating_state: ds 1
soak_temp:		ds 1
soak_time:		ds 1
reflow_temp:	ds 1
reflow_time:	ds 1
max_temp:		ds 1
dutycycle:		ds 1
RotLastTime: ds 1
;comms private
SERCmdI:	ds 1
SERCmd:	ds 5
;config private
config_state: ds 1

FREQ   EQU 33333333
BAUD   EQU 57600
T1LOAD EQU 256-(FREQ/(192*BAUD))

FREQ_2		   EQU 100
TIMER2_RELOAD  EQU 65536-(FREQ/(12*FREQ_2))
FREQ_0		   EQU 2000
TIMER0_RELOAD  EQU 65536-(FREQ/(12*2*FREQ_0))	

MISO   EQU  P0.0 
MOSI   EQU  P0.1 
SCLK   EQU  P0.2
CE_ADC EQU  P0.3
BEEP   EQU  P0.4

TATOL  EQU  2*256 ;2degC ;DEPRECATED
SSR	   EQU  P0.7

LM335  EQU  1
THERMO EQU  0


;Temperature Constants
;state constants
INITIAL		EQU #1
PREHEAT 	EQU #2
SOAK 		EQU #3
REFLOW		EQU #4
COOLDOWN	EQU #5
SAFE		EQU #6 


;rate costants
PREHEAT_R	EQU #1
REFLOW_R	EQU #2
;temp constants
COOLDOWN_temp	EQU #60
BSEG

;math32
mf: dbit 1
run: dbit 1
stateChange: dbit 1
RotNextTime: dbit 1

CSEG

;COMMS=========================================================================
SERmsg1: DB 'Target: ', 0
SERmsg2: DB 0xB0, 'C , Actual: ', 0
SERmsg3: DB 0xB0, 'C , Room: ', 0
SERmsg4: DB 0xB0, 'C', 0AH, 0DH, 0

;LCD===========================================================================
;------------------------------------------------------------------------------
; look up tables for strings example, REMENBER on 16 char long in ASCII 
;------------------------------------------------------------------------------
LCDmsgSTOP:		db 'STOP    ',0
LCDmsgPREHEAT:	db 'PREHEAT ',0
LCDmsgSOAK:		db 'SOAK    ',0
LCDmsgREFLOW:	db 'REFLOW  ',0
LCDmsgCOOLING:	db 'COOLING ',0
LCDmsgSAFE:		db 'SAFE    ',0
LCDmsgTi:		db 'Ti: ',0
LCDmsgTa:		db 'Ta: ',0
LCDcfgSoakTemp:	db 'Set Soak Temp:  ',0
LCDcfgSoakTime:	db 'Set Soak Time:  ',0
LCDcfgReflowTemp:	db 'Set Reflow Temp:',0

$LIST
