.data
	nl:     .asciiz "\n"
.text
# funcoes do scheduler
# ver se a input queue ta cheia e criar o request
# designar o request pra cada elevador

Scheduler_process:
	inputQueue_check:
	lw	$t0, 12($s0)
	beqz	$t0, exitScheduler	# se input vazio, sai do scheduler
	
	inputQueue_handler:
	lw	$t1, Elevador1_emMovimento
	lw	$t2, Elevador2_emMovimento
	add	$t0, $t1, $t2
	
	# carregando os valores de inputQueue
	lw	$t1, 0($s0)		# andar atual
	lw	$t2, 4($s0)		# desce/sobe	11/12
	lw	$t3, 8($s0)		# andar destino
	
	bnez	$t0, elevadorEmMovimento	# se os 2 estiverem parados
	elevadoresParados:
		lw	$t4, Elevador1_andarAtual
		lw	$t5, Elevador2_andarAtual
	
		sub	$t4, $t4, $t1
		sub	$t5, $t5, $t1
	
		bgez	$t4, elev1positivo
		sub	$t4, $zero, $t4
	
		elev1positivo:
		bgez	$t5, elev2positivo
		sub	$t5, $zero, $t5
	
		elev2positivo:
		bgt	$t4, $t5, requestElevador2
		requestElevador1:
		la	$t6, Elevador1_request
		j	fillRequest
		
		requestElevador2:
		la	$t6, Elevador2_request
		j	fillRequest
				
		fillRequest:
		sw	$t1, 0($t6)
		sw	$t2, 4($t6)
		sw	$t3, 8($t6)
		
		sw	$zero, 0($s0)
		sw	$zero, 4($s0)
		sw	$zero, 8($s0)
		sw	$zero, 12($s0)
			
		j	exitScheduler
		
	elevadorEmMovimento:
	bgt	$t0, 1, doisEmMovimento
	umEmMovimento:
	# verifica se o que esta em movimento passa pelo local, e esta na direcao certa
	# se nao manda o request pro outro elevador
		lw	$t4, Elevador1_emMovimento
		lw	$t5, Elevador2_emMovimento
		beqz	$t4, elevador2_Movendo
		
		elevador1_Movendo:
			lw	$t4, Elevador1_andarAtual
			lw	$t5, Elevador1_andarDestino
		
			sub	$t6, $t4, $t5
			beq	$t2, 12, elevador1_verifyRequestSobe
			elevador1_verifyRequestDesce:
			blt	$t6, $zero, requestElevador2
			blt	$t4, $t1, requestElevador2	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t5, $t1, requestElevador2	# se o andar destino for maior que o requisitoado
			j	requestElevador1
		
			elevador1_verifyRequestSobe:
			bgt	$t6, $zero, requestElevador2
			blt	$t5, $t1, requestElevador2	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t4, $t1, requestElevador2	# se o andar destino for maior que o requisitoado
			j	requestElevador1
		
		###########################################################################
		elevador2_Movendo:
			lw	$t4, Elevador2_andarAtual
			lw	$t5, Elevador2_andarDestino
		
			sub	$t6, $t4, $t5
			beq	$t2, 12, elevador2_verifyRequestSobe
			elevador2_verifyRequestDesce:
			blt	$t6, $zero, requestElevador1
			blt	$t4, $t1, requestElevador1	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t5, $t1, requestElevador1	# se o andar destino for maior que o requisitoado
			j	requestElevador2
		
			elevador2_verifyRequestSobe:
			bgt	$t6, $zero, requestElevador1
			blt	$t5, $t1, requestElevador1	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t4, $t1, requestElevador1	# se o andar destino for maior que o requisitoado
			j	requestElevador2
	
	doisEmMovimento:
			lw	$t4, Elevador1_andarAtual
			lw	$t5, Elevador1_andarDestino
		
			sub	$t6, $t4, $t5
			beq	$t2, 12, elevador1_verifyMovingRequestSobe
			elevador1_verifyMovingRequestDesce:
			blt	$t6, $zero, elevador2_RequestTest
			blt	$t4, $t1, elevador2_RequestTest	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t5, $t1, elevador2_RequestTest	# se o andar destino for maior que o requisitoado
			j	requestElevador1
		
			elevador1_verifyMovingRequestSobe:
			bgt	$t6, $zero, elevador2_RequestTest
			blt	$t5, $t1, elevador2_RequestTest	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t4, $t1, elevador2_RequestTest	# se o andar destino for maior que o requisitoado
			j	requestElevador1
		
		###########################################################################
		elevador2_RequestTest:
			lw	$t4, Elevador2_andarAtual
			lw	$t5, Elevador2_andarDestino
		
			sub	$t6, $t4, $t5
			beq	$t2, 12, elevador2_verifyMovingRequestSobe
			elevador2_verifyMovingRequestDesce:
			blt	$t6, $zero, systemPause
			blt	$t4, $t1, systemPause	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t5, $t1, systemPause	# se o andar destino for maior que o requisitoado
			j	requestElevador2
		
			elevador2_verifyMovingRequestSobe:
			bgt	$t6, $zero, systemPause
			blt	$t5, $t1, systemPause	# se o andar do elevador for menor que o do pedido, manda pro outro
			bgt	$t4, $t1, systemPause	# se o andar destino for maior que o requisitoado
			j	requestElevador2
			
			
	systemPause:
		#ADD CODE
		
		j	exitScheduler

exitScheduler:
	la	$t0, Elevador1_request
	lw	$t2, 0($t0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	lw	$t2, 4($t0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	lw	$t2, 8($t0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	la   $a0, nl
        li   $v0, 4
        syscall
        
        la	$t0, Elevador2_request
	lw	$t2, 0($t0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	lw	$t2, 4($t0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	lw	$t2, 8($t0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	la   $a0, nl
        li   $v0, 4
        syscall
        
        la   $a0, nl
        li   $v0, 4
        syscall
	
	
	jr	$ra
