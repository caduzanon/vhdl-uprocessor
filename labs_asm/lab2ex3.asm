	li s2,0x10010100
	li s3, 0x10011100
	
	addi s4, zero, 1
	addi s5, zero, 40
	addi s1, zero, 1
	
numero:	sw s1, 0(s2)	
	add, s1, s1, s4	
	addi s2, s2, 4
	addi s5, s5, -1
	bnez s5, numero
	
	li s2,0x10010100
	addi s5, zero, 40

troca:	lw s6, (s2)
	sw s6, (s3)
	sw zero, (s2)
	addi s2, s2, 4
	addi s3, s3 4
	addi s5, s5, -1
	bnez s5, troca
			
	nop
