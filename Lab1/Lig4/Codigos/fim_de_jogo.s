.text

# ====================================================================================================== # 
# 				       	     FIM DE JOGO		         		         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Esse arquivo guarda os procedimentos que vão fazer a análise do tabuleiro e determinar se alguma       #
# condição de fim de jogo foi atingida, cobrindo situações de empate, derrota e vitória de ambos o 	 #
# jogador e a máquina. 											 # 
#													 #
# ====================================================================================================== #

VERIFICAR_FIM_DE_JOGO:
	# Procedimento principal de fim_de_jogo.s, chama os procedimentos que checam individualmente
	# se houve um empate, derrota ou vitória
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	call VERIFICAR_EMPATE
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #	

VERIFICAR_EMPATE:
	# Procedimento que verifica se houve um empate após um jogada
	
	# Verificar o empate simplesmente se trata de ver se o endereço NUM_COLUNAS_LIVRES tem valor 0
	la t0, NUM_COLUNAS_LIVRES	# t0 recebe o endereço de NUM_COLUNAS_LIVRES
	lb t0, 0(t0)			# t0 recebe o valor armazenado em NUM_COLUNAS_LIVRES
	
	ret								
				
						
								
										
	
			
					
							

		
				
				