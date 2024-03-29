**********************************************************************************************************************************
* PROGRAMA............: Rotinas gerais de trabalho do SisColegio
*
* AUTOR...............: Eliana Aparecida Marin Contesini
*
* CRIADO EM...........: 11/2021
*
* ULTIMA ALTERA��O....: 11/2021
**********************************************************************************************************************************

********************************************************************************************* 
FUNCTION RL_MA02_NOVO(pCodigo,pAno,pMatricula)		  	
	
	xSexo = ""	
	xPai = "" 
	xEmpp = "" 
	xFuncp = ""
	xMae = "" 
	xEmpm = "" 
	xFuncm = ""
	xArea = ""
	xQtdade = 0
	xFormadepagto = ""
	xVenc = ""
	xMes = 0
	xValor = 0
	xExtensivo = ""
	xCurso = ""
	
	IF !USED("CURSO")
		Abre('AL02F1','SHARED','INDCODIGO','CURSO')
	ENDIF 
	xAB_COOPER_EMP = .F.
	IF !USED("COOPER_EMP")
		xAB_COOPER_EMP = .T.
		Abre( "EMP01F1" , "SHARED" , "INDCODIGO" , "COOPER_EMP" )
	ENDIF 
	
	Informacao("Arquivo sendo impresso............. AGUARDE!")	
	
	CREATE CURSOR cImpSisColegio(	cabec_titulo c(100)	,;
							cabec_rel c(100)	,;
							cabec_filtro c(100)	,;
							cabec_end1 c(100)	,;
							cabec_end2 c(100)	,;
							cabec_end3 c(100)	,;
							cabec_logo c(100)	,;
							rodape1 c(100)		,;
							rodape2 c(100)		,;
							tpfiltro c(1)		,;
							filtro c(140)		,;
							codigo			c(10),;
							matricula c(20)		,;
							c_nome c(60)		,;
							c_nacionalidade c(40)	,;
							c_rg c(20)		,;
							c_cpf c(20)		,;
							c_endereco c(80)	,;
							c_bairro c(60)		,;
							c_cidade c(40)		,;
							c_estado c(2)		,;
							c_cep c(10)		,;
							c_fone c(20)		,;
							c_celular c(20)		,;
							c_email c(100)		,;
							a_nome c(60)		,;
							a_nacionalidade c(40)	,;
							a_rg c(20)		,;
							a_cpf c(20)		,;
							a_endereco c(80)	,;
							a_bairro c(60)		,;
							a_cidade c(40)		,;
							a_estado c(2)		,;
							a_cep c(10)		,;
							a_fone c(20)		,;
							a_celular c(20)		,;
							a_email c(100)		,;
							e_nome c(60)		,;
							e_cnpj c(20)	,;
							e_endereco c(80)	,;
							e_bairro c(60)		,;
							e_cidade c(40)		,;
							e_estado c(2)		,;
							e_cep c(10)		,;
							e_fone c(20)		,;
							e_email c(100)		,;
							curso c(30)		,;
							modalidade c(20)	,;
							duracao c(20)		,;
							curso_ini d(8)		,;
							curso_fim d(8)		,;
							valor_curso n(11,2)	,;
							desconto n(11,2)	,;
							valor_contrato n(11,2)	,;
							qtd_parcela n(2)	,;
							parcela01 n(11,2),parcela02 n(11,2),parcela03 n(11,2),parcela04 n(11,2),parcela05 n(11,2),parcela06 n(11,2),;
							parcela07 n(11,2),parcela08 n(11,2),parcela09 n(11,2),parcela10 n(11,2),parcela11 n(11,2),parcela12 n(11,2),;
							parcela13 n(11,2),parcela14 n(11,2),parcela15 n(11,2),parcela16 n(11,2),parcela17 n(11,2),parcela18 n(11,2),; 
							dia 			n(02),;
							data_dia c(2)		,;
							data_mes c(20)		,;
							data_ano c(4)		,;
							extensivo		c(40))

			
			SELECT ('ALUNO')
			GO TOP IN 'ALUNO'

			IF SEEK(pAno + pCodigo,'ALUNO','INDCODIGO')
				
				
				IF ALUNO.sexo == 1
					xSexo = "Masculino"
				ELSE 
					xSexo = "Feminino"
				ENDIF 
				
				IF !EMPTY(ALUNO.nomep)
					xResp = ALLTRIM(ALUNO.nomep) + " / " + ALLTRIM(ALUNO.nomem)
					xEmpR = ALLTRIM(ALUNO.empresap) + " / " + ALLTRIM(ALUNO.empresam)
					xFuncR = ALLTRIM(ALUNO.funcaop) + " / " + ALLTRIM(ALUNO.funcaom)
				ELSE
					xResp = ALLTRIM(ALUNO.nomem)
					xEmpR = ALLTRIM(ALUNO.empresam)
					xFuncR = ALLTRIM(ALUNO.funcaom)
				ENDIF 
				
				SELECT ("CURSO")
				SET ORDER TO ("INDCODIGO")
				IF SEEK(MATRICULA.curso,'CURSO','INDCODIGO')
					xCurso = CURSO.nome
				ENDIF 
				
				
				GO TOP IN 'MATRICULA'
				IF SEEK(pAno + pMatricula,'MATRICULA','INDMATRIC')

					xDT_USO = MATRICULA.datama 
					loMES_EXTENSO = MES( xDT_USO )
					loDATA_DIA = strzero( DAY(xDT_USO),2)
					loDATA_ANO = strzero( YEAR(xDT_USO),4)
					
					xValor = TRANSFORM(MATRICULA.valor, "@R 999,999,999.99")
					DO CASE 
						CASE MATRICULA.area == 1
							xArea = "Biol�gicas"
						CASE MATRICULA.area == 2
							xArea = "Exatas"
						CASE MATRICULA.area == 3
							xArea = "Humanas"
						CASE MATRICULA.area == 4
							xArea = "ITA/Militares"
						CASE MATRICULA.area == 5
							xArea = "Arquitetura"
					ENDCASE 

					APPEND BLANK IN 'cImpSisColegio'
					REPLACE cImpSisColegio.codigo 		WITH RIGHT(MATRICULA.codigo, 4) 	IN 'cImpSisColegio'
					Replace cImpSisColegio.matricula	WITH ALLTRIM(MATRICULA.matricula)+"/"+MATRICULA.ano			IN "cImpSisColegio"
					Replace cImpSisColegio.data_dia		WITH loDATA_DIA			,;
							cImpSisColegio.data_mes		WITH loMES_EXTENSO		,;
							cImpSisColegio.data_ano		WITH loDATA_ANO			IN "cImpSisColegio"
					
					
*!*						REPLACE cImpSisColegio.turma 		WITH MATRICULA.turma	IN 'cImpSisColegio' 			
*!*						REPLACE cImpSisColegio.datama		WITH MATRICULA.datama	IN 'cImpSisColegio'	
*!*						REPLACE cImpSisColegio.ano			WITH MATRICULA.ano		IN 'cImpSisColegio'
					
					Replace cImpSisColegio.c_nome 			WITH ALUNO.c_nome			,;
							cImpSisColegio.c_nacionalidade 	WITH ALUNO.c_nac			,;
							cImpSisColegio.c_rg 			WITH ALUNO.c_rg				,;
							cImpSisColegio.c_cpf 			WITH TRANSFORM( ALUNO.c_cpf , "@R 999.999.999-99") 		,;
							cImpSisColegio.c_endereco 		WITH ALLTRIM(ALUNO.c_end) + ", " + ALUNO.c_end_num			,;
							cImpSisColegio.c_bairro 		WITH ALUNO.c_bairro			,;
							cImpSisColegio.c_cidade 		WITH ALUNO.c_cidade			,;
							cImpSisColegio.c_estado 		WITH ALUNO.c_estado			,;
							cImpSisColegio.c_cep 			WITH TRANSFORM(ALUNO.c_cep , "@R 99.999-999" )			,;
							cImpSisColegio.c_fone 			WITH ALUNO.c_foneres		,;
							cImpSisColegio.c_celular 		WITH ALUNO.c_celular		,;
							cImpSisColegio.c_email 			WITH ALUNO.c_email			IN "cImpSisColegio"
					
					Replace cImpSisColegio.e_nome 		WITH COOPER_EMP.razao				,;
							cImpSisColegio.e_cnpj 		WITH TRANSFORM( COOPER_EMP.cnpj, "@R 99.999.999/9999-99" )		,;
							cImpSisColegio.e_endereco 	WITH ALLTRIM(COOPER_EMP.endereco) + " n� " + ALLTRIM(COOPER_EMP.numero)	,;
							cImpSisColegio.e_bairro 	WITH COOPER_EMP.bairro		,;
							cImpSisColegio.e_cidade 	WITH COOPER_EMP.cidade		,;
							cImpSisColegio.e_estado 	WITH COOPER_EMP.estado		,;
							cImpSisColegio.e_cep 		WITH TRANSFORM( COOPER_EMP.cep , "@R 99.999-999" )	,;
							cImpSisColegio.e_fone 		WITH COOPER_EMP.fone1		,;
							cImpSisColegio.e_email 		WITH COOPER_EMP.email		IN "cImpSisColegio"
					xFONE = ALLTRIM(ALUNO.ddd1) + " " + ALLTRIM(ALUNO.telefone1)
					
					REPLACE cImpSisColegio.a_nome			WITH ALUNO.nome			IN 'cImpSisColegio'
					REPLACE cImpSisColegio.a_rg				WITH ALUNO.identidade	IN 'cImpSisColegio'			
					REPLACE cImpSisColegio.a_cpf			WITH TRANSFORM( ALUNO.cpf , "@R 999.999.999-99"	)		IN 'cImpSisColegio'			
					REPLACE cImpSisColegio.a_endereco		WITH ALLTRIM(ALUNO.endereco)+ "/"+ALLTRIM(ALUNO.numero)		IN 'cImpSisColegio'
					REPLACE cImpSisColegio.a_bairro			WITH ALUNO.bairro		IN 'cImpSisColegio'			
					REPLACE cImpSisColegio.a_cidade			WITH ALUNO.cidade		IN 'cImpSisColegio'
					REPLACE cImpSisColegio.a_estado			WITH ALUNO.estado		IN 'cImpSisColegio'
					REPLACE cImpSisColegio.a_cep			WITH TRANSFORM(ALUNO.cep , "@R 99.999-999" )			IN 'cImpSisColegio'
					REPLACE cImpSisColegio.a_fone			WITH xFONE				IN 'cImpSisColegio'
					REPLACE cImpSisColegio.a_celular		WITH ALUNO.celular		IN 'cImpSisColegio'
					REPLACE cImpSisColegio.a_email			WITH ALUNO.email		IN 'cImpSisColegio'
					
					REPLACE cImpSisColegio.curso			WITH xCurso				IN 'cImpSisColegio'

					Replace	cImpSisColegio.curso 		WITH xCURSO					,;
							cImpSisColegio.modalidade 	WITH MATRICULA.modalidade	,;
							cImpSisColegio.duracao 		WITH MATRICULA.duracao		,;
							cImpSisColegio.curso_ini 	WITH MATRICULA.curso_ini	,;
							cImpSisColegio.curso_fim 	WITH MATRICULA.curso_fim	,;
							cImpSisColegio.valor_curso 	WITH MATRICULA.total		,;
							cImpSisColegio.desconto 	WITH MATRICULA.desconto		,;
							cImpSisColegio.valor_contrato WITH MATRICULA.valor		,;
							cImpSisColegio.qtd_parcela 	WITH MATRICULA.qtd_parc		IN "cImpSisColegio"

