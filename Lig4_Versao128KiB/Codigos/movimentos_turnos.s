
.data
msgTitulo: 	.string "Organizacao Arquitetura de Computadores                 2022/2"
msgFacil:	.string "LIG4 - Dificuldade Facil"
msgMedio:	.string "LIG4 - Dificuldade Medio"
msgDificil:	.string "LIG4 - Dificuldade Dificil"

msgFrequencia:		.string "Freq  =                 MHz"
msgCiclos:		.string "C     ="
msgInstrucoes:		.string "I     ="
msgCPI:			.string "CPI   ="
msgTempoMedido:  	.string "Texec Medido (ms) ="
msgTempoCalculado:  	.string "Texec Calculado (ms) ="

.text

# ====================================================================================================== # 
# 				        MOVIMENTOS E TURNOS		         		         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# C�digo respons�vel por comandar o esquema de turnos do jogo, possuindo procedimentos tanto para o      #
# turno do jogador, quanto para o turno do computador, coordenando a l�gica para a inser��o e 		 #
# renderiza��o de pe�as no tabuleiro.									 #		         # 
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
		li a1, 59		# a1 = n�mero da coluna onde come�a a imagem = 59
		li a2, 52		# a1 = n�mero da linha onde come�a a imagem  = 52
		call CALCULAR_ENDERECO	
	
	mv t2, a0		# salvo o endere�o retornado em t2
	
	# Calculando o endere�o onde come�a a imagem da ultima sele��o de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 239		# a1 = n�mero da coluna onde come�a a imagem = 239
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
		li a1, 175		# a1 = n�mero da coluna onde come�a a imagem = 175
		li a2, 224		# a1 = n�mero da linha onde come�a a imagem  = 224
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endere�o retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde come�a os pixels no .data
	
	li t0, 110		# para encontrar a imagem da pe�a escolhida pelo jogador
	mul t0, s0, t0		# basta fazer essa multiplica�a�. t0 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o valor de s0 (cor 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels � necess�rio pular para
				# encontrar a imagem certo 
					
	# Imprime na parte inferior da tela, na sec��o TURNO, a imagem da pe�a do jogador
	# a0 tem o endere�o da imagem
	# a1 tem o endere�o de onde imprimir a imagem
	li a2, 11		# n�mero de colunas da imagem 
	li a3, 10		# n�mero de linhas da imagem 
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
		
		li t0, 'p'			# se 'p' foi apertado reinicia o jogo
		beq a0, t0, REINICIAR_DADOS
		
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
	bne t1, zero, JOGADOR_INSERIR_PECA
		la t0, NUM_COLUNAS_LIVRES	# t0 tem o endere�o de NUM_COLUNAS_LIVRES
		lw t1, 0(t0)			# t1 tem o numero de colunas livres
		addi t1, t1, -1			# decrementa t1
		sw t1, 0(t0)			# armazena t1 em NUM_COLUNAS_LIVRES
	
	JOGADOR_INSERIR_PECA:	
	# Atualiza a matriz do tabuleiro
	addi a0, s0, 1	# incrementa s0 de forma que a0 == 1 se a pe�a escolhida foi VERMELHA e a0 == 2 caso
			# a cor escolhida foi AMAARELA	
	mv a1, t6	# move para a1 o valor da coluna selecionada
	call ATUALIZAR_MATRIZ_TABULEIRO					
								
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
		li a1, 175		# a1 = n�mero da coluna onde come�a a imagem = 175
		li a2, 224		# a1 = n�mero da linha onde come�a a imagem  = 224
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endere�o retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde come�a os pixels no .data
	
	xori t0, s0, 1		# t0 recebe o inverso de s0
	
	li t1, 110		# para encontrar a imagem da pe�a do computador basta fazer
	mul t1, t0, t1		# essa multiplica�a�. t1 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o inverso de s0 (cor 
	add a0, a0, t1		# escolhida pelo jogador) vai determinar quantos pixels � necess�rio 
				# pular para encontrar a imagem certa da pe�a do computador 
					
	# Imprime na parte inferior da tela, na sec��o TURNO, a imagem da pe�a do computador
	# a0 tem o endere�o da imagem
	# a1 tem o endere�o de onde imprimir a imagem
	li a2, 11		# n�mero de colunas da imagem 
	li a3, 10		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	# Decide qual procedimento chamar de acordo com a dificuldade
	
	beq s1, zero, COMPUTADOR_JOGADA_FACIL
	
	li t0, 1
	beq s1, t0, COMPUTADOR_JOGADA_MEDIO
		
	li t0, 2
	beq s1, t0, COMPUTADOR_JOGADA_DIFICIL
	
		
	# Embora n�o seja prov�vel, caso s1 tem um valor diferente de 0, 1 ou 2 o procedimento termina		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

	COMPUTADOR_REALIZAR_JOGADA:
	# Do retorno dos procedimentos de decis�o a0 tem o numero da coluna escolhida
	
	# Atualiza o numero de posi��es livres para a coluna escolhida no vetor de colunas
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
	
	mv t4, a0	# salva a coluna escolhida em t4
	
	# Atualiza a matriz do tabuleiro
	xori t0, s0, 1	# inverte o valor de s0 e soma 1 de modo que a0 == 1 se a pe�a do computador for 
 	addi a0, t0, 1	# VERMELHA e a0 == 2 se for AMARELA
	mv a1, t4	# move para a1 o valor da coluna selecionada
	call ATUALIZAR_MATRIZ_TABULEIRO	
	
	
	# Calculando o endere�o onde come�a a imagem da primeira sele��o de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 59		# a1 = n�mero da coluna onde come�a a imagem = 59
		li a2, 52		# a1 = n�mero da linha onde come�a a imagem  = 52
		call CALCULAR_ENDERECO	
	
	li t3, 30 		# t3 tem a quantidade de pixels de diferen�a entre uma coluna e outra
		
	mul t4, t4, t3		# atrav�s dessa multiplica��o decide quantos pixels tem que ser pulados 
				# para encontrar o endere�o da coluna escolhida pelo computador
	
	add a1, a0, t4		# passa o endere�o de a1 para o endere�o da coluna escolhida pelo computador
		
	
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
		li a0, 1000			# sleep por 1 s
		call SLEEP			# chama o procedimento sleep
	
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
	# Nesse n�vel de dificuldade a escolha da coluna � rand�mica
	#
	# Retorno:
	# 	O procedimento sempre vai retornar para COMPUTADOR_REALIZAR_JOGADA com	
	# 	a0 = um n�mero de 0 a 6 representando a coluna escolhida 
	
	# Obs: n�o � necess�rio salvar o valor de ra, pois a chegada a esse procedimento � atrav�s de 
	# uma instru��o de branch e a sa�da � sempre para o label COMPUTADOR_REALIZAR_JOGADA
	
	csrr	s4, instret	# le o numero de intru��es antes do procedimento
	csrr	s5, cycle	# le o numero de ciclos antes do procedimento
	csrr	s6, time	# le o tempo do sistema antes do procedimento
													
	call ESCOLHER_COLUNA_RANDOMICA

	csrr	t2, time	# le o tempo do sistema depois do procedimento		
	csrr	t1, cycle	# le o numero de ciclos depois do procedimento
	csrr	t0, instret	# le o numero de intru��es depois do procedimento
	
	sub	s4, t0, s4	# I = diferen�a entre o numero de intru��es antes e depois do procedimento
	sub	s5, t1, s5	# C = diferen�a entre o numero de ciclos antes e depois do procedimento
	addi	s5, s5, 2	# Corrige o C pelas 2 instru��es a mais
	sub	s6, t2, s6	# Texec = diferen�a entre o tempo  antes e depois do procedimento
	
	call MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA	
				
	# pelo retorno do procedimento acima a0 tem o numero da coluna escolhida	
 					 				
	j COMPUTADOR_REALIZAR_JOGADA		
	
	
