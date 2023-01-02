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
	# Procedimento auxiliar que tem por objetivo usar uma matriz de tiles para imprimir uma imagem
	# de uma tela 
	# Cada tela do jogo � dividida em quadrados de 20 x 20, cada um desses quadrados �nicos configura 
	# um tile diferente. Esses tiles s�o organizados em uma imagem pr�pria de modo que cada 
	# tile fica um em baixo do outro (ver "../Imagens/menu_inicial/tiles_menu_inicial.bmp" para um exemplo).
	# Cada tile recebe um n�mero diferente que representa a posi��o do tile nessa imagem, 
	# dessa forma, as imagens das �reas podem simplesmente ser codificadas como uma matriz
	# em que cada elemento representa o n�mero de um tile, com isso, renderizar a imagem de uma
	# tela se trata apenas de analisar a matriz e encontrar os tiles correspondentes.
	# Como cada tile tem 20 x 20 eles recebem n�meros de modo que o tile na posi��o 1
	# est� a (20 * 20) * 1 pixels do �nicio da imagem, o tile na posi��o 5 est� a 
	# (20 * 10) * 5 pixels do incio, e assim por diante, facilitando o processo de "traduzir" os n�meros
	# da matriz para o tile correspondente 
	# Esse procedimento sempre imprime imagens de 320 x 240, ou seja, 16 x 12 tiles
	# Argumentos:
	# 	a4 = endere�o da matriz de tiles
	#	a5 = endere�o base do frame 0 ou 1 de onde os tiles v�o come�ar a ser impressos
	# 	a6 = imagem contendo os tiles
					
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
																
	li t2, 400	# t4 recebe 20 * 20 = 400, ou seja, a �rea de um tile							
	
	# o loop abaixo vai imprimir 16 x 12 tiles
	
	li t3, 12		# n�mero de linhas de tiles a serem impressos																													
																																																																																								
	PRINT_AREA_LINHAS:
		li t4, 16		# n�mero de colunas de tiles a serem impressos		
		mv t5, a5		# copia de a5 para usar no loop de colunas
				
		PRINT_AREA_COLUNAS:
			lb t0, 0(a4)	# pega 1 elemento da matriz de tiles e coloca em t0
		
			mul t0, t0, t2  # como dito na descri��o do procedimento t0 (n�mero do tile) * (20 * 20)
					# retorna quantos pixels esse tile est� do come�o da imagem
			
			add a0, a6, t0	# a0 recebe o endere�o do tile a ser impresso
			mv a1, t5	# a1 recebe o endere�o de onde imprimir o tile
			li a2, 20	# a2 = numero de colunas de um tile
			li a3, 20	# a3 = numero de linhas de um tile
			call PRINT_IMG
	
			addi a4, a4, 1		# vai para o pr�ximo elemento da matriz de tiles
			addi t5, t5, 20		# pula 20 colunas no bitmap j� que o tile impresso tem
						# 20 colunas de tamanho 
			
			addi t4, t4, -1			# decrementando o numero de colunas de tiles restantes
			bne t4, zero, PRINT_AREA_COLUNAS	# reinicia o loop se t4 != 0
			
		li t0, 6400		# t0 recebe 20 (n�mero de linhas impressas)  * 320 (tamanho de uma linha
					# do bitmap)
		add a5, a5, t0		# passa o endere�o do bitmap para a endere�o dos pr�ximos tiles

		addi t3, t3, -1			# decrementando o numero de linhas restantes
		bne t3, zero, PRINT_AREA_LINHAS	# reinicia o loop se t3 != 0
			
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
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
		sltu t1, t1, t0			# t1 recebe 1 se (t1 < t0) e 0 caso contr�rio
		bne t1, zero, LOOP_SLEEP 		# se o tempo de t1 != 0 reinicia o loop
		
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
