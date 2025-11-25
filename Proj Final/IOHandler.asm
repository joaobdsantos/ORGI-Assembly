.text
IOHandler_process:
	lw	$t6, key_lineEnable		# line enable address
	lw	$t7, key_keyPressed	# key pressed data address
	li	$s4, 0xFFFF0011		# loading the display address
	j	readLoopReset

readLoopReset:
	li	$t0, 1			# key row selector
	li	$t1, 0			# row counter
	li	$t8, 0
	la	$t9, keyTable

readLoop:
	beq	$t1, 4, exitIO	# if 4 rows are read, reset

	sb	$t0, 0($t6)		# enabling line

	lb	$t3, 0($t7)		# loading data in register
	bnez	$t3, rowIncrement	# if not zero, key read

	addi	$t1, $t1, 1		# incrementing counter
	sll	$t0, $t0, 1		# going to next row
	j	readLoop

rowIncrement:
	mul	$t2, $t1, 4             # offset = row * 4
	add	$t8, $t8, $t2		# setting pointer to right row
	add	$t9, $t9, $t2


findKey:
	lb	$t5, 0($t9)		# loading keyTable first value
	beq	$t3, $t5, queueIO 	# checking if equal
	addi	$t8, $t8, 1		# incrementing if not equal
	addi	$t9, $t9, 1
	j	findKey

queueIO:
	# se queue esta vazia e for numero, adicionar
	lw	$t1, 0($s0)
	bne	$t1,-1, queue1NotEmpty	# se a posicao 1 estiver ocupada
	bge	$t8, 8, exitIO		# se nao for numero valido, ignora
	
	sw	$t8, 0($s0)
	j 	exitIO
	
	# se nao se queue tiver segundo slot vazio e for cima/baixo adicionar
	queue1NotEmpty:
	lw	$t1, 4($s0)
	bne	$t1,-1, queue2NotEmpty		# se a posicao 2 estiver toda ocupada
	bgt	$t8, 12, exitIO		# se o valor nao for 11 ou 12 nao e valido
	blt	$t8, 11, exitIO
	
	sw	$t8, 4($s0)
	j 	exitIO
	
	queue2NotEmpty:
	lw	$t1, 8($s0)
	bne	$t1, -1, queue3NotEmpty	# se a posicao 1 estiver ocupada
	bge	$t8, 8, exitIO		# se nao for numero valido, ignora
	
	sw	$t8, 8($s0)
	j 	exitIO
	
	queue3NotEmpty:
	lw	$t1, 12($s0)
	bne	$t1, -1, exitIO		# se a posicao 1 estiver ocupada
	bne	$t8, 15, exitIO		# se nao for confirma
	
	sw	$t8, 12($s0)
	j 	exitIO

exitIO:
	# TODO: colocar inputQueue em um $s
	lw	$t2, 0($s0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	lw	$t2, 4($s0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	lw	$t2, 8($s0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	lw	$t2, 12($s0)
	move	$a0, $t2
	li 	$v0, 1
	syscall
	
	#li	$a0, 1000
	#li 	$v0, 32
	#syscall
	
	la   $a0, nl
        li   $v0, 4
        syscall
	
	# volta pro programa
	jr	$ra
