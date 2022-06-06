LPARAMETERS pMainEmp

CLOSE DATA ALL

PUBLIC MainEmp

IF TYPE('pMainEmp') = 'C'
	MainEmp = UPPER(pMainEmp)
Else
	MainEmp = ''
Endif

MainProg('\COOP\VFP\SISCOLEGIO\') 

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*FUNCAO PARA INCIALIZAÇÃO GERAL DO SISTEMA... PARAMETRO *
*	- > PCAM = CAMINHO PARA O FORMULÁRIO PRINCIPAL      *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
Function MainProg(pcam)
PUBLIC PMOD,FlagPrincipal
	
*!*		set procedure to '\coop\funcoes\cooperlib.fxp'			ADDITIVE 
*!*		set procedure to '\coop\funcoes\cooperSQL.fxp'			ADDITIVE
*!*		SET PROCEDURE TO '\COOP\MODULOS\ATUAUTO\ROTATUAUTO.PRG' ADDITIVE
*!*		
*!*	    SET CLASSLIB TO '\COOP\CLASSES\COOPERSIS.VCX' 			ADDITIVE
*!*	    SET CLASSLIB TO '\COOP\CLASSES\PERMISSAO.VCX' 			ADDITIVE
*!*	    SET CLASSLIB TO '\COOP\CLASSES\COOPERDIVERSOS.VCX' 		ADDITIVE
*!*	    SET CLASSLIB TO '\COOP\CLASSES\FORMULARIOS.VCX' 		ADDITIVE 
*!*	    SET CLASSLIB TO '\COOP\CLASSES\COOPERMACRO.VCX'			ADDITIVE
*!*	    SET CLASSLIB TO '\COOP\CLASSES\GRAFICO.VCX'    			ADDITIVE
	WAIT WINDOW 'Inicializando Sistema...... Declarando rotinas de uso' nowait
	
	set procedure to '\coop\funcoes\cooperlib.fxp'			ADDITIVE 
	set procedure to '\coop\funcoes\coopermenu.fxp'			ADDITIVE 
	set procedure to '\coop\funcoes\cooperSQL.fxp'			ADDITIVE
	SET PROCEDURE TO '\COOP\MODULOS\ATUAUTO\ROTATUAUTO.PRG' ADDITIVE
	SET PROCEDURE TO "\coop\funcoes\cdo2000.prg" 			ADDITIVE
	
    SET CLASSLIB TO '\COOP\CLASSES\COOPERSIS.VCX' 			ADDITIVE
    SET CLASSLIB TO '\COOP\CLASSES\PERMISSAO.VCX' 			ADDITIVE
    SET CLASSLIB TO '\COOP\CLASSES\COOPERDIVERSOS.VCX' 		ADDITIVE
    SET CLASSLIB TO '\COOP\CLASSES\FORMULARIOS.VCX' 		ADDITIVE 
    SET CLASSLIB TO '\COOP\CLASSES\COOPERMACRO.VCX'			ADDITIVE
    SET CLASSLIB TO '\COOP\CLASSES\GRAFICO.VCX'    			ADDITIVE

	SET CLASSLIB TO '\COOP\VFP\COOPERNFE\COOPERNFE.VCX'	 	ADDITIVE
	SET CLASSLIB TO '\COOP\CLASSES\COOPERCLASSE.VCX'		ADDITIVE
	SET CLASSLIB TO '\COOP\CLASSES\COOPERUTIL.VCX'			ADDITIVE
	
	
	WAIT WINDOW 'Inicializando Sistema......' nowait

	SET PROCEDURE TO "\COOP\VFP\SISCOLEGIO\ROTINASSISCOLEGIO.PRG" ADDITIVE
	
	WAIT WINDOW 'Inicializando Sistema......' nowait
    
	ON SHUTDOWN QUIT  && Permite a saida da aplicação pelo 'X'
	SET SYSMENU ON
	_screen.windowstate =  2
	
	INIT_SYS( "SISCOLEGIO" , .T. )
	&& init_sys( pSistema, pIgnorarRotKey , pNaoApagaTemp , pUnidadePadrao, pServerPadrao, pCaminhoRotKEY )

	&& EAMC - 01/2015 - O FOXPREVIEWER NÃO ACEITA ESTAR EM DIRETORIO DIFERENTE DO EXECUTAVEL, POR ISSO, FAREI A ROTINA LOGO NA INICIALIZAÇÃO PARA QUE SE O MESMO NÃO TIVER NO DIRETÓRIO DA APLICAÇÃO,
	&& EXECUTAVEL, O SISTEMA FAÇA A COPIA DO MESMO QUE ESTÁ POR PADRÃO NA PASTA CLASSES
	xDestFile = m.LetraServer + pCam + "foxypreviewer.app"
	SET EXACT ON 
	IF !FILE("&xDestFile.")
		xOrigem = m.letraserver + "\COOP\CLASSES\foxypreviewer.app"
		COPY FILE "&xOrigem." TO "&xDestFile."
	ENDIF
	
*!*		_REPORTBUILDER = "REPORTBUILDER.APP"
*!*		_REPORTPREVIEW = "REPORTPREVIEW.APP"
*!*		_REPORTOUTPUT  = "REPORTOUTPUT.APP"
	
	DO "&xDestFile."
	
	&& OBJETO PUBLICO DO RELATÓRIO DO FOXPREVIEWER - DEPOIS BASTA IR CONFIGURANDO O MESMO NAS ROTINAS DO SISTEMA	
	PUBLIC objVisRelatorio
	objVisRelatorio = CREATEOBJECT("coopvisrelatorio" )
*!*	Para desabilitar a FoxyPreviewer, basta um comando:
*!*		SET REPORTBEHAVIOR 80
		
*!*	Pra reativar:
	SET REPORTBEHAVIOR 90
	
	
	********************************************
	&& DEFINIÇÃO DE AMBIENTE
    xIcone   = _screen.Icon 
    xCaption = _screen.Caption
	_screen.Caption = m.CooperFone + 'SisColégio - Matrículas e Financeiro - Versão 1.0'
	
	SET DATE TO DMY               && Formato de data para Dia/Mes/Ano
	SET CURRENCY TO 'R$'          && Símbolo monetário
	SET POINT TO ','              && Separador decimal
	SET CENTURY ON                && Mostra o ano com 4 dígitos
	
	CARREGAMENU()
	MenuPrompt(MeuLabel, 'PRINCIPAL', '0')
    
    IF TYPE('xCaption') = "C"
		_screen.Icon = "&xIcone." 
		_screen.Caption = xCaption
		
		Descarregar_Screen()	    
	ENDIF
	
	SET SYSMENU ON
	SET SYSMENU TO DEFAULT
	SET DELETED OFF 
	SET STATUS BAR ON 
	SET CURSOR ON
	SET CLASSLIB TO
	CLOSE DATABASES ALL
	ON KEY
	CLEAR MEMORY
	CLEAR EVENTS 
	CLEAR
	ON ERROR
	
EndFunc