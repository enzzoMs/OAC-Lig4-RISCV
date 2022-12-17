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
	
	
	# Inicialmente seleciona a primeira coluna 
	mv a0, t5		# t5 tem o endere�o da imagem de sele��o com a cor do jogador
	mv a1, t2		# t2 tem o endere�o da primeira coluna
	li a2, 23		# n�mero de colunas da imagem 
	li a3, 23		# n�mero de linhas da imagem 
	call PRINT_IMG
			
	LOOP_TURNO_JOGADOR:
		call VERIFICAR_TECLA_APERTADA
		
		# Neste loop t1 vai receber o endere�o da pr�xima coluna a ser selecionada
		# dependendo do input do usu�rio
		
		li t0, 'a'
		addi t1, t4, -30		# t1 vai receber o endere�o da coluna atualmente selecionada (t4)
						# menos 30, essencialmente passando para t1 o endere�o
						# da coluna a esquerda  				
		beq a0, t0, SELECIONAR_COLUNA
		li t0, 'd'
		addi t1, t4, 30			# t1 vai receber o endere�o da coluna atualmente selecionada (t4)
						# mais 30, essencialmente passando para t1 o endere�o
						# da coluna a direita  
		beq a0, t0, SELECIONAR_COLUNA
		li t0, 10				# t0 = valor da tecla enter
		beq a0, t0, FIM_LOOP_TURNO_JOGADOR	# Se o ENTER foi apertado, termina o loop
		j LOOP_TURNO_JOGADOR
		
		SELECIONAR_COLUNA:
			# Primeiro verifica se o endere�o t1 est� dentro dos limites, ou seja,
			# se � maior que t2 (endere�o da primeria coluna) e menor que t3(endere�o da 
			# �ltima coluna), caso esteja fora nada deve acontecer
			
			blt t1, t2, LOOP_TURNO_JOGADOR
			bgt t1, t3, LOOP_TURNO_JOGADOR
		
			# Primeiramente � retirado a sele��o da coluna atual			
			la a0, selecao_colunas	# carrega a imagem em a0
			addi a0, a0, 8		# pula para onde come�a os pixels . data
			mv a1, t4		# a1 recebe o endere�o da coluna atual	
			
			mv t4, t1	# atualiza t4 com o endere�o da pr�xima coluna que vai ser selecionada
						
			li a2, 23		# n�mero de colunas da imagem 
			li a3, 23		# n�mero de linhas da imagem 
			call PRINT_IMG
			
			# Seleciona a coluna escolhida
			mv a0, t5		# t5 tem o endere�o da imagem de sele��o com a cor do jogador
			mv a1, t4		# a1 recebe o endere�o da coluna atual	
			li a2, 23		# n�mero de colunas da imagem 
			li a3, 23		# n�mero de linhas da imagem 
			call PRINT_IMG
			
			j LOOP_TURNO_JOGADOR
			
	FIM_LOOP_TURNO_JOGADOR:
	
	# Agora � necess�rio retirar a sele��o da coluna antes de prosseguir
	la a0, selecao_colunas	# carrega a imagem em a0
	addi a0, a0, 8		# pula para onde come�a os pixels .data
	mv a1, t4		# a1 recebe o endere�o da coluna atual		
	li a2, 23		# n�mero de colunas da imagem 
	li a3, 23		# n�mero de linhas da imagem 
	call PRINT_IMG
	
	# � necess�rio renderizar a pe�a descendo pela coluna do tabuleiro
	addi a1, t4, 642	# passa para o argumento a0 o endere�o de t4 (endere�o da coluna atual) mais
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
	
