.include	"Constants.asm"

.data



.text

main:
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
	move	$a0, $t8
	li 	$v0, 1
	syscall
	

exitIO:
	li	$a0, 1000
	li 	$v0, 32
	syscall
	j main
