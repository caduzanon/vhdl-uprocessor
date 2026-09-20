		#
		# s0: numero inicial
		# s1: resultado final
		# s2: numero menor da soma a ser feita
		# s4: numero maior da soma a ser feita
		# s3: resultado do bloco multiplica
		#

		addi s0, zero, 8 #guardar o numero inicial

		#edge cases: 1 e 0 devem resultar em 1

		addi s1, zero, 1
		beq s0, zero, end
		beq s0, s1, end
		bne s0, s1, start

start:		addi s2, s0, -1 #guarda o inicial-1
		add s4, s4, s0 #copia para numero de iteracoes

		#loop: multiplicar numero e numero -1 ate numero-1 chegar em 1
loop:		b premul
post:		addi s1, zero, 0
		add s1, s1, s3 #colocar em s1 o resultado colocado em s3

		addi s2, s2, -1
		add s4, zero, s1 #coloca em s4 o valor de s1 (numero de vezes a somar)
		bne s2, zero, loop

		b end

premul:		addi s3, zero, 0
		#s4 guarda o numero de vezes para somar, s3 recebe o resultado, s2 contem o numero a ser somado
multiplica:	add s3, s3, s2 		#s3 (resultado) recebe a soma do numero em s2 s4 vezes
		addi s4, s4, -1
		bne s4, zero, multiplica
		beq s4, zero, post

end: 		nop
