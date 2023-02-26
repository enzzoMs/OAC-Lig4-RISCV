.include "Codigos/MACROSv21.s"

.data

# Esse vetor guarda o n�mero de pe�as que ainda podem ser inseridas em cada uma das sete colunas do tabuleiro
# o vetor tem seu conte�do constantemente atualizado ao longo do jogo
COLUNAS_PECAS_RESTANTES: .word 5, 5, 5, 5, 5, 5, 5

# Abaixo � armazenado o numero de colunas livres, ou seja, que ainda podem receber pe�as.
# Inicialmente todas as 7 colunas est�o livres
NUM_COLUNAS_LIVRES: .word 7

# A matriz abaixo � uma representa��o do tabuleiro do jogo, onde:
# [ 0 ] = sem pe�a
# [ 1 ] = pe�a vermelha
# [ 2 ] = pe�a amarela
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
#	s2 = tem o endere�o base do vetor COLUNAS_PECAS_RESTANTES					 #	
#	s3 = tem o endere�o base da matriz MATRIZ_TABULEIRO						 #
#													 #
#	s4 = n�mero de intru��es executadas durante os procedimentos de decis�o de IA			 #
#	s5 = n�mero de ciclos executados durante os procedimentos de decis�o de IA			 #
#	s6 = tempo decorrido durante os procedimentos de decis�o de IA					 #
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

# Inicializa registradores salvos
la s2, COLUNAS_PECAS_RESTANTES
la s3, MATRIZ_TABULEIRO

LIG4_MAIN:

call INICIALIZAR_MENU_INICIAL		# Chama o procedimento em tela_menu_inicial.s

call INICIALIZAR_TABULEIRO		# Chama o procedimento em tela_tabuleiro.s

LOOP_PRINCIPAL_JOGO:
	call TURNO_JOGADOR		# Chama o procedimento em movimentos_turnos.s
	# Ap�s o turno do jogador � necess�rio verificar se ele ganhou ou se houve empate
	# Um detalhe � que s� � necess�rio verificar o empate ap�s o turno do jogador, j� 
	# que como � ele que sempre come�a jogando ele sempre joga as pe�as �mpares no tabuleiro,
	# como o tabuleiro tem 35 pe�as � o jogador que insere a �ltima pe�a poss�vel no tabuleiro
	li a0, 0				# a0 = 0 -> deseja verificar a vit�ria do jogador
	call VERIFICAR_VITORIA_OU_DERROTA	# Chama o procedimento em fim_de_jogo.s
	call VERIFICAR_EMPATE			# Chama o procedimento em fim_de_jogo.s
		
	call TURNO_COMPUTADOR			# Chama o procedimento em movimentos_turnos.s
	li a0, 1				# a0 = 1 -> deseja verificar a vit�ria do computador
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
	