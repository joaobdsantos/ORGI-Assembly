.text
main:
	la	$s0, inputQueue
	la	$s1, displayTable
	lw	$s2, ledE_end
	lw	$s3, ledD_end
	li	$s6, -2
	li	$s7, -2	
Loop_main:
	jal	IOHandler_process
	jal	Scheduler_process
	jal	Elevator1_process
	jal	Elevator2_process
	
	lw	$t1, Elevador1_andarAtual
	la 	$t0, ($s1)
	add	$t0, $t0, $t1
	lb 	$t2, 0($t0)
	sb 	$t2, 0($s2)					# escreve o valor no display
	
	lw	$t1, Elevador2_andarAtual
	la 	$t0, ($s1)
	add	$t0, $t0, $t1
	lb 	$t2, 0($t0)
	sb 	$t2, 0($s3)
	
	li   $a0, 100
	jal  DELAY_PROC
	
	
	

	j Loop_main
	
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
	
.include	"IOHandler.asm"
.include	"Scheduler.asm"
.include	"Constants.asm"
.include	"Elevator1.asm"
.include	"Elevator2.asm"
