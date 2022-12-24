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
	
	call RENDERIZAR_ESCOLHA_DIFICULDADE
		
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
	
	mv a4, a0		# salva o endereço retornado em a4
	
	# Calculando o endereço onde começa a imagem da opção AMARELO
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 97		# a1 = número da coluna onde começa a imagem = 97
		li a2, 193		# a1 = número da linha onde começa a imagem  = 193
		call CALCULAR_ENDERECO			
						
	mv a6, a0		# salva o endereço retornado em a6
	
	# a4 tem endereço de onde começa a primeira da opção
	li a5, 36	# a5 = diferença em linhas entre o começo de uma opção e o começo da opção seguinte 
	# a6 tem o endereço de inicio da última opção
	call SELECIONAR_OPCOES_MENU
			
	mv s0, a0		# atualiza o valor de s0 com o retornado em a0									
																									
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

RENDERIZAR_ESCOLHA_DIFICULDADE:		
	# Procedimento que imprime a imagem do menu incial com a escolha da dificuldade que o jogador 
	# vai jogar, além de trabalhar a lógica para a interação com o menu em si e a seleção dessas opções

	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	# Imprimindo a tela de seleção de cor no frame 0
		la a0, menu_inicial_dificuldade		# carrega a imagem
		li a1, 0xFF000000			# seleciona como argumento o frame 0
		call PRINT_TELA	
	
	# Calculando o endereço onde começa a imagem da opção FACIL
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 103		# a1 = número da coluna onde começa a imagem = 103
		li a2, 147		# a1 = número da linha onde começa a imagem  = 147
		call CALCULAR_ENDERECO		
	
	mv a4, a0		# salva o endereço retornado em a4
	
	# Calculando o endereço onde começa a imagem da opção DIFICIL
		li a0, 0xFF000000	# Selecionando como argumento o frame 0
		li a1, 103		# a1 = número da coluna onde começa a imagem = 103
		li a2, 205		# a1 = número da linha onde começa a imagem  = 205
		call CALCULAR_ENDERECO	
	
	mv a6, a0		# salva o endereço retornado em a6
	
	# a4 tem endereço de onde começa a primeira da opção
	li a5, 29	# a5 = diferença em linhas entre o começo de uma opção e o começo da opção seguinte 
	# a6 tem o endereço de inicio da última opção
	call SELECIONAR_OPCOES_MENU
	
	mv s1, a0		# atualiza o valor de s1 com o retornado em a0																	
																									
	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret
	
# ====================================================================================================== #

