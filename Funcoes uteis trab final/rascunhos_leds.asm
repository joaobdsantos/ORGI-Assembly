.data
	led_dir: 		.word 0xFFFF0010   				# endereço do display de 7 segmentos
	tabela_segmentos: 	.byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07  
.text

li	$s2, 7									#limitar até onde vai o elevador
lw 	$s1, led_dir     							# carrega o endereço do display
la 	$s0, tabela_segmentos      						# padrão para o número "1"
inicio:
li	$t1,0

	main:
		la 	$t0, ($s0)
		add	$t0, $t0, $t1
		
		lb 	$t2, 0($t0)
		sb 	$t2, 0($s1)       					# escreve o valor no display
		
		addi	$t1, $t1, 1
		
		li 	$v0, 32       						# código do serviço = 32 → "Sleep"
		li 	$a0, 1000     						# tempo de espera em milissegundos (ex: 1000 = 1 segundo)
		syscall
		
		ble	$t1, $s2,main
		j	inicio
