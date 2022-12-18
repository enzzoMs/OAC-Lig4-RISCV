.text

# ====================================================================================================== # 
# 				        MOVIMENTOS E TURNOS		         		         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# C�digo respons�vel por comandar o esquema de turnos do jogo, possuindo procedimentos tanto para o      #
# turno do jogador, quanto para o turno do computador, coordenando a l�gica para a inser��o de pe�as     # 
# no tabuleiro											         # 
#													 #
# ====================================================================================================== #

TURNO_JOGADOR:
	# Procedimento respons�vel por coordenar o turno do jogador, incluindo a chamada de procedimentos
	# para a sele��o interativa de colunas para inserir as pe�as
	# O procedimento funciona em um loop que s� termina quando o jogador aperta ENTER, devolvendo o 
	# controle para o procedimento chamador

	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Calculando o endere�o onde come�a a imagem da primeira sele��o de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 60		# a1 = n�mero da coluna onde come�a a imagem = 60
		li a2, 52		# a1 = n�mero da linha onde come�a a imagem  = 52
		call CALCULAR_ENDERECO	
	
	mv t2, a0		# salvo o endere�o retornado em t2
	
	# Calculando o endere�o onde come�a a imagem da ultima sele��o de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 240		# a1 = n�mero da coluna onde come�a a imagem = 240
		li a2, 52		# a1 = n�mero da linha onde come�a a imagem  = 52
		call CALCULAR_ENDERECO	
	
	mv t3, a0		# salvo o endere�o retornado em t3
	
	mv t4, t2		# t4 guarda o endere�o da coluna atualmente selecionada, inicialmente
				# ser� a coluna apontada por t2
	
	
	la t5, selecao_colunas		# carrega a imagem em t5	
	addi t5, t5, 8			# pula para onde come�a os pixels no .data
	addi t5, t5, 529		# pula para onde come�a as imagens de sele��o com pe�a no .data
		
	li t0, 529		# para encontrar a imagem de sele��o correta de acordo com a cor escolhida 
				# pelo jogador basta fazer essa multiplica��o. 
	mul t0, s0, t0		# 529 � a quantidade de pixels uma imagem de sele��o e outra 
				# O valor de s0 (cor escolhida) vai determinar quantos pixels � necess�rio 
	add t5, t5, t0		# pular para encontrar a imagem certa
				
	# Antes de tudo imprime uma imagem da pe�a escolhida pelo jogador na se���o TURNO
	# da tela do tabuleiro
	
	# Calcula o endere�o da sec��o TURNO do tabuleiro
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 174		# a1 = n�mero da coluna onde come�a a imagem = 174
		li a2, 220		# a1 = n�mero da linha onde come�a a imagem  = 220
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endere�o retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde come�a os pixels no .data
	
	li t0, 182		# para encontrar a imagem da pe�a escolhida pelo jogador
	mul t0, s0, t0		# basta fazer essa multiplica�a�. t0 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o valor de s0 (cor 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels � necess�rio pular para
				# encontrar a imagem certo 
					
	# Imprime na parte inferior da tela, na sec��o TURNO, a imagem da pe�a do jogador
	# a0 tem o endere�o da imagem
	# a1 tem o endere�o de onde imprimir a imagem
	li a2, 14		# n�mero de colunas da imagem 
	li a3, 13		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	li t6, 0		# t6 guarda o numero da coluna (de 0 a 6) atualmente selecionada,
				# de inicio a coluna selecioanda � a 0

	# Inicialmente seleciona a primeira coluna 
	li a1, 0		# a1 recebe 0 pois a coluna a ser seleciona � a atual
	addi t1, t6, 0		# t1 recebe o valor da coluna atual
	j SELECIONAR_COLUNA																							
																																																																								
	LOOP_TURNO_JOGADOR:
		call VERIFICAR_TECLA_APERTADA
		
		# Neste loop t1 vai receber o endere�o da pr�xima coluna a ser selecionada
		# dependendo do input do usu�rio
		
		li t0, 'a'
		li a1, -30	# a1 recebe -30 porque � o necess�rio para acessar o endere�o da coluna 
				# a esquerda da atual
		addi t1, t6, -1			# t1 recebe o valor da coluna a esquerda 								
		beq a0, t0, SELECIONAR_COLUNA
		li t0, 'd'
		li a1, 30	# a1 recebe 30 porque � o necess�rio para acessar o endere�o da coluna 
				# a direita da atual
		addi t1, t6, 1			# t1 recebe o valor da coluna a direita 					
		beq a0, t0, SELECIONAR_COLUNA
		li t0, 10				# t0 = valor da tecla enter
		beq a0, t0, FIM_LOOP_TURNO_JOGADOR	# Se o ENTER foi apertado, termina o loop
		j LOOP_TURNO_JOGADOR
		
		SELECIONAR_COLUNA:
			# Primeiro verifica se o endere�o t0 est� dentro dos limites, ou seja,
			# se � maior que t2 (endere�o da primeria coluna) e menor que t3(endere�o da 
			# �ltima coluna), caso esteja fora nada deve acontecer
			
			add t0, t4, a1	# t0 vai receber o endere�o da coluna atualmente selecionada (t4)
					# mais ou menos 30 (a1), essencialmente passando para t0 o endere�o
					# da coluna a direita ou esquerda, dependendo da tecla que foi
					# apertada
						
			blt t0, t2, LOOP_TURNO_JOGADOR
			bgt t0, t3, LOOP_TURNO_JOGADOR
		
			mv t6, t1		# atualiza o valor da coluna atual
					
			# Primeiramente � retirado a sele��o da coluna atual			
			la a0, selecao_colunas	# carrega a imagem em a0
			addi a0, a0, 8		# pula para onde come�a os pixels . data
			
			mv a1, t4		# passa para a1 o endere�o da coluna atual
			
			mv t4, t0	# atualiza o endere�o de t4 com o endere�o da pr�xima coluna	
		
			li a2, 23		# n�mero de colunas da imagem 
			li a3, 23		# n�mero de linhas da imagem 
			call PRINT_IMG
			
			slli t0, t6, 2		# multiplica t6 por 4, j� que cada word tem 4 bytes
			add t0, t0, s2		# passa para t0 o endere�o da coluna atual, de acordo com
						# o vetor de colunas em s2
			lw t1, 0(t0)		# pega o valor armazendo no vetor de colunas (numero de 
						# pe�as restantes)
		
			# se t1 == 0 ent�o n�o h� mais espa�o para pe�as nessa coluna, portanto
			# nada deve acontecer e ser� impresso uma imagem com X na coluna
			bne t1, zero, COLUNA_LIVRE
				la a0, selecao_colunas	# carrega a imagem em a0
				addi a0, a0, 8		# pula para onde come�a os pixels . data
				addi a0, a0, 1587	# pula para onde come�a a imagem de sele��o com X
				mv a1, t4		# a1 recebe o endere�o da coluna atual	
				li a2, 23		# n�mero de colunas da imagem 
				li a3, 23		# n�mero de linhas da imagem 
				call PRINT_IMG

				j LOOP_TURNO_JOGADOR
			
			COLUNA_LIVRE:
			
			# Seleciona a coluna escolhida
			mv a0, t5		# t5 tem o endere�o da imagem de sele��o com a cor do jogador
			mv a1, t4		# a1 recebe o endere�o da coluna atual	
			li a2, 23		# n�mero de colunas da imagem 
			li a3, 23		# n�mero de linhas da imagem 
			call PRINT_IMG
			
			j LOOP_TURNO_JOGADOR
			
	FIM_LOOP_TURNO_JOGADOR:

	# Decrementando a quantidade de pe�as restantes na coluna selecionada, por�m somente
	# se o n�mero de pe�as restantes for != 0
	slli t0, t6, 2		# multiplica t6 por 4, j� que cada word tem 4 bytes
	add t0, t0, s2		# passa para t0 o endere�o da coluna atual, de acordo com o vetor de colunas em s2
	lw t1, 0(t0)		# pega o valor armazendo no vetor de colunas (numero de pe�as restantes)
	
		# Se o numero de pe�as restantes for 0 n�o faz nada e reinicia o procedimento
		beq t1, zero, LOOP_TURNO_JOGADOR
	
	addi t1, t1, -1		# decrementa o numero de pe�as restantes
	sw t1, 0(t0)		# armazena o valor no vetor de colunas
	
	# Se com esse movimento a coluna n�o pode mais receber pe�as � ncessario decrementar o 
	# numero de colunas livres
	bne t1, zero, JOGADOR_RETIRAR_SELECAO
		la t0, NUM_COLUNAS_LIVRES	# t0 tem o endere�o de NUM_COLUNAS_LIVRES
		lw t1, 0(t0)			# t1 tem o numero de colunas livres
		addi t1, t1, -1			# decrementa t1
		sw t1, 0(t0)			# armazena t1 em NUM_COLUNAS_LIVRES
	
	JOGADOR_RETIRAR_SELECAO:	
				
	# Agora � necess�rio retirar a sele��o da coluna antes de prosseguir
	la a0, selecao_colunas	# carrega a imagem em a0
	addi a0, a0, 8		# pula para onde come�a os pixels .data
	mv a1, t4		# a1 recebe o endere�o da coluna atual		
	li a2, 23		# n�mero de colunas da imagem 
	li a3, 23		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	# � necess�rio renderizar a pe�a descendo pela coluna do tabuleiro
	addi a1, t4, 642	# passa para o argumento a1 o endere�o de t4 (endere�o da coluna atual) mais
				# 962 de forma que a0 tem o endere�o somente da imagem da pe�a
				
	la a0, pecas_tabuleiro	# carrega a imagem
	addi a0, a0, 8		# pula para onde come�a os pixels no .data
	
	li t0, 361		# para encontrar a imagem da pe�a escolhida pelo jogador
	mul t0, s0, t0		# basta fazer essa multiplica��o. t0 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o valor de s0 (cor 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels � necess�rio pular para
				# encontrar a imagem certo 			
										
	call DESCER_PECA
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

