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
	
	mv t4, a0		# salva o endere�o retornado em t4
	
	# Calculando o endere�o onde come�a a imagem da op��o AMARELO
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 97		# a1 = n�mero da coluna onde come�a a imagem = 97
		li a2, 193		# a1 = n�mero da linha onde come�a a imagem  = 193
		call CALCULAR_ENDERECO	
	
	mv t5, a0		# salva o endere�o retornado em t5
	
	mv t6, t4		# t6 guarda o endere�o da op��o atualmente selecionada, que inicialmente
				# ser� a op��o VERMELHO
				
	# Chama o procedimento para selecionar um op��o	
	mv a0, t6			# a op��o ter� como base o endere�o apontado por t6
	li a1, 126			# n�mero de colunas da imagem da op��o
	li a2, 24			# n�mero de linhas da imagem da op��o
	li a3, 0			# o procedimento vai selecionar essa op��o
	call SELECIONAR_OPCAO_MENU
			
	LOOP_SELECIONAR_COR:
		call VERIFICAR_TECLA_APERTADA
		
		# Neste loop t1 vai receber o endere�o da pr�xima op��o a ser selecionada
		# dependendo do input do usu�rio
		
		li t0, 'w'
		mv t1, t4
		beq a0, t0, SELECIONAR_COR
		li t0, 's'
		mv t1, t5
		beq a0, t0, SELECIONAR_COR
		j LOOP_SELECIONAR_COR
		
		SELECIONAR_COR:
			# Se t1 (pr�xima op��o a ser selecionada) for igual a t6 (op��o atualmente selecionada)
			# nada precisa ser feito
			beq t1, t6, LOOP_SELECIONAR_COR
		
			# Primeiramente � retirado a sele��o da op��o atual
			mv a0, t6	# a0 recebe o endere�o da op��o atual	
			
			mv t6, t1	# atualiza t6 com o endere�o da pr�xima op��o que vai ser selecionada
			
			li a1, 126	# n�mero de colunas da imagem da op��o
			li a2, 24	# n�mero de linhas da imagem da op��o	
			li a3, 1	# o procedimento vai retirar a sele��o dessa op��o
			call SELECIONAR_OPCAO_MENU
			
			# Seleciona a op��o escolhida
			mv a0, t6			# a op��o ter� como base o endere�o apontado por t6
			li a1, 126			# n�mero de colunas da imagem da op��o
			li a2, 24			# n�mero de linhas da imagem da op��o
			li a3, 0			# o procedimento vai selecionar essa op��o
			call SELECIONAR_OPCAO_MENU
			
			j LOOP_SELECIONAR_COR
				
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

SELECIONAR_OPCAO_MENU:
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
	beq a3, zero, SELECIONAR_OPCAO_LINHAS	
		li t0,	0xFFFFFFFF		# t0 = cor da op��o quando ela est� selecionada	
		li t1,	0			# t1 = cor que vai substituir a cor atual da op��o
					
	SELECIONAR_OPCAO_LINHAS:
		mv t2, a1		# copia do argumento de a1 para usar no loop de colunas
			
		SELECIONAR_OPCAO_COLUNAS:
			lb t3, 0(a0)			# pega 1 pixel do bitmap e coloca em t3
			
			# Se t3 != t0 ent�o o pixel n�o sera modificado,
			# dessa forma somente a moldura e o texto da op��o ser�o modificados						
			bne t3, t0, NAO_MODIFICAR_OPCAO
				sb t1, 0(a0)
			
			NAO_MODIFICAR_OPCAO:
	
			addi t2, t2, -1				# decrementando o numero de colunas restantes
			addi a0, a0, 1				# vai para o pr�ximo pixel do bitmap
			bne t2, zero, SELECIONAR_OPCAO_COLUNAS	# reinicia o loop se t2 != 0
			
		addi a2, a2, -1				# decrementando o numero de linhas restantes
		sub a0, a0, a1				# volta o ende�o do bitmap pelo numero de colunas impressas
		addi a0, a0, 320			# passa o endere�o do bitmap para a proxima linha
		bne a2, zero, SELECIONAR_OPCAO_LINHAS	# reinicia o loop se a2 != 0
			
	ret


# ====================================================================================================== #

.data
	.include "../Imagens/menu_inicial/menu_inicial_cor_pecas.data"
	
	
