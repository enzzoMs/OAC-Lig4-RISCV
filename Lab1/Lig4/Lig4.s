.text

# ====================================================================================================== # 
# 						Lig4						         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Este arquivo cont�m a l�gica central do jogo incluindo o loop principal e a chamada de procedimentos   #
# adquados para renderizar os elementos visuais.							 #
#													 #										 #
# ====================================================================================================== #
# 				    TABELA DE REGISTRADORES SALVOS					 #
# ====================================================================================================== #
#													 #
#	s0 = cor das pe�as selecionada pelo jogador, de modo que:					 #
#		[ 0 ] = pe�as da cor VERMELHA								 # 
#		[ 1 ] = pe�as da cor AMARELA								 #
#	s1 = dificuldade selecionada pelo jogador, de modo que:					 	 #
#		[ 0 ] = FACIL										 # 
#		[ 1 ] = MEDIO										 # 
#		[ 2 ] = DIFICIL										 #
#													 #											 
# ====================================================================================================== #
# Observa��es:											         #
# 													 #
# -> Este � o arquivo principal do jogo e atrav�s dele s�o chamados outros procedimentos para a execu��o #  
# de determinadas fun��es. Caso esses procedimentos chamem outros procedimentos � usado a pilha e o      #
# registrador sp (stack pointer) para guardar o endere�o de retorno, de modo que os procedimentos possam #
# voltar at� esse arquivo.										 #
# 													 #
# ====================================================================================================== #

call INICIALIZAR_MENU_INICIAL		# Chama o procedimento em menu_inicial.s

call INICIALIZAR_TABULEIRO		# Chama o procedimento em tabuleiro.s


loop : j loop	 # loop eterno 

# ====================================================================================================== #

.data
	.include "Codigos/menu_inicial.s"
	.include "Codigos/tabuleiro.s"
	.include "Codigos/procedimentos_auxiliares.s"