# ====================================================================================================== #

TURNO_COMPUTADOR:
	# Procedimento respons�vel por coordenar o turno do computador, incluindo a chamada de procedimentos
	# para decidir qual a jogada dependendo da dificuldade escolhida.

	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Antes de tudo imprime uma imagem da pe�a do computador na se���o TURNO
	# da tela do tabuleiro
	
	# Calcula o endere�o da sec��o TURNO do tabuleiro
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 174		# a1 = n�mero da coluna onde come�a a imagem = 174
		li a2, 220		# a1 = n�mero da linha onde come�a a imagem  = 220
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endere�o retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde come�a os pixels no .data
	
	xori t0, s0, 1		# t0 recebe o inverso de s0
	
	li t1, 182		# para encontrar a imagem da pe�a do computador basta fazer
	mul t1, t0, t1		# essa multiplica�a�. t1 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o inverso de s0 (cor 
	add a0, a0, t1		# escolhida pelo jogador) vai determinar quantos pixels � necess�rio 
				# pular para encontrar a imagem certa da pe�a do computador 
					
	# Imprime na parte inferior da tela, na sec��o TURNO, a imagem da pe�a do computador
	# a0 tem o endere�o da imagem
	# a1 tem o endere�o de onde imprimir a imagem
	li a2, 14		# n�mero de colunas da imagem 
	li a3, 13		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	# Decide qual procedimento chamar de acordo com a dificuldade
	
	beq s1, zero, COMPUTADOR_JOGADA_FACIL
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

	COMPUTADOR_REALIZAR_JOGADA:
	# Do retorno dos procedimentos de decis�o a0 tem o numero da coluna escolhida
	
	slli t0, a0, 2	# multiplica a0 por 4 porque cada word tem 4 bytes
	add t1, t0, s2	# passa t1 para o endere�o da coluna escolhida no vetor de colunas
	lw t2, 0(t1)	# pega o valor armazenado no vetor de colunas, ou seja, o numero de pe�as restantes
	
	addi t2, t2, -1	# decrementa o numero de pe�as restantes
	
	sw t2, 0(t1)	# armazena o valor atualizado no vetor de colunas		
	
	# Se com esse movimento a coluna n�o pode mais receber pe�as � ncessario decrementar o 
	# numero de colunas livres
	bne t2, zero, COMPUTADOR_COLOCAR_SELECAO
		la t0, NUM_COLUNAS_LIVRES	# t0 tem o endere�o de NUM_COLUNAS_LIVRES
		lw t1, 0(t0)			# t1 tem o numero de colunas livres
		addi t1, t1, -1			# decrementa t1
		sw t1, 0(t0)			# armazena t1 em NUM_COLUNAS_LIVRES
	
	COMPUTADOR_COLOCAR_SELECAO:	
	
	mv t2, a0	# salva o retorno em t2
	
	# Calculando o endere�o onde come�a a imagem da primeira sele��o de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 60		# a1 = n�mero da coluna onde come�a a imagem = 60
		li a2, 52		# a1 = n�mero da linha onde come�a a imagem  = 52
		call CALCULAR_ENDERECO	
	
	li t3, 30 		# t2 tem a quantidade de pixels de diferen�a entre uma coluna e outra
		
	mul t2, t2, t3		# atrav�s dessa multiplica��o decide quantos pixels tem que ser pulados 
				# para encontrar o endere�o da coluna escolhida pelo computador
	
	add a1, a0, t2		# passa o endere�o de a1 para o endere�o da coluna escolhida pelo computador
		
	
	la t0, selecao_colunas		# carrega a imagem em t5	
	addi t0, t0, 8			# pula para onde come�a os pixels no .data
	addi t0, t0, 529		# pula para onde come�a as imagens de sele��o com pe�a no .data
		
	li t1, 529		# para encontrar a imagem de sele��o correta de acordo com a cor do computador 
	xori t2, s0, 1		# basta fazer essa multiplica��o. 
	mul t1, t2, t1		# 529 � a quantidade de pixels entre uma imagem de sele��o e outra 
				# O valor inverso de s0 (cor escolhida pelo jogador) vai determinar quantos 
	add a0, t0, t1		# pixels � necess�rio pular para encontrar a imagem certa da pe�a do computador
	
	mv t2, a1		# salva em t2 o endere�o de a1
	
	# Imprime a imagem de sele��o na coluna escolhida pelo computador
	# a0 tem o endere�o da imagem de sele��o
	# a1 tem o endere�o da coluna, ou seja, de onde imprimir a imagem
	li a2, 23		# n�mero de colunas da imagem 
	li a3, 23		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	# Espera alguns milisegundos	
		li a7, 32			# selecionando syscall sleep	
		li a0, 1000			# sleep por 1 s
		ecall
	
	# Agora � necess�rio retirar a sele��o da coluna antes de prosseguir
	la a0, selecao_colunas	# carrega a imagem em a0
	addi a0, a0, 8		# pula para onde come�a os pixels .data
	mv a1, t2		# a1 recebe o endere�o da coluna selecionada		
	li a2, 23		# n�mero de colunas da imagem 
	li a3, 23		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	# � necess�rio renderizar a pe�a descendo pela coluna do tabuleiro
	addi a1, t2, 642	# passa para o argumento a0 o endere�o de t2 (endere�o da coluna selecionada) mais
				# 962 de forma que a0 tem o endere�o somente da imagem da pe�a
				
	la a0, pecas_tabuleiro	# carrega a imagem
	addi a0, a0, 8		# pula para onde come�a os pixels no .data
	
	li t0, 361		# para encontrar a imagem de sele��o correta de acordo com a cor do computador 
	xori t1, s0, 1		# basta fazer essa multiplica��o. 
	mul t0, t1, t0		# 529 � a quantidade de pixels entre uma imagem de sele��o e outra 
				# O valor inverso de s0 (cor escolhida pelo jogador) vai determinar quantos 
	add a0, a0, t0		# pixels � necess�rio pular para encontrar a imagem certa da pe�a do computador
																																					
	call DESCER_PECA
	
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret		
									
