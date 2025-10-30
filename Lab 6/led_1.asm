.include "labels.asm"

.globl led_1

.data
led_end: .word 0xFFFF0011

tabela_segmentos: 	
	.byte 0x3F,0x06,0x5B,0x4F  	 
        .byte 0x66,0x6D,0x7D,0x07   	
        .byte 0x7F,0x6F,0x77,0x7C   	
        .byte 0x39,0x5E,0x79,0x71 
	
.text
led_1:
	la   $t7, tabela_segmentos
	
	la   $t1, led_end
	lw   $t1, 0($t1)          # agora $t1 = 0xFFFF0010
	

loop_led:
	lb   $t6, 0($t7)
	sb   $t6, 0($t1)          # escreve byte no LED
	addi $t7, $t7, 1
	
	
	li   $a0, 1000
	jal  DELAY_PROC
	
	
	

	beq $t6,0x71,led_1
	j loop_led

DELAY_PROC:
	move $t0, $a0
	li $v0, 30
	syscall
	add $t0, $t0, $a0

loop:
	li $v0, 30
	syscall
	blt $a0, $t0, loop

	jr $ra