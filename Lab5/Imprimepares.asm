.data
	scanPrompt: .asciiz "Digite o limite do contador: "
	condPrompt: .asciiz "Contador: "
	quebraLinha: .asciiz "\n"


	limit: 	.word 0
	i:     	.word 0
	count: 	.word 0
	
	
.text
	addi $sp, $sp, -8
	# -4($fp) -> limit
	# -8($fp) -> count
	# -12($fp) -> i
	
	############
	#Scan limit#
	############
	li $v0, 4
	la $a0, scanPrompt
	syscall
	
	li $v0, 5
	syscall
	sw $v0, -4($fp)
	
	############
	#For par   #
	############
	for: 
	lw	$t0, -12($fp)
	li	$s1, 2
	div  	$t0, $s1
	mfhi	$t1
	
	beq	$t1, 0, cond_true
	j	isoma
	
	cond_true:
		#Carregar/add count
		lw	$t0, -8($fp)
		addi	$t0, $t0, 1
		sw	$t0, -8($fp)
		
		############
		#PrintCount#
		############
		li 	$v0, 4
		la 	$a0, condPrompt
		syscall
		
		li	$v0,1
		lw 	$a0, -12($fp)
		syscall
		
		li 	$v0, 4
		la 	$a0, quebraLinha
		syscall
	
	
	#i++
	isoma:
		lw	$t0, -12($fp)
		addi	$t0, $t0, 1
		sw	$t0, -12($fp)
		lw	$t2, -4($fp)
		blt	$t0, $t2, for
		
	li	$v0, 10
	syscall
	