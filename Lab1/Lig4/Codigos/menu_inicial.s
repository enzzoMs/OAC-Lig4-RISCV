.text

# ====================================================================================================== # 
# 						MENU INICIAL				                 #
# ------------------------------------------------------------------------------------------------------ #
# 													 #
# Código responsável por renderizar o menu inicial do jogo, com a escolha da cor das peças e escolha da	 #
# dificuldade.										.                # 
#													 #
# ====================================================================================================== #

INICIALIZAR_MENU_INICIAL:
	# Procedimento principal de menu_inicial.s, ele comanda a chamada a outros procedimentos para a 
	# renderização das telas do menu inicial
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, 0(sp)		# empilha ra
	
	call RENDERIZAR_ESCOLHA_COR
	
	
		
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

RENDERIZAR_ESCOLHA_COR:		
	# Procedimento que imprime a imagem do menu incial com a escolha da cor que o jogador vai jogar,
	# além de trabalhar a lógica para a interação com o menu em si e a seleção dessa cor

	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	# Imprimindo a tela de seleção de cor no frame 0
		la a0, menu_inicial_cor_pecas	# carrega a imagem
		li a1, 0xFF000000		# seleciona como argumento o frame 0
		call PRINT_TELA	
	
	# Calculando o endereço onde começa a imagem da opção VERMELHO
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 97		# a1 = número da coluna onde começa a imagem = 97
		li a2, 157		# a1 = número da linha onde começa a imagem  = 157
		call CALCULAR_ENDERECO		
	
	mv t4, a0		# salva o endereço retornado em t4
	
	# Calculando o endereço onde começa a imagem da opção AMARELO
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 97		# a1 = número da coluna onde começa a imagem = 97
		li a2, 193		# a1 = número da linha onde começa a imagem  = 193
		call CALCULAR_ENDERECO	
	
	mv t5, a0		# salva o endereço retornado em t5
	
	mv t6, t4		# t6 guarda o endereço da opção atualmente selecionada, que inicialmente
				# será a opção VERMELHO
				
	# Chama o procedimento para selecionar um opção	
	mv a0, t6			# a opção terá como base o endereço apontado por t6
	li a1, 126			# número de colunas da imagem da opção
	li a2, 24			# número de linhas da imagem da opção
	li a3, 0			# o procedimento vai selecionar essa opção
	call SELECIONAR_OPCAO_MENU
			
	LOOP_SELECIONAR_COR:
		call VERIFICAR_TECLA_APERTADA
		
		# Neste loop t1 vai receber o endereço da próxima opção a ser selecionada
		# dependendo do input do usuário
		
		li t0, 'w'
		mv t1, t4
		beq a0, t0, SELECIONAR_COR
		li t0, 's'
		mv t1, t5
		beq a0, t0, SELECIONAR_COR
		j LOOP_SELECIONAR_COR
		
		SELECIONAR_COR:
			# Se t1 (próxima opção a ser selecionada) for igual a t6 (opção atualmente selecionada)
			# nada precisa ser feito
			beq t1, t6, LOOP_SELECIONAR_COR
		
			# Primeiramente é retirado a seleção da opção atual
			mv a0, t6	# a0 recebe o endereço da opção atual	
			
			mv t6, t1	# atualiza t6 com o endereço da próxima opção que vai ser selecionada
			
			li a1, 126	# número de colunas da imagem da opção
			li a2, 24	# número de linhas da imagem da opção	
			li a3, 1	# o procedimento vai retirar a seleção dessa opção
			call SELECIONAR_OPCAO_MENU
			
			# Seleciona a opção escolhida
			mv a0, t6			# a opção terá como base o endereço apontado por t6
			li a1, 126			# número de colunas da imagem da opção
			li a2, 24			# número de linhas da imagem da opção
			li a3, 0			# o procedimento vai selecionar essa opção
			call SELECIONAR_OPCAO_MENU
			
			j LOOP_SELECIONAR_COR
				
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

SELECIONAR_OPCAO_MENU:
	# Procedimento para auxiliar a seleção de opções nos menus iniciais, podendo renderizar uma opção
	# como selecionada ou não selecionada
	
	# Argumentos: 
	# 	a0 = endereço no frame de onde começa a imagem de uma opção do menu
	#	a1 = número de colunas da moldura dessa opção
	#	a2 = número de linhas da moldura dessa opção
	#	(a3 == 0) -> Seleciona uma opção, ou seja:
	#		     	simplesmente troca todos da imagem dessa opção por pixels 
	#		     	brancos, representando que essa opção está atualmente selecionada
	#	(a3 != 0) ->  Retira a seleção de uma opção, ou seja:
	#			troca todos os pixels dessa opção por pixels de cor preta,
	#		   	retirando a seleção dessa opção
			
	li t0,	0			# t0 = cor da opção quando ela não está selecionada	
	li t1,	0xFFFFFFFF		# t1 = cor que vai substituir a cor atual da opção
		
	# Se a3 != 0 então o procedimento vai retirar a seleção de uma opção								
	beq a3, zero, SELECIONAR_OPCAO_LINHAS	
		li t0,	0xFFFFFFFF		# t0 = cor da opção quando ela está selecionada	
		li t1,	0			# t1 = cor que vai substituir a cor atual da opção
					
	SELECIONAR_OPCAO_LINHAS:
		mv t2, a1		# copia do argumento de a1 para usar no loop de colunas
			
		SELECIONAR_OPCAO_COLUNAS:
			lb t3, 0(a0)			# pega 1 pixel do bitmap e coloca em t3
			
			# Se t3 != t0 então o pixel não sera modificado,
			# dessa forma somente a moldura e o texto da opção serão modificados						
			bne t3, t0, NAO_MODIFICAR_OPCAO
				sb t1, 0(a0)
			
			NAO_MODIFICAR_OPCAO:
	
			addi t2, t2, -1				# decrementando o numero de colunas restantes
			addi a0, a0, 1				# vai para o próximo pixel do bitmap
			bne t2, zero, SELECIONAR_OPCAO_COLUNAS	# reinicia o loop se t2 != 0
			
		addi a2, a2, -1				# decrementando o numero de linhas restantes
		sub a0, a0, a1				# volta o endeço do bitmap pelo numero de colunas impressas
		addi a0, a0, 320			# passa o endereço do bitmap para a proxima linha
		bne a2, zero, SELECIONAR_OPCAO_LINHAS	# reinicia o loop se a2 != 0
			
	ret


# ====================================================================================================== #

.data
	.include "../Imagens/menu_inicial/menu_inicial_cor_pecas.data"
	
	
