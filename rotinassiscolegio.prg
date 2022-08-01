**********************************************************************************************************************************
* PROGRAMA............: Rotinas gerais de trabalho do SisColegio
*
* AUTOR...............: Eliana Aparecida Marin Contesini
*
* CRIADO EM...........: 11/2021
*
* ULTIMA ALTERA��O....: 11/2021
**********************************************************************************************************************************

&& FUN��O PARA CARREGAR OS DIAS DA SEMANA NA COMBO BOX
&& *************************************************************************************************************
FUNCTION SISCOLEGIO_CRIAR_CURSOR_PADRAO_MESES()
&& *************************************************************************************************************
	
	CREATE CURSOR cCfMeses(	mes 		c(01),;
							descricao 	c(30) ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "1", "Janeiro" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "2", "Fevereiro" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "3", "Mar�o" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "4", "Abril" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "5", "Maio" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "6", "Junho" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "7", "Julho" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "8", "Agosto" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "9", "Setembro" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "10", "Outubro" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "11", "Novembro" ) 
	INSERT INTO cCfMeses( mes, descricao ) values( "12", "Dezembro" ) 
	
&& *************************************************************************************************************
ENDFUNC
&& *************************************************************************************************************

&& FUN��O PARA CARREGAR AS TURMAS
&& *************************************************************************************************************
FUNCTION SISCOLEGIO_CARREGAR_TURMAS(xCodAno)
&& *************************************************************************************************************
	
	*xAno = ALLTRIM(STR(YEAR(DATE())))
	
	SELECT("SCG_CAD_TURMA")
	SELECT * FROM SCG_CAD_TURMA WHERE SCG_CAD_TURMA.codano = xCodAno INTO CURSOR "cCfTurma"


	SELECT("SCG_CAD_TURMA")
	SELECT SCG_CAD_TURMA.*	,;
			SCG_CAD_TURMA.ANO+SCG_CAD_TURMA.NUMERO AS ANONUMERO	;
		FROM SCG_CAD_TURMA WHERE SCG_CAD_TURMA.ATIVO=1 AND SCG_CAD_TURMA.codano = xCodAno AND !DELETED() ORDER BY SCG_CAD_TURMA.cursoturma  INTO CURSOR "cCfCadTurma"
		
&& *************************************************************************************************************
ENDFUNC
&& *************************************************************************************************************


&& FUN��O PARA CARREGAR OS DIAS DA SEMANA NA COMBO BOX
&& *************************************************************************************************************
FUNCTION SISCOLEGIO_CRIAR_CURSOR_PADRAO()
&& *************************************************************************************************************
	
	CREATE CURSOR cCfDiaSemana(	dia 		c(01),;
								fds 		n(01),;	
								descricao 	c(30) ) 
	INSERT INTO cCfDiaSemana( dia, fds, descricao ) values( "1", 1 , "Domingo" ) 
	INSERT INTO cCfDiaSemana( dia, fds, descricao ) values( "2", 0 , "Segunda-feira" ) 
	INSERT INTO cCfDiaSemana( dia, fds, descricao ) values( "3", 0 , "Ter�a-feira" ) 
	INSERT INTO cCfDiaSemana( dia, fds, descricao ) values( "4", 0 , "Quarta-feira" ) 
	INSERT INTO cCfDiaSemana( dia, fds, descricao ) values( "5", 0 , "Quinta-feira" ) 
	INSERT INTO cCfDiaSemana( dia, fds, descricao ) values( "6", 0 , "Sexta-feira" ) 
	INSERT INTO cCfDiaSemana( dia, fds, descricao ) values( "7", 1 , "S�bado" ) 
	
&& *************************************************************************************************************
ENDFUNC
&& *************************************************************************************************************



&& FUN��O PARA GRAVAR O CABE�ALHO DOS RELAT�RIOS
&& *************************************************************************************************************
FUNCTION SISCOLEGIO_CARREGAR_CABEC_REL( pTitulo, pEnd1, pEnd2, pEnd3 , pLogo , pRodape1 , pRodape2 )
&& *************************************************************************************************************
	
	xab = .F.
	IF !USED("ALCONF1")
		xAB = .T.
		Abre( "ALCONF1" , "SHARED" , "INDCODEMP" , "ALCONF1" )
	ENDIF 
	
	pTitulo = ALCONF1.cabec_nome
	pEnd1 = ALCONF1.cabec_end1 
	pEnd2 = ALCONF1.cabec_end2 
	pEnd3 = ALCONF1.cabec_end3
	
	pLogo = ALCONF1.cabec_logo
	
	pRodape1 = ALCONF1.rodape1
	pRodape2 = ALCONF1.rodape2
	
	IF EMPTY(pLogo)
		pLogo = m.letraserver + "\COOP\MODULOS\FIGURAS\LOGOS\VAZIO.JPG"
		SET EXACT ON 
		IF !FILE("&pLogo.")
			pLogo = m.letraserver + "\COOP\MODULOS\FIGURAS\VAZIO.JPG"
		ENDIF 
	ENDIF 
	
	SET EXACT ON 
	IF !FILE("&pLogo.")
		pLogo = m.letraserver + "\COOP\MODULOS\FIGURAS\LOGOS\VAZIO.JPG"
		SET EXACT ON 
		IF !FILE("&pLogo.")
			pLogo = m.letraserver + "\COOP\MODULOS\FIGURAS\VAZIO.JPG"
		ENDIF 
	ENDIF
	
	IF EMPTY(pRodape2)
		pRodape2 = "Desenvolvido por CooperSis Inform�tica - Impresso em " + TTOC(DATETIME())
	ENDIF 
	
	IF xAB
		FechaLivre( "ALCONF1" )
	ENDIF 
	
&& *************************************************************************************************************
ENDFUNC
&& *************************************************************************************************************
