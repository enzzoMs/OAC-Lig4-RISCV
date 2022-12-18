.data

# Esse vetor guarda o número de peças que ainda podem ser inseridas em cada uma das sete colunas do tabuleiro
# o vetor tem seu conteúdo constantemente atualizado ao longo do jogo
COLUNAS_PECAS_RESTANTES: .word 5, 5, 5, 5, 5, 5, 5

# Abaixo é armazenado o numero de colunas livres, ou seja, que ainda podem receber peças.
# Inicialmente todas as 7 colunas estão livres
NUM_COLUNAS_LIVRES: .word 7

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
#	s2 = tem o endereço base do vetor COLUNAS_PECAS_RESTANTES					 #	
#													 #
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

la s2, COLUNAS_PECAS_RESTANTES

LIG4_MAIN:

call INICIALIZAR_MENU_INICIAL		# Chama o procedimento em tela_menu_inicial.s

call INICIALIZAR_TABULEIRO		# Chama o procedimento em tela_tabuleiro.s

LOOP_PRINCIPAL_JOGO:
	call VERIFICAR_FIM_DE_JOGO	# Chama o procedimento em fim_de_jogo.s
	
	call TURNO_JOGADOR		# Chama o procedimento em movimentos_turnos.s
	
	call VERIFICAR_FIM_DE_JOGO	# Chama o procedimento em fim_de_jogo.s
	
	call TURNO_COMPUTADOR		# Chama o procedimento em movimentos_turnos.s
	
	j  LOOP_PRINCIPAL_JOGO

			
# ====================================================================================================== #

.data
	.include "Codigos/tela_menu_inicial.s"
	.include "Codigos/tela_tabuleiro.s"
	.include "Codigos/movimentos_turnos.s"
	.include "Codigos/fim_de_jogo.s"
	.include "Codigos/procedimentos_auxiliares.s"
