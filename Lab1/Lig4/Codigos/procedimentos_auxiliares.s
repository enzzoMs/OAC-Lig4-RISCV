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

PRINT_IMG:
	# Procedimento que imprime imagens de tamanho variado, menores que 320 x 240, no frame de escolha
	# Argumentos: 
	# 	a0 = endere�o da imagem		
	# 	a1 = endere�o de onde, no frame escolhido, a imagem deve ser renderizada
	# 	a2 = numero de colunas da imagem
	#	a3 = numero de linhas da imagem
	
	PRINT_IMG_LINHAS:
		mv t0, a2		# copia do numero de a2 para usar no loop de colunas
			
		PRINT_IMG_COLUNAS:
			lb t1, 0(a0)			# pega 1 pixel do .data e coloca em t1
			sb t1, 0(a1)			# pega o pixel de t1 e coloca no bitmap
	
			addi t0, t0, -1			# decrementa o numero de colunas restantes
			addi a0, a0, 1			# vai para o pr�ximo pixel da imagem
			addi a1, a1, 1			# vai para o pr�ximo pixel do bitmap
			bne t0, zero, PRINT_IMG_COLUNAS	# reinicia o loop se t0 != 0
			
		addi a3, a3, -1			# decrementando o numero de linhas restantes
		sub a1, a1, a2			# volta o ende�o do bitmap pelo numero de colunas impressas
		addi a1, a1, 320		# passa o endere�o do bitmap para a proxima linha
		bne a3, zero, PRINT_IMG_LINHAS	# reinicia o loop se a3 != 0
			
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

SLEEP:	
	# Procedimento que fica em loop, parando a execu��o do programa, por alguns milissegundos
	# Argumentos:
	# 	a0 = durancao em ms do sleep
	
	csrr t0, time	# le o tempo atual do sistema
	add t0, t0, a0	# adiciona a t0 a durancao do sleep
	
	LOOP_SLEEP:
		csrr t1, time			# le o tempo do sistema
		blt t1, t0, LOOP_SLEEP 		# se o tempo de t1 < t0 reinicia o loop
	
	ret
				
# ====================================================================================================== #

ENCONTRAR_NUMERO_RANDOMICO:	
	# Procedimento que encontra um numero "randomico" entre 0 e a0 (nao inclusivo)
	# Argumentos:
	# 	a0 = limite superior para o numero randomico (nao inclusivo)
	# Retorno:
	# 	a0 = n�mero "r�ndomico" entre 0 e a0 - 1
 		
	csrr t0, time	# le o tempo atual do sistema
	
	rem a0, t0, a0	# encontra o resto da divis�o do tempo do sistema por a0 de modo que a0 
			# tem um numero entre 0 e a0 - 1 
			
	ret

# ====================================================================================================== #			