
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
# Código responsável por comandar o esquema de turnos do jogo, possuindo procedimentos tanto para o      #
# turno do jogador, quanto para o turno do computador, coordenando a lógica para a inserção e 		 #
# renderização de peças no tabuleiro.									 #		         # 
#													 #
# ====================================================================================================== #

TURNO_JOGADOR:
	# Procedimento responsável por coordenar o turno do jogador, incluindo a chamada de procedimentos
	# para a seleção interativa de colunas para inserir as peças
	# O procedimento funciona em um loop que só termina quando o jogador aperta ENTER, devolvendo o 
	# controle para o procedimento chamador

	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Calculando o endereço onde começa a imagem da primeira seleção de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 59		# a1 = número da coluna onde começa a imagem = 59
		li a2, 52		# a1 = número da linha onde começa a imagem  = 52
		call CALCULAR_ENDERECO	
	
	mv t2, a0		# salvo o endereço retornado em t2
	
	# Calculando o endereço onde começa a imagem da ultima seleção de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 239		# a1 = número da coluna onde começa a imagem = 239
		li a2, 52		# a1 = número da linha onde começa a imagem  = 52
		call CALCULAR_ENDERECO	
	
	mv t3, a0		# salvo o endereço retornado em t3
	
	mv t4, t2		# t4 guarda o endereço da coluna atualmente selecionada, inicialmente
				# será a coluna apontada por t2
	
	
	la t5, selecao_colunas		# carrega a imagem em t5	
	addi t5, t5, 8			# pula para onde começa os pixels no .data
	addi t5, t5, 529		# pula para onde começa as imagens de seleção com peça no .data
		
	li t0, 529		# para encontrar a imagem de seleção correta de acordo com a cor escolhida 
				# pelo jogador basta fazer essa multiplicação. 
	mul t0, s0, t0		# 529 é a quantidade de pixels uma imagem de seleção e outra 
				# O valor de s0 (cor escolhida) vai determinar quantos pixels é necessário 
	add t5, t5, t0		# pular para encontrar a imagem certa
				
	# Antes de tudo imprime uma imagem da peça escolhida pelo jogador na seçção TURNO
	# da tela do tabuleiro
	
	# Calcula o endereço da secção TURNO do tabuleiro
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 175		# a1 = número da coluna onde começa a imagem = 175
		li a2, 224		# a1 = número da linha onde começa a imagem  = 224
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endereço retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde começa os pixels no .data
	
	li t0, 110		# para encontrar a imagem da peça escolhida pelo jogador
	mul t0, s0, t0		# basta fazer essa multiplicaçaõ. t0 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o valor de s0 (cor 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels é necessário pular para
				# encontrar a imagem certo 
					
	# Imprime na parte inferior da tela, na secção TURNO, a imagem da peça do jogador
	# a0 tem o endereço da imagem
	# a1 tem o endereço de onde imprimir a imagem
	li a2, 11		# número de colunas da imagem 
	li a3, 10		# número de linhas da imagem 
	call PRINT_IMG
	
	li t6, 0		# t6 guarda o numero da coluna (de 0 a 6) atualmente selecionada,
				# de inicio a coluna selecioanda é a 0

	# Inicialmente seleciona a primeira coluna 
	li a1, 0		# a1 recebe 0 pois a coluna a ser seleciona é a atual
	addi t1, t6, 0		# t1 recebe o valor da coluna atual
	j SELECIONAR_COLUNA																							
																																																																								
	LOOP_TURNO_JOGADOR:
		call VERIFICAR_TECLA_APERTADA
		
		# Neste loop t1 vai receber o endereço da próxima coluna a ser selecionada
		# dependendo do input do usuário
		
		li t0, 'p'			# se 'p' foi apertado reinicia o jogo
		beq a0, t0, REINICIAR_DADOS
		
		li t0, 'a'
		li a1, -30	# a1 recebe -30 porque é o necessário para acessar o endereço da coluna 
				# a esquerda da atual
		addi t1, t6, -1			# t1 recebe o valor da coluna a esquerda 								
		beq a0, t0, SELECIONAR_COLUNA
		li t0, 'd'
		li a1, 30	# a1 recebe 30 porque é o necessário para acessar o endereço da coluna 
				# a direita da atual
		addi t1, t6, 1			# t1 recebe o valor da coluna a direita 					
		beq a0, t0, SELECIONAR_COLUNA
		li t0, 10				# t0 = valor da tecla enter
		beq a0, t0, FIM_LOOP_TURNO_JOGADOR	# Se o ENTER foi apertado, termina o loop
		j LOOP_TURNO_JOGADOR
		
		SELECIONAR_COLUNA:
			# Primeiro verifica se o endereço t0 está dentro dos limites, ou seja,
			# se é maior que t2 (endereço da primeria coluna) e menor que t3(endereço da 
			# última coluna), caso esteja fora nada deve acontecer
			
			add t0, t4, a1	# t0 vai receber o endereço da coluna atualmente selecionada (t4)
					# mais ou menos 30 (a1), essencialmente passando para t0 o endereço
					# da coluna a direita ou esquerda, dependendo da tecla que foi
					# apertada
						
			blt t0, t2, LOOP_TURNO_JOGADOR
			bgt t0, t3, LOOP_TURNO_JOGADOR
		
			mv t6, t1		# atualiza o valor da coluna atual
					
			# Primeiramente é retirado a seleção da coluna atual			
			la a0, selecao_colunas	# carrega a imagem em a0
			addi a0, a0, 8		# pula para onde começa os pixels . data
			
			mv a1, t4		# passa para a1 o endereço da coluna atual
			
			mv t4, t0	# atualiza o endereço de t4 com o endereço da próxima coluna	
		
			li a2, 23		# número de colunas da imagem 
			li a3, 23		# número de linhas da imagem 
			call PRINT_IMG
			
			slli t0, t6, 2		# multiplica t6 por 4, já que cada word tem 4 bytes
			add t0, t0, s2		# passa para t0 o endereço da coluna atual, de acordo com
						# o vetor de colunas em s2
			lw t1, 0(t0)		# pega o valor armazendo no vetor de colunas (numero de 
						# peças restantes)
		
			# se t1 == 0 então não há mais espaço para peças nessa coluna, portanto
			# nada deve acontecer e será impresso uma imagem com X na coluna
			bne t1, zero, COLUNA_LIVRE
				la a0, selecao_colunas	# carrega a imagem em a0
				addi a0, a0, 8		# pula para onde começa os pixels . data
				addi a0, a0, 1587	# pula para onde começa a imagem de seleção com X
				mv a1, t4		# a1 recebe o endereço da coluna atual	
				li a2, 23		# número de colunas da imagem 
				li a3, 23		# número de linhas da imagem 
				call PRINT_IMG

				j LOOP_TURNO_JOGADOR
			
			COLUNA_LIVRE:
			
			# Seleciona a coluna escolhida
			mv a0, t5		# t5 tem o endereço da imagem de seleção com a cor do jogador
			mv a1, t4		# a1 recebe o endereço da coluna atual	
			li a2, 23		# número de colunas da imagem 
			li a3, 23		# número de linhas da imagem 
			call PRINT_IMG
			
			j LOOP_TURNO_JOGADOR
			
	FIM_LOOP_TURNO_JOGADOR:

	# Decrementando a quantidade de peças restantes na coluna selecionada, porém somente
	# se o número de peças restantes for != 0
	slli t0, t6, 2		# multiplica t6 por 4, já que cada word tem 4 bytes
	add t0, t0, s2		# passa para t0 o endereço da coluna atual, de acordo com o vetor de colunas em s2
	lw t1, 0(t0)		# pega o valor armazendo no vetor de colunas (numero de peças restantes)
	
		# Se o numero de peças restantes for 0 não faz nada e reinicia o procedimento
		beq t1, zero, LOOP_TURNO_JOGADOR
	
	addi t1, t1, -1		# decrementa o numero de peças restantes
	sw t1, 0(t0)		# armazena o valor no vetor de colunas
	
	# Se com esse movimento a coluna não pode mais receber peças é ncessario decrementar o 
	# numero de colunas livres
	bne t1, zero, JOGADOR_INSERIR_PECA
		la t0, NUM_COLUNAS_LIVRES	# t0 tem o endereço de NUM_COLUNAS_LIVRES
		lw t1, 0(t0)			# t1 tem o numero de colunas livres
		addi t1, t1, -1			# decrementa t1
		sw t1, 0(t0)			# armazena t1 em NUM_COLUNAS_LIVRES
	
	JOGADOR_INSERIR_PECA:	
	# Atualiza a matriz do tabuleiro
	addi a0, s0, 1	# incrementa s0 de forma que a0 == 1 se a peça escolhida foi VERMELHA e a0 == 2 caso
			# a cor escolhida foi AMAARELA	
	mv a1, t6	# move para a1 o valor da coluna selecionada
	call ATUALIZAR_MATRIZ_TABULEIRO					
								
	# Agora é necessário retirar a seleção da coluna antes de prosseguir
	la a0, selecao_colunas	# carrega a imagem em a0
	addi a0, a0, 8		# pula para onde começa os pixels .data
	mv a1, t4		# a1 recebe o endereço da coluna atual		
	li a2, 23		# número de colunas da imagem 
	li a3, 23		# número de linhas da imagem 
	call PRINT_IMG
	
	# É necessário renderizar a peça descendo pela coluna do tabuleiro
	addi a1, t4, 642	# passa para o argumento a1 o endereço de t4 (endereço da coluna atual) mais
				# 962 de forma que a0 tem o endereço somente da imagem da peça
				
	la a0, pecas_tabuleiro	# carrega a imagem
	addi a0, a0, 8		# pula para onde começa os pixels no .data
	
	li t0, 361		# para encontrar a imagem da peça escolhida pelo jogador
	mul t0, s0, t0		# basta fazer essa multiplicação. t0 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o valor de s0 (cor 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels é necessário pular para
				# encontrar a imagem certo 			
										
	call DESCER_PECA
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

