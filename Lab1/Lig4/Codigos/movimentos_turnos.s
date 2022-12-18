.text

# ====================================================================================================== # 
# 				        MOVIMENTOS E TURNOS		         		         #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Código responsável por comandar o esquema de turnos do jogo, possuindo procedimentos tanto para o      #
# turno do jogador, quanto para o turno do computador, coordenando a lógica para a inserção de peças     # 
# no tabuleiro											         # 
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
		li a1, 60		# a1 = número da coluna onde começa a imagem = 60
		li a2, 52		# a1 = número da linha onde começa a imagem  = 52
		call CALCULAR_ENDERECO	
	
	mv t2, a0		# salvo o endereço retornado em t2
	
	# Calculando o endereço onde começa a imagem da ultima seleção de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 240		# a1 = número da coluna onde começa a imagem = 240
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
		li a1, 174		# a1 = número da coluna onde começa a imagem = 174
		li a2, 220		# a1 = número da linha onde começa a imagem  = 220
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endereço retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde começa os pixels no .data
	
	li t0, 182		# para encontrar a imagem da peça escolhida pelo jogador
	mul t0, s0, t0		# basta fazer essa multiplicaçaõ. t0 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o valor de s0 (cor 
	add a0, a0, t0		# escolhida) vai determinar quantos pixels é necessário pular para
				# encontrar a imagem certo 
					
	# Imprime na parte inferior da tela, na secção TURNO, a imagem da peça do jogador
	# a0 tem o endereço da imagem
	# a1 tem o endereço de onde imprimir a imagem
	li a2, 14		# número de colunas da imagem 
	li a3, 13		# número de linhas da imagem 
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
	bne t1, zero, JOGADOR_RETIRAR_SELECAO
		la t0, NUM_COLUNAS_LIVRES	# t0 tem o endereço de NUM_COLUNAS_LIVRES
		lw t1, 0(t0)			# t1 tem o numero de colunas livres
		addi t1, t1, -1			# decrementa t1
		sw t1, 0(t0)			# armazena t1 em NUM_COLUNAS_LIVRES
	
	JOGADOR_RETIRAR_SELECAO:	
				
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
		li a1, 174		# a1 = número da coluna onde começa a imagem = 174
		li a2, 220		# a1 = número da linha onde começa a imagem  = 220
		call CALCULAR_ENDERECO	
	
	mv a1, a0		# move para a1 o endereço retornado
	
	la a0, pecas_menu	# carrega a imagem em a0	
	addi a0, a0, 8		# pula para onde começa os pixels no .data
	
	xori t0, s0, 1		# t0 recebe o inverso de s0
	
	li t1, 182		# para encontrar a imagem da peça do computador basta fazer
	mul t1, t0, t1		# essa multiplicaçaõ. t1 tem a quantidade de pixels
				# entre uma imagem e outra, de forma que o inverso de s0 (cor 
	add a0, a0, t1		# escolhida pelo jogador) vai determinar quantos pixels é necessário 
				# pular para encontrar a imagem certa da peça do computador 
					
	# Imprime na parte inferior da tela, na secção TURNO, a imagem da peça do computador
	# a0 tem o endereço da imagem
	# a1 tem o endereço de onde imprimir a imagem
	li a2, 14		# número de colunas da imagem 
	li a3, 13		# número de linhas da imagem 
	call PRINT_IMG
	
	# Decide qual procedimento chamar de acordo com a dificuldade
	
	beq s1, zero, COMPUTADOR_JOGADA_FACIL
	
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

	COMPUTADOR_REALIZAR_JOGADA:
	# Do retorno dos procedimentos de decisão a0 tem o numero da coluna escolhida
	
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
	
	mv t2, a0	# salva o retorno em t2
	
	# Calculando o endereço onde começa a imagem da primeira seleção de coluna
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 60		# a1 = número da coluna onde começa a imagem = 60
		li a2, 52		# a1 = número da linha onde começa a imagem  = 52
		call CALCULAR_ENDERECO	
	
	li t3, 30 		# t2 tem a quantidade de pixels de diferença entre uma coluna e outra
		
	mul t2, t2, t3		# através dessa multiplicação decide quantos pixels tem que ser pulados 
				# para encontrar o endereço da coluna escolhida pelo computador
	
	add a1, a0, t2		# passa o endereço de a1 para o endereço da coluna escolhida pelo computador
		
	
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
		li a7, 32			# selecionando syscall sleep	
		li a0, 1000			# sleep por 1 s
		ecall
	
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
	# Nesse nível de dificuldade a escolha da coluna é randomica
	# Retorno:
	# 	a0 = um número de 0 a 6 representando a coluna escolhida 
	
	# Obs: não é necessário salvar o valor de ra, pois a chegada a esse procedimento é através de 
	# uma instrução de branch e a saída é sempre para o label 
	
	# Antes de tudo é necessário saber quantas colunas estão livres
	la t0, NUM_COLUNAS_LIVRES	# t0 tem o endereço de NUM_COLUNAS_LIVRES
	lw t0, 0(t0)			# t0 tem o numero de colunas livres
	
	# Escolhe um numero randomico entre 0 e t0 (numero de colunas livres)
	# De forma que o retorno a0 representa que o computador "quer" a n-esima coluna livre do tabuleiro
	mv a1, t0		# limite superior (nao inclusivo)
	li a7, 42		# syscall RandIntRange
	ecall
	
	addi a0, a0, 1		# é necessario incrementar a0 porque a ecall acima inclui o numero 0

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
	
	j COMPUTADOR_REALIZAR_JOGADA		
	
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
		
		li t0, 32 	# para descer a peça para o slot abaixo é necessário realizar 32 loops
				# e em cada um a peça é movida um pixel para baixo
		
		j DESCER_PECA_SLOT						
									
	LOOP_DESCER_PECA:
		# Para descer a peça em uma posição é necessário saber se o espaço está desocupado
	
		li t0, 8010		# somando 8010 ao endereço de a1 podemos encontrar o endreço
		add t0, a1, t0		# de inicio do slot abaixo do atual
		
		lb t0, 0(t0)
	
		# Se o valor do pixel apontado por t0 não for igual a t1 então o espaço não
		# está livre
		bne t0, t1, FIM_LOOP_DESCER_PECA	
		
		li t0, 26 	# para descer a peça para o slot abaixo é necessário realizar 26 loops
				# e em cada um a peça é movida um pixel para baixo
				
		DESCER_PECA_SLOT:
		li t2, 19		# t2 = numero de linhas da imagem da peça
		
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
			
		addi t2, t2, -1			# decrementando o numero de linhas restantes
		addi a1, a1, -19		# volta o endereço do bitmap pelo numero de colunas impressas
		addi a1, a1, 320			# passa o endereço do bitmap para a proxima linha
		bne t2, zero, DESCER_PECA_LINHAS	# reinicia o loop se t2 != 0
		
		# Antes de continuar é preciso limpar o rastro deixado pelo sprite antigo da peça
		# Para isso o loop abaixo vai limpar a linha anterior ao novo sprite
		
		li t1, 82		# t1 tem o valor da cor de fundo da tela
		
		li t2, 19		# t3 = numero de colunas da imagem da peça
		
		mv a0, t5		# volta a0 para o valor salvo em t5
		lb t3, 10(a0)		# t2 tem o valor da cor que vai ser limpa
				
		addi a1, t6, -320	# volta a1 para a linha anterior ao endereço salvo em t6
		
		LOOP_COLUNAS_LIMPAR_RASTRO:
			lb t4, 0(a1)			# pega 1 pixel do bitmap e coloca em t4
			
			# só limpa a tela se o pixel do bitmap for igual a t5, ou seja,
			# se o sprite da peça está lá
			
			bne t4, t3, NAO_LIMPAR
				sb t1, 0(a1)		# pega o pixel de t1 (fundo da tela) e coloca no bitmap
		
			NAO_LIMPAR:
			addi t2, t2, -1				# decrementa o numero de colunas restantes
			addi a1, a1, 1					# vai para o próximo pixel do bitmap
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
	
