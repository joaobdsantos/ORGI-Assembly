.data
	#Struct Elevadores
	Elevador1_andarAtual:  	.word 0
	Elevador1_andarDestino: .word 0
	Elevador1_emMovimento:	.word 0
	Elevador1_passoTimer:	.word 0
	Elevador1_request:	.word 0, 0, 0
	
	Elevador2_andarAtual:  	.word 0
	Elevador2_andarDestino: .word 0
	Elevador2_emMovimento:	.word 0
	Elevador2_passoTimer:	.word 0
	Elevador2_request:	.word 0, 0, 0
	
	#Leds
	ledD_end: 		.word 0xFFFF0010
	ledE_end: 		.word 0xFFFF0011
	
	#Teclado
	keyTable:
				.byte	0x11,0x21,0x41,0x81
				.byte	0x12,0x22,0x42,0x82
				.byte	0x14,0x24,0x44,0x84
				.byte	0x18,0x28,0x48,0x88

	displayTable:
				.byte	0x3F, 0x06, 0x5B, 0x4F		#0-3
				.byte	0x66, 0x6D, 0x7D, 0x07		#4-7
				.byte	0x7F, 0x6F, 0x77, 0x7C		#8-B
				.byte	0x39, 0x5E, 0x79, 0x71		#C-F
				
	key_lineEnable:		.word 	0xFFFF0012
	key_keyPressed:		.word	0xFFFF0014
	
	#IOs
	# Andar que esta, sobe/desce, andar destino, confirma
	inputQueue:		.word	-1,-1,-1,-1
	
	#reset sistema
	
	 