# ====================================================================================================== #

TURNO_COMPUTADOR:
	# Procedimento responsável por coordenar o turno do computador, incluindo a chamada de procedimentos
	# para decidir qual a jogada dependendo da dificuldade escolhida.

	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Antes de tudo imprime uma imagem da peça do computador na seçção TURNO
	# da tela do tabuleiro
	
	# Calcula o endereço da secção TURNO do tabuleiro
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 175		# a1 = número da coluna onde começa a imagem = 175
		li a2, 224		# a1 = número da linha onde começa a imagem  = 224
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endereço retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde começa os pixels no .data
	
	xori t0, s0, 1		# t0 recebe o inverso de s0
	
	li t1, 110		# para encontrar a imagem da peça do computador basta fazer
	mul t1, t0, t1		# essa multiplicaçaõ. t1 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o inverso de s0 (cor 
	add a0, a0, t1		# escolhida pelo jogador) vai determinar quantos pixels é necessário 
				# pular para encontrar a imagem certa da peça do computador 
					
	# Imprime na parte inferior da tela, na secção TURNO, a imagem da peça do computador
	# a0 tem o endereço da imagem
	# a1 tem o endereço de onde imprimir a imagem
	li a2, 11		# número de colunas da imagem 
	li a3, 10		# número de linhas da imagem 
	call PRINT_IMG
	
	# Decide qual procedimento chamar de acordo com a dificuldade
	
	beq s1, zero, COMPUTADOR_JOGADA_FACIL
	
	li t0, 1
	beq s1, t0, COMPUTADOR_JOGADA_MEDIO
		
	li t0, 2
	beq s1, t0, COMPUTADOR_JOGADA_DIFICIL
	
		
	# Embora não seja provável, caso s1 tem um valor diferente de 0, 1 ou 2 o procedimento termina		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

	COMPUTADOR_REALIZAR_JOGADA:
	# Do retorno dos procedimentos de decisão a0 tem o numero da coluna escolhida
	
	# Atualiza o numero de posições livres para a coluna escolhida no vetor de colunas
	slli t0, a0, 2	# multiplica a0 por 4 porque cada word tem 4 bytes
	add t1, t0, s2	# passa t1 para o endereço da coluna escolhida no vetor de colunas
	lw t2, 0(t1)	# pega o valor armazenado no vetor de colunas, ou seja, o numero de peças restantes
	
	addi t2, t2, -1	# decrementa o numero de peças restantes
	
	sw t2, 0(t1)	# armazena o valor atualizado no vetor de colunas		
	
	# Se com esse movimento a coluna não pode mais receber peças é ncessario decrementar o 
	# numero de colunas livres
	bne t2, zero, COMPUTADOR_COLOCAR_SELECAO
		la t0, NUM_COLUNAS_LIVRES	# t0 tem o endereço de NUM_COLUNAS_LIVRES
		lw t1, 0(t0)			# t1 tem o numero de colunas livres
		addi t1, t1, -1			# decrementa t1
		sw t1, 0(t0)			# armazena t1 em NUM_COLUNAS_LIVRES
	
	COMPUTADOR_COLOCAR_SELECAO:	
	
	mv t4, a0	# salva a coluna escolhida em t4
	
	# Atualiza a matriz do tabuleiro
	xori t0, s0, 1	# inverte o valor de s0 e soma 1 de modo que a0 == 1 se a peça do computador for 
 	addi a0, t0, 1	# VERMELHA e a0 == 2 se for AMARELA
	mv a1, t4	# move para a1 o valor da coluna selecionada
	call ATUALIZAR_MATRIZ_TABULEIRO	
	
	
	# Calculando o endereço onde começa a imagem da primeira seleção de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 59		# a1 = número da coluna onde começa a imagem = 59
		li a2, 52		# a1 = número da linha onde começa a imagem  = 52
		call CALCULAR_ENDERECO	
	
	li t3, 30 		# t3 tem a quantidade de pixels de diferença entre uma coluna e outra
		
	mul t4, t4, t3		# através dessa multiplicação decide quantos pixels tem que ser pulados 
				# para encontrar o endereço da coluna escolhida pelo computador
	
	add a1, a0, t4		# passa o endereço de a1 para o endereço da coluna escolhida pelo computador
		
	
	la t0, selecao_colunas		# carrega a imagem em t5	
	addi t0, t0, 8			# pula para onde começa os pixels no .data
	addi t0, t0, 529		# pula para onde começa as imagens de seleção com peça no .data
		
	li t1, 529		# para encontrar a imagem de seleção correta de acordo com a cor do computador 
	xori t2, s0, 1		# basta fazer essa multiplicação. 
	mul t1, t2, t1		# 529 é a quantidade de pixels entre uma imagem de seleção e outra 
				# O valor inverso de s0 (cor escolhida pelo jogador) vai determinar quantos 
	add a0, t0, t1		# pixels é necessário pular para encontrar a imagem certa da peça do computador
	
	mv t2, a1		# salva em t2 o endereço de a1
	
	# Imprime a imagem de seleção na coluna escolhida pelo computador
	# a0 tem o endereço da imagem de seleção
	# a1 tem o endereço da coluna, ou seja, de onde imprimir a imagem
	li a2, 23		# número de colunas da imagem 
	li a3, 23		# número de linhas da imagem 
	call PRINT_IMG
	
	# Espera alguns milisegundos	
		li a0, 1000			# sleep por 1 s
		call SLEEP			# chama o procedimento sleep
	
	# Agora é necessário retirar a seleção da coluna antes de prosseguir
	la a0, selecao_colunas	# carrega a imagem em a0
	addi a0, a0, 8		# pula para onde começa os pixels .data
	mv a1, t2		# a1 recebe o endereço da coluna selecionada		
	li a2, 23		# número de colunas da imagem 
	li a3, 23		# número de linhas da imagem 
	call PRINT_IMG
	
	# É necessário renderizar a peça descendo pela coluna do tabuleiro
	addi a1, t2, 642	# passa para o argumento a0 o endereço de t2 (endereço da coluna selecionada) mais
				# 962 de forma que a0 tem o endereço somente da imagem da peça
				
	la a0, pecas_tabuleiro	# carrega a imagem
	addi a0, a0, 8		# pula para onde começa os pixels no .data
	
	li t0, 361		# para encontrar a imagem de seleção correta de acordo com a cor do computador 
	xori t1, s0, 1		# basta fazer essa multiplicação. 
	mul t0, t1, t0		# 529 é a quantidade de pixels entre uma imagem de seleção e outra 
				# O valor inverso de s0 (cor escolhida pelo jogador) vai determinar quantos 
	add a0, a0, t0		# pixels é necessário pular para encontrar a imagem certa da peça do computador
																																					
	call DESCER_PECA
	
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret		
									
