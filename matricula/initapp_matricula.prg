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
	SET PROCEDURE TO "\COOP\VFP\SISCOLEGIO\MATRICULA\ROTINASMATRICULA.PRG" ADDITIVE
	
	=MkDir( m.letraserver + "\COOP\ENVIAR\RECIBO" ) 
	=MkDir( m.letraserver + "\COOP\ENVIAR\MATRICULA" ) 
		
	
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINIÇÃO DOS MENUS
&& OBS: Para chamar menu de consulta, ao invés de colocar FORM->PROX como 
&& comumente era colocado, basta fazer da seguinte forma:
&& FUNC->Criar_Menu( @NomeDaMatrizQueContemOMenuDeConsulta ) -> PARA MENUS DE RELATORIOS NAO DINAMICOS 
&& FUNC->MENU_CONSULTA() -> Para menus de relatorios dinamicos 
&& O restante das definições já utilizadas, continuam da mesma forma.
	
	&& DEFINIÇAO DO MENU PRINCIPAL
    Public array aMenuMatricula[12,3]
    xProx = 1
   	aMenuMatricula[xProx,1] = 'cadastro de [M]atrícula'
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = 'FORM->frmmanutencaomatricula'
	
	xProx = xProx+1
   	aMenuMatricula[xProx,1] = 'cadastro de c[U]rso'
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = 'FORM->frmmanutencaocurso'
	
	xProx = xProx+1
   	aMenuMatricula[xProx,1] = '[I]mpressão de recibo'
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = 'FORM->frmimpressaoderecibo'
	
	xProx = xProx+1
	aMenuMatricula[xProx,1] = '[MA003] relatório de ma[T]riculas'
	aMenuMatricula[xProx,2]	= ''
	aMenuMatricula[xProx,3]	= 'FORM->frmconsultamatricula'
	
	xProx = xProx+1
	aMenuMatricula[xProx,1] = 'Impressão de [E]tiquetas'
	aMenuMatricula[xProx,2]	= ''
	aMenuMatricula[xProx,3]	= 'FORM->frmimpressaoetiquetas'
	
	xProx = xProx+1
	aMenuMatricula[xProx,1] = 'Im[P]ressão de Carteirinhas'
	aMenuMatricula[xProx,2]	= ''
	aMenuMatricula[xProx,3]	= 'FORM->frmimpressaodecarteirinha'
	
	xProx = xProx+1
	aMenuMatricula[xProx,1] = "[F]inanceiro"
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = "FUNC->Criar_Menu( @aMenuMatriculaFinan )"

	xProx = xProx+1
	aMenuMatricula[xProx,1] = "Ano [V]igente"
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = "FORM->frmanovigente"
	
	xProx = xProx+1
	aMenuMatricula[xProx,1] = '[C]opiar'
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = "FUNC->COPIE(.T.,'AL01F1','Aluno','AL01F2','Matricula', 'AL01F3', 'Vencimentos', 'AL02F1','Curso')" 
	
	xProx = xProx+1	
	aMenuMatricula[xProx,1] = '[R]estaurar'
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = "FUNC->RESTAURE(.T.,'AL01F1','Aluno','AL01F2','Matricula', 'AL01F3', 'Vencimentos', 'AL02F1','Curso')" 
	
	xProx = xProx+1
	aMenuMatricula[xProx,1] = 'organi[Z]ar'
	aMenuMatricula[xProx,2] = ''
	aMenuMatricula[xProx,3] = "FUNC->ORGANIZE(.T.,'AL01F1','Aluno','AL01F2','Matricula', 'AL01F3', 'Vencimentos', 'AL02F1','Curso')" 
	
	xProx = xProx+1
	aMenuMatricula[xProx,1] = '[S]obre'
	aMenuMatricula[xProx,2] = 'Sobre'
	aMenuMatricula[xProx,3] = 'FUNC->SOBRE()'
			    
   	&& DEFINICAO DO MENU DE CONSULTAS
	Public array aMenuMatriculaFinan[3,3]	
	xProx = 1
   	aMenuMatriculaFinan[xProx,1] = '[B]aixa de pagamento'
	aMenuMatriculaFinan[xProx,2] = ''
	aMenuMatriculaFinan[xProx,3] = 'FORM->frmbaixadepagamento'

	xProx = xProx+1
	aMenuMatriculaFinan[xProx,1] = '[MA001] relatório de ma[T]riculas'
	aMenuMatriculaFinan[xProx,2] = ''
	aMenuMatriculaFinan[xProx,3] = 'FORM->frmconsultamatricula'

	xProx = xProx+1
	aMenuMatriculaFinan[xProx,1] = '[MA002] relatório de m[E]nsalidades'
	aMenuMatriculaFinan[xProx,2] =	''
	aMenuMatriculaFinan[xProx,3] = 'FORM->frmconsultamensalidade'

	&& CRIA O MENU PADRAO 
	IF !pMenuConsulta
		xCriar = "Criar_Menu( @aMenuMatricula )"
		&xCriar.
	ELSE
		&& SE O APP FOI CHAMADO COM OPCAO DE MOSTRAR APENAS O MENU DE CONSULTAS, 
		&& ENTAO CHAMA O MENU DE CONSULTAS APENAS
		MENU_CONSULTA()
	ENDIF
    
    && LIMPA AS MATRIZES DA MEMÓRIA
    RELEASE aMenuMatricula, aMenuMatriculaFinan
    
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

