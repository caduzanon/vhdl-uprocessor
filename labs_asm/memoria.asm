	li  s2,0x10011234
	addi s3, zero, 1
	addi s4, zero, 1000
	addi s1, zero, 1
	
numero:	sw s1, 0(s2)	
	add, s1, s1, s3	
	addi s2, s2, 4
	addi s4, s4, -1
	bnez s4, numero
	
	nop
