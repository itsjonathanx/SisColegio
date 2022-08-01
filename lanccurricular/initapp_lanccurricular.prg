LPARAMETERS pMenuConsulta
	IF TYPE("pMenuConsulta") != "L"
		pMenuConsulta = .F.
	ENDIF 
	
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& PROGRAMA INICIAL DO APLICATIVO (APP)
&& DEFINI��ES DE MENU E PROCEDURES DO APLICATIVO DEVEM SER INICIADAS AQUI
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINI��ES DE PROCEDURES LOCAIS
			
	
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINI��O DOS MENUS
&& OBS: Para chamar menu de consulta, ao inv�s de colocar FORM->PROX como 
&& comumente era colocado, basta fazer da seguinte forma:
&& FUNC->Criar_Menu( @NomeDaMatrizQueContemOMenuDeConsulta ) -> PARA MENUS DE RELATORIOS NAO DINAMICOS 
&& FUNC->MENU_CONSULTA() -> Para menus de relatorios dinamicos 
&& O restante das defini��es j� utilizadas, continuam da mesma forma.
	
	&& DEFINI�AO DO MENU PRINCIPAL
    Public array aMenuLanccurricular[5,3]
    xI = 0
    
    xI = xI + 1
   	aMenuLanccurricular[xI,1] = 'Lan�amento de prense�a di�ria'
	aMenuLanccurricular[xI,2] = ''
	aMenuLanccurricular[xI,3] = 'FORM->frmlancpresencadiaria'
		
    xI = xI + 1
   	aMenuLanccurricular[xI,1] = 'Lan�amento de prense�a e conte�do'
	aMenuLanccurricular[xI,2] = ''
	aMenuLanccurricular[xI,3] = 'FORM->frmlancpresencaconteudo'	
		
    xI = xI + 1
   	aMenuLanccurricular[xI,1] = 'Lan�amento de ocorr�ncia'
	aMenuLanccurricular[xI,2] = ''
	aMenuLanccurricular[xI,3] = 'FORM->frmlancocorrencia'	
	
    xI = xI + 1
   	aMenuLanccurricular[xI,1] = 'Lan�amento de conte�do'
	aMenuLanccurricular[xI,2] = ''
	aMenuLanccurricular[xI,3] = 'FORM->frmlancconteudo'	
	
    xI = xI + 1
   	aMenuLanccurricular[xI,1] = 'Consulta de alunos por turma'
	aMenuLanccurricular[xI,2] = ''
	aMenuLanccurricular[xI,3] = 'FORM->frmalunoconsulta'		
	
	
	&& CRIA O MENU PADRAO 
	IF !pMenuConsulta
		xCriar = "Criar_Menu( @aMenuLanccurricular )"
		&xCriar.
	ELSE
		&& SE O APP FOI CHAMADO COM OPCAO DE MOSTRAR APENAS O MENU DE CONSULTAS, 
		&& ENTAO CHAMA O MENU DE CONSULTAS APENAS
		MENU_CONSULTA()
	ENDIF
    
    && LIMPA AS MATRIZES DA MEM�RIA
    RELEASE aMenuLanccurricular
    
&& *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
&& DEFINI��O DA FUN��O QUE CARREGA OS RELAT�RIOS DISPON�VEIS PARA O M�DULO, E VERIFICA PERMISS�ES.
&& OBS: Essa fun��o � necess�ria para que o VFP 'ache' os formul�rios do APP, uma vez que se a fun��o estiver 
&& encapsulada na classe MENU, o VFP busca o arquivo fisicamente. Dessa forma, n�o h� nacessidade dos formul�rios
&& ficarem na pasta do sistema. 
&& ESSA FUN��O N�O DEVE SER MEXIDA!!! APENAS COPIADA.
    
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
&& DEFINI��O DA FUN��O QUE EXECUTA AS CHAMADAS DE FORMUL�RIOS.
&& OBS: Essa fun��o � necess�ria para que o VFP 'ache' os formul�rios do APP, uma vez que se a fun��o estiver 
&& encapsulada na classe MENU, o VFP busca o arquivo fisicamente. Dessa forma, n�o h� nacessidade dos formul�rios
&& ficarem na pasta do sistema. 
&& ESSA FUN��O N�O DEVE SER MEXIDA!!! APENAS COPIADA.
    
	FUNCTION MENU_EXECUTAR( pTipo, pExecutar )
		
		DO CASE
			CASE pTipo = "FUNC" 
				&pExecutar.
			CASE pTipo = "FORM" 
				DO FORM &pExecutar.
		ENDCASE
	ENDFUNC

