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
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #	

VERIFICAR_EMPATE:
	# Procedimento que verifica se houve um empate ap�s um jogada
	
	# Verificar o empate simplesmente se trata de ver se o endere�o NUM_COLUNAS_LIVRES tem valor 0
	la t0, NUM_COLUNAS_LIVRES	# t0 recebe o endere�o de NUM_COLUNAS_LIVRES
	lb t0, 0(t0)			# t0 recebe o valor armazenado em NUM_COLUNAS_LIVRES
	
	ret								
				
						
								
										
	
			
					
							

		
				
				