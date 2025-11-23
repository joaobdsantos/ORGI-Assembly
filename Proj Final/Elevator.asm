
.text
Elevator_process:

	lw 	$t0, Elevador1_emMovimento
	lw	$t1, Elevador1_passoTimer
	
	verificaMovimento:
				beqz	$t0, exitElevator
	taMovendo:
				addi 	$t1, $t1, 100
				sw	$t1, Elevador1_passoTimer
				beq	$t1, 4000, passaAndar
				j	exitElevator	
	passaAndar:
				li	$t1, 0
				sw	$t1, Elevador1_passoTimer
				lw	$t4, Elevador1_andarAtual
				lw	$t5, Elevador1_andarDestino
				blt	$t4, $t5, subindo
	descendo:
		subi	$t4, $t4, 1
		j	noMesmoLugar
	subindo:
		addi	$t4, $t4, 1
	noMesmoLugar:
		sw	$t4, Elevador1_andarAtual
		bne	$t4, $t5, exitElevator
		sw	$zero, Elevador1_emMovimento
	
	
exitElevator:
	
	jr	$ra
