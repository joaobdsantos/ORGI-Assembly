.data

x:	.double 1.5708
n:	.word	20

.text
main:
	la	$a0, x
	lw	$a1, n
	
	jal sin
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	li	$v0, 10
	syscall

# Args, $a0: xAddr, $a1: iterations
# Returns: $f0, result
sin:
	addi 	$sp, $sp, -4	# increase stack
	sw   	$ra, 0($sp)    	# stores $ra on stack
	move	$t2, $a1	# setting iteration counter
	ldc1	$f4, 0($a0)	# loading x value
	move	$s0, $a0
	li	$t3, 3		# setting power value
	li	$t4, -1		# flag for operation (-/+)
	
	# -1 constant for signal inversion
	li	$t0, -1
	mtc1	$t0, $f8
	cvt.d.w	$f8, $f8

	# first iteration
	# x = x
	addi	$t2, $t2, -1
	
	sin_loop:
	move	$a0, $s0	# setting x addr arg0
	move	$a1, $t3	# setting power arg1
	jal	power		# f0 = x^pow
	
	mov.d   $f12, $f0
	
	move	$a0, $t3	# setting factorial value
	jal	factorial
	
	mov.d   $f6, $f0	# $f6 = fat
	
	div.d	$f6, $f12, $f6
	
	bgtz	$t4, positive
	
	negative:
	mul.d	$f6, $f6, $f8
	
	positive:
	add.d	$f4, $f4, $f6
	
	# variable update for next iteration
	mul	$t4, $t4, -1	# inverting flag
	addi	$t3, $t3, 2	# pow += 2
	addi	$t2, $t2, -1	# iteration--
	bnez	$t2, sin_loop
	
	mov.d	$f0, $f4
	lw	$ra, 0($sp)    	# loads $ra
	addi	$sp, $sp, 4    	# free stack space
	jr	$ra


# Args, $a0: numberAddr, $a1: exponent
# Returns: $f0, result
# Uses $t0-1, $f0-3
power:
	ldc1	$f2, 0($a0)	# float number
	move	$t0, $a1	# exponent
	
	# initializing acc 1
	li	$t1, 1
	mtc1	$t1, $f0
	cvt.d.w	$f0, $f0
	
	power_loop:
	mul.d	$f0, $f2, $f0	# acc = acc * x
	addi	$t0, $t0, -1
	
	bnez	$t0, power_loop
	
	jr	$ra

# Args, $a0: number
# Returns: $f0, result
factorial:
	move	$t0, $a0	# n
	li	$t1, 1
	mtc1	$t1, $f0
	cvt.d.w	$f0, $f0
	beq	$t0, $zero, factorial_end
	
	factorial_loop:
	mtc1	$t0, $f10
	cvt.d.w	$f10, $f10
	
	mul.d	$f0, $f0, $f10
	
	addi	$t0, $t0, -1
	bnez	$t0, factorial_loop
	
	factorial_end:
	jr	$ra