# ====================================================================================================== #

COMPUTADOR_JOGADA_FACIL:
	# Procedimento que decide qual a proxima jogada do computador na dificuldade facil
	# A jogada consiste em escolher em qual coluna, de 0 a 6, o computador vai inserir a peça
	# Nesse nível de dificuldade a escolha da coluna é randômica
	#
	# Retorno:
	# 	O procedimento sempre vai retornar para COMPUTADOR_REALIZAR_JOGADA com	
	# 	a0 = um número de 0 a 6 representando a coluna escolhida 
	
	# Obs: não é necessário salvar o valor de ra, pois a chegada a esse procedimento é através de 
	# uma instrução de branch e a saída é sempre para o label COMPUTADOR_REALIZAR_JOGADA
	
	csrr	s4, instret	# le o numero de intruções antes do procedimento
	csrr	s5, cycle	# le o numero de ciclos antes do procedimento
	csrr	s6, time	# le o tempo do sistema antes do procedimento
													
	call ESCOLHER_COLUNA_RANDOMICA

	csrr	t2, time	# le o tempo do sistema depois do procedimento		
	csrr	t1, cycle	# le o numero de ciclos depois do procedimento
	csrr	t0, instret	# le o numero de intruções depois do procedimento
	
	sub	s4, t0, s4	# I = diferença entre o numero de intruções antes e depois do procedimento
	sub	s5, t1, s5	# C = diferença entre o numero de ciclos antes e depois do procedimento
	addi	s5, s5, 2	# Corrige o C pelas 2 instruções a mais
	sub	s6, t2, s6	# Texec = diferença entre o tempo  antes e depois do procedimento
	
	call MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA	
				
	# pelo retorno do procedimento acima a0 tem o numero da coluna escolhida	
 					 				
	j COMPUTADOR_REALIZAR_JOGADA		
	
	
# ====================================================================================================== #

