LPARAMETERS pMenuConsulta
	IF TYPE("pMenuConsulta") != "L"
		pMenuConsulta = .F.
	ENDIF 
	
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& PROGRAMA INICIAL DO APLICATIVO (APP)
&& DEFINIÇÕES DE MENU E PROCEDURES DO APLICATIVO DEVEM SER INICIADAS AQUI
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINIÇÕES DE PROCEDURES LOCAIS

	
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINIÇÃO DOS MENUS
&& OBS: Para chamar menu de consulta, ao invés de colocar FORM->PROX como 
&& comumente era colocado, basta fazer da seguinte forma:
&& FUNC->Criar_Menu( @NomeDaMatrizQueContemOMenuDeConsulta ) -> PARA MENUS DE RELATORIOS NAO DINAMICOS 
&& FUNC->MENU_CONSULTA() -> Para menus de relatorios dinamicos 
&& O restante das definições já utilizadas, continuam da mesma forma.
	
	&& DEFINIÇAO DO MENU PRINCIPAL
    Public array aMenuCadastro[7,3]
    xI = 0
    
    xI = xI + 1
   	aMenuCadastro[xI,1] = 'cadastro de [A]lunos'
	aMenuCadastro[xI,2] = ''
	aMenuCadastro[xI,3] = 'FUNC->CHAMATODOS("\COOP\VFP\SISCOLEGIO\CADASTRO\ALUNO\ALUNO.APP")'
		
    xI = xI + 1
   	aMenuCadastro[xI,1] = 'cadastro de [C]ursos'
	aMenuCadastro[xI,2] = ''
	aMenuCadastro[xI,3] = 'FUNC->CHAMATODOS("\COOP\VFP\SISCOLEGIO\CADASTRO\CURSOS\CURSOS.APP")'	
		
    xI = xI + 1
   	aMenuCadastro[xI,1] = 'cadastro de [D]isciplinas'
	aMenuCadastro[xI,2] = ''
	aMenuCadastro[xI,3] = 'FUNC->CHAMATODOS("\COOP\VFP\SISCOLEGIO\CADASTRO\DISCIPLINA\DISCIPLINA.APP")'
	
    xI = xI + 1
   	aMenuCadastro[xI,1] = 'cadastro de [F]uncionarios'
	aMenuCadastro[xI,2] = ''
	aMenuCadastro[xI,3] = 'FUNC->CHAMATODOS("\COOP\VFP\SISCOLEGIO\CADASTRO\FUNCIONARIO\FUNCIONARIO.APP")'

    xI = xI + 1
   	aMenuCadastro[xI,1] = 'cadastro de [G]rade de aula'
	aMenuCadastro[xI,2] = ''
	aMenuCadastro[xI,3] = 'FUNC->CHAMATODOS("\COOP\VFP\SISCOLEGIO\CADASTRO\GRADEAULA\GRADEAULA.APP")'		
	
	xI = xI + 1
   	aMenuCadastro[xI,1] = 'cadastro de [P]rofessores'
	aMenuCadastro[xI,2] = ''
	aMenuCadastro[xI,3] = 'FUNC->CHAMATODOS("\COOP\VFP\SISCOLEGIO\CADASTRO\PROFESSOR\PROFESSOR.APP")'

	xI = xI + 1
   	aMenuCadastro[xI,1] = 'cadastros gerais'
	aMenuCadastro[xI,2] = ''
	aMenuCadastro[xI,3] = 'FUNC->Criar_Menu( @aMenuCadGerais )'
	
	
	&& CADASTROS GERAIS
	Public array aMenuCadGerais[6,3]
	
	xI = 1
   	aMenuCadGerais[xI,1] = 'cadastrar tipo [A]lergia'
	aMenuCadGerais[xI,2] = ''
	aMenuCadGerais[xI,3] = 'FORM->frmtipoalergiacadastro'

	xI = xI + 1
   	aMenuCadGerais[xI,1] = 'cadastrar tipo a[C]ompanhamento'
	aMenuCadGerais[xI,2] = ''
	aMenuCadGerais[xI,3] = 'FORM->frmtipoacompcadastro'
	
	xI = xI + 1
   	aMenuCadGerais[xI,1] = 'cadastrar tipo de [D]ata'
	aMenuCadGerais[xI,2] = ''
	aMenuCadGerais[xI,3] = 'FORM->frmtipodatacadastro'
	
	xI = xI + 1
   	aMenuCadGerais[xI,1] = 'cadastrar classificações de [O]corrências'
	aMenuCadGerais[xI,2] = ''
	aMenuCadGerais[xI,3] = 'FORM->frmclassocorrenciacadastro'
	
	xI = xI + 1
   	aMenuCadGerais[xI,1] = 'cadastrar tipo [P]arentesco'
	aMenuCadGerais[xI,2] = ''
	aMenuCadGerais[xI,3] = 'FORM->frmparentescocadastro'

	xI = xI + 1
   	aMenuCadGerais[xI,1] = 'cadastrar classificação de di[S]ciplina'
	aMenuCadGerais[xI,2] = ''
	aMenuCadGerais[xI,3] = 'FORM->frmclassdisciplinacadastro'

	&& CRIA O MENU PADRAO 
	IF !pMenuConsulta
		xCriar = "Criar_Menu( @aMenuCadastro )"
		&xCriar.
	ELSE
		&& SE O APP FOI CHAMADO COM OPCAO DE MOSTRAR APENAS O MENU DE CONSULTAS, 
		&& ENTAO CHAMA O MENU DE CONSULTAS APENAS
		MENU_CONSULTA()
	ENDIF
    
    && LIMPA AS MATRIZES DA MEMÓRIA
    RELEASE aMenuCadastro
    
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINIÇÃO DA FUNÇÃO QUE CARREGA OS RELATÓRIOS DISPONÍVEIS PARA O MÓDULO, E VERIFICA PERMISSÕES.
&& OBS: Essa função é necessária para que o VFP 'ache' os formulários do APP, uma vez que se a função estiver 
&& encapsulada na classe MENU, o VFP busca o arquivo fisicamente. Dessa forma, não há nacessidade dos formulários
&& ficarem na pasta do sistema. 
&& ESSA FUNÇÃO NÃO DEVE SER MEXIDA!!! APENAS COPIADA.
    
	FUNCTION MENU_CONSULTA()
		
		oPerRel = CREATEOBJECT( "relatorio" ) && CLASSE PERMISSAO 
    	oPerRel.set_projeto( m.CfNomeProjeto ) && INSIRO NA PROPRIEDADE 'PROJETO' O NOME DO PROJETO 
		oPerRel.set_caminho( m.CfCaminhoAPP )  && INSIRO NA PROPRIEDADE 'CAMINHO' O CAMINHO COMPLETO DO APP
		oPerRel.carregar_relatorio()	
		
		&& ESSE METODO, RETORNA SE O MENU FOI CRIADO, SE SIM, ENTAO CARREGO O MESMO
    	IF oPerRel.get_menu_criado()
    		xNomeArray = ALLTRIM(oPerRel.get_nome_menu())
    		IF !EMPTY(xNomeArray)
				xCriar = "Criar_Menu( @" + xNomeArray + " )"
				&xCriar.
    		ENDIF
    	ELSE
    		WaitEnter( oPerRel.get_mensagem() , .T. )
    	ENDIF
    	
    	RELEASE oPerRel
        
    ENDFUNC
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINIÇÃO DA FUNÇÃO QUE EXECUTA AS CHAMADAS DE FORMULÁRIOS.
&& OBS: Essa função é necessária para que o VFP 'ache' os formulários do APP, uma vez que se a função estiver 
&& encapsulada na classe MENU, o VFP busca o arquivo fisicamente. Dessa forma, não há nacessidade dos formulários
&& ficarem na pasta do sistema. 
&& ESSA FUNÇÃO NÃO DEVE SER MEXIDA!!! APENAS COPIADA.
    
	FUNCTION MENU_EXECUTAR( pTipo, pExecutar )
		
		DO CASE
			CASE pTipo = "FUNC" 
				&pExecutar.
			CASE pTipo = "FORM" 
				DO FORM &pExecutar.
		ENDCASE
	ENDFUNC

