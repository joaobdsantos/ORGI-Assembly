.text
Elevator2_process:
	elevador2_AttendRequest:
	la	$t1, Elevador2_request
	lw	$t2, 4($t1)
	beqz	$t2, elevador2_MoveLogic	# verifica se tem request
	
	lw 	$t0, Elevador2_emMovimento
	bnez	$t0, elevador2_RequestMovendo
	
	elevador2_RequestParado:
	lw	$t0, 0($t1)	# destino final do request pegando o andar atual da pessoa
	lw	$s6, 8($t1)
	li	$t1, 1
	sw	$t0, Elevador2_andarDestino
	sw	$t1, Elevador2_emMovimento
	j	elevador2_ClearRequest

	#################
	elevador2_RequestMovendo:
	la	$t1, Elevador2_request
	lw	$t2, 4($t1)
	beq	$t2, 11, elevador2_RequestMovendo_descendo
	
	elevador2_RequestMovendo_subuindo:
	bne	$s6,-2, elevador2_RequestMovendo_subindo_buscando
	lw	$t0, 8($t1)			# carregando o destino final do request
	lw	$t2, Elevador2_andarDestino	# carregando o detino atual
	bge	$t2, $t0, elevador2_MoveLogic 	####era t2
	sw	$t0, Elevador2_andarDestino
	j	elevador2_ClearRequest
	
	elevador2_RequestMovendo_subindo_buscando:
	lw	$t0, 8($t1)			# carregando o destino final do request
	#lw	$t2, Elevador1_andarDestino	# carregando o detino atual
	bge	$s6, $t0, elevador2_MoveLogic 	####era t2
	#sw	$t0, Elevador1_andarDestino
	move	$s6, $t0
	j	elevador2_ClearRequest
	
	
	
	
	
	elevador2_RequestMovendo_descendo:
	bne	$s6, -2, elevador2_RequestMovendo_descendo_buscando
	lw	$t0, 8($t1)			# carregando o destino final do request
	lw	$t2, Elevador2_andarDestino	# carregando o detino atual
	ble	$t2, $t0, elevador2_MoveLogic 	####era t2
	sw	$t0, Elevador2_andarDestino
	j	elevador2_ClearRequest
	
	elevador2_RequestMovendo_descendo_buscando:
	lw	$t0, 8($t1)			# carregando o destino final do request
	#lw	$t2, Elevador2_andarDestino	# carregando o detino atual
	ble	$s6, $t0, elevador2_MoveLogic 	####era t2
	#sw	$t0, Elevador2_andarDestino
	move	$s6, $t0
	j	elevador2_ClearRequest
	##################
	elevador2_ClearRequest:
	la	$t1, Elevador2_request
	sw	$zero, 0($t1)
	sw	$zero, 4($t1)
	sw	$zero, 8($t1)
	j	elevador2_MoveLogic
	
	elevador2_MoveLogic:
	lw 	$t0, Elevador2_emMovimento
	
	verificaMovimento2:
		beqz	$t0, exitElevator2
	taMovendo2:
		lw	$t1, Elevador2_passoTimer
		addi 	$t1, $t1, 100
		sw	$t1, Elevador2_passoTimer
		bge	$t1, 4000, passaAndar2
		j	exitElevator2
	passaAndar2:
		sw	$zero, Elevador2_passoTimer
		lw	$t4, Elevador2_andarAtual
		lw	$t5, Elevador2_andarDestino
		blt	$t4, $t5, subindo2
		beq	$t4, $t5, noMesmoLugar2
	descendo2:
		subi	$t4, $t4, 1
		j	noMesmoLugar2
	subindo2:
		addi	$t4, $t4, 1
	noMesmoLugar2:
		sw	$t4, Elevador2_andarAtual
		bne	$t4, $t5, exitElevator2
		
		bne	$s6, -2, trocaDestino2				#Atual do pedido -> Final do elevador /// Final do pedido -> s6 /// vê se tem algo em s6, 
		
		
		sw	$zero, Elevador2_emMovimento
		j exitElevator2
trocaDestino2:
		sw	$s6, Elevador2_andarDestino			
		li	$s6, -2
exitElevator2:
	jr	$ra
