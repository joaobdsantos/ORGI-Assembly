.text
Elevator1_process:
	elevador1_AttendRequest:
	la	$t1, Elevador1_request
	lw	$t2, 4($t1)
	beqz	$t2, elevador1_MoveLogic	# verifica se tem request
	
	lw 	$t0, Elevador1_emMovimento
	bnez	$t0, elevador1_RequestMovendo
	
	elevador1_RequestParado:
	lw	$t0, 0($t1)	# destino final do request pegando o andar atual da pessoa
	lw	$s7, 8($t1)
	li	$t1, 1
	sw	$t0, Elevador1_andarDestino
	sw	$t1, Elevador1_emMovimento
	j	elevador1_ClearRequest

	#################
	elevador1_RequestMovendo:
	la	$t1, Elevador1_request
	lw	$t2, 4($t1)
	beq	$t2, 11, elevador1_RequestMovendo_descendo
	
	elevador1_RequestMovendo_subuindo:
	bnez	$s7, elevador1_RequestMovendo_subindo_buscando
	lw	$t0, 8($t1)			# carregando o destino final do request
	lw	$t2, Elevador1_andarDestino	# carregando o detino atual
	bge	$t2, $t0, elevador1_MoveLogic 	####era t2
	sw	$t0, Elevador1_andarDestino
	j	elevador1_ClearRequest
	
	elevador1_RequestMovendo_subindo_buscando:
	lw	$t0, 8($t1)			# carregando o destino final do request
	#lw	$t2, Elevador1_andarDestino	# carregando o detino atual
	bge	$s7, $t0, elevador1_MoveLogic 	####era t2
	#sw	$t0, Elevador1_andarDestino
	move	$s7, $t0
	j	elevador1_ClearRequest
	
	
	
	
	
	elevador1_RequestMovendo_descendo:
	bnez	$s7, elevador1_RequestMovendo_descendo_buscando
	lw	$t0, 8($t1)			# carregando o destino final do request
	lw	$t2, Elevador1_andarDestino	# carregando o detino atual
	ble	$t2, $t0, elevador1_MoveLogic 	####era t2
	sw	$t0, Elevador1_andarDestino
	j	elevador1_ClearRequest
	
	elevador1_RequestMovendo_descendo_buscando:
	lw	$t0, 8($t1)			# carregando o destino final do request
	#lw	$t2, Elevador1_andarDestino	# carregando o detino atual
	ble	$s7, $t0, elevador1_MoveLogic 	####era t2
	#sw	$t0, Elevador1_andarDestino
	move	$s7, $t0
	j	elevador1_ClearRequest
	##################
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
		
		bnez	$s7, trocaDestino				#Atual do pedido -> Final do elevador /// Final do pedido -> s7 /// vê se tem algo em s7, 
		
		
		sw	$zero, Elevador1_emMovimento
		j exitElevator1
trocaDestino:
		sw	$s7, Elevador1_andarDestino			
		li	$s7, 0
exitElevator1:
	jr	$ra
