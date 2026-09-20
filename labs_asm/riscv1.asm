		addi s8, zero, 30
comeco:		addi s0,zero,23
		add s1,s1, s0 
		addi s2,s2,01 		
		bne s2, s8, comeco
		add s5, zero, s1
		
		addi s0, zero, 0
		addi, s1, zero, 0
		addi, s2, zero, 0
		
		addi, s0, s0, 1
		addi, s8, zero, 40
segundo:	add, s1, s1, s0
		addi, s0, s0, 2
		addi, s2, s2, 01
		bne s2, s8, segundo