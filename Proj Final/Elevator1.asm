.text
Elevator1_process:
	elevador1_AttendRequest:
	la	$t1, Elevador1_request
	lw	$t2, 4($t1)
	beqz	$t2, elevador1_MoveLogic	# verifica se tem request
	
	lw 	$t0, Elevador1_emMovimento
	bnez	$t0, elevador1_RequestMovendo
	
	elevador1_RequestParado:
	lw	$t0, 8($t1)	# destino final do request
	li	$t1, 1
	sw	$t0, Elevador1_andarDestino
	sw	$t1, Elevador1_emMovimento
	j	elevador1_ClearRequest
	
	elevador1_RequestMovendo:
	lw	$t0, 8($t1)			# carregando o destino final do request
	lw	$t2, Elevador1_andarDestino	# carregando o detino atual
	bge	$t2, $t0, elevador1_MoveLogic
	sw	$t0, Elevador1_andarDestino
	j	elevador1_ClearRequest
	
	elevador1_ClearRequest:
	la	$t1, Elevador1_request
	sw	$zero, 0($t1)
	sw	$zero, 4($t1)
	sw	$zero, 8($t1)
	j	elevador1_MoveLogic
	
	elevador1_MoveLogic:
	lw 	$t0, Elevador1_emMovimento
	
	verificaMovimento1:
		beqz	$t0, exitElevator1
	taMovendo1:
		lw	$t1, Elevador1_passoTimer
		addi 	$t1, $t1, 1000
		sw	$t1, Elevador1_passoTimer
		bge	$t1, 4000, passaAndar1
		j	exitElevator1
	passaAndar1:
		sw	$zero, Elevador1_passoTimer
		lw	$t4, Elevador1_andarAtual
		lw	$t5, Elevador1_andarDestino
		blt	$t4, $t5, subindo1
	descendo1:
		subi	$t4, $t4, 1
		j	noMesmoLugar1
	subindo1:
		addi	$t4, $t4, 1
	noMesmoLugar1:
		sw	$t4, Elevador1_andarAtual
		bne	$t4, $t5, exitElevator1
		sw	$zero, Elevador1_emMovimento

exitElevator1:
	jr	$ra