# ====================================================================================================== #

COMPUTADOR_JOGADA_MEDIO:
	# Procedimento que decide qual a proxima jogada do computador na dificuldade m�dio
	# A jogada consiste em escolher em qual coluna, de 0 a 6, o computador vai inserir a pe�a
	# Nesse n�vel de dificuldade o computador pode fazer dois tipos de movimentos: um defensivo
	# e um ofensivo. No defensivo ele vai procurar por grupos de 3 pe�as do jogador e tentar
	# impedir que um grupo de 4 seja feito botando uma pe�a no meio do caminho. O computador joga de forma
	# rand�mica at� que um grupo de 3 de suas pe�as sejam formados, a� ele joga de maneira ofensiva
	# tentando aumentar esse grupo para formar um agrumento de 4 pe�as. 
	# Caso seja poss�vel realizar tanto a jogada defensiva quanto a ofensiva ele sempre vai escolher
	# a defensiva em primeiro lugar. 
	# 
	# Retorno:
	# 	O procedimento sempre vai retornar para COMPUTADOR_REALIZAR_JOGADA com	
	# 	a0 = um n�mero de 0 a 6 representando a coluna escolhida 
	
	# Obs: n�o � necess�rio salvar o valor de ra, pois a chegada a esse procedimento � atrav�s de 
	# uma instru��o de branch e a sa�da � sempre para o label COMPUTADOR_REALIZAR_JOGADA
 
 	csrr	s4, instret	# le o numero de intru��es antes do procedimento
	csrr	s5, cycle	# le o numero de ciclos antes do procedimento
	csrr	s6, time	# le o tempo do sistema antes do procedimento
													
							
	# DEFENSIVA --------------------------------------------------------------------------------
	# Primeiramente o computador tenta fazer uma jogada defensiva, encontrando grupos de 3 pe�as
	# do jogador e impedindo a expans�o deles
	li a6, 3		# vai procurar por grupos do jogador com pelo menos 3 pe�as
	call ESCOLHER_COLUNA_DEFENSIVA	

	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_MEDIO
	
	# OFENSIVA --------------------------------------------------------------------------------	
	# Se n�o � poss�vel fazer uma jogada defensiva ent�o o computador tenta uma ofensiva
	li a6, 3		# vai procurar por grupos do computador com pelo menos 3 pe�as
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_MEDIO
	
	# Se nenhum grupo foi encontrado, tanto para a jogada ofensiva quanto defensiva, ent�o
	# escolhe uma coluna rand�micamente 
	
	call ESCOLHER_COLUNA_RANDOMICA 

	# pelo retorno do procedimento acima a0 tem o numero da coluna escolhida	

