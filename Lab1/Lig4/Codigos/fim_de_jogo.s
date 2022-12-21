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

VERIFICAR_EMPATE:
	# Procedimento que verifica se houve um empate ap�s um jogada
	# Se houve um empate o pr�prio procedimento vai imprimir a mensagem de fim de jogo e chamar um
	# procedimento para reiniciar o jogo
	
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
		li a1, 68		# n�mero da coluna onde imprimir a mensagem
		li a2, 75		# n�mero da linha onde imprimir a mensagem
		call CALCULAR_ENDERECO	
	
	mv a1, a0	# move para a1 o endere�o de onde imprimir a imagem
	
	# Imprime a mensagem de empate 
	la a0, mensagem_fim_jogo_empate	# carrega a imagem
	addi a0, a0, 8			# pula para onde come�a os pixels .data
	li a2, 183		# n�mero de colunas da imagem 
	li a3, 89		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	j RECOMECAR_JOGO	# reinicia o jogo
	
	FIM_VERIFICAR_EMPATE:
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
									
# ====================================================================================================== #	

VERIFICAR_VITORIA_OU_DERROTA:
	# Procedimento que verifica se houve uma vitoria ou derrota do jogador ap�s um jogada
	# Se houve uma vitoria ou derrota o pr�prio procedimento vai imprimir a mensagem de fim de jogo
	# Argumentos:
	#	a0 = 0 se deseja verificar a vitoria do jogador,
	#	   qualquer valor != 0, se deseja verificar a derrota do jogador, ou seja, a vitoria do computador
	
	# Para vencer o jogador ou o computador precisa formar grupos de 4 pe�as de maneira:
	#	Horizontal, Vertical ou na Diagonal
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	mv t6, a0	# salva o valor de a0 em t6
	
	addi t5, s0, 1	# t5 tem o valor da pe�a do jogador na matriz, ou seja, t4 recebe o valor que 
			# ser� procurado para formar grupos. Nesse caso t4 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO t5 recebe 1 e se escolheu AMARELO t4 recebe 2
	
	# verifica se o que deve ser analisado � a vitoria do computador ou do jogador
	beq a0, zero, VERIFICAR_GRUPOS_PECAS_HORIZONTAL
		# se a0 != 0 o que deve ser analisado � a vit�ria do computador
		xori t5, s0, 1	# t5 recebe o inverso da pe�a do jogador 
 		addi t5, t5, 1	# invertendo o valor de s0 e somando 1 de modo que t5 == 1 se a pe�a do 
 				# computador for VERMELHA e t5 == 2 se for AMARELA
	
	VERIFICAR_GRUPOS_PECAS_HORIZONTAL:
	# Primeiramente verifica se foi formado algum grupo de 4 na horizontal
	# Para isso perceba que n�o � necess�rio analisar todas as posi��es, somente as 4 primeiras colunas de 
	# todas as linhas para cobrir todo o tabuleiro
		
	mv a0, t5	# move para a0 a cor de pe�a que ser� analisada
	li a1, 4	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 5	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	call VERIFICAR_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	beq a0, zero, VERIFICAR_GRUPOS_PECAS_VERTICAL
		# se um grupo foi formado � necess�rio real�ar as pe�as e imprimir a mensagem de fim de jogo
		mv a0, a1	# pelo retorno de VERIFICAR_GRUPOS_DE_PECAS a1 tem o endere�o na matriz
				# do primeiro elemento do grupo encontrado
		li a1, 0	# quantidade de linhas entre uma pe�a e outra		
		li a2, 1	# quantidade de colunas entre uma pe�a e outra		
		call REALCAR_GRUPO_DE_PECAS
		j ESCOLHE_MENSAGEM_VITORIA_DERROTA	
	
	
	VERIFICAR_GRUPOS_PECAS_VERTICAL:
	# Agora verifica se foi formado algum grupo de 4 na vertical
	# N�o � necess�rio analisar todas as posi��es, somente todas as colunas de 2 linhas para cobrir 
	# todo o tabuleiro
		
	mv a0, t5	# move para a0 a cor de pe�a que ser� analisada
	li a1, 28	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 7	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	call VERIFICAR_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	beq a0, zero, VERIFICAR_GRUPOS_PECAS_DIAGONAL_DIREITA
		# se um grupo foi formado � necess�rio real�ar as pe�as e imprimir a mensagem de fim de jogo
		mv a0, a1	# pelo retorno de VERIFICAR_GRUPOS_DE_PECAS a1 tem o endere�o na matriz
				# do primeiro elemento do grupo encontrado
		li a1, 1	# quantidade de linhas entre uma pe�a e outra		
		li a2, 0	# quantidade de colunas entre uma pe�a e outra	
		call REALCAR_GRUPO_DE_PECAS
		j ESCOLHE_MENSAGEM_VITORIA_DERROTA	
		
				
	VERIFICAR_GRUPOS_PECAS_DIAGONAL_DIREITA:
	# Agora verifica se foi formado algum grupo de 4 na diagonal partindo da esquerda para a direita
	# Para isso perceba que n�o � necess�rio analisar todas as posi��es, somente as 4 primeiras colunas das
	# duas primeiras linhas para cobrir todas as diagonais possiveis a partir desses parametros
	
	mv a0, t5	# move para a0 a cor de pe�a que ser� analisada
	li a1, 32	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	call VERIFICAR_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	beq a0, zero, VERIFICAR_GRUPOS_PECAS_DIAGONAL_ESQUERDA
		# se um grupo foi formado � necess�rio real�ar as pe�as e imprimir a mensagem de fim de jogo
		mv a0, a1	# pelo retorno de VERIFICAR_GRUPOS_DE_PECAS a1 tem o endere�o na matriz
				# do primeiro elemento do grupo encontrado
		li a1, 1	# quantidade de linhas entre uma pe�a e outra		
		li a2, 1	# quantidade de colunas entre uma pe�a e outra	
		call REALCAR_GRUPO_DE_PECAS
		j ESCOLHE_MENSAGEM_VITORIA_DERROTA
	
	VERIFICAR_GRUPOS_PECAS_DIAGONAL_ESQUERDA:
	# Agora verifica se foi formado algum grupo de 4 na diagonal partindo da direita para a esquerda
	# Para isso perceba que n�o � necess�rio analisar todas as posi��es, somente as 4 ultimas colunas das
	# duas primeiras linhas para cobrir todas as diagonais possiveis a partir desses parametros
	
	mv a0, t5	# move para a0 a cor de pe�a que ser� analisada
	li a1, 24	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	addi a2, s3, 12	# a2 recebe o endere�o da matriz onde come�ar a busca, nesse caso a 1a linha 
			# da 4a coluna
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	call VERIFICAR_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	beq a0, zero, FIM_VERIFICAR_VITORIA_OU_DERROTA
		# se um grupo foi formado � necess�rio real�ar as pe�as e imprimir a mensagem de fim de jogo
		mv a0, a1	# pelo retorno de VERIFICAR_GRUPOS_DE_PECAS a1 tem o endere�o na matriz
				# do primeiro elemento do grupo encontrado
		li a1, 1	# quantidade de linhas entre uma pe�a e outra		
		li a2, -1	# quantidade de colunas entre uma pe�a e outra	
		call REALCAR_GRUPO_DE_PECAS
		j ESCOLHE_MENSAGEM_VITORIA_DERROTA	
	
	
	FIM_VERIFICAR_VITORIA_OU_DERROTA:
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret																																																																																																																																																												
	
	ESCOLHE_MENSAGEM_VITORIA_DERROTA:
	# � necessario verificar se � para imprimir a mensagem de derrota ou vitoria

	# t1 recebe a mensagem de derrota ou vitoria de acordo com o valor do argumento a0 (salvo em t6)	
	la t2, mensagem_fim_jogo_vitoria
	
	beq t6, zero, PRINT_MENSAGEM_VITORIA_DERROTA
		la t2, mensagem_fim_jogo_derrota	
	
	PRINT_MENSAGEM_VITORIA_DERROTA:
	
	# Calculando o endere�o de onde imprimir a mensagem 
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 68		# n�mero da coluna onde imprimir a mensagem
		li a2, 75		# n�mero da linha onde imprimir a mensagem
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endere�o de onde imprimir a imagem
	
	# Imprime a mensagem 
	mv a0, t2		# move para a0 o endere�o da mensagem escolhida anteriormente
	addi a0, a0, 8		# pula para onde come�a os pixels .data
	li a2, 183		# n�mero de colunas da imagem 
	li a3, 89		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	j RECOMECAR_JOGO 	# reinicia o jogo
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																			
# ====================================================================================================== #	

