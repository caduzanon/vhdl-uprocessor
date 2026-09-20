		addi s1, zero, 0
		addi s2, zero, 31
		addi s5, zero, 32
		
		beqz s1, comparamaior
		bge s1, zero, comparamaior
		bltz s1, comparamenor
	
comparamaior: 	beq s2, s5, dois
		bge s2, s5, um
		blt s2, s5, tres
		
comparamenor: 	beq s2, s5, cinco
		bge s2, s5, quatro
		blt s2, s5, seis
	
um:		addi s3, zero, 1
		b end

dois:		addi s3, zero, 2
		b end

tres:		addi s3, zero, 3
		b end
	
quatro:		addi s3, zero, 4
		b end
	
cinco:		addi s3, zero, 5
		b end
	
seis:		addi s3, zero, 6
		
end:		nop