FIM_COMPUTADOR_JOGADA_MEDIO:
 	
	csrr	t2, time	# le o tempo do sistema depois do procedimento		
	csrr	t1, cycle	# le o numero de ciclos depois do procedimento
	csrr	t0, instret	# le o numero de intru��es depois do procedimento
	
	sub	s4, t0, s4	# I = diferen�a entre o numero de intru��es antes e depois do procedimento
	sub	s5, t1, s5	# C = diferen�a entre o numero de ciclos antes e depois do procedimento
	addi	s5, s5, 2	# Corrige o C pelas 2 instru��es a mais
	sub	s6, t2, s6	# Texec = diferen�a entre o tempo  antes e depois do procedimento
	
	call MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA
																																																																																					
	j COMPUTADOR_REALIZAR_JOGADA	
	
# ====================================================================================================== #

COMPUTADOR_JOGADA_DIFICIL:
	# Procedimento que decide qual a proxima jogada do computador na dificuldade dificil
	# A jogada consiste em escolher em qual coluna, de 0 a 6, o computador vai inserir a pe�a
	# Nesse n�vel de dificuldade o computador pode fazer dois tipos de movimentos: um defensivo
	# e um ofensivo. No defensivo ele vai procurar por grupos de 2 pe�as do jogador e tentar
	# impedir que um grupo de 4 seja feito botando uma pe�a no meio do caminho. O computador joga de forma
	# rand�mica at� que um grupo de 1 de suas pe�as sejam formados, a� ele joga de maneira ofensiva
	# tentando aumentar esse grupo para formar um agrumento de 4 pe�as. 
	# Caso seja poss�vel realizar tanto a jogada defensiva quanto a ofensiva ele sempre vai escolher
	# a defensiva em primeiro lugar. 
	# 
	# Retorno:
	# 	O procedimento sempre vai retornar para COMPUTADOR_REALIZAR_JOGADA com	
	# 	a0 = um n�mero de 0 a 6 representando a coluna escolhida 
	
	# Obs: n�o � necess�rio salvar o valor de ra, pois a chegada a esse procedimento � atrav�s de 
	# uma instru��o de branch e a sa�da � sempre para o label COMPUTADOR_REALIZAR_JOGADA

	csrr	s4, instret	# le o numero de intru��es antes do procedimento
	csrr	s5, cycle	# le o numero de ciclos antes do procedimento
	csrr	s6, time	# le o tempo do sistema antes do procedimento
	
	# DEFENSIVA --------------------------------------------------------------------------------
	# Primeiramente o computador tenta fazer uma jogada defensiva, encontrando grupos de 3 pe�as
	# do jogador e impedindo a expans�o deles
	li a6, 3		# vai procurar por grupos do jogador com pelo menos 3 pe�as
	call ESCOLHER_COLUNA_DEFENSIVA	

	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL

	# Se n�o h� grupos de 3 pe�as ent�o tenta encontrar grupos de 2 pe�as do jogador e 
	# impede a expans�o deles
	li a6, 2		# vai procurar por grupos do jogador com pelo menos 2 pe�as
	call ESCOLHER_COLUNA_DEFENSIVA	

	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL
	
	
	# OFENSIVA --------------------------------------------------------------------------------					
	# Se n�o � poss�vel fazer uma jogada defensiva ent�o o computador tenta uma ofensiva
	li a6, 3		# vai procurar por grupos do computador com pelo menos 3 pe�as
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL

	# Se n�o h� grupos de 3 pe�as ent�o tenta encontrar grupos de 2 pe�as para expandi-los
	li a6, 2		# vai procurar por grupos do computador com pelo menos 2 pe�as
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL
	
	# Se n�o h� grupos de 3 e 2 pe�as ent�o tenta encontrar grupos de 1 pe�as para expandi-los
	li a6, 1		# vai procurar por grupos do computador com pelo menos 1 pe�as
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL
							
	# Se nenhum grupo foi encontrado, tanto para a jogada ofensiva quanto defensiva, ent�o
	# escolhe uma coluna rand�micamente 
	
	call ESCOLHER_COLUNA_RANDOMICA 

	# pelo retorno do procedimento acima a0 tem o numero da coluna escolhida	