VERIFICAR_GRUPOS_DE_PECAS:
	# Procedimento auxiliar a VERIFICAR_VITORIA_OU_DERROTA que tem como objetivo verificar a partir da
	# matriz do tabuleiro se existe algum grupo de 4 pe�as de mesma cor 
	# Argumentos:
	#	a0 = cor de pe�a que ser� analisada para identificar os grupos, com:
	#		[ 1 ] = Vermelho
	#		[ 2 ] = Amarelo 
	#	a1 = dist�ncia a ser pulada em bytes entre um endere�o da matriz e outro para encontrar as
	#	outras pe�as, ou seja, � esse argumento que permite escolher se deseja verificar 
	#	grupos na diagonal, vertical ou horizontal. Por exemplo, se deseja verificar grupos
	#	na vertical ent�o a1 = 28, porque esse � o valor entre uma posi��o da matriz e a posi��o
	#	na linha imediatamente abaixo 
	#	a2 = endere�o na matriz do tabuleiro de onde a busca deve come�ar
	#	a3 = numero de linhas do tabuleiro a serem analisadas a partir de a1
	#	a4 = numero de colunas do tabuleiro a serem analisadas por cada linha de a3
	# Retorno:
	# 	a0 = 1 se foi detectado um grupo com esses parametros ou 0 caso contr�rio
	# 	a1 = se houve um grupo a1 recebe o endere�o, na matriz do tabuleiro, do primerio elemento 
	#	desse grupo
	
	VERIFICAR_GRUPOS_LINHAS:
		mv t0, a2	# copia de a2 para usar no loop de colunas
		mv t1, a2	# copia de a2 para usar no loop de colunas
		
		mv t2, a4	# copia de a4 para usar no loop de colunas
	
		VERIFICAR_GRUPOS_COLUNAS:
			# verifica se as pe�as na posicao atual e nas tres seguintes s�o as mesmas 
			# atrav�s de operacoes AND
			# sempre pulando de uma posi��o a outra de acordo com o valor do argumento a1
			lw t3, 0(t1)		# t3 recebe o valor armazenado em t1
			
			add t1, t1, a1		# passa o endere�o de t1 para a proxima posi��o de acordo com a1
			
			lw t4, 0(t1)		# t4 recebe o valor armazenado em t1
				
			and t3, t3, t4		# verifica se t3 e t4 s�o iguais atrav�s de um AND
			
			add t1, t1, a1		# passa o endere�o de t1 para a proxima posi��o de acordo com a1
										
			lw t4, 0(t1)		# t4 recebe o valor armazenado em t1
			
			and t3, t3, t4		# verifica se t3 e t4 s�o iguais atrav�s de um AND
						
			add t1, t1, a1		# passa o endere�o de t1 para a proxima posi��o de acordo com a1
						
			lw t4, 0(t1)		# t4 recebe o valor armazenado em t1
			
			and t3, t3, t4		# verifica se t3 e t4 s�o iguais atrav�s de um AND
			
			# se t3 == a0 ent�o significa que as 4 pe�as analisadas tem a mesma cor e essa
			# cor � a que est� sendo procurada, portanto existe um grupo de pe�as
			beq t3, a0, GRUPO_PECAS_DETECTADO				
		
			addi t0, t0, 4		# passa o endere�o de t0 para a proxima coluna da matriz
			mv t1, t0		# atualiza o endere�o de t1		
			addi t2, t2, -1		# decrementa o numero de colunas restantes 
			bne t2, zero, VERIFICAR_GRUPOS_COLUNAS	# reinica o loop se t2 != 0
		
		addi a2, a2, 28		# passa o endere�o de a2 para a proxima linha da matriz
		addi a3, a3, -1		# decrementa o numero de linhas restantes
		bne a3, zero, VERIFICAR_GRUPOS_LINHAS	# reinica o loop se a3 != 0
	
	li a0, 0	# a0 recebe 0 pois nenhum grupo foi detectado
	
	ret
	
	GRUPO_PECAS_DETECTADO:
		li a0, 1	# a0 recebe 1 porque algum grupo foi encontrado
		mv a1, t0	# a1 recebe t0 porque t0 tem o endere�o na matriz do primeiro elemento do grupo
	
		ret
		