# ====================================================================================================== #

COMPUTADOR_JOGADA_FACIL:
	# Procedimento que decide qual a proxima jogada do computador na dificuldade facil
	# A jogada consiste em escolher em qual coluna, de 0 a 6, o computador vai inserir a pe�a
	# Nesse n�vel de dificuldade a escolha da coluna � randomica
	# Retorno:
	# 	a0 = um n�mero de 0 a 6 representando a coluna escolhida 
	
	# Obs: n�o � necess�rio salvar o valor de ra, pois a chegada a esse procedimento � atrav�s de 
	# uma instru��o de branch e a sa�da � sempre para o label 
	
	# Antes de tudo � necess�rio saber quantas colunas est�o livres
	la t0, NUM_COLUNAS_LIVRES	# t0 tem o endere�o de NUM_COLUNAS_LIVRES
	lw t0, 0(t0)			# t0 tem o numero de colunas livres
	
	# Escolhe um numero randomico entre 0 e t0 (numero de colunas livres)
	# De forma que o retorno a0 representa que o computador "quer" a n-esima coluna livre do tabuleiro
	mv a1, t0		# limite superior (nao inclusivo)
	li a7, 42		# syscall RandIntRange
	ecall
	
	addi a0, a0, 1		# � necessario incrementar a0 porque a ecall acima inclui o numero 0

	# Agora � necess�rio procurar qual � a n-esima coluna livre
	
	li t1, -1	# numero da coluna que est� sendo analisada	
	
	LOOP_ENCONTRAR_COLUNA_COMPUTADOR:
		addi t1, t1, 1	# incrementa o numero da coluna sendo analisada
		
		slli t2, t1, 2	# multiplica t1 por 4 porque cada word tem 4 bytes
		add t2, t2, s2	# passa t2 para o endere�o da coluna atual no vetor de colunas
		lw t2, 0(t2)	# pega o valor armazenado no vetor de colunas, ou seja, o numero de pe�as restantes
		
		# Se t2 == 0 ent�o a coluna n�o est� livre e n�o deve ser levada em conta na contagem de a0
		beq t2, zero, LOOP_ENCONTRAR_COLUNA_COMPUTADOR	
			addi a0, a0, -1		# decrementa o numero de colunas livres encontradas
		
		# o loop termina ao encontrar a n-esima coluna livre, ou seja, quando a0 == 0				
		bne a0, zero, LOOP_ENCONTRAR_COLUNA_COMPUTADOR
		
	mv a0, t1	# ao terminar o loop t1 vai ter o numero da n-esima coluna livre, ou seja,
			# a coluna escolhida pelo computador
	
	j COMPUTADOR_REALIZAR_JOGADA		
	
