.text

# ====================================================================================================== # 
# 						Lig4						         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Este arquivo contém a lógica central do jogo incluindo o loop principal e a chamada de procedimentos   #
# adquados para renderizar os elementos visuais.							 #
#													 #										 #
# ====================================================================================================== #
# 				    TABELA DE REGISTRADORES SALVOS					 #
# ====================================================================================================== #
#													 #
#	s0 = cor das peças selecionada pelo jogador, de modo que:					 #
#		[ 0 ] = peças da cor VERMELHA								 # 
#		[ Qualquer outro valor] = peças da cor AMARELA						 #
#													 #											 
# ====================================================================================================== #
# Observações:											         #
# 													 #
# -> Este é o arquivo principal do jogo e através dele são chamados outros procedimentos para a execução #  
# de determinadas funções. Caso esses procedimentos chamem outros procedimentos é usado a pilha e o      #
# registrador sp (stack pointer) para guardar o endereço de retorno, de modo que os procedimentos possam #
# voltar até esse arquivo.										 #
# 													 #
# ====================================================================================================== #

call INICIALIZAR_MENU_INICIAL		# Chama o procedimento em menu_inicial.s



loop : j loop	 # loop eterno 

# ====================================================================================================== #

.data
	.include "Codigos/menu_inicial.s"
	.include "Codigos/procedimentos_auxiliares.s"
