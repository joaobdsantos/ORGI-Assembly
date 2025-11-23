
.data



.text
main:
	la	$s0, inputQueue
Loop_main:
	#jal	IOHandler_process
	jal	Scheduler_process
	#Elavador_process
	j	Loop_main
	
.include	"IOHandler.asm"
.include	"Scheduler.asm"
#.include	"Constants.asm"