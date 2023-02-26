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
		la a0, matriz_tiles_tabuleiro		# carregando a imagem da matriz de tiles
		addi a0, a0, 8				# pula para onde come�a os pixels .data
		li a1, 0xFF000000			# seleciona como argumento o frame 0
		li a2, 16				# numero de colunas de tiles a serem impressos
		li a3, 12				# numero de linhas de tiles a serem impressos		
		la a4, tiles_tabuleiro			# carregando a imagem dos tiles
		addi a4, a4, 8				# pula para onde come�a os pixels .data
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
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

# ====================================================================================================== #

.data
	.include "../Imagens/tabuleiro/tiles_tabuleiro.data"
	.include "../Imagens/tabuleiro/matriz_tiles_tabuleiro.data"
	.include "../Imagens/tabuleiro/texto_dificuldades.data"
	.include "../Imagens/tabuleiro/pecas_menu.data"	