FIM_COMPUTADOR_JOGADA_DIFICIL:
 	
	csrr	t2, time	# le o tempo do sistema depois do procedimento		
	csrr	t1, cycle	# le o numero de ciclos depois do procedimento
	csrr	t0, instret	# le o numero de intru��es depois do procedimento
	
	sub	s4, t0, s4	# I = diferen�a entre o numero de intru��es antes e depois do procedimento
	sub	s5, t1, s5	# C = diferen�a entre o numero de ciclos antes e depois do procedimento
	addi	s5, s5, 2	# Corrige o C pelas 2 instru��es a mais
	sub	s6, t2, s6	# Texec = diferen�a entre o tempo  antes e depois do procedimento
	
	call MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA
													
	j COMPUTADOR_REALIZAR_JOGADA	
	
# ====================================================================================================== #

ESCOLHER_COLUNA_RANDOMICA:
	# Procedimento auxiliar COMPUTADOR_JOGADA_FACIL e COMPUTADOR_JOGADA_MEDIO que escolhe randomicamente 
	# um numero de coluna (0 a 6) que n�o est� cheia
	#
	# Retorno:
	#	a0 = numero de 0 a 6 da coluna escolhida
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Antes de tudo � necess�rio saber quantas colunas est�o livres
	la t0, NUM_COLUNAS_LIVRES	# t0 tem o endere�o de NUM_COLUNAS_LIVRES
	lw a0, 0(t0)			# t0 tem o numero de colunas livres
	
	# Obs: para o turno do computador � garantido que sempre vai haver pelo menos 1 coluna livre, porque
	# � o jogador que coloca a ultima pe�a poss�vel no tabuleiro e a� acontece um empate
	
	# Escolhe um numero randomico entre 0 e t0 (numero de colunas livres)
	# De forma que o retorno a0 representa que o computador "quer" a n-esima coluna livre do tabuleiro
	call ENCONTRAR_NUMERO_RANDOMICO
	
	addi a0, a0, 1		# � necessario incrementar a0 porque o ENCONTRAR_NUMERO_RANDOMICO acima 
				# inclui o numero 0

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
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

# ====================================================================================================== #

ESCOLHER_COLUNA_OFENSIVA:
	# Procedimento auxiliar a COMPUTADOR_JOGADA_MEDIO e COMPUTADOR_JOGADA_DIFICIL que tem como 
	# objetivo ajudar o computador a escolher uma coluna de forma ofensiva, ou seja, � verificado se 
	# existe algum grupo de pelo menos um espa�o livre e pelo menos a6 pe�as do computador na horizontal, 
	# vertical ou diagonal para que o computador possa expandi-lo
	# O procedimento sempre parte do ponto de vista que ele ser� usado somente pelo computador para 
	# encontrar pe�as do computador
	# Argumentos:
	#	a6 = numero minimo de pe�as no grupo
	#
	# Retorno:
	#	a0 = se nenhum grupo poss�vel foi encontrado a0 = -1, caso contr�rio 
	#	a0 recebe um numero de 0 a 6 representando a coluna escolhida
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	li t0, 4	# numero de pe�as em um grupo
	
	sub a6, t0, a6	# a6 - 4 = numero maximo de pe�as vazias no grupo
	
	# Verifica se foi formado algum grupo de pelo menos a6 na horizontal				
	xori a0, s0, 1	# a0 recebe o inverso da pe�a do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a pe�a do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 4	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 5	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na vertical				
	xori a0, s0, 1	# a0 recebe o inverso da pe�a do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a pe�a do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 28	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 7	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
		
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da esquerda para direita				
	xori a0, s0, 1	# a0 recebe o inverso da pe�a do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a pe�a do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 32	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da direita para a esquerda				
	xori a0, s0, 1	# a0 recebe o inverso da pe�a do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a pe�a do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 24	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	addi a2, s3, 12	# a2 recebe o endere�o da matriz onde come�ar a busca, nesse caso a 1a linha 
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado termina o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
	li a0, -1	# a0 = -1 significa que nenhum grupo foi encontrado

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

	RETORNAR_COLUNA_OFENSIVA:
	# se um grupo foi encontrado � necess�rio transformar o retorno a1 de VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	# em um numero de coluna de 0 a 6
	
	li t0, 7	# t0 recebe o numero de colunas da matriz
	
	sub a1, a1, s3	# a1 recebe a diferen�a de a1 e o endere�o de inicio da matriz
	srai a1, a1, 2	# divide a1 por 4 porque cada endere�o de 4 bytes
	
	rem a0, a1, t0	# a0 recebe o resto da divis�o de a0 / 7 de modo que a0 tem um numero de 0 a 6
			# representando a coluna do endere�o a1 na matriz do tabuleiro
			
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

