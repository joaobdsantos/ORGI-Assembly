.data	
	matriz: .space 1024
	row:	.word 0
	col:	.word 0
	value:	.word 0
	
.text
main:
	la	$s0, row
	la	$s1, col
	la	$s2, matriz
	la	$s3, value
			
	li	$t0, 0
	sw	$t0, 0($s0)
	row_loop:
	bge	$t0, 16, end_row
	##for da coluna
	li	$t1, 0
	sw	$t1, 0($s1)
		col_loop:
		bge	$t1, 16, end_col
		
		lw	$t3, 0($s3)	#carrega var value
		#atualizar data
		#mul	$t4, $t0, 64	#ajusta o immediate para row*64
		sll	$t4, $t0, 6
		add	$t5, $s2, $t4	#endereco + imediate (row*64)
		sll	$t4, $t1, 2
		add	$t5, $t5, $t4	#endereco + imediate (row*64 + col*4)
		
		sw	$t3, 0($t5)
		
		addi	$t3, $t3, 1	#incrementa value
		sw	$t3, 0($s3)	
		
		lw	$t1, 0($s1)
		addi	$t1, $t1, 1	#incrementa col
		sw	$t1, 0($s1)
		j	col_loop
		end_col:
	
	lw	$t0, 0($s0)
	addi	$t0, $t0, 1	#incrementa row
	sw	$t0, 0($s0)
	j	row_loop
	end_row:

	li	$v0, 10
	syscall