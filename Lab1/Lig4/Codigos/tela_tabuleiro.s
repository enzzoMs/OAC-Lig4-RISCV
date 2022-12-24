.text

# ====================================================================================================== # 
# 						TABULEIRO				                 #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# C�digo respons�vel por inicializar o tabuleiro do jogo, com a renderiza��o do menu do tabuleiro de	 # 
# acordo com as escolhas feitas pelo jogador, al�m de trabalhar a l�gica de intera��o entre o usu�rio e	 #
# o tabuleiro										       		 #
#													 #
# ====================================================================================================== #

INICIALIZAR_TABULEIRO:
	# Procedimento principal de tabuleiro.s, ele comanda a chamada a outros procedimentos para a 
	# renderiza��o dos elementos do tabuleiro do jogo 
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Imprimindo o tabuleiro no frame 0
		la a0, tabuleiro		# carrega a imagem
		li a1, 0xFF000000		# seleciona como argumento o frame 0
		call PRINT_TELA	

	# Primeiro � necess�rio inicializar o menu do tabuleiro com as informa��es dadas pelo jogador,
	# nesse caso, a dificuldade e a cor das pe�as
	
	# Calculando o endere�o onde colocar a dificuldade no menu
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 106		# a1 = n�mero da coluna onde come�a a imagem = 106
		li a2, 9		# a1 = n�mero da linha onde come�a a imagem  = 9
		call CALCULAR_ENDERECO	

	mv a1, a0			# move o endere�o retornado para a1

	la a0, texto_dificuldades	# carrega a imagem em a0	
	addi a0, a0, 8			# pula para onde come�a os pixels no .data
	
	li t0, 270		# para encontrar o texto da dificuldade escolhida pelo jogador
	mul t0, s1, t0		# basta fazer essa multiplica�a�. t0 tem a quantidade de pixels
				# entre um texto e outro, de forma que o valor de s1 (dificuldade 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels � necess�rio pular para
				# encontrar o texto certo 
	
	# Imprime o texto da dificuldade no menu
		# a0 tem o endere�o da imagem 
	 	# a1 tem o endere�o de onde a imagem deve ser renderizada
		li a2, 30 			# numero de colunas da imagem
		li a3, 9 			# numero de linhas da imagem
		call PRINT_IMG
	
	# Agora � precisa imprimir a imagem das pe�as no menu

	la t2, pecas_menu		# carrega a imagem base em a0
	addi t2, t2, 8			# pula para onde come�a os pixels no .data
	
	addi t3, t2, 110		# passa t3 para a pr�xima imagem
	
	# De acordo com o acima t2 tem o endere�o da pe�a VERMELHA e t3 da pe�a AMARELA
	# Agora � necess�rio decidir qual � a pe�a do jogador e qual � do computador
	
	# Por padr�o t2 � a pe�a do jogador e t3 a do computador, caso s0 for diferente de zero ent�o
	# isso significa que o jogador escolheu as pe�as amarelas, ent�o os endere�os de t2 e t3 s�o trocados
	beq s0, zero, NAO_TROCAR_PECAS
		mv t0, t2	# temp = t2
		mv t2, t3	# t2 = t3
		mv t3, t0	# t3 = temp
	
	NAO_TROCAR_PECAS:
	
	# Calculando o endere�o onde colocar a cor da pe�a do jogador no menu
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 258		# a1 = n�mero da coluna onde come�a a imagem = 258
		li a2, 9		# a1 = n�mero da linha onde come�a a imagem  = 9
		call CALCULAR_ENDERECO	

	mv a1, a0			# move o endere�o retornado para a1

	# Imprime a pe�a no menu
		mv a0, t2 		# move para a0 o endere�o de t2
	 	# a1 tem o endere�o de onde a imagem deve ser renderizada
		li a2, 11 			# numero de colunas da imagem
		li a3, 10 			# numero de linhas da imagem
		call PRINT_IMG

	# Calculando o endere�o onde colocar a cor da pe�a do computador no menu
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 282		# a1 = n�mero da coluna onde come�a a imagem = 282
		li a2, 27		# a1 = n�mero da linha onde come�a a imagem  = 27
		call CALCULAR_ENDERECO	

	mv a1, a0			# move o endere�o retornado para a1

	# Imprime a pe�a no menu
		mv a0, t3 		# move para a0 o endere�o de t3
	 	# a1 tem o endere�o de onde a imagem deve ser renderizada
		li a2, 11 		# numero de colunas da imagem
		li a3, 10 		# numero de linhas da imagem
		call PRINT_IMG

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

# ====================================================================================================== #

.data
	.include "../Imagens/tabuleiro/tabuleiro.data"
	.include "../Imagens/tabuleiro/texto_dificuldades.data"
	.include "../Imagens/tabuleiro/pecas_menu.data"	
