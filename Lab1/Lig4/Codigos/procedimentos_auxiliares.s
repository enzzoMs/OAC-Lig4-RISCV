.text

# ====================================================================================================== # 
# 					PROCEDIMENTOS AUXILIARES				         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Este arquivo cont�m uma cole��o de procedimentos auxiliares com o objetivo de facilitar a execu��o de  # 
# certas tarefas ao longo da execu��o do programa.							 #
#													 #
# ====================================================================================================== #

PRINT_TELA:
	# Procedimento que imprime uma imagem de 320 x 240 no frame de escolha
	# Argumentos: 
	# 	a0 = endere�o da imgagem		
	# 	a1 = endere�o base do frame
	
	li t0, 76800		# area total da imagem -> 320 x 240 = 76800 pixels
	addi a0, a0, 8		# pula para onde come�a os pixels no .data

	LOOP_PRINT_IMG: 
		lw t1, 0(a0)			# pega 4 pixels do .data e coloca em t3
		sw t1, 0(a1)			# pega os pixels de t3 e coloca no bitmap
		addi a0, a0, 4			# vai para os pr�ximos pixels da imagem
		addi a1, a1, 4			# vai para os pr�ximos pixels do bitmap
		addi t0, t0, -4			# decrementa o contador de pixels restantes
		bne t0, zero, LOOP_PRINT_IMG	# se t0 != zero -> reinicia o loop
		
	ret 
	
# ====================================================================================================== #