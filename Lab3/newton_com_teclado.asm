.data

linha:       		.word 0xFFFF0012      		# Endereço relativo à linha do teclado
leitura_teclado:	.word 0xFFFF0014      		# Endereço relativo à leitura da tecla



x:		.double 293
estimativa:	.double 1
n:		.word 10
espaco:		.asciiz "     "


# Tabela com os valores dos numeros no display de 7 segmentos
tabela_valores: 	.word 0, 1, 2, 3  	 
           		.word 4, 5, 6, 7   	
           		.word 8, 9, 10, 11   	
           		.word 12, 13, 14, 15   	

# Tabela dos códigos do teclado do digital lab sim
tabela_codigos: 	.byte 0x11,0x21,0x41,0x81
           		.byte 0x12,0x22,0x42,0x82
           		.byte 0x14,0x24,0x44,0x84
           		.byte 0x18,0x28,0x48,0x88




.text
main:
	la	$a0, estimativa
	la	$a1, x
	
	lw 	$t9, linha			# Carrega o endereço da ativação da linha no registrador t0
	lw 	$t8, leitura_teclado		# Carrega o endereço relativo à leitura no registrador t1
	li	$t3, 1
	jal	lendo_teclado
	
	
	
	#la	$a2, 0($v0)		# Le do teclado e carrega em a2 o numero de iteracoes
	sw	$v0, n
	la	$a2, n
	
	
	jal	raiz_quadrada_newton
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	li 	$v0, 4
	la	$a0, espaco	# Printando um espaco entre as duas respostas
	syscall
	
	li	$v0, 3
	sqrt.d 	$f12, $f2	# Calculo da raiz por uso da funcao
	syscall
	
	li	$v0, 10
	syscall



lendo_teclado:
		sb	$t3, 0($t9)			# Ativa a linha, carregando o valor de t3 no endereço de ativação da linha
		lb	$t4, 0($t8)			# Le a tecla e armazena em t4
		bne 	$t4, $zero, pressionada		# Compara t4 com zero para saber se alguma tecla foi pressionada, se foi, passa para o proximo bloco
		sll	$t3, $t3, 1			# Da shift left em t3 para assim ativar a proxima linha, exemplo 0001 (linha 1) -> 0010 (linha 2)
		ble  	$t3, 8, lendo_teclado		# Enquanto t3 for menor ou igual a 8(ou seja, enquanto ainda nao tiver passado por todas as linhas), mantem o loop
		j	fim				# Nenhuma tecla pressionada até o final, jogando assim para o fim do programa
	 
	pressionada:
		li 	$t3, 0				# Carrega 0 em t3 para servir de contador futuramente
		la 	$t5, tabela_codigos		# Carrega a tabela dos codigos do teclado para comparar com o resultado adquirido
		
	traduzir_tecla:
		lb	$t6, 0($t5)			# Carrega em t6 o byte referente a t5 (no primeiro caso, o byte 0x11)
		beq	$t6, $t4, iguais		# Verifica se o byte de t6 é igual ao byte t4(byte salvo pelo teclado), se for, passa para o proximo bloco
		addi	$t3, $t3, 1			# Adiciona 1 ao contador
		addi	$t5, $t5, 1			# Adiciona 1 a t5 para checar o proximo byte ( em primeira instacia, após verificar que 0x11 nao é o byte desejado, passa para 0x21)
		blt  	$t3, 16, traduzir_tecla		#Fica nesse loop até o contador resultar em 16(passou por todas as teclas)
		j	fim				#Não achou tecla pressionada, jogando assim para o fim do programa
		
	iguais:
		la	$t7, tabela_valores		# Carrega em t7 a tabela dos numeros traduzidos em seus segmentos
		li	$t5, 4				# Multiplica t5 por 4 por serem palavras
		mul 	$t3, $t3, $t5
		add	$t7, $t7, $t3			# Soma t7 com o contador (t3) para assim ter o deslocamento referente a qual byte foi equivalente na tabela anterior
		lw	$v0, 0($t7)			# Carrega este byte em t8
		jr	$ra








raiz_quadrada_newton:
	ldc1	$f0, 0($a0)	# estimativa
	ldc1	$f2, 0($a1)	# x
	## O MIPS nao permite carregar um inteiro direto em um reg float, precisa jogar em outro reg
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
	
	
fim:
	li	$v0, 10
	syscall
