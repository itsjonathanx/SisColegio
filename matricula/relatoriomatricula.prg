*************************************************************
*  PROGRAMA......: Relat�rio de Espet�culo e Recrea��es		*	
*  AUTOR.........: Ricardo Aparecido Garbati 				*
*  DATA..........: 01/2006									*
*  ULT. ALTERA��O: 11/2021 - EAMC															*
*************************************************************

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
FUNCTION RL_ESPCRE( pEspetaculo, pRecreacao )
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	PUBLIC ARRAY aImp[1,4]
	m.linha  = 100
	m.pagina = 0
	m.aux_n_lines = VAL(ALLTRIM(n_lines))
	
	t = 0
	y = 0

	* 	ESPETACULO
	abre(  "SE12F1" , "SHARED" , "INDCODIGO" , "SE_ESP" )
	*	RECREACAO
	abre(  "SE12F6" , "SHARED" , "INDCODIGO" , "SE_REC" )

	
	CREATE CURSOR cListaEventos ( 	Nome c(40),;
									Codigo c(6),;
									Tipo c(3))
			
	SELECT ("cListaEventos")
	ZAP IN "cListaEventos"
	
	IF pEspetaculo=1
		SELECT ("SE_ESP") 
		GO TOP IN 'SE_ESP'
		
		DO WHILE ! EOF('SE_ESP')
			APPEND BLANK IN 'cListaEventos'
			replace cListaEventos.Nome 		WITH SE_ESP.nome			,;
					cListaEventos.Codigo	WITH SE_ESP.codigo			,;
					cListaEventos.Tipo		WITH "ESP"					IN 'cListaEventos'
			t = t+1	
			SKIP 1 IN 'SE_ESP'
		ENDDO 
	ENDIF 
	
	IF pRecreacao = 1 		
		SELECT ("SE_REC") 
		GO TOP IN 'SE_REC'
		
		DO WHILE ! EOF('SE_REC')
			APPEND BLANK IN 'cListaEventos'
			replace cListaEventos.Nome 		WITH SE_REC.nome			IN 'cListaEventos'
			replace cListaEventos.Codigo	WITH SE_REC.codigo			IN 'cListaEventos'				
			replace cListaEventos.Tipo		WITH "REC"					IN 'cListaEventos'
			y = y+1
			SKIP 1 IN 'SE_REC'
		ENDDO 		
	ENDIF


	SELECT 'cListaEventos'
	GO TOP IN 'cListaEventos'

	DO WHILE ! EOF ('cListaEventos') 

		IF m.linha > m.aux_n_lines
			CB_ESPCRE( "1" )
		ENDIF 
		
		aCarrPadrao( "| " + cListaEventos.Codigo + " | " +;
					 cListaEventos.Tipo 		 + " | " +;
					 cListaEventos.Nome 		 + " |" ,, "N" )
		
		SKIP 1 IN 'cListaEventos'
	ENDDO



	aCarrPadrao( "========================================================== "  ,, "N" )
	aCarrPadrao("")
	aCarrPadrao("Quantidade de Espetaculos.: " + STR(t) ,, "C")
	aCarrPadrao("Quantidade de Recreacoes..: " + STR(y) ,, "C")
	aCarrPadrao("")
	aCarrPadrao( "========================================================== "  ,, "N" ) 
	
	FOR j = m.linha TO m.aux_n_lines
		aCarrPadrao( "" )
	NEXT 
	
	DO FORM "\COOP\MODULOS\FRMCONSULTAPADRAO"
	RELEASE aImp
				
	
	FechaLivre( "SE_ESP" , "SE_REC" , "cListaEventos" ) 

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
ENDFUNC
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
FUNCTION CB_ESPCRE( pTipo, pC1, pC2, pC3 )
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	if m.linha < 80  && Pois qdo eh a primeira vez, a linha eh 100 
	    xPriVez = .F.
	    aCarrPadrao( "EJECT",,"P" )
	ELSE 
		xPriVez = .T.
	endif

	m.Linha = 0 
	m.pagina = m.pagina + 1
		

	aCarrPadrao( "========================================================== "  ,, "N" )
	aCarrPadrao( left(m.clientespri,40) + chr(20)  ,, "E" )
	aCarrPadrao( "[" + dtoc( date()) + "] - [" + time() + "]" + space(09) + "[PAGINA " + strzero( m.pagina, 3 ) + "]" ,, "N")
	aCarrPadrao( "========================================================== "  ,, "N" )

    pTipo = strzero( pTipo , 2 )
    aCarrPadrao("")
	msglist = IIF( pTipo = "01" ,"RELATORIO DE ESPETACULOS E RECREACOES"  ,"." )

     if type( "m.CfNumRel" ) = "C"
        if !empty( m.CfNumRel ) 
           MsgList = "[" + m.CfNumRel + "] " + MsgList
        endif
     endif

	aCarrPadrao( msglist )  
	aCarrPadrao( '')
	
	DO CASE 
		CASE  pTipo = "01" 
	
			aCarrPadrao( "---------------------------------------------------------- "  ,, "N" )
			aCarrPadrao( "|CODIGO  |TIPO |NOME                                      |"  ,, "N" ) 
			aCarrPadrao( "|========|=====|==========================================|"  ,, "N" )
			&&            | 999999 | XXX | XXXXXxxxxxXXXXXxxxxxXXXXXxxxxxXXXXXxxxxx |
	
	ENDCASE 
	
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
ENDFUNC
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
