
.include "IOHandler.asm"
.include "Scheduler.asm"


.data



.text	
Loop_main:
	li   $a0, 100
	jal  DELAY_PROC
	
	
DELAY_PROC:
	move $t0, $a0
	li $v0, 30
	syscall
	add $t0, $t0, $a0

loop:
	li $v0, 30
	syscall
	blt $a0, $t0, loop

	jr $ra