COMPUTADOR_JOGADA_MEDIO:
	# Procedimento que decide qual a proxima jogada do computador na dificuldade médio
	# A jogada consiste em escolher em qual coluna, de 0 a 6, o computador vai inserir a peça
	# Nesse nível de dificuldade o computador pode fazer dois tipos de movimentos: um defensivo
	# e um ofensivo. No defensivo ele vai procurar por grupos de 3 peças do jogador e tentar
	# impedir que um grupo de 4 seja feito botando uma peça no meio do caminho. O computador joga de forma
	# randômica até que um grupo de 3 de suas peças sejam formados, aí ele joga de maneira ofensiva
	# tentando aumentar esse grupo para formar um agrumento de 4 peças. 
	# Caso seja possível realizar tanto a jogada defensiva quanto a ofensiva ele sempre vai escolher
	# a defensiva em primeiro lugar. 
	# 
	# Retorno:
	# 	O procedimento sempre vai retornar para COMPUTADOR_REALIZAR_JOGADA com	
	# 	a0 = um número de 0 a 6 representando a coluna escolhida 
	
	# Obs: não é necessário salvar o valor de ra, pois a chegada a esse procedimento é através de 
	# uma instrução de branch e a saída é sempre para o label COMPUTADOR_REALIZAR_JOGADA
 
 	csrr	s4, instret	# le o numero de intruções antes do procedimento
	csrr	s5, cycle	# le o numero de ciclos antes do procedimento
	csrr	s6, time	# le o tempo do sistema antes do procedimento
													
							
	# DEFENSIVA --------------------------------------------------------------------------------
	# Primeiramente o computador tenta fazer uma jogada defensiva, encontrando grupos de 3 peças
	# do jogador e impedindo a expansão deles
	li a6, 3		# vai procurar por grupos do jogador com pelo menos 3 peças
	call ESCOLHER_COLUNA_DEFENSIVA	

	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_MEDIO
	
	# OFENSIVA --------------------------------------------------------------------------------	
	# Se não é possível fazer uma jogada defensiva então o computador tenta uma ofensiva
	li a6, 3		# vai procurar por grupos do computador com pelo menos 3 peças
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_MEDIO
	
	# Se nenhum grupo foi encontrado, tanto para a jogada ofensiva quanto defensiva, então
	# escolhe uma coluna randômicamente 
	
	call ESCOLHER_COLUNA_RANDOMICA 

	# pelo retorno do procedimento acima a0 tem o numero da coluna escolhida	

FIM_COMPUTADOR_JOGADA_MEDIO:
 	
	csrr	t2, time	# le o tempo do sistema depois do procedimento		
	csrr	t1, cycle	# le o numero de ciclos depois do procedimento
	csrr	t0, instret	# le o numero de intruções depois do procedimento
	
	sub	s4, t0, s4	# I = diferença entre o numero de intruções antes e depois do procedimento
	sub	s5, t1, s5	# C = diferença entre o numero de ciclos antes e depois do procedimento
	addi	s5, s5, 2	# Corrige o C pelas 2 instruções a mais
	sub	s6, t2, s6	# Texec = diferença entre o tempo  antes e depois do procedimento
	
	call MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA
																																																																																					
	j COMPUTADOR_REALIZAR_JOGADA	
	
# ====================================================================================================== #

COMPUTADOR_JOGADA_DIFICIL:
	# Procedimento que decide qual a proxima jogada do computador na dificuldade dificil
	# A jogada consiste em escolher em qual coluna, de 0 a 6, o computador vai inserir a peça
	# Nesse nível de dificuldade o computador pode fazer dois tipos de movimentos: um defensivo
	# e um ofensivo. No defensivo ele vai procurar por grupos de 2 peças do jogador e tentar
	# impedir que um grupo de 4 seja feito botando uma peça no meio do caminho. O computador joga de forma
	# randômica até que um grupo de 1 de suas peças sejam formados, aí ele joga de maneira ofensiva
	# tentando aumentar esse grupo para formar um agrumento de 4 peças. 
	# Caso seja possível realizar tanto a jogada defensiva quanto a ofensiva ele sempre vai escolher
	# a defensiva em primeiro lugar. 
	# 
	# Retorno:
	# 	O procedimento sempre vai retornar para COMPUTADOR_REALIZAR_JOGADA com	
	# 	a0 = um número de 0 a 6 representando a coluna escolhida 
	
	# Obs: não é necessário salvar o valor de ra, pois a chegada a esse procedimento é através de 
	# uma instrução de branch e a saída é sempre para o label COMPUTADOR_REALIZAR_JOGADA

	csrr	s4, instret	# le o numero de intruções antes do procedimento
	csrr	s5, cycle	# le o numero de ciclos antes do procedimento
	csrr	s6, time	# le o tempo do sistema antes do procedimento
	
	# DEFENSIVA --------------------------------------------------------------------------------
	# Primeiramente o computador tenta fazer uma jogada defensiva, encontrando grupos de 3 peças
	# do jogador e impedindo a expansão deles
	li a6, 3		# vai procurar por grupos do jogador com pelo menos 3 peças
	call ESCOLHER_COLUNA_DEFENSIVA	

	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL

	# Se não há grupos de 3 peças então tenta encontrar grupos de 2 peças do jogador e 
	# impede a expansão deles
	li a6, 2		# vai procurar por grupos do jogador com pelo menos 2 peças
	call ESCOLHER_COLUNA_DEFENSIVA	

	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL
	
	
	# OFENSIVA --------------------------------------------------------------------------------					
	# Se não é possível fazer uma jogada defensiva então o computador tenta uma ofensiva
	li a6, 3		# vai procurar por grupos do computador com pelo menos 3 peças
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL

	# Se não há grupos de 3 peças então tenta encontrar grupos de 2 peças para expandi-los
	li a6, 2		# vai procurar por grupos do computador com pelo menos 2 peças
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL
	
	# Se não há grupos de 3 e 2 peças então tenta encontrar grupos de 1 peças para expandi-los
	li a6, 1		# vai procurar por grupos do computador com pelo menos 1 peças
	call ESCOLHER_COLUNA_OFENSIVA
	
	# se a0 != -1 significa que algum grupo foi encontrado e a0 tem o valor da coluna escolhida
	li t0, -1
	bne a0, t0, FIM_COMPUTADOR_JOGADA_DIFICIL
							
	# Se nenhum grupo foi encontrado, tanto para a jogada ofensiva quanto defensiva, então
	# escolhe uma coluna randômicamente 
	
	call ESCOLHER_COLUNA_RANDOMICA 

	# pelo retorno do procedimento acima a0 tem o numero da coluna escolhida	