# ====================================================================================================== #	

REALCAR_GRUPO_DE_PECAS:
	# Procedimento auxiliar a VERIFICAR_VITORIA_OU_DERROTA que tem como objetivo real�ar um grupo de 
	# pe�as, ou seja, depois que foi verificado que um grupo de 4 pe�as foi encontrado esse procedimento
	# pode imprimir uma moldura especial para real�ar para o jogador qual foi o grupo encontrado
	# Argumentos:
	#	a0 = endere�o, na matriz do tabuleiro, do primeiro elemento do grupo
	#	a1 = numero de linhas que tem que ser puladas para encontrar o proximo elemento do grupo
	#	a2 = numero de colunas que tem que ser puladas para encontrar o proximo elemento do grupo
	#	(Ambos a1 e a2 podem ser negativos para voltar uma linha ou coluna)	
		
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra

	# Primeiro � necess�rio usar a1 e a2 para encontrar a quantidade de pixels no bitmap entre uma 
	# pe�a e outra do grupo
	
		li t0, 8320		# t0 = 26 * 320 = quantidade de pixels entre uma linha do tabuleiro e 
					# outra no bitmap
		mul a1, a1, t0		# multiplica o a1 por t0 para encontrar quantos pixels pular no bitmap
					# at� a linha da proxima pe�a
		mv t3, a1		# move o numero de pixels calculados para t3
	
		li t0, 30		# t0 = 30 = quantidade de pixels entre uma coluna do tabuleiro e outra
					# no bitmap
		mul a2, a2, t0		# multiplica o a2 por t0 para encontrar quantos pixels pular no bitmap
					# at� a coluna da proxima pe�a
		add t3, t3, a2		# adiciona a t3 a quantidade de pixels calculada acima 
	
		# Portanto, em t3 fica salvo a quantidade total de pixels no bitmap entre uma pe�a e 
		# outra do grupo
		
	# Agora � necess�rio transformar o endere�o de a0 no endere�o da respectiva posi��o do
	# tabuleiro no bitmap
		
		sub a0, a0, s3		# a0 recebe a diferen�a entre o endere�o do come�o da metriz e a0
		srai a0, a0, 2		# divide a0 por 4 porque cada endere�o tem 4 bytes
	
		li t0, 7		# t0 = 7 = numero de colunas do tabuleiro
		div t2, a0, t0		# divide a0 por 7 de modo que t2 tem o numero da linha onde esta o 
					# primeiro elemento do grupo
				
		rem t4, a0, t0		# t4 recebe o resto de a0 / 7 de modo que t4 tem o numero da coluna			 
	
		# Calculando o endere�o onde come�a a primeira posi��o do tabuleiro
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 59		# a1 = n�mero da coluna onde come�a a posi��o 
		li a2, 83		# a1 = n�mero da linha onde come�a a posi��o
		call CALCULAR_ENDERECO	
		
		# a0 tem como retorno o endere�o calculado
	
		li t1, 8320		# t1 = 26 * 320 = quantidade de pixels entre uma linha do tabuleiro e outra
		mul t2, t2, t1		# multiplica o t2 por t1 para encontrar quantos pixels pular no bitmap
					# at� a linha indicada por t2
		add a0, a0, t2		# move o endere�o calculado para a linha encontrada em t2
	
		li t1, 30		# t1 = 30 = quantidade de pixels entre uma coluna do tabuleiro e outra
		mul t4, t4, t1		# multiplica o t4 por t1 para encontrar quantos pixels pular no bitmap
					# at� a coluna indicada por t4
		add a0, a0, t4		# move o endere�o calculado para a coluna encontrada em t0
	
		mv t4, a0		# salva a0 em t4
		
		# Portanto, em t4 fica salvo o endere�o da primeira pe�a do grupo
		

	# Com tudo calculado � necess�rio real�ar todas as 4 pe�as
	li t5, 4	# t5 = numero de pe�a para real�ar
			
	LOOP_REALCAR_PECAS:	
		# a0 j� tem o endere�o no bitmap da posi��o da pe�a a ser real�ada
		call REALCAR_PECA
		
		# Espera alguns milisegundos	
			li a0, 750			# sleep por 750 ms
			call SLEEP			# chama o procedimento de sleep						
		
		add t4, t4, t3		# atualiza o endere�o de t4 para a proxima pe�a
		mv a0, t4		# a0 recebe o endere�o da proxima pe�a
		
		addi t5, t5, -1				# decrementa o numero de pe�as restantes
		bne t5, zero, LOOP_REALCAR_PECAS	# reinicia o loop se t5 != 0
		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

