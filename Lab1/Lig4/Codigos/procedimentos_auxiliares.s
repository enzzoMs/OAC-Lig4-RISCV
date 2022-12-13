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
																	
CALCULAR_ENDERECO:
	# Procedimento que calcula um endere�o em um frame ou em uma imagem
	# Argumentos: 
	#	a0 = endere�o do base do frame ou imagem
	# 	a1 = numero da coluna onde calcular o endere�o
	# 	a2 = numero da linha onde calcular o endere�o
	# a0 = retorno com o endere�o
	
	li t0, 320			# t0 = 320
	
	mul t0, a2, t0			# t0 = linha x 320
	add a0, a0, a1			# a0 = ender�o base + coluna	
	add a0, a0, t0			# a0 = ender�o base + coluna + (linha x 320)

	ret 
	
# ====================================================================================================== #

VERIFICAR_TECLA_APERTADA:
	# Procedimento que verifica se alguma tecla foi apertada
	# Retorna a0 com o valor da tecla ou a0 = -1 caso nenhuma tecla tenha sido apertada		
	
	li a0, -1 		# a0 = -1
	 
	li t0, 0xFF200000	# carrega em t0 o endere�o de controle do KDMMIO
 	lw t1, 0(t0)		# carrega em t1 o valor do endere�o de t0
   	andi t1, t1, 1		# (t1 == 0) = n�o tem tecla, (t1 == 1) = tem tecla. 
   				# realiza opera��o andi de forma a deixar em t0 somente o bit necessario para an�lise
   	
    	beq t1, zero, FIM_VERIFICAR_TECLA	# (t1 == 0) = n�o tem tecla pressionada ent�o vai para fim
   		lw a0, 4(t0)				# le o valor da tecla no endere�o 0xFF200004
   		 	
	FIM_VERIFICAR_TECLA:					
		ret
			
# ====================================================================================================== #		
