.text
main:
	la	$s0, inputQueue
	la	$s1, displayTable
	lw	$s2, ledD_end
	lw	$s3, ledE_end
		
Loop_main:
	jal	IOHandler_process
	jal	Scheduler_process
	jal	Elevator1_process
	jal	Elevator2_process
	
	lw	$t1, Elevador1_andarAtual
	la 	$t0, ($s1)
	add	$t0, $t0, $t1
	lb 	$t2, 0($t0)
	sb 	$t2, 0($s2)       					# escreve o valor no display
	
	lw	$t1, Elevador2_andarAtual
	la 	$t0, ($s1)
	add	$t0, $t0, $t1
	lb 	$t2, 0($t0)
	sb 	$t2, 0($s3)
	
	li	$v0, 32
	li	$a0, 50
	syscall
	j	Loop_main
	
.include	"IOHandler.asm"
.include	"Scheduler.asm"
.include	"Constants.asm"
.include	"Elevator1.asm"
.include	"Elevator2.asm"
