.include "Codigos/MACROSv21.s"

.data

# Esse vetor guarda o número de peças que ainda podem ser inseridas em cada uma das sete colunas do tabuleiro
# o vetor tem seu conteúdo constantemente atualizado ao longo do jogo
COLUNAS_PECAS_RESTANTES: .word 5, 5, 5, 5, 5, 5, 5

# Abaixo é armazenado o numero de colunas livres, ou seja, que ainda podem receber peças.
# Inicialmente todas as 7 colunas estão livres
NUM_COLUNAS_LIVRES: .word 7

# A matriz abaixo é uma representação do tabuleiro do jogo, onde:
# [ 0 ] = sem peça
# [ 1 ] = peça vermelha
# [ 2 ] = peça amarela
MATRIZ_TABULEIRO: .word 
	0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0
	
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
#	s3 = tem o endereço base da matriz MATRIZ_TABULEIRO						 #
#													 #
#	s4 = número de intruções executadas durante os procedimentos de decisão de IA			 #
#	s5 = número de ciclos executados durante os procedimentos de decisão de IA			 #
#	s6 = tempo decorrido durante os procedimentos de decisão de IA					 #
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

# Inicializa registradores salvos
la s2, COLUNAS_PECAS_RESTANTES
la s3, MATRIZ_TABULEIRO

LIG4_MAIN:

call INICIALIZAR_MENU_INICIAL		# Chama o procedimento em tela_menu_inicial.s

call INICIALIZAR_TABULEIRO		# Chama o procedimento em tela_tabuleiro.s

LOOP_PRINCIPAL_JOGO:
	call TURNO_JOGADOR		# Chama o procedimento em movimentos_turnos.s
	# Após o turno do jogador é necessário verificar se ele ganhou ou se houve empate
	# Um detalhe é que só é necessário verificar o empate após o turno do jogador, já 
	# que como é ele que sempre começa jogando ele sempre joga as peças ímpares no tabuleiro,
	# como o tabuleiro tem 35 peças é o jogador que insere a última peça possível no tabuleiro
	li a0, 0				# a0 = 0 -> deseja verificar a vitória do jogador
	call VERIFICAR_VITORIA_OU_DERROTA	# Chama o procedimento em fim_de_jogo.s
	call VERIFICAR_EMPATE			# Chama o procedimento em fim_de_jogo.s
		
	call TURNO_COMPUTADOR			# Chama o procedimento em movimentos_turnos.s
	li a0, 1				# a0 = 1 -> deseja verificar a vitória do computador
	call VERIFICAR_VITORIA_OU_DERROTA	# Chama o procedimento em fim_de_jogo.s
	
	j  LOOP_PRINCIPAL_JOGO

			
# ====================================================================================================== #

.data
	.include "Codigos/tela_menu_inicial.s"
	.include "Codigos/tela_tabuleiro.s"
	.include "Codigos/movimentos_turnos.s"
	.include "Codigos/fim_de_jogo.s"
	.include "Codigos/procedimentos_auxiliares.s"

	.include "Codigos/SYSTEMv21.s"
	