FIM_COMPUTADOR_JOGADA_DIFICIL:
 	
	csrr	t2, time	# le o tempo do sistema depois do procedimento		
	csrr	t1, cycle	# le o numero de ciclos depois do procedimento
	csrr	t0, instret	# le o numero de intruções depois do procedimento
	
	sub	s4, t0, s4	# I = diferença entre o numero de intruções antes e depois do procedimento
	sub	s5, t1, s5	# C = diferença entre o numero de ciclos antes e depois do procedimento
	addi	s5, s5, 2	# Corrige o C pelas 2 instruções a mais
	sub	s6, t2, s6	# Texec = diferença entre o tempo  antes e depois do procedimento
	
	call MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA
													
	j COMPUTADOR_REALIZAR_JOGADA	
	
# ====================================================================================================== #

ESCOLHER_COLUNA_RANDOMICA:
	# Procedimento auxiliar COMPUTADOR_JOGADA_FACIL e COMPUTADOR_JOGADA_MEDIO que escolhe randomicamente 
	# um numero de coluna (0 a 6) que não está cheia
	#
	# Retorno:
	#	a0 = numero de 0 a 6 da coluna escolhida
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	# Antes de tudo é necessário saber quantas colunas estão livres
	la t0, NUM_COLUNAS_LIVRES	# t0 tem o endereço de NUM_COLUNAS_LIVRES
	lw a0, 0(t0)			# t0 tem o numero de colunas livres
	
	# Obs: para o turno do computador é garantido que sempre vai haver pelo menos 1 coluna livre, porque
	# é o jogador que coloca a ultima peça possível no tabuleiro e aí acontece um empate
	
	# Escolhe um numero randomico entre 0 e t0 (numero de colunas livres)
	# De forma que o retorno a0 representa que o computador "quer" a n-esima coluna livre do tabuleiro
	call ENCONTRAR_NUMERO_RANDOMICO
	
	addi a0, a0, 1		# é necessario incrementar a0 porque o ENCONTRAR_NUMERO_RANDOMICO acima 
				# inclui o numero 0

	# Agora é necessário procurar qual é a n-esima coluna livre
	
	li t1, -1	# numero da coluna que está sendo analisada	
	
	LOOP_ENCONTRAR_COLUNA_COMPUTADOR:
		addi t1, t1, 1	# incrementa o numero da coluna sendo analisada
		
		slli t2, t1, 2	# multiplica t1 por 4 porque cada word tem 4 bytes
		add t2, t2, s2	# passa t2 para o endereço da coluna atual no vetor de colunas
		lw t2, 0(t2)	# pega o valor armazenado no vetor de colunas, ou seja, o numero de peças restantes
		
		# Se t2 == 0 então a coluna não está livre e não deve ser levada em conta na contagem de a0
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
	# objetivo ajudar o computador a escolher uma coluna de forma ofensiva, ou seja, é verificado se 
	# existe algum grupo de pelo menos um espaço livre e pelo menos a6 peças do computador na horizontal, 
	# vertical ou diagonal para que o computador possa expandi-lo
	# O procedimento sempre parte do ponto de vista que ele será usado somente pelo computador para 
	# encontrar peças do computador
	# Argumentos:
	#	a6 = numero minimo de peças no grupo
	#
	# Retorno:
	#	a0 = se nenhum grupo possível foi encontrado a0 = -1, caso contrário 
	#	a0 recebe um numero de 0 a 6 representando a coluna escolhida
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	li t0, 4	# numero de peças em um grupo
	
	sub a6, t0, a6	# a6 - 4 = numero maximo de peças vazias no grupo
	
	# Verifica se foi formado algum grupo de pelo menos a6 na horizontal				
	xori a0, s0, 1	# a0 recebe o inverso da peça do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a peça do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 4	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	mv a2, s3	# a2 recebe o endereço da matriz onde começar a busca
	li a3, 5	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na vertical				
	xori a0, s0, 1	# a0 recebe o inverso da peça do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a peça do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 28	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	mv a2, s3	# a2 recebe o endereço da matriz onde começar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 7	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
		
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da esquerda para direita				
	xori a0, s0, 1	# a0 recebe o inverso da peça do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a peça do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 32	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	mv a2, s3	# a2 recebe o endereço da matriz onde começar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da direita para a esquerda				
	xori a0, s0, 1	# a0 recebe o inverso da peça do jogador 
	addi a0, a0, 1	# invertendo o valor de a0 e somando 1 de modo que a0 == 1 se a peça do 
 			# computador for VERMELHA e t4 == 2 se for AMARELA
	li a1, 24	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	addi a2, s3, 12	# a2 recebe o endereço da matriz onde começar a busca, nesse caso a 1a linha 
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado termina o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_OFENSIVA
	
	li a0, -1	# a0 = -1 significa que nenhum grupo foi encontrado

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

	RETORNAR_COLUNA_OFENSIVA:
	# se um grupo foi encontrado é necessário transformar o retorno a1 de VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	# em um numero de coluna de 0 a 6
	
	li t0, 7	# t0 recebe o numero de colunas da matriz
	
	sub a1, a1, s3	# a1 recebe a diferença de a1 e o endereço de inicio da matriz
	srai a1, a1, 2	# divide a1 por 4 porque cada endereço de 4 bytes
	
	rem a0, a1, t0	# a0 recebe o resto da divisão de a0 / 7 de modo que a0 tem um numero de 0 a 6
			# representando a coluna do endereço a1 na matriz do tabuleiro
			
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

# ====================================================================================================== #