# ====================================================================================================== #

ESCOLHER_COLUNA_DEFENSIVA:
	# Procedimento auxiliar a COMPUTADOR_JOGADA_MEDIO e COMPUTADOR_JOGADA_DIFICIL que tem como 
	# objetivo ajudar o computador a escolher uma coluna de forma defensiva, ou seja, � verificado se 
	# existe algum grupo de pelo menos um espa�o livre e pelo menos a6 pe�as do jogador na horizontal, 
	# vertical ou diagonal para que o computador possa impedir a sua expans�o
	# O procedimento sempre parte do ponto de vista que ele ser� usado somente pelo computador para 
	# encontrar pe�as do jogador
	# Argumentos:
	#	a6 = numero minimo de pe�as no grupo
	#
	# Retorno:
	#	a0 = se nenhum grupo poss�vel foi encontrado a0 = -1, caso contr�rio 
	#	a0 recebe um numero de 0 a 6 representando a coluna escolhida
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	li t0, 4	# numero de pe�as em um grupo
	
	sub a6, t0, a6	# a6 - 4 = numero maximo de pe�as vazias no grupo
	

	# Verifica se foi formado algum grupo de pelo menos a6 na horizontal				
	addi a0, s0, 1	# a0 tem o valor da pe�a do jogador na matriz, ou seja, a0 recebe o valor que 
			# ser� procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 4	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 5	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na vertical				
	addi a0, s0, 1	# a0 tem o valor da pe�a do jogador na matriz, ou seja, a0 recebe o valor que 
			# ser� procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 28	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 7	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
		
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da esquerda para direita				
	addi a0, s0, 1	# a0 tem o valor da pe�a do jogador na matriz, ou seja, a0 recebe o valor que 
			# ser� procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 32	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	mv a2, s3	# a2 recebe o endere�o da matriz onde come�ar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da direita para a esquerda				
	addi a0, s0, 1	# a0 tem o valor da pe�a do jogador na matriz, ou seja, a0 recebe o valor que 
			# ser� procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 24	# a1 recebe a distancia em bytes que ser� pulada entre uma posi��o e outra
	addi a2, s3, 12	# a2 recebe o endere�o da matriz onde come�ar a busca, nesse caso a 1a linha 
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posi��es vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado termina o processo de verifica��o
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
	li a0, -1	# a0 = -1 significa que nenhum grupo foi encontrado

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

	RETORNAR_COLUNA_DEFENSIVA:
	# se um grupo foi encontrado � necess�rio transformar o retorno a1 de VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	# em um numero de coluna de 0 a 6
	
	li t0, 7	# t0 recebe o numero de colunas da matriz
	
	sub a1, a1, s3	# a1 recebe a diferen�a de a1 e o endere�o de inicio da matriz
	srai a1, a1, 2	# divide a1 por 4 porque cada endere�o de 4 bytes
	
	rem a0, a1, t0	# a0 recebe o resto da divis�o de a0 / 7 de modo que a0 tem um numero de 0 a 6
			# representando a coluna do endere�o a1 na matriz do tabuleiro
			
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	
	
# ====================================================================================================== #
	
VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS:
	# Procedimento auxiliar a COMPUTADOR_JOGADA_MEDIO e COMPUTADOR_JOGADA_DIFICIL que tem como 
	# objetivo verificar a partir da matriz do tabuleiro se existe algum POSSIVEL grupo de 4 pe�as 
	# de mesma cor 
	# A diferen�a desse procedimento para VERIFICAR_GRUPOS_DE_PECAS em fim_de_jogo.s � que esse procedimento
	# verifica POSS�VEIS grupos, ou seja, dependo do argumento a5 ele procura grupos de 4 posi��es no tabuleiro
	# em que no m�ximo a5 posi��es est�o vazias e o resto possui pe�as da mesma cor, retornando o endere�o 
	# na matriz de uma dessas posi��es vazias para que o computador possa realizar a sua jogada
	# Esse procedimento s� deve ser usado para encontrar POSSIVEIS grupos, ou seja, quando a5 � pelo menos 1
	
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
	# 	a5 = numero m�ximo de posi��es vazias no grupo
	# Retorno:
	# 	a0 = 1 se foi detectado um grupo com esses parametros ou 0 caso contr�rio
	# 	a1 = se houve um grupo v�lido com esses par�metros a1 recebe o endere�o, na matriz do 
	#	tabuleiro, da �ltima posi��o vazia encontrada no grupo
	
	VERIFICAR_POSSIVEIS_GRUPOS_LINHAS:
		mv t0, a2	# copia de a2 para usar no loop de colunas
		mv t1, a2	# copia de a2 para usar no loop de colunas
		
		mv t2, a4	# copia de a4 para usar no loop de colunas
		
		VERIFICAR_POSSIVEIS_GRUPOS_COLUNAS:		
			mv t3, a5	# copia de a5 para usar no loop de colunas
			li t4, 4	# t4 = numero de posi��es a serem analisadas para encontrar um grupo
			li t6, -1	# t6 vai receber o endere�o da ultima posi��o vazia do grupo. por�m
					# s� se essa posi��o estiver em cima de uma pe�a ou se for da ultima
					# linha
			
			VERIFICAR_POSSIVEIS_GRUPOS_POSICOES:
				lw t5, 0(t1)		# t5 recebe o valor armazenado em t1
			
				# se t5 != 0 ent�o a posi��o n�o est� vazia
				bne t5, zero, POSICAO_NAO_VAZIA	
					addi t3, t3, -1 # se a posi��o est� vazia decrementa o n�mero de 
							# m�ximo de posi��es vazias permitidas
					# Se depois desse decremento o numero de m�ximo de posi��es
					# vazias ficar menor do que zero ent�o h� mais posi��es vazias
					# do que o permitido, ent�o n�o � necess�rio verificar mais posi��es
					# porque n�o existe um grupo v�lido com esses par�metros 
					blt t3, zero, FIM_VERIFICAR_POSSIVEIS_GRUPOS_POSICOES
									
					addi t5, s3, 112	# t5 recebe o endere�o de come�o da ultima 
								# linha da matriz
					
					# se o endere�o de t1 > t5 ent�o segue o loop						
					bge t1, t5, POSICAO_VAZIA_VALIDA
						# se n�o verifica a posi��o da linha de baixo
						lw t5, 28(t1)
						# se a posi��o estiver em cima de nada verifica a proxima
						beq t5, zero, VERIFICAR_PROXIMA_POSICAO 		
					
					POSICAO_VAZIA_VALIDA:				
					mv t6, t1	# salva em t6 o endere�o na matriz da posi��o 
							# vazia encontrada
													
					j VERIFICAR_PROXIMA_POSICAO
					
				POSICAO_NAO_VAZIA:
					# verifica se a pe�a encontrada � da cor procurada (a0), se n�o for 
					# ent�o n�o � necess�rio verificar mais posi��es
					# porque n�o existe um grupo v�lido com esses par�metros 
					bne t5, a0, FIM_VERIFICAR_POSSIVEIS_GRUPOS_POSICOES
			
			VERIFICAR_PROXIMA_POSICAO:		
			addi t4, t4, -1		# decrementa o numero de posi��es a serem analisadas
			add t1, t1, a1		# passa o endere�o de t1 para a proxima posi��o de acordo com a1
			bne t4, zero, VERIFICAR_POSSIVEIS_GRUPOS_POSICOES	# reinicia o loop se t4 != 0
			
			# se todas as 4 posi��es foram analisadas e n�o ocorreu nenhum branch, ou seja, se 
			# n�o existem mais posi��es vazias do que o permitido, todas as outras pe�as s�o
			# da cor procurada (a0) e t6 != -1, ou seja, existe uma posicao vazia valida, ent�o 
			# um grupo v�lido foi encontrado
			
			li t5, -1
			bne t6, t5, POSSIVEL_GRUPO_PECAS_DETECTADO	
		
			FIM_VERIFICAR_POSSIVEIS_GRUPOS_POSICOES:
		
			
			addi t0, t0, 4		# passa o endere�o de t0 para a proxima coluna da matriz
			mv t1, t0		# atualiza o endere�o de t1		
			addi t2, t2, -1		# decrementa o numero de colunas restantes 
			bne t2, zero, VERIFICAR_POSSIVEIS_GRUPOS_COLUNAS	# reinica o loop se t2 != 0
		
		addi a2, a2, 28		# passa o endere�o de a2 para a proxima linha da matriz
		addi a3, a3, -1		# decrementa o numero de linhas restantes
		bne a3, zero, VERIFICAR_POSSIVEIS_GRUPOS_LINHAS	# reinica o loop se a3 != 0
	
	# se o procedimento chegou at� aqui ent�o nenhum grupo v�lido foi encontrado
	li a0, 0	# a0 recebe 0 pois nenhum grupo foi detectado
	
	ret
	
	POSSIVEL_GRUPO_PECAS_DETECTADO:
		li a0, 1	# a0 recebe 1 porque algum grupo foi encontrado
		mv a1, t6	# a1 recebe t6 porque t6 tem o endere�o na matriz da ultima posi��o
				# vazia do grupo
	
		ret


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
		
		li t2, 32 	# para descer a pe�a para o slot abaixo � necess�rio realizar 32 loops
				# e em cada um a pe�a � movida um pixel para baixo
		
		j DESCER_PECA_SLOT						
									
	LOOP_DESCER_PECA:
		# Para descer a pe�a em uma posi��o � necess�rio saber se o espa�o est� desocupado
	
		li t0, 8010		# somando 8010 ao endere�o de a1 podemos encontrar o endere�o
		add t0, a1, t0		# de inicio do slot abaixo do atual
		
		lb t0, 0(t0)
	
		li t1, 82		# t1 tem o valor da cor de fundo da tela
			
		# Se o valor do pixel apontado por t0 n�o for igual a t1 ent�o o espa�o n�o
		# est� livre
		bne t0, t1, FIM_LOOP_DESCER_PECA	
		
		li t2, 26 	# para descer a pe�a para o slot abaixo � necess�rio realizar 26 loops
				# e em cada um a pe�a � movida um pixel para baixo
				
		DESCER_PECA_SLOT:
		li t0, 19		# t0 = numero de linhas da imagem da pe�a
		
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
			
		addi t0, t0, -1			# decrementando o numero de linhas restantes
		addi a1, a1, -19		# volta o endere�o do bitmap pelo numero de colunas impressas
		addi a1, a1, 320			# passa o endere�o do bitmap para a proxima linha
		bne t0, zero, DESCER_PECA_LINHAS	# reinicia o loop se t0 != 0
		
		# Antes de continuar � preciso limpar o rastro deixado pelo sprite antigo da pe�a
		# Para isso o loop abaixo vai limpar a linha anterior ao novo sprite
		
		li t1, 82		# t1 tem o valor da cor de fundo da tela
		
		li t0, 19		# t0 = numero de colunas da imagem da pe�a
		
		mv a0, t5		# volta a0 para o valor salvo em t5
		lb t3, 10(a0)		# t3 tem o valor da cor que vai ser limpa, ou seja, a cor do topo da pe�a
				
		addi a1, t6, -320	# volta a1 para a linha anterior ao endere�o salvo em t6
		
		LOOP_COLUNAS_LIMPAR_RASTRO:
			lb t4, 0(a1)			# pega 1 pixel do bitmap e coloca em t4
			
			# s� limpa a tela se o pixel do bitmap for igual a t5, ou seja,
			# se o sprite da pe�a est� l�
			
			bne t4, t3, NAO_LIMPAR
				sb t1, 0(a1)		# pega o pixel de t1 (fundo da tela) e coloca no bitmap
		
			NAO_LIMPAR:
			addi t0, t0, -1				# decrementa o numero de colunas restantes
			addi a1, a1, 1					# vai para o pr�ximo pixel do bitmap
			bne t0, zero, LOOP_COLUNAS_LIMPAR_RASTRO	# reinicia o loop se t0 != 0
	
		addi a1, t6, 320	# volta a1 para o valor salvo em t6 + 320
					# ou seja, passa a1 para o valor de t6 na proxima linha
					
		mv t6, a1		# atualiza o valor de t6
		
		
		# Espera alguns milisegundos	
		li a0, 6			# sleep por 6 ms
		call SLEEP			# chama o procedimento SLEEP		
		
		mv a0, t5		# volta a0 para o valor salvo em t5	
		
		addi t2, t2, -1		# decrementa o numero de loops restantes
		
		bne t2, zero, DESCER_PECA_SLOT	# reinicia o loop se t2 != 0
		
		j LOOP_DESCER_PECA	
		
										
	FIM_LOOP_DESCER_PECA:	
		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	
	
