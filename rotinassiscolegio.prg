**********************************************************************************************************************************
* PROGRAMA............: Rotinas gerais de trabalho do SisColegio
*
* AUTOR...............: Eliana Aparecida Marin Contesini
*
* CRIADO EM...........: 11/2021
*
* ULTIMA ALTERA��O....: 11/2021
**********************************************************************************************************************************




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
