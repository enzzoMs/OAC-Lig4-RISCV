.text

# ====================================================================================================== # 
# 						TABULEIRO				                 #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Código responsável por inicializar o tabuleiro do jogo, com a renderização do menu do tabuleiro de	 # 
# acordo com as escolhas feitas pelo jogador								 #
#													 #
# ====================================================================================================== #

INICIALIZAR_TABULEIRO:
	# Procedimento principal de tabuleiro.s, ele comanda a chamada a outros procedimentos para a 
	# renderização dos elementos do tabuleiro do jogo 
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Imprimindo o tabuleiro no frame 0
		la a0, tabuleiro		# carrega a imagem
		li a1, 0xFF000000		# seleciona como argumento o frame 0
		call PRINT_TELA	

	# Primeiro é necessário inicializar o menu do tabuleiro com as informações dadas pelo jogador,
	# nesse caso, a dificuldade e a cor das peças
	
	# Calculando o endereço onde colocar a dificuldade no menu
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 104		# a1 = número da coluna onde começa a imagem = 104
		li a2, 10		# a1 = número da linha onde começa a imagem  = 10
		call CALCULAR_ENDERECO	

	mv a1, a0			# move o endereço retornado para a1

	la a0, texto_dificuldades	# carrega a imagem em a0	
	addi a0, a0, 8			# pula para onde começa os pixels no .data
	
	li t0, 300		# para encontrar o texto da dificuldade escolhida pelo jogador
	mul t0, s1, t0		# basta fazer essa multiplicaçaõ. t0 tem a quantidade de pixels
				# entre um texto e outro, de forma que o valor de s1 (dificuldade 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels é necessário pular para
				# encontrar o texto certo 
	
	# Imprime o texto da dificuldade no menu
		# a0 tem o endereço da imagem 
	 	# a1 tem o endereço de onde a imagem deve ser renderizada
		li a2, 30 			# numero de colunas da imagem
		li a3, 10 			# numero de linhas da imagem
		call PRINT_IMG
	
	# Agora é precisa imprimir a imagem das peças no menu

	la t2, pecas_menu		# carrega a imagem base em a0
	addi t2, t2, 8			# pula para onde começa os pixels no .data
	
	addi t3, t2, 210		# passa t3 para a próxima imagem
	
	# De acordo com o acima t2 tem o endereço da peça VERMELHA e t3 da peça AMARELA
	# Agora é necessário decidir qual é a peça do jogador e qual é do computador
	
	# Por padrão t2 é a peça do jogador e t3 a do computador, caso s0 for diferente de zero então
	# isso significa que o jogador escolheu as peças amarelas, então os endereços de t2 e t3 são trocados
	beq s0, zero, NAO_TROCAR_PECAS
		mv t0, t2	# temp = t2
		mv t2, t3	# t2 = t3
		mv t3, t0	# t3 = temp
	
	NAO_TROCAR_PECAS:
	
	# Calculando o endereço onde colocar a cor da peça do jogador no menu
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 260		# a1 = número da coluna onde começa a imagem = 260
		li a2, 8		# a1 = número da linha onde começa a imagem  = 8
		call CALCULAR_ENDERECO	

	mv a1, a0			# move o endereço retornado para a1

	# Imprime a peça no menu
		mv a0, t2 		# move para a0 o endereço de t2
	 	# a1 tem o endereço de onde a imagem deve ser renderizada
		li a2, 15 			# numero de colunas da imagem
		li a3, 14 			# numero de linhas da imagem
		call PRINT_IMG

	# Calculando o endereço onde colocar a cor da peça do computador no menu
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 282		# a1 = número da coluna onde começa a imagem = 282
		li a2, 29		# a1 = número da linha onde começa a imagem  = 29
		call CALCULAR_ENDERECO	

	mv a1, a0			# move o endereço retornado para a1

	# Imprime a peça no menu
		mv a0, t3 		# move para a0 o endereço de t3
	 	# a1 tem o endereço de onde a imagem deve ser renderizada
		li a2, 15 		# numero de colunas da imagem
		li a3, 14 		# numero de linhas da imagem
		call PRINT_IMG

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

# ====================================================================================================== #

.data
	.include "../Imagens/tabuleiro/tabuleiro.data"
	.include "../Imagens/tabuleiro/texto_dificuldades.data"
	.include "../Imagens/tabuleiro/pecas_menu.data"	
