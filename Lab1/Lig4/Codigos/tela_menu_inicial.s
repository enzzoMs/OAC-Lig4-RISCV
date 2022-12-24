.text

# ====================================================================================================== # 
# 						MENU INICIAL				                 #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# C�digo respons�vel por renderizar o menu inicial do jogo, com a escolha da cor das pe�as e escolha da	 #
# dificuldade.										.                # 
#													 #
# ====================================================================================================== #

INICIALIZAR_MENU_INICIAL:
	# Procedimento principal de menu_inicial.s, ele comanda a chamada a outros procedimentos para a 
	# renderiza��o das telas do menu inicial
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	call RENDERIZAR_ESCOLHA_COR
	
	call RENDERIZAR_ESCOLHA_DIFICULDADE
		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

RENDERIZAR_ESCOLHA_COR:		
	# Procedimento que imprime a imagem do menu incial com a escolha da cor que o jogador vai jogar,
	# al�m de trabalhar a l�gica para a intera��o com o menu em si e a sele��o dessa cor

	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	# Imprimindo a tela de sele��o de cor no frame 0
		la a0, menu_inicial_cor_pecas	# carrega a imagem
		li a1, 0xFF000000		# seleciona como argumento o frame 0
		call PRINT_TELA	
	
	# Calculando o endere�o onde come�a a imagem da op��o VERMELHO
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 97		# a1 = n�mero da coluna onde come�a a imagem = 97
		li a2, 157		# a1 = n�mero da linha onde come�a a imagem  = 157
		call CALCULAR_ENDERECO		
	
	mv a4, a0		# salva o endere�o retornado em a4
	
	# Calculando o endere�o onde come�a a imagem da op��o AMARELO
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 97		# a1 = n�mero da coluna onde come�a a imagem = 97
		li a2, 193		# a1 = n�mero da linha onde come�a a imagem  = 193
		call CALCULAR_ENDERECO			
						
	mv a6, a0		# salva o endere�o retornado em a6
	
	# a4 tem endere�o de onde come�a a primeira da op��o
	li a5, 36	# a5 = diferen�a em linhas entre o come�o de uma op��o e o come�o da op��o seguinte 
	# a6 tem o endere�o de inicio da �ltima op��o
	call SELECIONAR_OPCOES_MENU
			
	mv s0, a0		# atualiza o valor de s0 com o retornado em a0									
																									
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

RENDERIZAR_ESCOLHA_DIFICULDADE:		
	# Procedimento que imprime a imagem do menu incial com a escolha da dificuldade que o jogador 
	# vai jogar, al�m de trabalhar a l�gica para a intera��o com o menu em si e a sele��o dessas op��es

	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	# Imprimindo a tela de sele��o de cor no frame 0
		la a0, menu_inicial_dificuldade		# carrega a imagem
		li a1, 0xFF000000			# seleciona como argumento o frame 0
		call PRINT_TELA	
	
	# Calculando o endere�o onde come�a a imagem da op��o FACIL
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 103		# a1 = n�mero da coluna onde come�a a imagem = 103
		li a2, 147		# a1 = n�mero da linha onde come�a a imagem  = 147
		call CALCULAR_ENDERECO		
	
	mv a4, a0		# salva o endere�o retornado em a4
	
	# Calculando o endere�o onde come�a a imagem da op��o DIFICIL
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 103		# a1 = n�mero da coluna onde come�a a imagem = 103
		li a2, 205		# a1 = n�mero da linha onde come�a a imagem  = 205
		call CALCULAR_ENDERECO	
	
	mv a6, a0		# salva o endere�o retornado em a6
	
	# a4 tem endere�o de onde come�a a primeira da op��o
	li a5, 29	# a5 = diferen�a em linhas entre o come�o de uma op��o e o come�o da op��o seguinte 
	# a6 tem o endere�o de inicio da �ltima op��o
	call SELECIONAR_OPCOES_MENU
	
	mv s1, a0		# atualiza o valor de s1 com o retornado em a0																	
																									
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