ESCOLHER_COLUNA_DEFENSIVA:
	# Procedimento auxiliar a COMPUTADOR_JOGADA_MEDIO e COMPUTADOR_JOGADA_DIFICIL que tem como 
	# objetivo ajudar o computador a escolher uma coluna de forma defensiva, ou seja, é verificado se 
	# existe algum grupo de pelo menos um espaço livre e pelo menos a6 peças do jogador na horizontal, 
	# vertical ou diagonal para que o computador possa impedir a sua expansão
	# O procedimento sempre parte do ponto de vista que ele será usado somente pelo computador para 
	# encontrar peças do jogador
	# Argumentos:
	#	a6 = numero minimo de peças no grupo
	#
	# Retorno:
	#	a0 = se nenhum grupo possível foi encontrado a0 = -1, caso contrário 
	#	a0 recebe um numero de 0 a 6 representando a coluna escolhida
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	li t0, 4	# numero de peças em um grupo
	
	sub a6, t0, a6	# a6 - 4 = numero maximo de peças vazias no grupo
	

	# Verifica se foi formado algum grupo de pelo menos a6 na horizontal				
	addi a0, s0, 1	# a0 tem o valor da peça do jogador na matriz, ou seja, a0 recebe o valor que 
			# será procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 4	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	mv a2, s3	# a2 recebe o endereço da matriz onde começar a busca
	li a3, 5	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na vertical				
	addi a0, s0, 1	# a0 tem o valor da peça do jogador na matriz, ou seja, a0 recebe o valor que 
			# será procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 28	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	mv a2, s3	# a2 recebe o endereço da matriz onde começar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 7	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
		
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da esquerda para direita				
	addi a0, s0, 1	# a0 tem o valor da peça do jogador na matriz, ou seja, a0 recebe o valor que 
			# será procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 32	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	mv a2, s3	# a2 recebe o endereço da matriz onde começar a busca
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado continua o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
	
	# Verifica se foi formado algum grupo de pelo menos a6 na diagonal da direita para a esquerda				
	addi a0, s0, 1	# a0 tem o valor da peça do jogador na matriz, ou seja, a0 recebe o valor que 
			# será procurado para formar grupos. Nesse caso a0 recebe s0 + 1, ou seja, 
			# se o jogador escolheu VERMELHO a0 recebe 1 e se escolheu AMARELO a0 recebe 2
	li a1, 24	# a1 recebe a distancia em bytes que será pulada entre uma posição e outra
	addi a2, s3, 12	# a2 recebe o endereço da matriz onde começar a busca, nesse caso a 1a linha 
	li a3, 2	# a3 recebe o numero de linhas a serem analisadas a partir de a2
	li a4, 4	# a4 recebe o numero de colunas a serem analisadas por cada linha de a3
	mv a5, a6	# a5 recebe o maximo de posições vazias permitidas no grupo
	call VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	
	# se um grupo nao foi formado termina o processo de verificação
	bne a0, zero, RETORNAR_COLUNA_DEFENSIVA
	
	li a0, -1	# a0 = -1 significa que nenhum grupo foi encontrado

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	

	RETORNAR_COLUNA_DEFENSIVA:
	# se um grupo foi encontrado é necessário transformar o retorno a1 de VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS
	# em um numero de coluna de 0 a 6
	
	li t0, 7	# t0 recebe o numero de colunas da matriz
	
	sub a1, a1, s3	# a1 recebe a diferença de a1 e o endereço de inicio da matriz
	srai a1, a1, 2	# divide a1 por 4 porque cada endereço de 4 bytes
	
	rem a0, a1, t0	# a0 recebe o resto da divisão de a0 / 7 de modo que a0 tem um numero de 0 a 6
			# representando a coluna do endereço a1 na matriz do tabuleiro
			
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret	
	
# ====================================================================================================== #
	
VERIFICAR_POSSIVEIS_GRUPOS_DE_PECAS:
	# Procedimento auxiliar a COMPUTADOR_JOGADA_MEDIO e COMPUTADOR_JOGADA_DIFICIL que tem como 
	# objetivo verificar a partir da matriz do tabuleiro se existe algum POSSIVEL grupo de 4 peças 
	# de mesma cor 
	# A diferença desse procedimento para VERIFICAR_GRUPOS_DE_PECAS em fim_de_jogo.s é que esse procedimento
	# verifica POSSÍVEIS grupos, ou seja, dependo do argumento a5 ele procura grupos de 4 posições no tabuleiro
	# em que no máximo a5 posições estão vazias e o resto possui peças da mesma cor, retornando o endereço 
	# na matriz de uma dessas posições vazias para que o computador possa realizar a sua jogada
	# Esse procedimento só deve ser usado para encontrar POSSIVEIS grupos, ou seja, quando a5 é pelo menos 1
	
	# Argumentos:
	#	a0 = cor de peça que será analisada para identificar os grupos, com:
	#		[ 1 ] = Vermelho
	#		[ 2 ] = Amarelo 
	#	a1 = distância a ser pulada em bytes entre um endereço da matriz e outro para encontrar as
	#	outras peças, ou seja, é esse argumento que permite escolher se deseja verificar 
	#	grupos na diagonal, vertical ou horizontal. Por exemplo, se deseja verificar grupos
	#	na vertical então a1 = 28, porque esse é o valor entre uma posição da matriz e a posição
	#	na linha imediatamente abaixo 
	#	a2 = endereço na matriz do tabuleiro de onde a busca deve começar
	#	a3 = numero de linhas do tabuleiro a serem analisadas a partir de a1
	#	a4 = numero de colunas do tabuleiro a serem analisadas por cada linha de a3
	# 	a5 = numero máximo de posições vazias no grupo
	# Retorno:
	# 	a0 = 1 se foi detectado um grupo com esses parametros ou 0 caso contrário
	# 	a1 = se houve um grupo válido com esses parâmetros a1 recebe o endereço, na matriz do 
	#	tabuleiro, da última posição vazia encontrada no grupo
	
	VERIFICAR_POSSIVEIS_GRUPOS_LINHAS:
		mv t0, a2	# copia de a2 para usar no loop de colunas
		mv t1, a2	# copia de a2 para usar no loop de colunas
		
		mv t2, a4	# copia de a4 para usar no loop de colunas
		
		VERIFICAR_POSSIVEIS_GRUPOS_COLUNAS:		
			mv t3, a5	# copia de a5 para usar no loop de colunas
			li t4, 4	# t4 = numero de posições a serem analisadas para encontrar um grupo
			li t6, -1	# t6 vai receber o endereço da ultima posição vazia do grupo. porém
					# só se essa posição estiver em cima de uma peça ou se for da ultima
					# linha
			
			VERIFICAR_POSSIVEIS_GRUPOS_POSICOES:
				lw t5, 0(t1)		# t5 recebe o valor armazenado em t1
			
				# se t5 != 0 então a posição não está vazia
				bne t5, zero, POSICAO_NAO_VAZIA	
					addi t3, t3, -1 # se a posição está vazia decrementa o número de 
							# máximo de posições vazias permitidas
					# Se depois desse decremento o numero de máximo de posições
					# vazias ficar menor do que zero então há mais posições vazias
					# do que o permitido, então não é necessário verificar mais posições
					# porque não existe um grupo válido com esses parâmetros 
					blt t3, zero, FIM_VERIFICAR_POSSIVEIS_GRUPOS_POSICOES
									
					addi t5, s3, 112	# t5 recebe o endereço de começo da ultima 
								# linha da matriz
					
					# se o endereço de t1 > t5 então segue o loop						
					bge t1, t5, POSICAO_VAZIA_VALIDA
						# se não verifica a posição da linha de baixo
						lw t5, 28(t1)
						# se a posição estiver em cima de nada verifica a proxima
						beq t5, zero, VERIFICAR_PROXIMA_POSICAO 		
					
					POSICAO_VAZIA_VALIDA:				
					mv t6, t1	# salva em t6 o endereço na matriz da posição 
							# vazia encontrada
													
					j VERIFICAR_PROXIMA_POSICAO
					
				POSICAO_NAO_VAZIA:
					# verifica se a peça encontrada é da cor procurada (a0), se não for 
					# então não é necessário verificar mais posições
					# porque não existe um grupo válido com esses parâmetros 
					bne t5, a0, FIM_VERIFICAR_POSSIVEIS_GRUPOS_POSICOES
			
			VERIFICAR_PROXIMA_POSICAO:		
			addi t4, t4, -1		# decrementa o numero de posições a serem analisadas
			add t1, t1, a1		# passa o endereço de t1 para a proxima posição de acordo com a1
			bne t4, zero, VERIFICAR_POSSIVEIS_GRUPOS_POSICOES	# reinicia o loop se t4 != 0
			
			# se todas as 4 posições foram analisadas e não ocorreu nenhum branch, ou seja, se 
			# não existem mais posições vazias do que o permitido, todas as outras peças são
			# da cor procurada (a0) e t6 != -1, ou seja, existe uma posicao vazia valida, então 
			# um grupo válido foi encontrado
			
			li t5, -1
			bne t6, t5, POSSIVEL_GRUPO_PECAS_DETECTADO	
		
			FIM_VERIFICAR_POSSIVEIS_GRUPOS_POSICOES:
		
			
			addi t0, t0, 4		# passa o endereço de t0 para a proxima coluna da matriz
			mv t1, t0		# atualiza o endereço de t1		
			addi t2, t2, -1		# decrementa o numero de colunas restantes 
			bne t2, zero, VERIFICAR_POSSIVEIS_GRUPOS_COLUNAS	# reinica o loop se t2 != 0
		
		addi a2, a2, 28		# passa o endereço de a2 para a proxima linha da matriz
		addi a3, a3, -1		# decrementa o numero de linhas restantes
		bne a3, zero, VERIFICAR_POSSIVEIS_GRUPOS_LINHAS	# reinica o loop se a3 != 0
	
	# se o procedimento chegou até aqui então nenhum grupo válido foi encontrado
	li a0, 0	# a0 recebe 0 pois nenhum grupo foi detectado
	
	ret
	
	POSSIVEL_GRUPO_PECAS_DETECTADO:
		li a0, 1	# a0 recebe 1 porque algum grupo foi encontrado
		mv a1, t6	# a1 recebe t6 porque t6 tem o endereço na matriz da ultima posição
				# vazia do grupo
	
		ret


