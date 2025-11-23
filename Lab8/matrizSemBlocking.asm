.eqv	MAX 4	# Constante do tamanho da matriz

.data
A:	.float 1.0, 2.0, 3.0, 4.0,
	5.0, 6.0, 7.0, 8.0,
	9.0, 10.0, 11.0, 12.0,
	13.0, 14.0, 15.0, 16.0

B:	.float 10.0, 20.0, 30.0, 40.0,
	50.0, 60.0, 70.0, 80.0,
	90.0, 100.0, 110.0, 120.0,
	130.0, 140.0, 150.0, 160.0

newline: .asciiz "\n"
space:   .asciiz " "

.text
main:
	li	$s0, MAX    # s0 = MAX
	la	$s1, A      # endereço A
	la	$s2, B      # endereço B

	li	$t1, 0	# i = 0
	
for_i:
	beq	$t1, $s0, end_i

	li	$t2, 0	# j = 0
for_j:
beq	$t2, $s0, end_j

	# offset_A = (i * MAX + j) * 4
	mul	$t3, $t1, $s0
	add	$t3, $t3, $t2
	sll	$t3, $t3, 2
	add	$t4, $s1, $t3	# $t4 = endereço de A[i][j]
	l.s	$f0, 0($t4)	# $f0 = valor de A[i][j]

	# offset_B = (j * MAX + i) * 4
	mul	$t5, $t2, $s0
	add	$t5, $t5, $t1
	sll	$t5, $t5, 2
	add	$t6, $s2, $t5	# $t6 = endereço de B[j][i]
	l.s	$f1, 0($t6)	# $f1 = valor de B[j][i]

	# soma = A[i][j] + B[j][i]
	add.s	$f2, $f0, $f1

	# Armazena resultado de volta em A[i][j]
	s.s	$f2, 0($t4)

	addi	$t2, $t2, 1	# j++
	j	for_j

end_j:
	addi	$t1, $t1, 1	# i++
	j	for_i
	
end_i:
	# Fim do programa
	#jal print_matrix_A
	li	$v0, 10
	syscall


print_matrix_A:
	# Assume que $s0 = MAX e $s1 = endereço base de A
	li	$t0, 0		# i = 0
p_loop_i:
	beq	$t0, $s0, p_end_i
	li	$t1, 0		# j = 0
p_loop_j:
	beq	$t1, $s0, p_end_j

	# offset = (i * MAX + j) * 4
	mul	$t2, $t0, $s0	# i * MAX
	add	$t2, $t2, $t1	# + j
	sll	$t2, $t2, 2	# * 4 bytes
	add	$t3, $s1, $t2	# endereço A[i][j]

	# syscall para imprimir float (valor em $f12)
	l.s	$f12, 0($t3)
	li	$v0, 2
	syscall

	# syscall para imprimir espaço
	li	$v0, 4
	la	$a0, space
	syscall

	addi	$t1, $t1, 1	# j++
	j	p_loop_j
p_end_j:
	# syscall para imprimir nova linha ao fim da linha da matriz
	li	$v0, 4
	la	$a0, newline
	syscall

	addi	$t0, $t0, 1	# i++
	j	p_loop_i
p_end_i:
	jr	$ra