SELECIONAR_OPCOES_MENU:
	# Procedimento para auxiliar a sele��o de op��es nos menus iniciais.
	# Consiste em um loop que vai verificar a tecla apertada pelo usu�rio (w ou s) e 
	# a partir disso vai chamar os procedimento adequados para renderizar a op��o escolhida
	# como selecionada e as outras como n�o selecionadas
	# O procedimento termina e devolve o controle para o procedimento chamador quando o 
	# usu�rio apertar ENTER
	# Parte do pressuposto que todas as imagens de op��o tem no m�ximo 130 x 25 de tamanho
	
	# Argumentos:
	#	a4 = endere�o de onde come�a a primeira a op��o 
	# 	a5 = diferen�a, em n�mero de linhas, entre o come�o de uma op��o e o come�o da op��o seguinte 
	# 	a6 = endere�o limite inferior, ou seja, o endere�o de inicio da �ltima op��o 
	# Retorno:
	#	a0 = retorna o n�mero da op��o escolhida, come�ando no zero
	
	addi sp, sp, -4		# cria espa�o para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	li t0, 320
	mul t4, a5, t0		# t4 = a4 * 320, ou seja, t4 recebe a quantidade de pixels que precisam ser
				# pulados entre o come�o de uma op��o e outra		
	
	mv t5, a4		# t5 guarda o endere�o da op��o atualmente selecionada, inicialmente
				# ser� a op��o apontada por a4
	
	# Inicialmente seleciona a primeira op��o 
	mv a0, a4			# a4 tem o endere�o da primeria op��o
	li a1, 130			# n�mero de colunas da imagem da op��o
	li a2, 25			# n�mero de linhas da imagem da op��o
	li a3, 0			# o procedimento vai selecionar essa op��o
	call RENDERIZAR_OPCAO
			
	LOOP_SELECIONAR_OPCAO:
		call VERIFICAR_TECLA_APERTADA
		
		# Neste loop t1 vai receber o endere�o da pr�xima op��o a ser selecionada
		# dependendo do input do usu�rio
		
		li t0, 'w'
		sub t1, t5, t4			# t1 vai receber o endere�o da op��o atualmente selecionada (t5)
						# menos o valor de t4, essencialmente passando para t1 o endere�o
						# da op��o acima  				
		beq a0, t0, SELECIONAR_OPCAO
		li t0, 's'
		add t1, t5, t4			# t1 vai receber o endere�o da op��o atualmente selecionada (t5)
						# mais o valor de t4, essencialmente passando para t1 o endere�o
						# da op��o abaixo  
		beq a0, t0, SELECIONAR_OPCAO
		li t0, 10				# t0 = valor da tecla enter
		beq a0, t0, FIM_SELECIONAR_OPCOES_MENU	# Se o ENTER foi apertado, termina o loop
		j LOOP_SELECIONAR_OPCAO
		
		SELECIONAR_OPCAO:
			# Primeiro verifica se o endere�o t1 est� dentro dos limites, ou seja,
			# se � maior que a4 (endere�o da primeria op��o) e menor que a6(endere�o da 
			# �ltima op��o), caso esteja fora nada deve acontecer
			
			blt t1, a4, LOOP_SELECIONAR_OPCAO
			bgt t1, a6, LOOP_SELECIONAR_OPCAO
		
			# Primeiramente � retirado a sele��o da op��o atual
			mv a0, t5	# a0 recebe o endere�o da op��o atual	
			
			mv t5, t1	# atualiza t5 com o endere�o da pr�xima op��o que vai ser selecionada
			
			li a1, 130	# n�mero de colunas da imagem da op��o
			li a2, 25	# n�mero de linhas da imagem da op��o	
			li a3, 1	# o procedimento vai retirar a sele��o dessa op��o
			call RENDERIZAR_OPCAO
			
			# Seleciona a op��o escolhida
			mv a0, t5			# a op��o ter� como base o endere�o apontado por t5
			li a1, 130			# n�mero de colunas da imagem da op��o
			li a2, 25			# n�mero de linhas da imagem da op��o
			li a3, 0			# o procedimento vai selecionar essa op��o
			call RENDERIZAR_OPCAO
			
			j LOOP_SELECIONAR_OPCAO
			
	FIM_SELECIONAR_OPCOES_MENU:

	sub t0, t5, a4		# t0 recebe a diferen�a entre o endere�o da primeira op��o e a op��o atual
	li t1, 320		# divide t0 por 320 para saber quantas linhas de diferen�a entre a primeira
	div t0, t0, t1		# op��o e a op��o selecionada
	
	div a0, t0, a5		# a0 recebe a divis�o entre o calculado acima e a5, dessa forma, a0 recebe
				# o valor de qual op��o foi selecionada, de acordo com o convencionado

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

