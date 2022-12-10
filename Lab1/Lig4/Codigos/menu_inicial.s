.text

# ====================================================================================================== # 
# 						MENU INICIAL				                 #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# C�digo respons�vel por renderizar o menu inicial do jogo, com a escolha da cor das pe�as e escolha da	 #
# dificuldade.										.                # 
#													 #
# ====================================================================================================== #

INICIALIZAR_MENU_INICIAL:
	# Procedimento principal de menu_inicial.s, ele comanda a chamada a outros procedimentos para a 
	# renderiza��o das telas do menu inicial
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	call RENDERIZAR_ESCOLHA_COR
	
	
		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

RENDERIZAR_ESCOLHA_COR:		
	# Procedimento que imprime a imagem do menu incial com a escolha da cor que o jogador vai jogar,
	# al�m de trabalhar a l�gica para a intera��o com o menu em si e a sele��o dessa cor

	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	# Imprimindo a tela de sele��o de cor no frame 0
		la a0, menu_inicial_cor_pecas	# carrega a imagem
		li a1, 0xFF000000		# seleciona como argumento o frame 0
		call PRINT_TELA	
		
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

.data
	.include "../Imagens/menu_inicial/menu_inicial_cor_pecas.data"
	
	