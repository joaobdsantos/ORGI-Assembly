.data

x:		.double 36
estimativa:	.double 1
n:		.word 10

.text
main:
	la	$a0, estimativa
	la	$a1, x
	la	$a2, n
	
	jal	raiz_quadrada
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	li	$v0, 10
	syscall

raiz_quadrada:
	ldc1	$f0, 0($a0)	# estimativa
	ldc1	$f2, 0($a1)	# x
	## O MIPS não permite carregar um inteiro direto em um reg float, precisa jogar em outro reg
	# iniciando a constante 2 em %f4
	li	$t0, 2
	mtc1	$t0, $f4
	cvt.d.w	$f4, $f4
	
	lw	$t0, 0($a2)	# n
	li	$t1, 0		# instanciando contador de 0 ate n
	
	loop:
	div.d	$f6, $f2, $f0	# f6 = x/est
	add.d	$f6, $f6, $f0	# f6 = x/est + est
	div.d	$f0, $f6, $f4	# estimativa
	
	addi	$t1, $t1, 1
	blt	$t1, $t0, loop
	
	jr	$ra