# ====================================================================================================== #

RENDERIZAR_OPCAO:
	# Procedimento para auxiliar a sele��o de op��es nos menus iniciais, podendo renderizar uma op��o
	# como selecionada ou n�o selecionada
	
	# Argumentos: 
	# 	a0 = endere�o no frame de onde come�a a imagem de uma op��o do menu
	#	a1 = n�mero de colunas da moldura dessa op��o
	#	a2 = n�mero de linhas da moldura dessa op��o
	#	(a3 == 0) -> Seleciona uma op��o, ou seja:
	#		     	simplesmente troca todos da imagem dessa op��o por pixels 
	#		     	brancos, representando que essa op��o est� atualmente selecionada
	#	(a3 != 0) ->  Retira a sele��o de uma op��o, ou seja:
	#			troca todos os pixels dessa op��o por pixels de cor preta,
	#		   	retirando a sele��o dessa op��o
			
	li t0,	0			# t0 = cor da op��o quando ela n�o est� selecionada	
	li t1,	0xFFFFFFFF		# t1 = cor que vai substituir a cor atual da op��o
		
	# Se a3 != 0 ent�o o procedimento vai retirar a sele��o de uma op��o								
	beq a3, zero, RENDERIZAR_OPCAO_LINHAS	
		li t0,	0xFFFFFFFF		# t0 = cor da op��o quando ela est� selecionada	
		li t1,	0			# t1 = cor que vai substituir a cor atual da op��o
					
	RENDERIZAR_OPCAO_LINHAS:
		mv t2, a1		# copia do argumento de a1 para usar no loop de colunas
			
		RENDERIZAR_OPCAO_COLUNAS:
			lb t3, 0(a0)			# pega 1 pixel do bitmap e coloca em t3
			
			# Se t3 != t0 ent�o o pixel n�o sera modificado,
			# dessa forma somente a moldura e o texto da op��o ser�o modificados						
			bne t3, t0, NAO_MODIFICAR_OPCAO
				sb t1, 0(a0)
			
			NAO_MODIFICAR_OPCAO:
	
			addi t2, t2, -1				# decrementando o numero de colunas restantes
			addi a0, a0, 1				# vai para o pr�ximo pixel do bitmap
			bne t2, zero, RENDERIZAR_OPCAO_COLUNAS	# reinicia o loop se t2 != 0
			
		addi a2, a2, -1				# decrementando o numero de linhas restantes
		sub a0, a0, a1				# volta o ende�o do bitmap pelo numero de colunas impressas
		addi a0, a0, 320			# passa o endere�o do bitmap para a proxima linha
		bne a2, zero, RENDERIZAR_OPCAO_LINHAS	# reinicia o loop se a2 != 0
			
	ret


# ====================================================================================================== #

.data
	.include "../Imagens/menu_inicial/menu_inicial_cor_pecas.data"
	.include "../Imagens/menu_inicial/menu_inicial_dificuldade.data"
	
