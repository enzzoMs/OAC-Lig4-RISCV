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
#		[ 1 ] = peças da cor AMARELA								 #
#	s1 = dificuldade selecionada pelo jogador, de modo que:					 	 #
#		[ 0 ] = FACIL										 # 
#		[ 1 ] = MEDIO										 # 
#		[ 2 ] = DIFICIL										 #
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

call INICIALIZAR_TABULEIRO		# Chama o procedimento em tabuleiro.s

LOOP_PRINCIPAL_JOGO:
	call TURNO_JOGADOR		# Chama o procedimento me movimentos_turnos.s
	
	j  LOOP_PRINCIPAL_JOGO
	
# ====================================================================================================== #

.data
	.include "Codigos/menu_inicial.s"
	.include "Codigos/tabuleiro.s"
	.include "Codigos/movimentos_turnos.s"
	.include "Codigos/procedimentos_auxiliares.s"