# ====================================================================================================== #

ATUALIZAR_MATRIZ_TABULEIRO:
	# Procedimento que atualiza a matriz do tabuleiro com um novo valor de pe�a
	# Argumentos:
	#	a0 = valor da pe�a, com 1 = pe�a vermelha e 2 = pe�a amarela
	# 	a1 = numero da coluna onde a pe�a foi inserida
	
	slli a1, a1, 2		# multiplica a1 por 4 porque cada word tem 4 bytes
	
	add t0, a1, s3		# passa t0 para o endere�o, na matriz do tabuleiro, da primeira posi��o
				# da coluna onde a pe�a foi inserida
	
	li t3, 4		# t3 recebe o numero maximo de linhas a serem analisadas
	
	# O loop abaixo vai encontrar a ultima posi��o disponivel na coluna
	LOOP_ATUALIZAR_MATRIZ:
		addi t1, t0, 28		# passa para t1 a posi��o no tabuleiro que est� abaixo de t0 
		
		lw t2, 0(t1)		# pega o valor dessa posi��o do  tabuleiro
		
		# verifica se essa posi��o est� livre, caso sim termina o loop
		bne t2, zero, FIM_LOOP_ATUALIZAR_MATRIZ
		
		addi t0, t0, 28		# passa t0 para a posi��o abaixo no tabuleiro
		addi t3, t3, -1		# decrementa t3
		
		bne t3, zero, LOOP_ATUALIZAR_MATRIZ
	
	FIM_LOOP_ATUALIZAR_MATRIZ:
		sw a0, 0(t0)		# armazena o valor da pe�a no endere�o da posi��o encontrada
		
	ret			

