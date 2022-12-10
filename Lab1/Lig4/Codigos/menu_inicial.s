.text

# ====================================================================================================== # 
# 						MENU INICIAL				                 #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Código responsável por renderizar o menu inicial do jogo, com a escolha da cor das peças e escolha da	 #
# dificuldade.										.                # 
#													 #
# ====================================================================================================== #

INICIALIZAR_MENU_INICIAL:
	# Procedimento principal de menu_inicial.s, ele comanda a chamada a outros procedimentos para a 
	# renderização das telas do menu inicial
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	call RENDERIZAR_ESCOLHA_COR
	
	
		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

RENDERIZAR_ESCOLHA_COR:		
	# Procedimento que imprime a imagem do menu incial com a escolha da cor que o jogador vai jogar,
	# além de trabalhar a lógica para a interação com o menu em si e a seleção dessa cor

	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	# Imprimindo a tela de seleção de cor no frame 0
		la a0, menu_inicial_cor_pecas	# carrega a imagem
		li a1, 0xFF000000		# seleciona como argumento o frame 0
		call PRINT_TELA	
		
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

.data
	.include "../Imagens/menu_inicial/menu_inicial_cor_pecas.data"
	
	