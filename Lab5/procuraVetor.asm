.data
	sizePrompt:    .asciiz "Digite o tamanho do vetor: "
	vetorPrompt:   .asciiz "Digite "
	vetorPrompt2:  .asciiz " numeros para o vetor:\n"
	keyPrompt:     .asciiz "Digite o numero a procurar: "
	foundMsg:      .asciiz "Numero encontrado!\n"
	nfoundMsg:  	.asciiz "Numero nao encontrado.\n"
	
.text
.globl main
main:
	move	$fp, $sp
	# criando espaco na pilha para as vars locaais
	addi	$sp, $sp, -20
	#-4($fp) -> size
	#-8($fp) -> i
	#-12($fp) -> key
	#-16($fp) -> found
	#-20($fp) -> array (pointer)

	# printf tamanho do vetor
	li	$v0, 4
	la	$a0, sizePrompt
	syscall
	
	# scanf tamanho do vetor
	li	$v0, 5
	syscall
	sw	$v0, -4($fp)
	
	# alocando espaco do vetor
	lw	$t0, -4($fp)
	sll	$t0, $t0, 2	# size * 4
	sub	$sp, $sp, $t0
	sw	$sp, -20($fp)	# salva referencia
	
	# prompt digite size numeros
	li	$v0, 4
	la	$a0, vetorPrompt
	syscall
	li	$v0, 1
	lw	$a0, -4($fp)
	syscall
	li	$v0, 4
	la	$a0, vetorPrompt2
	syscall
	
	# for loop para preencher o vetor
	li	$t0, 0
	sw	$t0, -8($fp)
	
for_fill:
	# condicao
	lw	$t0, -8($fp)
	lw	$t1, -4($fp)
	bge	$t0, $t1, end_for_fill
	
	# scanf
	li	$v0, 5
	syscall
	lw	$t2, -20($fp)
	sll	$t1, $t0, 2	# t1 = i * 4
	add	$t1, $t2, $t1	# define o endereco = sp + (i*4)
	sw	$v0, 0($t1)
	
	#i++
	lw	$t0, -8($fp)
	addi	$t0, $t0, 1
	sw	$t0, -8($fp)
	j	for_fill
end_for_fill:
	
	# prompt numero procurar
	li	$v0, 4
	la	$a0, keyPrompt
	syscall
	
	# scanf key
	li	$v0, 5
	syscall
	sw	$v0, -12($fp)
	
	
	# recebe found = 0
	li	$t0, 0
	sw	$t0, -16($fp)
	
	# for busca
	li	$t0, 0
	sw	$t0, -8($fp)

for_busca:
	# condicao
	lw	$t0, -8($fp)
	lw	$t1, -4($fp)
	bge	$t0, $t1, end_for_busca
	
	# arr[i]==key
	lw	$t2, -20($fp)	#arr*
	sll	$t1, $t0, 2	#i*4
	add	$t1, $t2, $t1
	lw	$t3, 0($t1)	#arr[i]
	#compara
	lw	$t4, -12($fp)
	bne	$t3, $t4, endif_key
	
	# if true
	li	$t0, 1
	sw	$t0, -16($fp)
	j	end_for_busca
endif_key:
	lw	$t0, -8($fp)
	addi	$t0, $t0, 1
	sw	$t0, -8($fp)
	j	for_busca

end_for_busca:
	lw	$t0, -16($fp)
	beq	$t0, $zero, else_nfound

#found:
	li	$v0, 4
	la	$a0, foundMsg
	syscall
	j	endif_found

else_nfound:
	li	$v0, 4
	la	$a0, nfoundMsg
	syscall

endif_found:
	move	$sp, $fp
	li	$v0, 10
	syscall
	
