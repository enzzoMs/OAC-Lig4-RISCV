.text

# ====================================================================================================== # 
# 				       	     FIM DE JOGO		         		         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Esse arquivo guarda os procedimentos que v�o fazer a an�lise do tabuleiro e determinar se alguma       #
# condi��o de fim de jogo foi atingida, cobrindo situa��es de empate, derrota e vit�ria de ambos o 	 #
# jogador e a m�quina. 											 # 
#													 #
# ====================================================================================================== #

VERIFICAR_FIM_DE_JOGO:
	# Procedimento principal de fim_de_jogo.s, chama os procedimentos que checam individualmente
	# se houve um empate, derrota ou vit�ria
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	call VERIFICAR_EMPATE
	
	# se a0 != 0 ent�o houve empate
	bne a0, zero, RECOMECAR_JOGO
	
	FIM_VERIFICAR_FIM_DE_JOGO:
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #	

VERIFICAR_EMPATE:
	# Procedimento que verifica se houve um empate ap�s um jogada
	# Se houve um empate o pr�prio procedimento vai imprimir a mensagem de fim de jogo
	# Retorno:
	#	a0 = 0 se n�o houve empate e 1 se houve
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Verificar o empate simplesmente se trata de ver se o endere�o NUM_COLUNAS_LIVRES tem valor 0
	la t0, NUM_COLUNAS_LIVRES	# t0 recebe o endere�o de NUM_COLUNAS_LIVRES
	lw t0, 0(t0)			# t0 recebe o valor armazenado em NUM_COLUNAS_LIVRES
	
	li a0, 0		# inicialmente a0 recebe 0 pois n�o h� empate encontrado
		
	# se NUM_COLUNAS_LIVRES != 0 termina o procedimneto
	bne t0, zero, FIM_VERIFICAR_EMPATE
	
	# se houve empate � necess�rio imprimir a mensagem de fim de jogo na tela
	
	# Calculando o endere�o de onde imprimir a mensagem 
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 113		# n�mero da coluna onde imprimir a mensagem
		li a2, 87		# n�mero da linha onde imprimir a mensagem
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endere�o de onde imprimir a imagem
	
	# Imprime a mensagem de empate 
	la a0, mensagem_fim_jogo	# carrega a imagem
	addi a0, a0, 8			# pula para onde come�a os pixels .data
	li a2, 95		# n�mero de colunas da imagem 
	li a3, 67		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	li a0, 1	# a1 recebe 1 porque houve empate
	
	FIM_VERIFICAR_EMPATE:
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
									
# ====================================================================================================== #	

RECOMECAR_JOGO:
	# Procedimento que espera o jogador apertar ENTER para recome�ar o jogo, reiniciando os valores de
	# 	COLUNAS_PECAS_RESTANTES e NUM_COLUNAS_LIVRES

	LOOP_RECOMECAR_JOGO:
	# espera o jogador apertar ENTER para voltar ao menu inicial e recome�ar o jogo
	
	call VERIFICAR_TECLA_APERTADA
	
	li t0, 10				# t0 tem o c�digo da tecla ENTER	
	bne a0, t0, LOOP_RECOMECAR_JOGO 	# se ENTER foi apertado volta para o inicio do jogo
	
	# Reinicia o valor de NUM_COLUNAS_LIVRES para 7
	la t0, NUM_COLUNAS_LIVRES
	li t1, 7
	sw t1, 0(t0)
	
	# Reinicia cada posi��o do vetor COLUNAS_PECAS_RESTANTES para 5
	la t0, COLUNAS_PECAS_RESTANTES
	li t1, 5
	sw t1, 0(t0)
	sw t1, 4(t0)
	sw t1, 8(t0)
	sw t1, 12(t0)
	sw t1, 16(t0)
	sw t1, 20(t0)
	sw t1, 24(t0)
	
	# O valor de ra empilhado em VERIFICAR_FIM_DE_JOGO n�o ser� desimpilhado
	addi sp, sp, 4		# remove 1 word da pilha
	
	j LIG4_MAIN	# reinicia o jogo

# ====================================================================================================== #																																	
																																																																																																
.data 
	.include "../Imagens/outros/mensagem_fim_jogo.data"	
			
					
							

		
				
				