# ====================================================================================================== #

DESCER_PECA:
	# Procedimento auxiliar que desce, gradualmente, uma peça pelo tabuleiro
	# A peça irá descer até que o procedimento identifique que não há espaço livre na coluna
	# O procedimento parte do pressuposto que cada peça tem 23 x 23
	# Argumentos:
	#	a0 = endereço da imagem da peça
	# 	a1 = endereço de onde, no frame, a imagem da peça esta

	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	mv t5, a0		# salva o argumento a0 em t5
	mv t6, a1		# salva o argumento a1 em t6
	
			
	# Para descer a peça em uma posição é necessário saber se o espaço está desocupado
	
		li t0, 10250		# somando 10250 ao endereço de a1 podemos encontrar o endreço
		add t0, a1, t0		# de inicio do slot abaixo do atual
	
		lb t0, 0(t0)
		
		li t1, 82		# t1 tem o valor da cor de fundo da tela
				
		# Se o valor do pixel apontado por t0 não for igual a t1 então o espaço não
		# está livre
		bne t0, t1, FIM_LOOP_DESCER_PECA	
		
		li t2, 32 	# para descer a peça para o slot abaixo é necessário realizar 32 loops
				# e em cada um a peça é movida um pixel para baixo
		
		j DESCER_PECA_SLOT						
									
	LOOP_DESCER_PECA:
		# Para descer a peça em uma posição é necessário saber se o espaço está desocupado
	
		li t0, 8010		# somando 8010 ao endereço de a1 podemos encontrar o endereço
		add t0, a1, t0		# de inicio do slot abaixo do atual
		
		lb t0, 0(t0)
	
		li t1, 82		# t1 tem o valor da cor de fundo da tela
			
		# Se o valor do pixel apontado por t0 não for igual a t1 então o espaço não
		# está livre
		bne t0, t1, FIM_LOOP_DESCER_PECA	
		
		li t2, 26 	# para descer a peça para o slot abaixo é necessário realizar 26 loops
				# e em cada um a peça é movida um pixel para baixo
				
		DESCER_PECA_SLOT:
		li t0, 19		# t0 = numero de linhas da imagem da peça
		
		DESCER_PECA_LINHAS:
		li t3, 19		# t3 = numero de colunas da imagem da peça
			
		DESCER_PECA_COLUNAS:
			lb t4, 0(a1)			# pega 1 pixel do bitmap e coloca em t4
			
			# só imprime a imagem se o pixel do bitmap for igual a t1 ou zero, ou seja,
			# se o lugar está livre
			
			li t1, 9		# t1 tem o valor da cor de fundo do tabuleiro
				
			beq t4, zero, NAO_IMPRIMIR_PECA			
			beq t4, t1, NAO_IMPRIMIR_PECA
				lb t4, 0(a0)		# pega 1 pixel do .data
				sb t4, 0(a1)		# pega o pixel de t4 e coloca no bitmap
	
			NAO_IMPRIMIR_PECA:
			
			addi t3, t3, -1				# decrementa o numero de colunas restantes
			addi a0, a0, 1				# vai para o próximo pixel da imagem
			addi a1, a1, 1				# vai para o próximo pixel do bitmap
			bne t3, zero, DESCER_PECA_COLUNAS	# reinicia o loop se t3 != 0
			
		addi t0, t0, -1			# decrementando o numero de linhas restantes
		addi a1, a1, -19		# volta o endereço do bitmap pelo numero de colunas impressas
		addi a1, a1, 320			# passa o endereço do bitmap para a proxima linha
		bne t0, zero, DESCER_PECA_LINHAS	# reinicia o loop se t0 != 0
		
		# Antes de continuar é preciso limpar o rastro deixado pelo sprite antigo da peça
		# Para isso o loop abaixo vai limpar a linha anterior ao novo sprite
		
		li t1, 82		# t1 tem o valor da cor de fundo da tela
		
		li t0, 19		# t0 = numero de colunas da imagem da peça
		
		mv a0, t5		# volta a0 para o valor salvo em t5
		lb t3, 10(a0)		# t3 tem o valor da cor que vai ser limpa, ou seja, a cor do topo da peça
				
		addi a1, t6, -320	# volta a1 para a linha anterior ao endereço salvo em t6
		
		LOOP_COLUNAS_LIMPAR_RASTRO:
			lb t4, 0(a1)			# pega 1 pixel do bitmap e coloca em t4
			
			# só limpa a tela se o pixel do bitmap for igual a t5, ou seja,
			# se o sprite da peça está lá
			
			bne t4, t3, NAO_LIMPAR
				sb t1, 0(a1)		# pega o pixel de t1 (fundo da tela) e coloca no bitmap
		
			NAO_LIMPAR:
			addi t0, t0, -1				# decrementa o numero de colunas restantes
			addi a1, a1, 1					# vai para o próximo pixel do bitmap
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
	# Procedimento que atualiza a matriz do tabuleiro com um novo valor de peça
	# Argumentos:
	#	a0 = valor da peça, com 1 = peça vermelha e 2 = peça amarela
	# 	a1 = numero da coluna onde a peça foi inserida
	
	slli a1, a1, 2		# multiplica a1 por 4 porque cada word tem 4 bytes
	
	add t0, a1, s3		# passa t0 para o endereço, na matriz do tabuleiro, da primeira posição
				# da coluna onde a peça foi inserida
	
	li t3, 4		# t3 recebe o numero maximo de linhas a serem analisadas
	
	# O loop abaixo vai encontrar a ultima posição disponivel na coluna
	LOOP_ATUALIZAR_MATRIZ:
		addi t1, t0, 28		# passa para t1 a posição no tabuleiro que está abaixo de t0 
		
		lw t2, 0(t1)		# pega o valor dessa posição do  tabuleiro
		
		# verifica se essa posição está livre, caso sim termina o loop
		bne t2, zero, FIM_LOOP_ATUALIZAR_MATRIZ
		
		addi t0, t0, 28		# passa t0 para a posição abaixo no tabuleiro
		addi t3, t3, -1		# decrementa t3
		
		bne t3, zero, LOOP_ATUALIZAR_MATRIZ
	
	FIM_LOOP_ATUALIZAR_MATRIZ:
		sw a0, 0(t0)		# armazena o valor da peça no endereço da posição encontrada
		
	ret			