*!*						REPLACE cImpSisColegio.area			WITH xArea				IN 'cImpSisColegio'
*!*						REPLACE cImpSisColegio.dia			WITH MATRICULA.dia		IN 'cImpSisColegio'
					
					SELECT ('VENCIMENTO')
					SET ORDER TO "INDMACOD"
					
					SET NEAR ON 
					=SEEK(pAno + pMatricula + Pcodigo,'VENCIMENTO','INDMACOD')
					
					xDATA = CTOD("")
					IF VENCIMENTO.ano + VENCIMENTO.matricula + VENCIMENTO.codigo = pAno + pMatricula + pCodigo
						xData = VENCIMENTO.vencimento 
					ENDIF 					
					xQtdade = 0
					DO WHILE VENCIMENTO.ano + VENCIMENTO.matricula + VENCIMENTO.codigo = pAno + pMatricula + pCodigo AND !EOF('VENCIMENTO') 
						xQtdade = xQtdade + 1
						
						SKIP 1 IN 'VENCIMENTO'	
					ENDDO 
						
					xExtensivo = "Extensivo Diurno " + ALLTRIM(STR(YEAR(DATE())) )
					xFormadepagto = ALLTRIM(STR(xQtdade)) + "x de R$ " + ALLTRIM(xValor)  

*!*							SELECT("cImpSisColegio")
*!*							REPLACE cImpSisColegio.formadepagto	WITH xFormadepagto		IN 'cImpSisColegio'
*!*							REPLACE cImpSisColegio.extensivo	WITH xExtensivo			IN 'cImpSisColegio'
						
					SELECT("VENCIMENTO")
					SET ORDER TO "INDMACOD"
					
					SET NEAR ON 
					=SEEK(pAno + pMatricula + pCodigo,'VENCIMENTO','INDMACOD')
					xvenc = MONTH(VENCIMENTO.vencimento)
					DO WHILE !EOF('VENCIMENTO') AND VENCIMENTO.ano + VENCIMENTO.matricula + VENCIMENTO.codigo = pAno + pMatricula + pCodigo
						DO CASE 
											
							CASE MONTH(VENCIMENTO.vencimento) == 11 AND YEAR(VENCIMENTO.vencimento) == (VAL(MATRICULA.ano) - 1)
								xvenc = '01'
							CASE MONTH(VENCIMENTO.vencimento) == 12 AND YEAR(VENCIMENTO.vencimento) == (VAL(MATRICULA.ano) - 1)
								xvenc = '02'
							&& -----------------------------------	
							**CASE MONTH(VENCIMENTO.vencimento) == 11 AND YEAR(VENCIMENTO.vencimento) == VAL(MATRICULA.ano)
								**xvenc = '01'
							**CASE MONTH(VENCIMENTO.vencimento) == 12 AND YEAR(VENCIMENTO.vencimento) == VAL(MATRICULA.ano)
								**xvenc = '02'		
							&& -----------------------------------	
							CASE (MONTH(VENCIMENTO.vencimento) == 01 OR MONTH(VENCIMENTO.vencimento) == 02;
								  OR MONTH(VENCIMENTO.vencimento) == 03 OR MONTH(VENCIMENTO.vencimento) == 04) AND YEAR(VENCIMENTO.vencimento) == (VAL(MATRICULA.ano) + 1)
								xvenc = STRzero(MONTH(VENCIMENTO.vencimento) + 14, 2)
							OTHERWISE
								xvenc = STRzero(MONTH(VENCIMENTO.vencimento) + 2, 2)
						ENDCASE
*!*								xvenc = VENCIMENTO.parcelas
*!*								xMes = LEFT( mes(VENCIMENTO.vencimento),3 ) 
*!*								REPLACE cImpSisColegio.mes&xvenc.		WITH xMes	,;
								cImpSisColegio.parcela&xvenc.	WITH VENCIMENTO.valor	IN "cImpSisColegio"
						REPLACE cImpSisColegio.parcela&xvenc.	WITH VENCIMENTO.valor	IN "cImpSisColegio"
						
						SKIP 1 IN 'VENCIMENTO'
					ENDDO  
						
					
				ENDIF 
			ENDIF 
			Informacao("Arquivo sendo impresso............. AGUARDE!")	
			IF RECCOUNT('cImpSisColegio')!= 0
				xFILTRO = ""	
				&& ROTINA PARA CARREGAR OS DADOS PADR�ES DO CABE�ALHO
				STORE SPACE(1) TO xTitulo, xEnd1, xEnd2, xEnd3, xLogo, xRodape1, xRodape2	
				SISCOLEGIO_CARREGAR_CABEC_REL( @xTitulo , @xEnd1, @xEnd2, @xEnd3 , @xLogo , @xRodape1, @xRodape2 )
				Replace ALL cImpSisColegio.cabec_titulo		WITH xTitulo		,;
							cImpSisColegio.cabec_end1		WITH xEnd1			,;
							cImpSisColegio.cabec_end2		WITH xEnd2			,;
							cImpSisColegio.cabec_end3		WITH xEnd3			,;
							cImpSisColegio.cabec_logo		WITH xLogo			,;
							cImpSisColegio.cabec_rel		WITH ""				,;
							cImpSisColegio.cabec_filtro		WITH "" 			,;
							cImpSisColegio.filtro			WITH xFILTRO		,;
							cImpSisColegio.rodape1			WITH xRodape1		,;
							cImpSisColegio.rodape2			WITH xRodape2		IN "cImpSisColegio"
				
				SELECT("cImpSisColegio")
				GO TOP IN "cImpSisColegio"
				xNOME_ALUNO = ALLTRIM(cImpSisColegio.a_nome)
				xNOME_ALUNO = STRTRAN( xNOME_ALUNO , " " , "_" )
				
				
				SELECT("cImpSisColegio")
				xNOME_RPT = "rptAluno"				
				objVisRelatorio.carregar_configuracao()
				objVisRelatorio.cNomeReport = ALLTRIM(xNOME_RPT) + ".frx"
				objVisRelatorio.cOrigemReport = "\COOP\VFP\SISCOLEGIO\MATRICULA\"
				objVisRelatorio.cDirSaida = m.letraserver + "\COOP\ENVIAR\MATRICULA\"
				objVisRelatorio.cNomeSaida = "ALUNO_" + xNOME_ALUNO 
				objVisRelatorio.cTipoArquivoSaida = "PDF"

				objVisRelatorio.set_email_assunto( "Matr�cula aluno " + cImpSisColegio.a_nome + " (" + TTOC(DATETIME()) + ")" )		
				
				&& APENAS EXECUTA O RELAT�RIO
				objVisRelatorio.gerar_arquivo()
				objVisRelatorio.executar_relatorio()				
									
	
				WaitEnter("Arquivo criado na pasta Enviar!")
			ELSE 
				WaitEnter("N�o h� dados disponiveis!")
			ENDIF
			fechalivre("CURSO") 
			
	IF xAB_COOPER_EMP
		FechaLivre( "COOPER_EMP" ) 
	ENDIF 
ENDFUNC 
********************************************************************************



*****************************************************************
***						..CARTEIRINHAS..					  ***
*****************************************************************
FUNCTION RL_CAR01()
	
*!*		ImpEscolha = ""
*!*	    ImpEscolha = GetPrinter()

*!*	     IF EMPTY( ImpEscolha )
*!*		    WaitEnter("Aten��o! Nenhuma impressora definida para impress�o..." )
*!*		    RETURN -1
*!*		 ENDIF 

*!*		CREATE CURSOR cCar	(	nome		c(50),;
*!*								matricula	c(10),;
*!*								RA			c(10),;
*!*								turma		c(04),;
*!*								ano			c(04))
							
	CREATE CURSOR cImpSisColegio(	cabec_titulo c(100)	,;
									cabec_rel c(100)	,;
									cabec_filtro c(100)	,;
									cabec_end1 c(100)	,;
									cabec_end2 c(100)	,;
									cabec_end3 c(100)	,;
									cabec_logo c(100)	,;
									rodape1 c(100)		,;
									rodape2 c(100)		,;
									tpfiltro c(1)		,;
									filtro c(140)		,;	
									nome		c(50),;
									data		d(08),;
									ident		c(30),;
									estado		c(02),;
									numero		c(10),;
									validade	c(04))						
							
							
	SELECT("cImpSisColegio")
	ZAP IN "cImpSisColegio"

	SELECT('cCarteirinha')
	GO TOP IN 'cCarteirinha'
	DO WHILE !EOF('cCarteirinha')
	
		IF cCarteirinha.ativo = 1
		
			APPEND BLANK IN 'cImpSisColegio'
			REPLACE cImpSisColegio.nome 		WITH cCarteirinha.nome 				IN 'cImpSisColegio'
			REPLACE cImpSisColegio.data			WITH cCarteirinha.data				IN 'cImpSisColegio'
			REPLACE cImpSisColegio.ident		WITH cCarteirinha.ident				IN 'cImpSisColegio'
			REPLACE cImpSisColegio.estado		WITH cCarteirinha.estado			IN 'cImpSisColegio'
			REPLACE cImpSisColegio.numero		WITH cCarteirinha.numero			IN 'cImpSisColegio'
			REPLACE cImpSisColegio.validade		WITH cCarteirinha.validade			IN 'cImpSisColegio'
		ENDIF 

		SKIP 1 IN 'cCarteirinha'
	ENDDO 
	
	SELECT * from cImpSisColegio ORDER BY nome INTO CURSOR "cAuxCar"
	SELECT("cImpSisColegio")
	ZAP IN "cImpSisColegio"
	APPEND FROM DBF("cAuxCar")



	xFILTRO = ""
	&& ROTINA PARA CARREGAR OS DADOS PADR�ES DO CABE�ALHO
	STORE SPACE(1) TO xTitulo, xEnd1, xEnd2, xEnd3, xLogo, xRodape1, xRodape2	
	SISCOLEGIO_CARREGAR_CABEC_REL( @xTitulo , @xEnd1, @xEnd2, @xEnd3 , @xLogo , @xRodape1, @xRodape2 )
	Replace ALL cImpSisColegio.cabec_titulo		WITH xTitulo		,;
				cImpSisColegio.cabec_end1		WITH xEnd1			,;
				cImpSisColegio.cabec_end2		WITH xEnd2			,;
				cImpSisColegio.cabec_end3		WITH xEnd3			,;
				cImpSisColegio.cabec_logo		WITH xLogo			,;
				cImpSisColegio.cabec_rel		WITH ""				,;
				cImpSisColegio.cabec_filtro		WITH xFILTRO					,;
				cImpSisColegio.filtro			WITH xFILTRO		,;
				cImpSisColegio.rodape1			WITH xRodape1		,;
				cImpSisColegio.rodape2			WITH xRodape2		IN "cImpSisColegio"

	
	SELECT("cImpSisColegio")
	GO TOP IN "cImpSisColegio"
	
	xData = DTOC(DATE())
	xData = STRTRAN(xData,"/","")
	
	xNOME_RPT = "rptCarteirinha"				
	objVisRelatorio.carregar_configuracao()
	objVisRelatorio.cNomeReport = ALLTRIM(xNOME_RPT) + ".frx"
	objVisRelatorio.cOrigemReport = "\COOP\VFP\SISCOLEGIO\MATRICULA\"
	objVisRelatorio.cDirSaida = m.letraserver + "\COOP\ENVIAR\"
	objVisRelatorio.cNomeSaida = "CARTEIRINHA_" + xData 
	objVisRelatorio.cTipoArquivoSaida = "PDF"

	objVisRelatorio.set_email_assunto( "Carteirinha " + " (" + TTOC(DATETIME()) + ")" )		
	
	&& APENAS EXECUTA O RELAT�RIO
	objVisRelatorio.gerar_arquivo()
	objVisRelatorio.executar_relatorio()	
	