# ====================================================================================================== #

MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA:
	# Procedimento que imprime no frame 1 o tempo de execu��o e outros par�metros medidos durante
	# o processo de decis�o da IA em cada n�vel
	# Obs: O frame 1 n�o ser� mostrado ao final do procedimento, para ver as informa��es � necess�rio 
	# trocar manualmente
	# Argumentos:
	#	s4, s5 e s6 precisam conter os valores medidos durante os procedimentos da IA

	mv a6, a0	# Salva a0 em a6

	# Limpa o frame 1
	li a0, 0	# limpa com a cor preta
	li a1, 1	# limpa o frame 1
	li a7, 48	# ecall Clear Screen	
	ecall
	
	fcvt.s.w ft0, s4		# ft0 = n�mero de instru��es calculadas no procedimento
	fcvt.s.w ft1, s5		# ft1 = n�mero de ciclos calculadas no procedimento
	fcvt.s.w ft2, s6		# ft2 = tempo calculado no procedimento
		
	fdiv.s	ft3, ft1, ft2		# F em kHz = Ciclos/tempo
	fdiv.s	ft4, ft1, ft0		# CPI = Ciclos/Instru��es
		
	li 	t0, 1000
	fcvt.s.w ft5, t0
	fdiv.s	ft3, ft3, ft5	# Frequencia em MHz = Frequencia em kHz/1000 
	
	fmul.s ft5, ft0, ft4	# ft5 = CPI x Intru��es
	fdiv.s ft5, ft5, ft3	# ft5 = Texec = (CPI x Intru��es) / frequ�ncia

	# Imprime as informa��es no frame 0
		# Imprime o titulo
		la a0, msgTitulo	# carrega a string
		li a1, 0		# posi��o x
		li a2, 0		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
	
		# Escolhe e imprime a mensagem com a dificuldade
		la a0, msgFacil
		beq s1, zero, IMPRIMIR_MENSAGEM_DIFICULDADE
	
		la a0, msgMedio
		li t0, 1
		beq s1, t0, IMPRIMIR_MENSAGEM_DIFICULDADE
		
		la a0, msgDificil
		
		IMPRIMIR_MENSAGEM_DIFICULDADE:
		li a1, 8		# posi��o x
		li a2, 35		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
	
		# Imprime a frequencia
		la a0, msgFrequencia	# carrega a string
		li a1, 8		# posi��o x
		li a2, 65		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		fmv.s fa0, ft3		# ft3 tem o valor da frequencia calculada acima
		li a1, 72		# posi��o x
		li a2, 65		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 102		# ecall Print Float
		ecall

		# Imprime os ciclos
		la a0, msgCiclos	# carrega a string
		li a1, 8		# posi��o x
		li a2, 73		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		mv a0, s5		# s5 tem o n�mero de ciclos
		li a1, 72		# posi��o x
		li a2, 73		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 101		# ecall Print Int
		ecall

		# Imprime as intru��es
		la a0, msgInstrucoes	# carrega a string
		li a1, 8		# posi��o x
		li a2, 81		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		mv a0, s4		# s4 tem o n�mero de intru��es
		li a1, 72		# posi��o x
		li a2, 81		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 101		# ecall Print Int
		ecall
		
		# Imprime a CPI
		la a0, msgCPI		# carrega a string
		li a1, 8		# posi��o x
		li a2, 89		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		fmv.s fa0, ft4		# ft4 tem o valor da CPI calculada acima
		li a1, 72		# posi��o x
		li a2, 89		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 102		# ecall Print Float
		ecall	
		
		
			
		# Imprime o tempo medido
		la a0, msgTempoMedido	# carrega a string
		li a1, 8		# posi��o x
		li a2, 125		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		mv a0, s6		# s6 tem o tempo medido
		li a1, 165		# posi��o x
		li a2, 125		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 101		# ecall Print Int
		ecall	
	
		# Imprime o tempo calculado
		la a0, msgTempoCalculado	# carrega a string
		li a1, 8		# posi��o x
		li a2, 135		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		fmv.s fa0, ft5		# ft5 tem o valor da frequencia calculada acima
		li a1, 190		# posi��o x
		li a2, 135		# posi��o y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 102		# ecall Print Float
		ecall	
	
	mv a0, a6	# Volta o valor de a0 
	
	ret	
# ====================================================================================================== #
.data
	.include "../Imagens/tabuleiro/selecao_colunas.data"
	.include "../Imagens/tabuleiro/pecas_tabuleiro.data"
	