# ====================================================================================================== #

MOSTRAR_DESEMPENHO_PROCEDIMENTOS_IA:
	# Procedimento que imprime no frame 1 o tempo de execução e outros parâmetros medidos durante
	# o processo de decisão da IA em cada nível
	# Obs: O frame 1 não será mostrado ao final do procedimento, para ver as informações é necessário 
	# trocar manualmente
	# Argumentos:
	#	s4, s5 e s6 precisam conter os valores medidos durante os procedimentos da IA

	mv a6, a0	# Salva a0 em a6

	# Limpa o frame 1
	li a0, 0	# limpa com a cor preta
	li a1, 1	# limpa o frame 1
	li a7, 48	# ecall Clear Screen	
	ecall
	
	fcvt.s.w ft0, s4		# ft0 = número de instruções calculadas no procedimento
	fcvt.s.w ft1, s5		# ft1 = número de ciclos calculadas no procedimento
	fcvt.s.w ft2, s6		# ft2 = tempo calculado no procedimento
		
	fdiv.s	ft3, ft1, ft2		# F em kHz = Ciclos/tempo
	fdiv.s	ft4, ft1, ft0		# CPI = Ciclos/Instruções
		
	li 	t0, 1000
	fcvt.s.w ft5, t0
	fdiv.s	ft3, ft3, ft5	# Frequencia em MHz = Frequencia em kHz/1000 
	
	fmul.s ft5, ft0, ft4	# ft5 = CPI x Intruções
	fdiv.s ft5, ft5, ft3	# ft5 = Texec = (CPI x Intruções) / frequência

	# Imprime as informações no frame 0
		# Imprime o titulo
		la a0, msgTitulo	# carrega a string
		li a1, 0		# posição x
		li a2, 0		# posição y
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
		li a1, 8		# posição x
		li a2, 35		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
	
		# Imprime a frequencia
		la a0, msgFrequencia	# carrega a string
		li a1, 8		# posição x
		li a2, 65		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		fmv.s fa0, ft3		# ft3 tem o valor da frequencia calculada acima
		li a1, 72		# posição x
		li a2, 65		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 102		# ecall Print Float
		ecall

		# Imprime os ciclos
		la a0, msgCiclos	# carrega a string
		li a1, 8		# posição x
		li a2, 73		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		mv a0, s5		# s5 tem o número de ciclos
		li a1, 72		# posição x
		li a2, 73		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 101		# ecall Print Int
		ecall

		# Imprime as intruções
		la a0, msgInstrucoes	# carrega a string
		li a1, 8		# posição x
		li a2, 81		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		mv a0, s4		# s4 tem o número de intruções
		li a1, 72		# posição x
		li a2, 81		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 101		# ecall Print Int
		ecall
		
		# Imprime a CPI
		la a0, msgCPI		# carrega a string
		li a1, 8		# posição x
		li a2, 89		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		fmv.s fa0, ft4		# ft4 tem o valor da CPI calculada acima
		li a1, 72		# posição x
		li a2, 89		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 102		# ecall Print Float
		ecall	
		
		
			
		# Imprime o tempo medido
		la a0, msgTempoMedido	# carrega a string
		li a1, 8		# posição x
		li a2, 125		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		mv a0, s6		# s6 tem o tempo medido
		li a1, 165		# posição x
		li a2, 125		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 101		# ecall Print Int
		ecall	
	
		# Imprime o tempo calculado
		la a0, msgTempoCalculado	# carrega a string
		li a1, 8		# posição x
		li a2, 135		# posição y
		li a3, 0x0038		# cor da mensagem
		li a4, 1		# frame 1
		li a7, 104		# ecall Print String
		ecall
		
		fmv.s fa0, ft5		# ft5 tem o valor da frequencia calculada acima
		li a1, 190		# posição x
		li a2, 135		# posição y
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
	