SELECIONAR_OPCOES_MENU:
	# Procedimento para auxiliar a seleção de opções nos menus iniciais.
	# Consiste em um loop que vai verificar a tecla apertada pelo usuário (w ou s) e 
	# a partir disso vai chamar os procedimento adequados para renderizar a opção escolhida
	# como selecionada e as outras como não selecionadas
	# O procedimento termina e devolve o controle para o procedimento chamador quando o 
	# usuário apertar ENTER
	# Parte do pressuposto que todas as imagens de opção tem no máximo 130 x 25 de tamanho
	
	# Argumentos:
	#	a4 = endereço de onde começa a primeira a opção 
	# 	a5 = diferença, em número de linhas, entre o começo de uma opção e o começo da opção seguinte 
	# 	a6 = endereço limite inferior, ou seja, o endereço de inicio da última opção 
	# Retorno:
	#	a0 = retorna o número da opção escolhida, começando no zero
	
	addi sp, sp, -4		# cria espaço para 1 word na pilha
	sw ra, (sp)		# empilha ra
	
	li t0, 320
	mul t4, a5, t0		# t4 = a4 * 320, ou seja, t4 recebe a quantidade de pixels que precisam ser
				# pulados entre o começo de uma opção e outra		
	
	mv t5, a4		# t5 guarda o endereço da opção atualmente selecionada, inicialmente
				# será a opção apontada por a4
	
	# Inicialmente seleciona a primeira opção 
	mv a0, a4			# a4 tem o endereço da primeria opção
	li a1, 130			# número de colunas da imagem da opção
	li a2, 25			# número de linhas da imagem da opção
	li a3, 0			# o procedimento vai selecionar essa opção
	call RENDERIZAR_OPCAO
			
	LOOP_SELECIONAR_OPCAO:
		call VERIFICAR_TECLA_APERTADA
		
		# Neste loop t1 vai receber o endereço da próxima opção a ser selecionada
		# dependendo do input do usuário
		
		li t0, 'w'
		sub t1, t5, t4			# t1 vai receber o endereço da opção atualmente selecionada (t5)
						# menos o valor de t4, essencialmente passando para t1 o endereço
						# da opção acima  				
		beq a0, t0, SELECIONAR_OPCAO
		li t0, 's'
		add t1, t5, t4			# t1 vai receber o endereço da opção atualmente selecionada (t5)
						# mais o valor de t4, essencialmente passando para t1 o endereço
						# da opção abaixo  
		beq a0, t0, SELECIONAR_OPCAO
		li t0, 10				# t0 = valor da tecla enter
		beq a0, t0, FIM_SELECIONAR_OPCOES_MENU	# Se o ENTER foi apertado, termina o loop
		j LOOP_SELECIONAR_OPCAO
		
		SELECIONAR_OPCAO:
			# Primeiro verifica se o endereço t1 está dentro dos limites, ou seja,
			# se é maior que a4 (endereço da primeria opção) e menor que a6(endereço da 
			# última opção), caso esteja fora nada deve acontecer
			
			blt t1, a4, LOOP_SELECIONAR_OPCAO
			bgt t1, a6, LOOP_SELECIONAR_OPCAO
		
			# Primeiramente é retirado a seleção da opção atual
			mv a0, t5	# a0 recebe o endereço da opção atual	
			
			mv t5, t1	# atualiza t5 com o endereço da próxima opção que vai ser selecionada
			
			li a1, 130	# número de colunas da imagem da opção
			li a2, 25	# número de linhas da imagem da opção	
			li a3, 1	# o procedimento vai retirar a seleção dessa opção
			call RENDERIZAR_OPCAO
			
			# Seleciona a opção escolhida
			mv a0, t5			# a opção terá como base o endereço apontado por t5
			li a1, 130			# número de colunas da imagem da opção
			li a2, 25			# número de linhas da imagem da opção
			li a3, 0			# o procedimento vai selecionar essa opção
			call RENDERIZAR_OPCAO
			
			j LOOP_SELECIONAR_OPCAO
			
	FIM_SELECIONAR_OPCOES_MENU:

	sub t0, t5, a4		# t0 recebe a diferença entre o endereço da primeira opção e a opção atual
	li t1, 320		# divide t0 por 320 para saber quantas linhas de diferença entre a primeira
	div t0, t0, t1		# opção e a opção selecionada
	
	div a0, t0, a5		# a0 recebe a divisão entre o calculado acima e a5, dessa forma, a0 recebe
				# o valor de qual opção foi selecionada, de acordo com o convencionado

	lw ra, (sp)		# desempilha ra
	addi sp, sp, 4		# remove 1 word da pilha
	
	ret

# ====================================================================================================== #

RENDERIZAR_OPCAO:
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
	beq a3, zero, RENDERIZAR_OPCAO_LINHAS	
		li t0,	0xFFFFFFFF		# t0 = cor da opção quando ela está selecionada	
		li t1,	0			# t1 = cor que vai substituir a cor atual da opção
					
	RENDERIZAR_OPCAO_LINHAS:
		mv t2, a1		# copia do argumento de a1 para usar no loop de colunas
			
		RENDERIZAR_OPCAO_COLUNAS:
			lb t3, 0(a0)			# pega 1 pixel do bitmap e coloca em t3
			
			# Se t3 != t0 então o pixel não sera modificado,
			# dessa forma somente a moldura e o texto da opção serão modificados						
			bne t3, t0, NAO_MODIFICAR_OPCAO
				sb t1, 0(a0)
			
			NAO_MODIFICAR_OPCAO:
	
			addi t2, t2, -1				# decrementando o numero de colunas restantes
			addi a0, a0, 1				# vai para o próximo pixel do bitmap
			bne t2, zero, RENDERIZAR_OPCAO_COLUNAS	# reinicia o loop se t2 != 0
			
		addi a2, a2, -1				# decrementando o numero de linhas restantes
		sub a0, a0, a1				# volta o endeço do bitmap pelo numero de colunas impressas
		addi a0, a0, 320			# passa o endereço do bitmap para a proxima linha
		bne a2, zero, RENDERIZAR_OPCAO_LINHAS	# reinicia o loop se a2 != 0
			
	ret


# ====================================================================================================== #

.data
	.include "../Imagens/menu_inicial/menu_inicial_cor_pecas.data"
	.include "../Imagens/menu_inicial/menu_inicial_dificuldade.data"
	