*!*		IF FILE("c:\coop\enviar\Cooper_rptCarteirinha.frx.pdf")
*!*		 	ERASE "c:\coop\enviar\Cooper_rptCarteirinha.frx.pdf"
*!*		ELSE
*!*			ERASE "c:\coop\enviar\Cooper_rptCarteirinha.pdf"
*!*		ENDIF 
*!*		
*!*		xData = DTOC(DATE())
*!*		xData = STRTRAN(xData,"/","")

*!*	 	IF FILE("c:\coop\enviar\" + "CARTEIRINHA_" + xData + ".PDF")
*!*		 	ERASE "c:\coop\enviar\" + "CARTEIRINHA_" + xData + ".PDF"
*!*		ENDIF 
*!*		
*!*		IF RECCOUNT('cCar') > 0
*!*		    SET DEVICE TO PRINTER 
*!*		    SET PRINTER TO NAME "&ImpEscolha."	

*!*			REPORT FORM '\COOP\VFP\SISCOLEGIO\MATRICULA\rptCarteirinha' TO PRINTER 
*!*		ELSE 
*!*			WaitEnter("N�o h� Dados disponiveis!")
*!*		ENDIF 		
*!*		
*!*		INKEY(8)
*!*		
*!*		IF FILE("c:\coop\enviar\Cooper_rptCarteirinha.frx.pdf")
*!*			INKEY(8)
*!*			RENAME "c:\coop\enviar\Cooper_rptCarteirinha.frx.pdf" TO "c:\coop\enviar\" + "CARTEIRINHA_" + xData + ".PDF"
*!*		ELSE
*!*			IF FILE("c:\coop\enviar\Cooper_rptCarteirinha.pdf")
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptCarteirinha.pdf" TO "c:\coop\enviar\" + "CARTEIRINHA_" + xData + ".PDF"				
*!*			ENDIF
*!*		ENDIF					
	
	Fechalivre("cCar")

ENDFUNC 
*****************************************************************
***							..RECIBO..						  ***
*****************************************************************
FUNCTION REC_PAGTO(pAno, pMatricula, pCodigo, pParcela, pPagamento, pValor, pMes)

	IF !USED("ALUNO")
		abre('AL01F1','SHARED','INDCODIGO','ALUNO') 
	ENDIF 
	IF !USED("M_ALUNO")
		abre('AL01F2','SHARED','INDMATRIC','M_ALUNO') 
	ENDIF 
	IF !USED("V_ALUNO")
		abre('AL01F3','SHARED','INDMACOD','V_ALUNO') 
	ENDIF 
	IF !USED("CURSO")
		abre('AL02F1','SHARED','INDCODIGO','CURSO')
	ENDIF 
	
	CREATE CURSOR cImpSisColegio(	cabec_titulo c(100)	,;
								cabec_rel c(100)	,;
								cabec_filtro c(100)	,;
								cabec_end1 c(100)	,;
								cabec_end2 c(100)	,;
								cabec_end3 c(100)	,;
								cabec_logo c(100)	,;
								rodape1 c(100)		,;
								rodape2 c(100)		,;
								tpfiltro c(1)		,;
								filtro c(140)		,;	
								local 		c(30)	,;
								cedente		c(50)	,;
								cgccpf		c(20)	,;
								data		d(08)	,;
								valor		n(14,2) ,;
								mes    		c(10)	,;
								pagamento	d(08)	,;
								turma		c(10)	,;
								codcurso    c(03)	,;
								curso		c(20)	,;
								nome		c(40)	,;
								codigo		c(10)	)
	
*!*		
*!*		CREATE CURSOR cAux(		local 		c(30)	,;
*!*								cedente		c(30)	,;
*!*								cgccpf		c(14)	,;
*!*								data		d(08)	,;
*!*								valor		n(14,2) ,;
*!*								pagamento	d(08)	,;
*!*								turma		n(04)	,;
*!*								curso		c(20)	,;
*!*								nome		c(40)	,;
*!*								codigo		n(05)	)
						
	SELECT("M_ALUNO")
	SET ORDER TO "INDMATRIC"
	
	SET NEAR ON 
	=SEEK(pAno + pMatricula, "M_ALUNO", "INDMATRIC")
	
	IF pMatricula != M_ALUNO.matricula
		RETURN .F.
	ENDIF
	
	xCurso = ""
	xCodCurso = ""
	xMes = ""
	xData = ""
	
	IF SEEK(M_ALUNO.curso, "CURSO", "INDCODIGO")
		xCodCurso = CURSO.codigo
		xCurso = CURSO.nome
	ENDIF
	
	SELECT("V_ALUNO")
	SET ORDER TO "INDMACOD"

	SET NEAR ON
	=SEEK(M_ALUNO.ano + M_ALUNO.matricula + M_ALUNO.codigo, "V_ALUNO", "INDMACOD")
		
	DO WHILE V_ALUNO.ano + V_ALUNO.matricula + V_ALUNO.codigo = M_ALUNO.ano + M_ALUNO.matricula + M_ALUNO.codigo AND !EOF("V_ALUNO")
		IF pParcela != V_ALUNO.parcelas
			SKIP 1 IN 'V_ALUNO'
			LOOP
		ENDIF 

		xData = CTOD( strzero(DAY(pPagamento),2) + "/" + pMes + "/" + strzero(YEAR(pPagamento),4))
		xMes = mes(xData)
		
		IF DELETED("V_ALUNO")
			SKIP 1 IN "V_ALUNO"
			LOOP
		ENDIF
		
*!*			xData = mes(pPagamento)
*!*			IF EMPTY(V_ALUNO.pagamento)
*!*				EXIT
*!*			ENDIF
		
		xAluno = ""
		IF SEEK(M_ALUNO.ano + M_ALUNO.codigo, "ALUNO", "INDCODIGO")
			xAluno = ALUNO.nome
		ENDIF
		
		APPEND BLANK IN "cImpSisColegio"
		REPLACE cImpSisColegio.local 		WITH "CURSO ANGLO VESTIBULARES"	IN "cImpSisColegio"
		REPLACE cImpSisColegio.cedente		WITH m.AirRazao					IN "cImpSisColegio"
		REPLACE cImpSisColegio.cgccpf		WITH TRANSFORM(m.AirCgc, "@R 99.999.999/9999-99")	IN "cImpSisColegio"
		REPLACE cImpSisColegio.data 		WITH pPagamento					IN "cImpSisColegio"
		REPLACE cImpSisColegio.valor		WITH pValor						IN "cImpSisColegio"
		REPLACE cImpSisColegio.mes			WITH xMes						IN "cImpSisColegio"
		REPLACE cImpSisColegio.turma		WITH M_ALUNO.turma				IN "cImpSisColegio"
		REPLACE cImpSisColegio.codcurso		WITH xCodCurso					IN "cImpSisColegio"
		REPLACE cImpSisColegio.curso		WITH xCurso						IN "cImpSisColegio"
		REPLACE cImpSisColegio.nome			WITH xALUNO						IN "cImpSisColegio"
		REPLACE cImpSisColegio.codigo		WITH RIGHT(V_ALUNO.codigo, 4)	IN "cImpSisColegio"
		REPLACE cImpSisColegio.pagamento	WITH pPagamento					IN "cImpSisColegio"
		EXIT 
	ENDDO

	SELECT MAX(pagamento) as pagamento, codigo from cImpSisColegio INTO CURSOR "cAuxRec"
	
	SELECT * from cImpSisColegio WHERE cImpSisColegio.codigo = cAuxRec.codigo AND cImpSisColegio.pagamento = cAuxRec.pagamento INTO CURSOR "cAuxRec1"
	
	SELECT("cImpSisColegio")
	ZAP IN "cImpSisColegio"
	APPEND FROM DBF("cAuxRec1")
	GO TOP IN "cImpSisColegio"
		
	xFILTRO = ""	
	&& ROTINA PARA CARREGAR OS DADOS PADR�ES DO CABE�ALHO
	STORE SPACE(1) TO xTitulo, xEnd1, xEnd2, xEnd3, xLogo, xRodape1, xRodape2	
	SISCOLEGIO_CARREGAR_CABEC_REL( @xTitulo , @xEnd1, @xEnd2, @xEnd3 , @xLogo , @xRodape1, @xRodape2 )
	Replace ALL cImpSisColegio.cabec_titulo		WITH xTitulo		,;
				cImpSisColegio.cabec_end1		WITH xEnd1			,;
				cImpSisColegio.cabec_end2		WITH xEnd2			,;
				cImpSisColegio.cabec_end3		WITH xEnd3			,;
				cImpSisColegio.cabec_logo		WITH xLogo			,;
				cImpSisColegio.cabec_rel		WITH ""				,;
				cImpSisColegio.cabec_filtro		WITH "" 			,;
				cImpSisColegio.filtro			WITH xFILTRO		,;
				cImpSisColegio.rodape1			WITH xRodape1		,;
				cImpSisColegio.rodape2			WITH xRodape2		IN "cImpSisColegio"

	
	SELECT("cImpSisColegio")
	GO TOP IN "cImpSisColegio"
	xNOME_ALUNO = ALLTRIM(cImpSisColegio.nome)
	xNOME_ALUNO = STRTRAN( xNOME_ALUNO , " " , "_" )
	
	xNOME_RPT = "rptRecibo"				
	objVisRelatorio.carregar_configuracao()
	objVisRelatorio.cNomeReport = ALLTRIM(xNOME_RPT) + ".frx"
	objVisRelatorio.cOrigemReport = "\COOP\VFP\SISCOLEGIO\MATRICULA\"
	objVisRelatorio.cDirSaida = m.letraserver + "\COOP\ENVIAR\RECIBO\"
	objVisRelatorio.cNomeSaida = "RECIBO_" + xNOME_ALUNO
	objVisRelatorio.cTipoArquivoSaida = "PDF"

	objVisRelatorio.set_email_assunto( "Recibo aluno " + cImpSisColegio.nome + " (" + TTOC(DATETIME()) + ")" )		
	
	&& APENAS EXECUTA O RELAT�RIO
	objVisRelatorio.gerar_arquivo()
	objVisRelatorio.executar_relatorio()				
	
		
*!*			IF FILE("c:\coop\enviar\Cooper_rptRecibo.frx.pdf")
*!*			 	ERASE "c:\coop\enviar\Cooper_rptRecibo.frx.pdf"
*!*			ELSE
*!*				ERASE "c:\coop\enviar\Cooper_rptRecibo.pdf"
*!*			ENDIF 

*!*		 	IF FILE("c:\coop\enviar\" + "RECIBO_" + xNome + ".PDF")
*!*			 	ERASE "c:\coop\enviar\" + "RECIBO_" + xNome + ".PDF"
*!*			ENDIF 
*!*			
*!*			SELECT('cRecibo')
*!*			SET DEVICE TO PRINTER
*!*			SET PRINTER TO NAME "PDFCreator"
*!*			REPORT FORM '\COOP\VFP\SISCOLEGIO\MATRICULA\rptRecibo' TO PRINTER
*!*			INKEY(12)
*!*			IF FILE("c:\coop\enviar\Cooper_rptRecibo.frx.pdf")
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptRecibo.frx.pdf" TO "c:\coop\enviar\" + "RECIBO_" + xNome + ".PDF"
*!*			ELSE
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptRecibo.pdf" TO "c:\coop\enviar\" + "RECIBO_" + xNome + ".PDF"				
*!*			ENDIF					

*!*			IF m.letraserver != "C:"
*!*				INKEY(4)				
*!*				IF FILE(m.letraserver + "\coop\enviar\" + "RECIBO_" + xNome + ".PDF")
*!*					ERASE m.letraserver + "\coop\enviar\" + "RECIBO_" + xNome + ".PDF"
*!*				ENDIF
*!*				COPY FILE "c:\coop\enviar\" + "RECIBO_" + xNome + ".PDF" TO m.letraserver + "\coop\enviar\" + "RECIBO_" + xNome + ".PDF"
*!*				INKEY(4)
*!*			ENDIF

ENDFUNC
****************************************************************************************
**********************					MATRICULA			      **********************
****************************************************************************************
FUNCTION RL_MA01(pAno)
	
	abre(	'AL01F1','SHARED','INDCODIGO','ALUNO',; 
			'AL01F2','SHARED','INDANO','M_ALUNO',; 
			'AL01F3','SHARED','INDMACOD','V_ALUNO')

	CREATE CURSOR cImpSisColegio(	cabec_titulo c(100)	,;
									cabec_rel c(100)	,;
									cabec_filtro c(100)	,;
									cabec_end1 c(100)	,;
									cabec_end2 c(100)	,;
									cabec_end3 c(100)	,;
									cabec_logo c(100)	,;
									rodape1 c(100)		,;
									rodape2 c(100)		,;
									tpfiltro c(1)		,;
									filtro c(140)		,;	
									codigo	 		c(10),;
									matricula		d(08),;
									datama		 	d(08),;
									cadastroe 		c(10),;
									nome			c(60),;
									rg				c(10),;
									nasc			d(08),;
									endereco		c(60),;
									bairro			c(30),;
									cidade			c(30),;
									cep				c(08),;
									ddd				c(02),;
									telefone		c(08),;
									diapagto		n(02),;
									condpagto		c(50),;
									ano				c(04))
									
	xTotal=0
	xValor=0
	xQtdade=0
	xFormadepagto = ""


	SELECT * from M_ALUNO WHERE M_ALUNO.ano = pAno AND M_ALUNO.matricula != "NOVO" AND;
	 		!EMPTY(M_ALUNO.codigo) ORDER BY M_ALUNO.codigo INTO CURSOR 'cDados'

	GO TOP IN 'cDados'
	DO WHILE !EOF('cDados')
		xValor = TRANSFORM(cDados.valor, "@R 999,999,999.99")
		IF cDados.vl_parcela > 0	&& CRIADO DEPOIS DAS ALTERA��ES DE 11/2021
			xValor = TRANSFORM(cDados.vl_parcela, "@R 999,999,999.99")
		ENDIF 
		
		xTotal = cDados.total&&TOTAL
		xQtdade = 0
		SELECT('ALUNO')
		IF SEEK(cDados.ano + cDados.codigo,'ALUNO','INDCODIGO')
			SELECT('V_ALUNO')
			SET ORDER TO 'INDMACOD'
			
			SET NEAR ON 
			=SEEK( cDados.ano + cDados.matricula + cDados.codigo,'V_ALUNO','INDMACOD')
			xQtdade = 0
			DO WHILE !EOF('V_ALUNO') AND V_ALUNO.ano + V_ALUNO.matricula + V_ALUNO.codigo = cDados.ano + cDados.matricula + cDados.codigo
				xQtdade = xQtdade + 1
				SKIP 1 IN 'V_ALUNO'	
			ENDDO 
			xFormadepagto = ALLTRIM(STR(xQtdade)) + "x de R$" + ALLTRIM(xValor)  

			APPEND BLANK IN 'cImpSisColegio'
			REPLACE cImpSisColegio.codigo		WITH ALUNO.codigo						IN 'cImpSisColegio'
			REPLACE cImpSisColegio.matricula	WITH cDados.datama						IN 'cImpSisColegio'
			REPLACE cImpSisColegio.datama		WITH cDados.datama						IN 'cImpSisColegio'
			REPLACE cImpSisColegio.cadastroe	WITH ALUNO.cadastroe					IN 'cImpSisColegio'
			REPLACE cImpSisColegio.nome 		WITH ALUNO.nome							IN 'cImpSisColegio'
			REPLACE cImpSisColegio.RG			WITH ALUNO.identidade					IN 'cImpSisColegio'
			REPLACE cImpSisColegio.nasc			WITH ALUNO.data							IN 'cImpSisColegio'
			REPLACE cImpSisColegio.endereco		WITH ALLTRIM(ALUNO.endereco)+","+ ALLTRIM(ALUNO.numero)	IN 'cImpSisColegio'
			REPLACE cImpSisColegio.bairro		WITH ALUNO.bairro						IN 'cImpSisColegio'
			REPLACE cImpSisColegio.cidade		WITH ALUNO.cidade						IN 'cImpSisColegio'
			REPLACE cImpSisColegio.cep			WITH ALUNO.cep							IN 'cImpSisColegio'
			REPLACE cImpSisColegio.ddd			WITH ALUNO.ddd1							IN 'cImpSisColegio'
			REPLACE cImpSisColegio.telefone		WITH ALUNO.telefone1					IN 'cImpSisColegio'	
			REPLACE cImpSisColegio.diapagto		WITH cDados.dia							IN 'cImpSisColegio'
			REPLACE cImpSisColegio.condpagto	WITH xFormadepagto						IN 'cImpSisColegio'
			REPLACE cImpSisColegio.ano			WITH pAno								IN 'cImpSisColegio'				

		ENDIF  
		SKIP 1 IN 'cDados'
	ENDDO 
		
	SELECT("cImpSisColegio")
	IF RECCOUNT('cImpSisColegio')!= 0
		
		xFILTRO = "ANO " + cImpSisColegio.ano
		&& ROTINA PARA CARREGAR OS DADOS PADR�ES DO CABE�ALHO
		STORE SPACE(1) TO xTitulo, xEnd1, xEnd2, xEnd3, xLogo, xRodape1, xRodape2	
		SISCOLEGIO_CARREGAR_CABEC_REL( @xTitulo , @xEnd1, @xEnd2, @xEnd3 , @xLogo , @xRodape1, @xRodape2 )
		Replace ALL cImpSisColegio.cabec_titulo		WITH xTitulo		,;
					cImpSisColegio.cabec_end1		WITH xEnd1			,;
					cImpSisColegio.cabec_end2		WITH xEnd2			,;
					cImpSisColegio.cabec_end3		WITH xEnd3			,;
					cImpSisColegio.cabec_logo		WITH xLogo			,;
					cImpSisColegio.cabec_rel		WITH "Relat�rio de Alunos matriculados (financeiro)"				,;
					cImpSisColegio.cabec_filtro		WITH xFILTRO					,;
					cImpSisColegio.filtro			WITH xFILTRO		,;
					cImpSisColegio.rodape1			WITH xRodape1		,;
					cImpSisColegio.rodape2			WITH xRodape2		IN "cImpSisColegio"

		
		SELECT("cImpSisColegio")
		GO TOP IN "cImpSisColegio"
		
		xNOME_RPT = "rptMatricula"				
		objVisRelatorio.carregar_configuracao()
		objVisRelatorio.cNomeReport = ALLTRIM(xNOME_RPT) + ".frx"
		objVisRelatorio.cOrigemReport = "\COOP\VFP\SISCOLEGIO\MATRICULA\"
		objVisRelatorio.cDirSaida = m.letraserver + "\COOP\ENVIAR\"
		objVisRelatorio.cNomeSaida = "MATRICULA_FINANCEIRO_" + DTOS(DATE())
		objVisRelatorio.cTipoArquivoSaida = "PDF"

		objVisRelatorio.set_email_assunto( "Relat�rio de Matr�culas " + " (" + TTOC(DATETIME()) + ")" )		
		
		&& APENAS EXECUTA O RELAT�RIO
		objVisRelatorio.gerar_arquivo()
		objVisRelatorio.executar_relatorio()			
		
		
		
*!*		 	IF FILE("c:\coop\enviar\Cooper_rptMatricula.frx.pdf")
*!*			 	ERASE "c:\coop\enviar\Cooper_rptMatricula.frx.pdf"
*!*			ELSE
*!*				ERASE "c:\coop\enviar\Cooper_rptMatricula.pdf"
*!*			ENDIF 

*!*		 	IF FILE("c:\coop\enviar\MatriculaEli.PDF")
*!*			 	ERASE "c:\coop\enviar\MatriculaEli.PDF"
*!*			ENDIF 
*!*			
*!*			SELECT('cMatricula')
*!*			SET DEVICE TO PRINTER
*!*			SET PRINTER TO NAME "PDFCreator"
*!*			REPORT FORM '\COOP\VFP\SISCOLEGIO\MATRICULA\rptMatricula' TO PRINTER
*!*			INKEY(8)
*!*			IF FILE("c:\coop\enviar\Cooper_rptMatricula.frx.pdf")
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptMatricula.frx.pdf" TO "c:\coop\enviar\MatriculaEli.PDF"
*!*			ELSE
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptMatricula.pdf" TO "c:\coop\enviar\MatriculaEli.PDF"				
*!*			ENDIF					

*!*			IF m.letraserver != "C:"
*!*				INKEY(4)				
*!*				IF FILE(m.letraserver + "\coop\enviar\MatriculaEli.PDF")
*!*					ERASE m.letraserver + "\coop\enviar\MatriculaEli.PDF"
*!*				ENDIF
*!*				COPY FILE "c:\coop\enviar\MatriculaEli.PDF" TO m.letraserver + "\coop\enviar\MatriculaEli.PDF"
*!*				INKEY(4)
*!*			ENDIF

	ELSE 
		WaitEnter("N�o a Dados disponiveis!")
	ENDIF 

	fechalivre('ALUNO','M_ALUNO')
	
*	SELECT * FROM CMATRICULA INTO TABLE C:\COOP\CMATRICULA.DBF
ENDFUNC
****************************************************************************************
**********************					MATRICULASIMPLES	      **********************
****************************************************************************************
FUNCTION RL_MA03(pAno)
	
	abre(	'AL01F1','SHARED','INDCODIGO','ALUNO',; 
			'AL01F2','SHARED','INDANO','M_ALUNO',; 
			'AL01F3','SHARED','INDMACOD','V_ALUNO')

*!*		
*!*		CREATE CURSOR cMatricula(	nome		c(60),;
*!*									telefone	c(08),;
*!*									ddd			c(02),;
*!*									codigo		c(10),;
*!*									matricula	c(10),;
*!*									endereco	c(60),;
*!*									numero		c(04),;
*!*									cep			c(08),;
*!*									bairro		c(30),;
*!*									cidade		c(20),;
*!*									estado		c(02),;
*!*									total		n(11,2),;
*!*									condpagto	c(50),;
*!*									diapagto	n(02),;
*!*									cadastroe	c(10))
	CREATE CURSOR cImpSisColegio(	cabec_titulo c(100)	,;
									cabec_rel c(100)	,;
									cabec_filtro c(100)	,;
									cabec_end1 c(100)	,;
									cabec_end2 c(100)	,;
									cabec_end3 c(100)	,;
									cabec_logo c(100)	,;
									rodape1 c(100)		,;
									rodape2 c(100)		,;
									tpfiltro c(1)		,;
									filtro c(140)		,;	
									codigo	 		c(10),;
									matricula	 	d(08),;
									cadastroe 		c(10),;
									nome			c(60),;
									rg				c(10),;
									nasc			d(08),;
									endereco		c(60),;
									bairro			c(30),;
									cidade			c(30),;
									cep				c(08),;
									ddd				c(02),;
									telefone		c(08),;
									ano				c(04))
	xMatric=""
	xCondicao=""
	xTotal=0
	xValor=0
	xQtdade=0
	xDia=0

	SELECT('M_ALUNO')
	SET ORDER TO 'INDANO'
	
	SET NEAR ON 
	=SEEK(pAno,'M_ALUNO','INDANO')
	SELECT * from M_ALUNO WHERE M_ALUNO.ano = ALLTRIM(pAno) AND M_ALUNO.matricula != "NOVO" AND;
	 !EMPTY(M_ALUNO.codigo) ORDER BY M_ALUNO.codigo INTO CURSOR 'cDados'

	GO TOP IN 'cDados'
	DO WHILE !EOF('cDados')
		xValor = TRANSFORM(cDados.total, "@R 999,999,999.99")
		xMatric = cDados.datama&&DATA DA MATRICULA
		xTotal = cDados.total&&TOTAL
		xDia = cDados.dia
*!*			SELECT('C_PAGTO')
*!*			GO TOP IN 'C_PAGTO'
*!*			IF SEEK(cDados.condpagto,'C_PAGTO','INDCODCOND')
*!*				xCondicao = C_PAGTO.descricao && ARMAZENO A CONDI��O DE PAGAMENTO
			
			SELECT('ALUNO')
			IF SEEK(cDados.ano + cDados.codigo,'ALUNO','INDCODIGO')

				IF SEEK( cDados.ano + cDados.matricula + cDados.codigo,'V_ALUNO','INDMACOD')
					
					DO WHILE !EOF('V_ALUNO') AND V_ALUNO.ano + V_ALUNO.matricula + V_ALUNO.codigo = cDados.ano + cDados.matricula + cDados.codigo
							xQtdade = xQtdade + 1
							SKIP 1 IN 'V_ALUNO'	
					ENDDO 
				
				ENDIF 
				
				APPEND BLANK IN 'cImpSisColegio'
				REPLACE cImpSisColegio.codigo		WITH ALUNO.codigo						IN 'cImpSisColegio'
				REPLACE cImpSisColegio.matricula	WITH xMatric							IN 'cImpSisColegio'
				REPLACE cImpSisColegio.cadastroe	WITH ALUNO.cadastroe					IN 'cImpSisColegio'
				REPLACE cImpSisColegio.nome 		WITH ALUNO.nome							IN 'cImpSisColegio'
				REPLACE cImpSisColegio.RG			WITH ALUNO.identidade					IN 'cImpSisColegio'
				REPLACE cImpSisColegio.nasc			WITH ALUNO.data							IN 'cImpSisColegio'
				REPLACE cImpSisColegio.endereco		WITH ALLTRIM(ALUNO.endereco)+","+ ALLTRIM(ALUNO.numero)	IN 'cImpSisColegio'
				REPLACE cImpSisColegio.bairro		WITH ALUNO.bairro						IN 'cImpSisColegio'
				REPLACE cImpSisColegio.cidade		WITH ALUNO.cidade						IN 'cImpSisColegio'
				REPLACE cImpSisColegio.cep			WITH ALUNO.cep							IN 'cImpSisColegio'
				REPLACE cImpSisColegio.ddd			WITH ALUNO.ddd1							IN 'cImpSisColegio'
				REPLACE cImpSisColegio.telefone		WITH ALUNO.telefone1					IN 'cImpSisColegio'	
				REPLACE cImpSisColegio.ano			WITH pAno							 	IN 'cImpSisColegio'	

			ENDIF  
		SKIP 1 IN 'cDados'
	ENDDO 

*Relat�rio de Alunos matriculados no Curso Anglo Jundia�


	SELECT("cImpSisColegio")
	IF RECCOUNT('cImpSisColegio')!= 0
	 	
		xFILTRO = "ANO " + cImpSisColegio.ano
		&& ROTINA PARA CARREGAR OS DADOS PADR�ES DO CABE�ALHO
		STORE SPACE(1) TO xTitulo, xEnd1, xEnd2, xEnd3, xLogo, xRodape1, xRodape2	
		SISCOLEGIO_CARREGAR_CABEC_REL( @xTitulo , @xEnd1, @xEnd2, @xEnd3 , @xLogo , @xRodape1, @xRodape2 )
		Replace ALL cImpSisColegio.cabec_titulo		WITH xTitulo		,;
					cImpSisColegio.cabec_end1		WITH xEnd1			,;
					cImpSisColegio.cabec_end2		WITH xEnd2			,;
					cImpSisColegio.cabec_end3		WITH xEnd3			,;
					cImpSisColegio.cabec_logo		WITH xLogo			,;
					cImpSisColegio.cabec_rel		WITH "Relat�rio de Alunos matriculados"				,;
					cImpSisColegio.cabec_filtro		WITH xFILTRO					,;
					cImpSisColegio.filtro			WITH xFILTRO		,;
					cImpSisColegio.rodape1			WITH xRodape1		,;
					cImpSisColegio.rodape2			WITH xRodape2		IN "cImpSisColegio"

		
		SELECT("cImpSisColegio")
		GO TOP IN "cImpSisColegio"
		
		xNOME_RPT = "rptMatriculasimples"				
		objVisRelatorio.carregar_configuracao()
		objVisRelatorio.cNomeReport = ALLTRIM(xNOME_RPT) + ".frx"
		objVisRelatorio.cOrigemReport = "\COOP\VFP\SISCOLEGIO\MATRICULA\"
		objVisRelatorio.cDirSaida = m.letraserver + "\COOP\ENVIAR\"
		objVisRelatorio.cNomeSaida = "MATRICULA_SIMPLES_" + DTOS(DATE())
		objVisRelatorio.cTipoArquivoSaida = "PDF"

		objVisRelatorio.set_email_assunto( "Relat�rio de Matr�culas " + " (" + TTOC(DATETIME()) + ")" )		
		
		&& APENAS EXECUTA O RELAT�RIO
		objVisRelatorio.gerar_arquivo()
		objVisRelatorio.executar_relatorio()				
	 	
	 	
*!*		 	IF FILE("c:\coop\enviar\Cooper_rptMatriculasimples.frx.pdf")
*!*			 	ERASE "c:\coop\enviar\Cooper_rptMatriculasimples.frx.pdf"
*!*			ELSE
*!*				ERASE "c:\coop\enviar\Cooper_rptMatriculasimples.pdf"
*!*			ENDIF 

*!*		 	IF FILE("c:\coop\enviar\Matriculasimples.PDF")
*!*			 	ERASE "c:\coop\enviar\Matriculasimples.PDF"
*!*			ENDIF 
*!*			
*!*			SELECT('cMatriculasimples')
*!*			SET DEVICE TO PRINTER
*!*			SET PRINTER TO NAME "PDFCreator"
*!*			REPORT FORM '\COOP\VFP\SISCOLEGIO\MATRICULA\rptMatriculasimples' TO PRINTER
*!*			INKEY(8)
*!*			IF FILE("c:\coop\enviar\Cooper_rptMatriculasimples.frx.pdf")
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptMatriculasimples.frx.pdf" TO "c:\coop\enviar\Matriculasimples.PDF"
*!*			ELSE
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptMatriculasimples.pdf" TO "c:\coop\enviar\Matriculasimples.PDF"				
*!*			ENDIF					

*!*			IF m.letraserver != "C:"
*!*				INKEY(4)				
*!*				IF FILE(m.letraserver + "\coop\enviar\Matriculasimples.PDF")
*!*					ERASE m.letraserver + "\coop\enviar\Matriculasimples.PDF"
*!*				ENDIF
*!*				COPY FILE "c:\coop\enviar\Matriculasimples.PDF" TO m.letraserver + "\coop\enviar\Matriculasimples.PDF"
*!*				INKEY(4)
*!*			ENDIF

	ELSE 
		WaitEnter("Dados n�o localizados!" )
	ENDIF 

	fechalivre('ALUNO','M_ALUNO')
	
*	SELECT * FROM CMATRICULASIMPLES INTO TABLE C:\COOP\CMATRICULASIMPLES.DBF
ENDFUNC
*********************************************************************************************
*****************************      			MENSALIDADE  				*********************
********************************************************************************************* 
FUNCTION RL_MEN01(pTurma, pMes, pAno, pLocal, pData)

	abre('AL01F1','SHARED','INDCODIGO','ALUNO') 
	abre('AL01F2','SHARED','INDMATRIC','M_ALUNO') 
	abre('AL01F3','SHARED','INDMACOD','V_ALUNO') 
	
	&& Defini��o da data // EU NAO CONSEGUI FAZER ISSO FUNCIONAR.. 
	&& SET DATE TO DMY 

	CREATE CURSOR cImpSisColegio(	cabec_titulo c(100)	,;
									cabec_rel c(100)	,;
									cabec_filtro c(100)	,;
									cabec_end1 c(100)	,;
									cabec_end2 c(100)	,;
									cabec_end3 c(100)	,;
									cabec_logo c(100)	,;
									rodape1 c(100)		,;
									rodape2 c(100)		,;
									tpfiltro c(1)		,;
									filtro c(140)		,;	
									numero		c(03)	,;
									nome		c(200)	,;
									codigo		c(10)	,;	
									data 		c(10)	,;
									valor		n(11,2)	,;
									MesAno		c(20)	,;
									titulo		c(50)	,;
									rs			c(02))
*!*							LOCAL 		c(20)
*!*							tipodata	c(20)
*!*							obs			c(40)
	xDiaPrim = 1	
	xDiaUlt= 0	
	xNum = 0		
	xDataIni = CTOD("")
	xDataFim = CTOD("")	
	xMesAno = ""
	xMes = ""
	xTitulo = ""
	xCodigo = ""
	xTotal = 0
	
	&&CRIO A PRIMEIRA E A ULTIMA DATA DO MES ESCOLHIDO.
	DO CASE 
		CASE pmes == 1 OR pmes == 3 OR pmes == 5 OR pmes == 7 OR pmes == 10 OR pmes == 12
			xdiaUlt = 31
		CASE pmes == 4 OR pmes == 6 OR pmes == 8 OR pmes == 9 OR pmes == 11
			xdiaUlt = 30
		CASE MOD(pano,4) == 0 
			IF pmes = 2
				xdiaUlt = 29
			ENDIF 
		CASE pmes== 2
			 xdiaUlt = 28
	ENDCASE   
	xDataIni = CTOD(STR(xdiaPrim, 2) + "/" + STR(pmes, 2) + "/" + STR(pano, 4)) 
	xDataFim = CTOD(STR(xdiaUlt, 2) + "/" + STR(pmes, 2) + "/" + STR(pano, 4))  

	xIndice = "INDPAGTO"
	xPesquisa = "V_ALUNO.pagamento >= xDataini and V_ALUNO.pagamento <= xDataFim "
	xData = "pagamento"
	xValor = "valorpago"
	xComplemento = ""
*!*		xTipodata="PAGAMENTO"
	&&SE A DATA DE VENCIMENTO FOR SELECIONADA.. O INDICE SERA INCVENCS E O CAMPO DA TABELA V_ALUNO SERA VENCIMENTO
	IF pData == 1
		xIndice = "INDVENCS"
		xPesquisa = "V_ALUNO.vencimento >= xDataini and V_ALUNO.vencimento <= xDataFim "
		xData = "vencimento"
		xValor = "valor"
		xComplemento = "_Venc"
*!*			xTipodata="VENCIMENTO"
	ENDIF
	
	&&SE O LOCAL SELECIONADO FOR "TODOS" A VARIAVEL LOCAL FICARA VAZIA
*!*		xLocal = ""
*!*		xLocalpagto="BANCO/CAIXA"
*!*		IF pLocal == 1
*!*			xLocal = "01"
*!*			xLocalpagto="BANCO"
*!*		ENDIF
*!*		IF pLocal == 2
*!*			xLocal = "02"
*!*			xLocalpagto="CAIXA"
*!*		ENDIF
	
	
	xTitulo_REL = ""
	xTitulo_REL="Relat�rio de Mensalidades"
	IF pLocal == 1 AND pData == 2
		xTitulo_REL="Relat�rio de Mensalidades realizadas no Banco"
	ENDIF
	
	&&xComplemento define a nome do aquivo que vai ser criado na pasta enviar...
	DO CASE 
	CASE pLocal == 1 AND pData == 2
		xComplemento = xComplemento + "_Banco"	
	CASE pLocal == 2 AND pData == 2
		xComplemento = xComplemento + "_Caixa"
	CASE pLocal == 3 AND pData == 2
		xComplemento = xComplemento + "_BancoCaixa"
	ENDCASE 
	
	SELECT("V_ALUNO")
	SET ORDER TO "&xIndice."

	&& POSICIONO O CURSOR NA DATA INICIAL... PELO INDICE ESCOLHIDO CONFORME AS OP��ES DA TELA(INDVECS OU INDPAGTO)
	SET NEAR ON
	=SEEK(DTOS(xDataIni), "V_ALUNO", "&xIndice.")

	DO WHILE &xPesquisa. and !EOF("V_ALUNO")
		&&PULO UM REGISTRO SE ELE ESTIVER MARCADO PARA DELE��O OU CODIGO = 'NOVO'
		IF DELETED('V_ALUNO') OR ALLTRIM(V_ALUNO.codigo) = 'NOVO' OR EMPTY(V_ALUNO.codigo)
			SKIP 1 IN 'V_ALUNO'
			LOOP 
		ENDIF 
		
		&&SE A VARIAVEL LOCAL ESTIVER VAZIA SIGNIFICA QUE FOI SELECIONADO A OP��O "TODOS"
*!*			IF !EMPTY(xLocal)
*!*				IF V_ALUNO.local != xLocal
*!*					SKIP 1 IN 'V_ALUNO'
*!*					LOOP 
*!*				ENDIF
*!*			ENDIF
		
		&& ----------------------------------------------------------------------------------------------
		&& Se o local escolhido for banco e caixa, eu adiciono na pesquisa os dois locais de pagamento
		&& se for por caixa ou por banco, eu pulo os registros pagos em locais diferentes!
		
		
		IF pData = 2
		&& Os valores na tabela estao 01 = Caixa , e 02 = Banco, e na tela esta ao contrario
			DO CASE 
				CASE pLocal == 1
					xLocal = '02'
				CASE pLocal == 2
					xlocal = '01'
			ENDCASE  
			
			IF pLocal != 3 
				IF xLocal != V_ALUNO.local
					SKIP 1 IN 'V_ALUNO'
					LOOP
				ENDIF 
			ENDIF 
		ENDIF 
		
		xAluno = ""
		IF SEEK(V_ALUNO.ano + V_ALUNO.codigo, 'ALUNO', 'INDCODIGO')
			xAluno = ALUNO.nome
		ENDIF	
		
		xMes = CTOD("01/"+ STR(pMes) + "/2009") && tem q coloca 2010
		xMesAno = ALLTRIM(mes(xMes))	+"/"+ ALLTRIM(STR(pAno))	
		xNum = xNum + 1 
		
		&& -- Linha de comando para tirar os zeros do codigo ----------
		&& Conto quantos zeros tem a esquerda
		xCont = 1
		xQtd = 0
		xZero = '0'
		 
		DO WHILE LEFT(V_ALUNO.codigo, xCont) = xZero
			xCont = xCont + 1
			xZero = xZero + '0'
		ENDDO 
		
		&& Subtraio um por que no la�o ele sempre ira contar um zero a mais, pois usei o xCont na fun��o left tambem
		&& entao ela nao podeia come�ar como zero.
		
		xCont = xCont -1
		&& 10 � a quantidade de caracteres q o campo codigo possui..
		xQtd = 10 - xCont
		xCodigo = RIGHT(V_ALUNO.codigo, xQtd)
		
		xObs = ""
		IF !EMPTY(V_ALUNO.obs)
			xObs = "/" + V_ALUNO.obs
		ENDIF 
		
		
		xTotal = xTotal + V_ALUNO.&xValor.  
		APPEND BLANK IN 'cImpSisColegio'
		REPLACE cImpSisColegio.numero 	WITH ALLTRIM(STR(xNum)) 	IN 'cImpSisColegio'
		REPLACE cImpSisColegio.nome		WITH ALLTRIM(xAluno)+" "+ xObs		IN 'cImpSisColegio'
		REPLACE cImpSisColegio.codigo	WITH xCodigo		 		IN 'cImpSisColegio'
		REPLACE cImpSisColegio.data		WITH DTOC(V_ALUNO.&xData.)	IN 'cImpSisColegio' && xData PODE SER VENCIMENTO OU PAGAMENTO
		REPLACE cImpSisColegio.valor 	WITH V_ALUNO.&xValor.		IN 'cImpSisColegio' && xValor PODE SER VALORPAGO OU VALOR
		&&REPLACE cMen.obs		WITH V_ALUNO.obs			IN 'cMen'
		REPLACE cImpSisColegio.MesAno	WITH xMesAno				IN 'cImpSisColegio'
		REPLACE cImpSisColegio.titulo	WITH xTitulo_REL			IN 'cImpSisColegio'
		REPLACE cImpSisColegio.rs		WITH "R$"					IN 'cImpSisColegio'
		
*!*			REPLACE cMen.local		WITH xLocalpagto			IN 'cMen'
*!*			REPLACE cMen.tipodata	WITH xTipodata				IN 'cMen' 	
		
		SKIP 1 IN "V_ALUNO"
	ENDDO 
	
*!*		APPEND BLANK IN 'cImpSisColegio'
*!*		REPLACE cImpSisColegio.data		WITH "	R$	"		 		IN 'cImpSisColegio'
*!*		REPLACE cImpSisColegio.nome		WITH "  TOTAL   "			IN 'cImpSisColegio'
*!*		REPLACE cImpSisColegio.valor 	WITH xTotal					IN 'cImpSisColegio'
	
	&& SE O CURSOR cMen CONTER INFORMA��O... SELECIONO A IMPRESSORA E IMPRIME O RELATORIO
	SELECT("cImpSisColegio")
	IF RECCOUNT('cImpSisColegio')!= 0
	 	
	 	
		xFILTRO = ""
		&& ROTINA PARA CARREGAR OS DADOS PADR�ES DO CABE�ALHO
		STORE SPACE(1) TO xTitulo, xEnd1, xEnd2, xEnd3, xLogo, xRodape1, xRodape2	
		SISCOLEGIO_CARREGAR_CABEC_REL( @xTitulo , @xEnd1, @xEnd2, @xEnd3 , @xLogo , @xRodape1, @xRodape2 )
		Replace ALL cImpSisColegio.cabec_titulo		WITH xTitulo		,;
					cImpSisColegio.cabec_end1		WITH xEnd1			,;
					cImpSisColegio.cabec_end2		WITH xEnd2			,;
					cImpSisColegio.cabec_end3		WITH xEnd3			,;
					cImpSisColegio.cabec_logo		WITH xLogo			,;
					cImpSisColegio.cabec_rel		WITH xTitulo_REL	,;
					cImpSisColegio.cabec_filtro		WITH xFILTRO		,;
					cImpSisColegio.filtro			WITH xFILTRO		,;
					cImpSisColegio.rodape1			WITH xRodape1		,;
					cImpSisColegio.rodape2			WITH xRodape2		IN "cImpSisColegio"

		
		SELECT("cImpSisColegio")
		GO TOP IN "cImpSisColegio"
		
		xNOME_RPT = "rptMensalidades"				
		objVisRelatorio.carregar_configuracao()
		objVisRelatorio.cNomeReport = ALLTRIM(xNOME_RPT) + ".frx"
		objVisRelatorio.cOrigemReport = "\COOP\VFP\SISCOLEGIO\MATRICULA\"
		objVisRelatorio.cDirSaida = m.letraserver + "\COOP\ENVIAR\"
		objVisRelatorio.cNomeSaida = "MATRICULA_FINANCEIRO_" + DTOS(DATE())
		objVisRelatorio.cTipoArquivoSaida = "PDF"

		objVisRelatorio.set_email_assunto( "Relat�rio de Matr�culas " + " (" + TTOC(DATETIME()) + ")" )		
		
		&& APENAS EXECUTA O RELAT�RIO
		objVisRelatorio.gerar_arquivo()
		objVisRelatorio.executar_relatorio()	 	
	 	
	 	
	 	
*!*		 	IF FILE("c:\coop\enviar\Cooper_rptMensalidades.frx.pdf")
*!*			 	ERASE "c:\coop\enviar\Cooper_rptMensalidades.frx.pdf"
*!*			ELSE
*!*				ERASE "c:\coop\enviar\Cooper_rptMensalidades.pdf"
*!*			ENDIF 

*!*		 	IF FILE("c:\coop\enviar\Mensalidades" + xComplemento + ".PDF")
*!*			 	ERASE "c:\coop\enviar\Mensalidades" + xComplemento + ".PDF"
*!*			ENDIF 
*!*			
*!*			SELECT('cMen')
*!*			SET DEVICE TO PRINTER
*!*			SET PRINTER TO NAME "PDFCreator"
*!*			REPORT FORM '\COOP\VFP\SISCOLEGIO\MATRICULA\rptMensalidades' TO PRINTER
*!*			INKEY(8)
*!*			IF FILE("c:\coop\enviar\Cooper_rptMensalidades.frx.pdf")
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptMensalidades.frx.pdf" TO "c:\coop\enviar\Mensalidades" + xComplemento + ".PDF"
*!*			ELSE
*!*				INKEY(8)
*!*				RENAME "c:\coop\enviar\Cooper_rptMensalidades.pdf" TO "c:\coop\enviar\Mensalidades" + xComplemento + ".PDF"				
*!*			ENDIF					

*!*			IF m.letraserver != "C:"
*!*				INKEY(4)				
*!*				IF FILE(m.letraserver + "\coop\enviar\Mensalidades" + xComplemento + ".PDF")
*!*					ERASE m.letraserver + "\coop\enviar\Mensalidades" + xComplemento + ".PDF"
*!*				ENDIF
*!*				COPY FILE "c:\coop\enviar\Mensalidades" + xComplemento + ".PDF" TO m.letraserver + "\coop\enviar\Mensalidades" + xComplemento + ".PDF"
*!*				INKEY(4)
*!*			ENDIF

	ELSE 
		WaitEnter("Dados n�o encontrados!")
	ENDIF 
	
	fechalivre( 'ALUNO'		)
	FechaLivre( 'M_ALUNO'	)
	FechaLivre( 'V_ALUNO'	)
	
ENDFUNC 
********************************************************************************************* 

********************************************************************************************* 
&& vers�o antiga
FUNCTION RL_MA02(pCodigo,pAno,pMatricula)		  	

	xSexo = ""	
	xPai = "" 
	xEmpp = "" 
	xFuncp = ""
	xMae = "" 
	xEmpm = "" 
	xFuncm = ""
	xArea = ""
	xQtdade = 0
	xFormadepagto = ""
	xVenc = ""
	xMes = 0
	xValor = 0
	xExtensivo = ""
	xCurso = ""
	
	abre('AL02F1','SHARED','INDCODIGO','CURSO')
	Informacao("Arquivo sendo impresso............. AGUARDE!")	
	
	CREATE CURSOR cAluno(	cabec_titulo c(100)	,;
							cabec_rel c(100)	,;
							cabec_filtro c(100)	,;
							cabec_end1 c(100)	,;
							cabec_end2 c(100)	,;
							cabec_end3 c(100)	,;
							cabec_logo c(100)	,;
							rodape1 c(100)		,;
							rodape2 c(100)		,;
							tpfiltro c(1)		,;
							filtro c(140)		,;
							codigo			c(10),;
							turma			c(04),;
							datama			d(08),;
							nome			c(80),;
							ano				c(04),;
							data			d(08),;
							identidade		c(30),;
							endereco		c(85),;
							bairro			c(30),;
							cidade			c(40),;
							estado			c(02),;
							cep				c(08),;
							ddd1			c(02),;
							telefone1		c(10),;
							ddd2			c(02),;
							telefone2		c(10),;
							sexo			c(09),;
							procedenci		c(30),;
							conclusao		c(60),;
							email			c(60),;
							nomep			c(80),;
							empresap		c(80),;
							irmao			c(60),;
							ddd4			c(02),;
							telefone4		c(10),;
							funcaop			c(80),;
							nomem			c(40),;
							empresam		c(30),;
							ddd5			c(02),;
							telefone5		c(10),;
							funcaom			c(30),;
							periodo			c(20),;
							curso			c(20),;
							area			c(20),;
							formadepagto	c(50),;
							parcela01 n(11,2),parcela02 n(11,2),parcela03 n(11,2),parcela04 n(11,2),parcela05 n(11,2),parcela06 n(11,2),;
							parcela07 n(11,2),parcela08 n(11,2),parcela09 n(11,2),parcela10 n(11,2),parcela11 n(11,2),parcela12 n(11,2),;
							parcela13 n(11,2),parcela14 n(11,2),parcela15 n(11,2),parcela16 n(11,2),parcela17 n(11,2),parcela18 n(11,2),; 
							dia 			n(02),;
							extensivo		c(40))

			SELECT ('ALUNO')
			GO TOP IN 'ALUNO'

			IF SEEK(pAno + pCodigo,'ALUNO','INDCODIGO')
				IF ALUNO.sexo == 1
					xSexo = "Masculino"
				ELSE 
					xSexo = "Feminino"
				ENDIF 
				
				IF !EMPTY(ALUNO.nomep)
					xResp = ALLTRIM(ALUNO.nomep) + " / " + ALLTRIM(ALUNO.nomem)
					xEmpR = ALLTRIM(ALUNO.empresap) + " / " + ALLTRIM(ALUNO.empresam)
					xFuncR = ALLTRIM(ALUNO.funcaop) + " / " + ALLTRIM(ALUNO.funcaom)
				ELSE
					xResp = ALLTRIM(ALUNO.nomem)
					xEmpR = ALLTRIM(ALUNO.empresam)
					xFuncR = ALLTRIM(ALUNO.funcaom)
				ENDIF 
				
				SELECT ("CURSO")
				SET ORDER TO ("INDCODIGO")
				IF SEEK(MATRICULA.curso,'CURSO','INDCODIGO')
					xCurso = CURSO.nome
				ENDIF 
				
				
				GO TOP IN 'MATRICULA'
				IF SEEK(pAno + pMatricula,'MATRICULA','INDMATRIC')
					xValor = TRANSFORM(MATRICULA.valor, "@R 999,999,999.99")
					DO CASE 
						CASE MATRICULA.area == 1
							xArea = "Biol�gicas"
						CASE MATRICULA.area == 2
							xArea = "Exatas"
						CASE MATRICULA.area == 3
							xArea = "Humanas"
						CASE MATRICULA.area == 4
							xArea = "ITA/Militares"
						CASE MATRICULA.area == 5
							xArea = "Arquitetura"
					ENDCASE 

					APPEND BLANK IN 'cAluno'
					REPLACE cAluno.codigo 		WITH RIGHT(MATRICULA.codigo, 4) 	IN 'cAluno'
					REPLACE cAluno.turma 		WITH MATRICULA.turma	IN 'cAluno' 			
					REPLACE cAluno.datama		WITH MATRICULA.datama	IN 'cAluno'
					REPLACE cAluno.nome			WITH PADR(ALLTRIM(ALUNO.nome), 80) IN 'cAluno'
					REPLACE cAluno.ano			WITH MATRICULA.ano		IN 'cAluno'
					REPLACE cAluno.data			WITH ALUNO.data			IN 'cAluno'
					REPLACE cAluno.identidade	WITH ALUNO.identidade	IN 'cAluno'			
					REPLACE cAluno.endereco		WITH ALLTRIM(ALUNO.endereco)+ "/"+ALLTRIM(ALUNO.numero)		IN 'cAluno'
					REPLACE cAluno.bairro		WITH ALUNO.bairro		IN 'cAluno'			
					REPLACE cAluno.cidade		WITH ALUNO.cidade		IN 'cAluno'
					REPLACE cAluno.estado		WITH ALUNO.estado		IN 'cAluno'
					REPLACE cAluno.cep			WITH ALUNO.cep			IN 'cAluno'
					REPLACE cAluno.ddd1			WITH ALUNO.ddd1			IN 'cAluno'
					REPLACE cAluno.telefone1	WITH ALUNO.telefone1	IN 'cAluno'
					REPLACE cAluno.ddd2			WITH ALUNO.ddd2			IN 'cAluno'
					REPLACE cAluno.telefone2	WITH ALUNO.telefone2	IN 'cAluno'
					REPLACE cAluno.sexo			WITH xSexo				IN 'cAluno'
					REPLACE cAluno.procedenci	WITH ALUNO.proced		IN 'cAluno'
					REPLACE cAluno.conclusao	WITH ALUNO.conclusao	IN 'cAluno'
					REPLACE cAluno.irmao		WITH ALUNO.irmao		IN 'cAluno'
					REPLACE cAluno.email		WITH ALUNO.email		IN 'cAluno'
					REPLACE cAluno.nomep		WITH xResp				IN 'cAluno'
					REPLACE cAluno.empresap		WITH xEmpR				IN 'cAluno'
					REPLACE cAluno.ddd4			WITH ALUNO.ddd4			IN 'cAluno'
					REPLACE cAluno.telefone4	WITH ALUNO.telefone4	IN 'cAluno'
					REPLACE cAluno.funcaop		WITH xFuncR				IN 'cAluno'
					REPLACE cAluno.ddd5			WITH ALUNO.ddd5			IN 'cAluno'
					REPLACE cAluno.telefone5	WITH ALUNO.telefone5	IN 'cAluno'
					REPLACE cAluno.periodo		WITH MATRICULA.periodo	IN 'cAluno'
					REPLACE cAluno.curso		WITH xCurso				IN 'cAluno'
					REPLACE cAluno.area			WITH xArea				IN 'cAluno'
					REPLACE cAluno.dia			WITH MATRICULA.dia		IN 'cAluno'
					
					SELECT ('VENCIMENTO')
					GO TOP IN 'VENCIMENTO'
					
					IF SEEK(pAno + pMatricula + Pcodigo,'VENCIMENTO','INDMACOD')
						xData = VENCIMENTO.vencimento 
						DO WHILE !EOF('VENCIMENTO') AND VENCIMENTO.ano + VENCIMENTO.matricula + VENCIMENTO.codigo = ;
							pAno + pMatricula + pCodigo
							
							xQtdade = xQtdade + 1
							
							SKIP 1 IN 'VENCIMENTO'	
						ENDDO 
						
						xExtensivo = "Extensivo Diurno " + ALLTRIM(STR(YEAR(DATE())) )
						xFormadepagto = ALLTRIM(STR(xQtdade)) + "x de R$ " + ALLTRIM(xValor)  

						SELECT("cAluno")
						REPLACE cAluno.formadepagto	WITH xFormadepagto		IN 'cAluno'
						REPLACE cAluno.extensivo	WITH xExtensivo			IN 'cAluno'
						
*!*							APPEND BLANK IN 'cAluno'
*!*							REPLACE cAluno.codigo 		WITH RIGHT(MATRICULA.codigo, 4) 	IN 'cAluno'
*!*							REPLACE cAluno.turma 		WITH MATRICULA.turma	IN 'cAluno' 			
*!*							REPLACE cAluno.datama		WITH MATRICULA.datama	IN 'cAluno'
*!*							REPLACE cAluno.nome			WITH PADR(ALLTRIM(ALUNO.nome), 80) IN 'cAluno'
*!*							REPLACE cAluno.ano			WITH MATRICULA.ano		IN 'cAluno'
*!*							REPLACE cAluno.data			WITH ALUNO.data			IN 'cAluno'
*!*							REPLACE cAluno.identidade	WITH ALUNO.identidade	IN 'cAluno'			
*!*							REPLACE cAluno.endereco		WITH ALLTRIM(ALUNO.endereco)+ "/"+ALLTRIM(ALUNO.numero)		IN 'cAluno'
*!*							REPLACE cAluno.bairro		WITH ALUNO.bairro		IN 'cAluno'			
*!*							REPLACE cAluno.cidade		WITH ALUNO.cidade		IN 'cAluno'
*!*							REPLACE cAluno.estado		WITH ALUNO.estado		IN 'cAluno'
*!*							REPLACE cAluno.cep			WITH ALUNO.cep			IN 'cAluno'
*!*							REPLACE cAluno.ddd1			WITH ALUNO.ddd1			IN 'cAluno'
*!*							REPLACE cAluno.telefone1	WITH ALUNO.telefone1	IN 'cAluno'
*!*							REPLACE cAluno.ddd2			WITH ALUNO.ddd2			IN 'cAluno'
*!*							REPLACE cAluno.telefone2	WITH ALUNO.telefone2	IN 'cAluno'
*!*							REPLACE cAluno.sexo			WITH xSexo				IN 'cAluno'
*!*							REPLACE cAluno.procedenci	WITH ALUNO.proced		IN 'cAluno'
*!*							REPLACE cAluno.conclusao	WITH ALUNO.conclusao	IN 'cAluno'
*!*							REPLACE cAluno.irmao		WITH ALUNO.irmao		IN 'cAluno'
*!*							REPLACE cAluno.email		WITH ALUNO.email		IN 'cAluno'
*!*							REPLACE cAluno.nomep		WITH xResp				IN 'cAluno'
*!*							REPLACE cAluno.empresap		WITH xEmpR				IN 'cAluno'
*!*							REPLACE cAluno.ddd4			WITH ALUNO.ddd4			IN 'cAluno'
*!*							REPLACE cAluno.telefone4	WITH ALUNO.telefone4	IN 'cAluno'
*!*							REPLACE cAluno.funcaop		WITH xFuncR				IN 'cAluno'
*!*							REPLACE cAluno.ddd5			WITH ALUNO.ddd5			IN 'cAluno'
*!*							REPLACE cAluno.telefone5	WITH ALUNO.telefone5	IN 'cAluno'
*!*							REPLACE cAluno.periodo		WITH MATRICULA.periodo	IN 'cAluno'
*!*							REPLACE cAluno.curso		WITH xCurso				IN 'cAluno'
*!*							REPLACE cAluno.area			WITH xArea				IN 'cAluno'
*!*							REPLACE cAluno.formadepagto	WITH xFormadepagto		IN 'cAluno'
*!*							REPLACE cAluno.dia			WITH MATRICULA.dia		IN 'cAluno'
*!*							REPLACE cAluno.extensivo	WITH xExtensivo			IN 'cAluno'
						
						 	
						GO TOP IN 'VENCIMENTO'
						SET NEAR ON 
						=SEEK(pAno + pMatricula + pCodigo,'VENCIMENTO','INDMACOD')
						xvenc = MONTH(VENCIMENTO.vencimento)
						DO WHILE !EOF('VENCIMENTO') AND VENCIMENTO.ano + VENCIMENTO.matricula + VENCIMENTO.codigo = pAno + pMatricula + pCodigo
							DO CASE 
												
								CASE MONTH(VENCIMENTO.vencimento) == 11 AND YEAR(VENCIMENTO.vencimento) == (VAL(MATRICULA.ano) - 1)
									xvenc = '01'
								CASE MONTH(VENCIMENTO.vencimento) == 12 AND YEAR(VENCIMENTO.vencimento) == (VAL(MATRICULA.ano) - 1)
									xvenc = '02'
								&& -----------------------------------	
								**CASE MONTH(VENCIMENTO.vencimento) == 11 AND YEAR(VENCIMENTO.vencimento) == VAL(MATRICULA.ano)
									**xvenc = '01'
								**CASE MONTH(VENCIMENTO.vencimento) == 12 AND YEAR(VENCIMENTO.vencimento) == VAL(MATRICULA.ano)
									**xvenc = '02'		
								&& -----------------------------------	
								CASE (MONTH(VENCIMENTO.vencimento) == 01 OR MONTH(VENCIMENTO.vencimento) == 02;
									  OR MONTH(VENCIMENTO.vencimento) == 03 OR MONTH(VENCIMENTO.vencimento) == 04) AND YEAR(VENCIMENTO.vencimento) == (VAL(MATRICULA.ano) + 1)
									xvenc = STRzero(MONTH(VENCIMENTO.vencimento) + 14, 2)
								OTHERWISE
									xvenc = STRzero(MONTH(VENCIMENTO.vencimento) + 2, 2)
							ENDCASE
*!*								xvenc = VENCIMENTO.parcelas
*!*								xMes = LEFT( mes(VENCIMENTO.vencimento),3 ) 
*!*								REPLACE cAluno.mes&xvenc.		WITH xMes	,;
									cAluno.parcela&xvenc.	WITH VENCIMENTO.valor	IN "cAluno"
							REPLACE cAluno.parcela&xvenc.	WITH VENCIMENTO.valor	IN "cAluno"
							
							SKIP 1 IN 'VENCIMENTO'
						ENDDO  
						
					ENDIF 
				ENDIF 
			ENDIF 
			Informacao("Arquivo sendo impresso............. AGUARDE!")	
			IF RECCOUNT('cAluno')!= 0
				xFILTRO = ""	
				&& ROTINA PARA CARREGAR OS DADOS PADR�ES DO CABE�ALHO
				STORE SPACE(1) TO xTitulo, xEnd1, xEnd2, xEnd3, xLogo, xRodape1, xRodape2	
				SISCOLEGIO_CARREGAR_CABEC_REL( @xTitulo , @xEnd1, @xEnd2, @xEnd3 , @xLogo , @xRodape1, @xRodape2 )
				Replace ALL cAluno.cabec_titulo		WITH xTitulo		,;
							cAluno.cabec_end1		WITH xEnd1			,;
							cAluno.cabec_end2		WITH xEnd2			,;
							cAluno.cabec_end3		WITH xEnd3			,;
							cAluno.cabec_logo		WITH xLogo			,;
							cAluno.cabec_rel		WITH ""				,;
							cAluno.cabec_filtro		WITH "" 			,;
							cAluno.filtro			WITH xFILTRO		,;
							cAluno.rodape1			WITH xRodape1		,;
							cAluno.rodape2			WITH xRodape2		IN "cAluno"
				
				xNome = ALLTRIM(cAluno.nome)
				xNOME = STRTRAN( xNOME , " " , "_" )
				
				
				SELECT("cAluno")
				xNOME_RPT = "rptAluno"				
				objVisRelatorio.carregar_configuracao()
				objVisRelatorio.cNomeReport = ALLTRIM(xNOME_RPT) + ".frx"
				objVisRelatorio.cOrigemReport = "\COOP\VFP\SISCOLEGIO\MATRICULA\"
				objVisRelatorio.cDirSaida = m.letraserver + "\COOP\ENVIAR\"
				objVisRelatorio.cNomeSaida = "ALUNO_" + xNOME
				objVisRelatorio.cTipoArquivoSaida = "PDF"

				objVisRelatorio.set_email_assunto( "Matr�cula aluno " + cAluno.nome + " (" + TTOC(DATETIME()) + ")" )		
				
				&& APENAS EXECUTA O RELAT�RIO
				objVisRelatorio.gerar_arquivo()
				objVisRelatorio.executar_relatorio()				
									
	
*!*					xNome = ALLTRIM(cAluno.nome)
*!*				 	IF FILE("c:\coop\enviar\Cooper_rptAluno.frx.pdf")
*!*					 	ERASE "c:\coop\enviar\Cooper_rptAluno.frx.pdf"
*!*					ELSE
*!*						ERASE "c:\coop\enviar\Cooper_rptAluno.pdf"
*!*					ENDIF 

*!*				 	IF FILE("c:\coop\enviar\" + "ALUNO_" + xNome + ".PDF")
*!*					 	ERASE "c:\coop\enviar\" + "ALUNO_" + xNome + ".PDF"
*!*					ENDIF 
*!*					Informacao("Arquivo sendo impresso............. AGUARDE!")	
*!*					SELECT('cAluno')
*!*					SET DEVICE TO PRINTER
*!*					SET PRINTER TO NAME "PDFCreator"
*!*					REPORT FORM '\COOP\VFP\SISCOLEGIO\MATRICULA\rptAluno' TO PRINTER
*!*					INKEY(8)
*!*					IF FILE("c:\coop\enviar\Cooper_rptAluno.frx.pdf")
*!*						INKEY(8)
*!*						RENAME "c:\coop\enviar\Cooper_rptAluno.frx.pdf" TO "c:\coop\enviar\" + "ALUNO_" + xNome + ".PDF"
*!*					ELSE
*!*						INKEY(8)
*!*						RENAME "c:\coop\enviar\Cooper_rptAluno.pdf" TO "c:\coop\enviar\" + "ALUNO_" + xNome + ".PDF"				
*!*					ENDIF					
*!*					Informacao("Arquivo sendo impresso............. AGUARDE!")	
*!*					IF m.letraserver != "C:"
*!*						INKEY(4)				
*!*						IF FILE(m.letraserver + "\coop\enviar\" + "ALUNO_" + xNome + ".PDF")
*!*							ERASE m.letraserver + "\coop\enviar\" + "ALUNO_" + xNome + ".PDF"
*!*						ENDIF
*!*						COPY FILE "c:\coop\enviar\" + "ALUNO_" + xNome + ".PDF" TO m.letraserver + "\coop\enviar\" + "ALUNO_" + xNome + ".PDF"
*!*						INKEY(4)
*!*					ENDIF
				WaitEnter("Arquivo criado na pasta Enviar!")
			ELSE 
				WaitEnter("N�o h� dados disponiveis!")
			ENDIF
			fechalivre("CURSO") 
ENDFUNC 
********************************************************************************
** ETIQUETAS
********************************************************************************
FUNCTION RL_ET01(pLinha,pColuna)

	ImpEscolha = ""
    ImpEscolha = GetPrinter()

     IF EMPTY( ImpEscolha )
	    WaitEnter("Aten��o! Nenhuma impressora definida para impress�o..." )
	    RETURN -1
	 ENDIF 

     SET DEVICE TO PRINTER 
     SET PRINTER TO NAME "&ImpEscolha."

	CREATE CURSOR cEtiqueta(	nome1		c(50),;
								endereco1	c(50),;
								cidade1		c(50),;
								cep1		c(14),;
								bairro1		c(30),;
								nome2		c(50),;
								endereco2	c(50),;
								cidade2		c(50),;
								cep2		c(14),;
								bairro2		c(30),;
								nome3		c(50),;
								endereco3	c(50),;
								cidade3		c(50),;
								cep3		c(14),;
								bairro3		c(30))
	
	xLinha = pLinha - 1
	FOR xcont = 1 TO xLinha
		APPEND BLANK IN 'cEtiqueta'
	NEXT	
	
	GO TOP IN 'cAluno'
	DO WHILE !EOF('cAluno')
	
		IF cAluno.ativo == 0 
			SKIP 1 IN "cAluno"
			LOOP
		ENDIF
	
		APPEND BLANK IN 'cEtiqueta'
		IF pColuna == 1 AND !EOF('cAluno')
			REPLACE cEtiqueta.nome1 	WITH cAluno.nome 		IN 'cEtiqueta'
			REPLACE cEtiqueta.endereco1	WITH ALLTRIM(cAluno.endereco) + "," + cAluno.numero	IN 'cEtiqueta'
			REPLACE cEtiqueta.cidade1	WITH ALLTRIM(cAluno.cidade) + "/" + cAluno.estado 		IN 'cEtiqueta'
			REPLACE cEtiqueta.cep1		WITH cAluno.cep			IN 'cEtiqueta'
			REPLACE cEtiqueta.bairro1	WITH cAluno.bairro		IN 'cEtiqueta'
			SKIP 1 IN 'cAluno'
			pColuna = 2
		ELSE 
			REPLACE cEtiqueta.nome1 	WITH  	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.endereco1	WITH 	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.cidade1	WITH  	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.cep1		WITH 	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.bairro1	WITH 	""	IN 'cEtiqueta'
		ENDIF 

		IF pColuna == 2 AND !EOF('cAluno')
			REPLACE cEtiqueta.nome2 	WITH cAluno.nome 		IN 'cEtiqueta'
			REPLACE cEtiqueta.endereco2	WITH ALLTRIM(cAluno.endereco)+ ","+cAluno.numero	IN 'cEtiqueta'
			REPLACE cEtiqueta.cidade2	WITH ALLTRIM(cAluno.cidade) + "/" + cAluno.estado 		IN 'cEtiqueta'
			REPLACE cEtiqueta.cep2		WITH cAluno.cep			IN 'cEtiqueta'
			REPLACE cEtiqueta.bairro2	WITH cAluno.bairro		IN 'cEtiqueta'
			SKIP 1 IN 'cAluno'
			pColuna = 3
		ELSE 
			REPLACE cEtiqueta.nome2 	WITH  	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.endereco2	WITH 	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.cidade2	WITH  	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.cep2		WITH 	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.bairro2	WITH 	""	IN 'cEtiqueta'
		ENDIF 
		
		IF pColuna == 3 AND !EOF('cAluno')
			REPLACE cEtiqueta.nome3 	WITH cAluno.nome 		IN 'cEtiqueta'
			REPLACE cEtiqueta.endereco3	WITH ALLTRIM(cAluno.endereco)+ ","+cAluno.numero	IN 'cEtiqueta'
			REPLACE cEtiqueta.cidade3	WITH ALLTRIM(cAluno.cidade) + "/" + cAluno.estado 		IN 'cEtiqueta'
			REPLACE cEtiqueta.cep3		WITH cAluno.cep			IN 'cEtiqueta'
			REPLACE cEtiqueta.bairro3	WITH cAluno.bairro		IN 'cEtiqueta'
			SKIP 1 IN 'cAluno'
			pColuna = 1
		ELSE 
			REPLACE cEtiqueta.nome3 	WITH  	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.endereco3	WITH 	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.cidade3	WITH  	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.cep3		WITH 	""	IN 'cEtiqueta'
			REPLACE cEtiqueta.bairro3	WITH 	""	IN 'cEtiqueta'
		ENDIF 
	ENDDO 
	REPORT FORM '\COOP\VFP\SISCOLEGIO\MATRICULA\rptEtiquetas' TO PRINTER PREVIEW 

ENDFUNC 
