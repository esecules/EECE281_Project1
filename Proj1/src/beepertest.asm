$MODDE2
org 0000H
   ljmp MyProgram
org 000BH
	ljmp ISR_Timer0
	
$include(var.asm)

org 1337H
$include(math32.asm)

$include(utilities.asm)
$include(beeper.asm)

MyProgram:
	LCALL InitDE2
	LCALL initTimer0
	mov P0MOD, #00000011B
	setb EA
Forever:
	LCALL beeper
	sjmp Forever
END