# ====================================================================================================== #	

REALCAR_PECA:
	# Procedimento auxiliar a REALCAR_GRUPO_DE_PECAS que tem como objetivo substituir os pixels pretos
	# da moldura de uma posi��o do tabuleiro por pixels de outra cor de forma a real�ar aquela posi��o
	# Argumentos:
	# 	a0 = endere�o no bitmap de onde come�a a imagem da posi��o
	
	li t0, 23	# t0 = numero de linhas da imagem
					
	REALCAR_PECA_LINHAS:
		li t1, 23	# t1 = numero de colunas da imagem
			
		REALCAR_PECA_COLUNAS:
			lb t2, 0(a0)			# pega 1 pixel do bitmap e coloca em t2
			
			# se o pixel nao for preto nada deve acontecer
			bne t2, zero, NAO_REALCAR_PECA
				li t2, 0xFFFFFFFF	# t2 = cor que ser� usada para real�ar as pe�as
				sb t2, 0(a0)		# muda o pixel de preto para a cor em t2
			
			NAO_REALCAR_PECA:
		
			addi t1, t1, -1			# decrementa o numero de colunas restantes
			addi a0, a0, 1			# vai para o pr�ximo pixel do bitmap
			bne t1, zero, REALCAR_PECA_COLUNAS	# reinicia o loop se t1 != 0
			
		addi t0, t0, -1			# decrementando o numero de linhas restantes
		addi a0, a0, -23		# volta o ende�o do bitmap pelo numero de colunas impressas
		addi a0, a0, 320		# passa o endere�o do bitmap para a proxima linha
		bne t0, zero, REALCAR_PECA_LINHAS	# reinicia o loop se t0 != 0
			
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
	
	# Reinicia cada elemento da matriz do tabuleiro para 0 (sem pe�a)
	
	li t0, 35	# numero de posi��es do tabuleiro
	
	LOOP_REINICIAR_MATRIZ_TABULEIRO:
		slli t1, t0, 2		# multiplica t0 por 4 porque cada word tem 4 bytes
		add t1, t1, s3		# passa t1 para um endere�o da matriz do tabuleiro
			
		sw zero, 0(t1)		# reinicia a posi��o do tabuleiro para 0
	
		addi t0, t0, -1		# decrementa o numero de posi��es do tabuleiro restantes
		
		bge t0, zero, LOOP_REINICIAR_MATRIZ_TABULEIRO	# se t0 != 0 reinicia loop
	
	
	# O valor de ra empilhado em VERIFICAR_EMPATE ou VERIFICAR_VITORIA_OU_DERROTA n�o ser� desimpilhado
	addi sp, sp, 4		# remove 1 word da pilha
	
	j LIG4_MAIN	# reinicia o jogo

# ====================================================================================================== #																																	
																																																																																																
.data 
	.include "../Imagens/mensagens_fim_jogo/mensagem_fim_jogo_empate.data"	
	.include "../Imagens/mensagens_fim_jogo/mensagem_fim_jogo_derrota.data"	
	.include "../Imagens/mensagens_fim_jogo/mensagem_fim_jogo_vitoria.data"					
							

		
				
				