# ====================================================================================================== #

DESCER_PECA:
	# Procedimento auxiliar que desce, gradualmente, uma pe�a pelo tabuleiro
	# A pe�a ir� descer at� que o procedimento identifique que n�o h� espa�o livre na coluna
	# O procedimento parte do pressuposto que cada pe�a tem 23 x 23
	# Argumentos:
	#	a0 = endere�o da imagem da pe�a
	# 	a1 = endere�o de onde, no frame, a imagem da pe�a esta

	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	mv t5, a0		# salva o argumento a0 em t5
	mv t6, a1		# salva o argumento a1 em t6
	
			
	# Para descer a pe�a em uma posi��o � necess�rio saber se o espa�o est� desocupado
	
		li t0, 10250		# somando 10250 ao endere�o de a1 podemos encontrar o endre�o
		add t0, a1, t0		# de inicio do slot abaixo do atual
	
		lb t0, 0(t0)
		
		li t1, 82		# t1 tem o valor da cor de fundo da tela
				
		# Se o valor do pixel apontado por t0 n�o for igual a t1 ent�o o espa�o n�o
		# est� livre
		bne t0, t1, FIM_LOOP_DESCER_PECA	
		
		li t0, 32 	# para descer a pe�a para o slot abaixo � necess�rio realizar 32 loops
				# e em cada um a pe�a � movida um pixel para baixo
		
		j DESCER_PECA_SLOT						
									
	LOOP_DESCER_PECA:
		# Para descer a pe�a em uma posi��o � necess�rio saber se o espa�o est� desocupado
	
		li t0, 8010		# somando 8010 ao endere�o de a1 podemos encontrar o endre�o
		add t0, a1, t0		# de inicio do slot abaixo do atual
		
		lb t0, 0(t0)
	
		# Se o valor do pixel apontado por t0 n�o for igual a t1 ent�o o espa�o n�o
		# est� livre
		bne t0, t1, FIM_LOOP_DESCER_PECA	
		
		li t0, 26 	# para descer a pe�a para o slot abaixo � necess�rio realizar 26 loops
				# e em cada um a pe�a � movida um pixel para baixo
				
		DESCER_PECA_SLOT:
		li t2, 19		# t2 = numero de linhas da imagem da pe�a
		
		DESCER_PECA_LINHAS:
		li t3, 19		# t3 = numero de colunas da imagem da pe�a
			
		DESCER_PECA_COLUNAS:
			lb t4, 0(a1)			# pega 1 pixel do bitmap e coloca em t4
			
			# s� imprime a imagem se o pixel do bitmap for igual a t1 ou zero, ou seja,
			# se o lugar est� livre
			
			li t1, 9		# t1 tem o valor da cor de fundo do tabuleiro
				
			beq t4, zero, NAO_IMPRIMIR_PECA			
			beq t4, t1, NAO_IMPRIMIR_PECA
				lb t4, 0(a0)		# pega 1 pixel do .data
				sb t4, 0(a1)		# pega o pixel de t4 e coloca no bitmap
	
			NAO_IMPRIMIR_PECA:
			
			addi t3, t3, -1				# decrementa o numero de colunas restantes
			addi a0, a0, 1				# vai para o pr�ximo pixel da imagem
			addi a1, a1, 1				# vai para o pr�ximo pixel do bitmap
			bne t3, zero, DESCER_PECA_COLUNAS	# reinicia o loop se t3 != 0
			
		addi t2, t2, -1			# decrementando o numero de linhas restantes
		addi a1, a1, -19		# volta o endere�o do bitmap pelo numero de colunas impressas
		addi a1, a1, 320			# passa o endere�o do bitmap para a proxima linha
		bne t2, zero, DESCER_PECA_LINHAS	# reinicia o loop se t2 != 0
		
		# Antes de continuar � preciso limpar o rastro deixado pelo sprite antigo da pe�a
		# Para isso o loop abaixo vai limpar a linha anterior ao novo sprite
		
		li t1, 82		# t1 tem o valor da cor de fundo da tela
		
		li t2, 19		# t3 = numero de colunas da imagem da pe�a
		
		mv a0, t5		# volta a0 para o valor salvo em t5
		lb t3, 10(a0)		# t2 tem o valor da cor que vai ser limpa
				
		addi a1, t6, -320	# volta a1 para a linha anterior ao endere�o salvo em t6
		
		LOOP_COLUNAS_LIMPAR_RASTRO:
			lb t4, 0(a1)			# pega 1 pixel do bitmap e coloca em t4
			
			# s� limpa a tela se o pixel do bitmap for igual a t5, ou seja,
			# se o sprite da pe�a est� l�
			
			bne t4, t3, NAO_LIMPAR
				sb t1, 0(a1)		# pega o pixel de t1 (fundo da tela) e coloca no bitmap
		
			NAO_LIMPAR:
			addi t2, t2, -1				# decrementa o numero de colunas restantes
			addi a1, a1, 1					# vai para o pr�ximo pixel do bitmap
			bne t2, zero, LOOP_COLUNAS_LIMPAR_RASTRO	# reinicia o loop se t3 != 0
	
		addi t0, t0, -1		# decrementa o numero de loops restantes
	
		addi a1, t6, 320	# volta a1 para o valor salvo em t6 + 320
					# ou seja, passa a1 para o valor de t6 na proxima linha
					
		mv t6, a1		# atualiza o valor de t6
		
		bne t0, zero, DESCER_PECA_SLOT	# reinicia o loop se t0 != 0
		
		# Espera alguns milisegundos	
		li a7, 32			# selecionando syscall sleep	
		li a0, 100			# sleep por 100 ms
		ecall
		
		mv a0, t5		# volta a0 para o valor salvo em t5
		
		j LOOP_DESCER_PECA	
		
										
	FIM_LOOP_DESCER_PECA:	
		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	
	
# ====================================================================================================== #


.data
	.include "../Imagens/tabuleiro/selecao_colunas.data"
	.include "../Imagens/tabuleiro/pecas_tabuleiro.data"
	
