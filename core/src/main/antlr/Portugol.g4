grammar Portugol;

import PortugolLexico;

arquivo 
    :   INICIOALGORITMO
        inclusaoBiblioteca* (declaracaoFuncao | listaDeclaracoes)* 
        FIMALGORITMO ;

inclusaoBiblioteca
    : INCLUA BIBLIOTECA ID (OP_ALIAS_BIBLIOTECA ID)?;

listaDeclaracoes
    :  CONSTANTE? declaracao (VIRGULA declaracao)* TIPO;

declaracao
    :   declaracaoVariavel | declaracaoArray | declaracaoMatriz ;

declaracaoVariavel
    : ID (OP_ATRIBUICAO expressao)? TIPO ;

declaracaoMatriz
    : ID ABRE_COLCHETES linhaMatriz? FECHA_COLCHETES ABRE_COLCHETES colunaMatriz? FECHA_COLCHETES TIPO (OP_ATRIBUICAO inicializacaoMatriz)? ;

inicializacaoMatriz
    :  ABRE_CHAVES inicializacaoArray (VIRGULA inicializacaoArray)* FECHA_CHAVES;  

linhaMatriz
    :   tamanhoArray ;

colunaMatriz
    :   tamanhoArray ;

declaracaoArray
    :   ID ABRE_COLCHETES tamanhoArray? FECHA_COLCHETES TIPO (OP_ATRIBUICAO inicializacaoArray)? ;

inicializacaoArray
    :   ABRE_CHAVES listaExpressoes? FECHA_CHAVES ;

tamanhoArray 
    :   expressao; // aceita inteiro ou variável como tamanho do array, o semântico verifica se a variável é constante

declaracaoFuncao
    :   FUNCAO TIPO? ID parametroFuncao ABRE_CHAVES comando* FECHA_CHAVES ; 

parametroFuncao
	:	ABRE_PARENTESES listaParametros? FECHA_PARENTESES ;
listaParametros
    :   parametro (VIRGULA parametro)* ;

parametro
    :   TIPO E_COMERCIAL? ID (parametroArray | parametroMatriz)? ;

parametroArray
    :   ABRE_COLCHETES FECHA_COLCHETES ;

parametroMatriz
    :   ABRE_COLCHETES FECHA_COLCHETES ABRE_COLCHETES FECHA_COLCHETES ;

comando
    :   listaDeclaracoes   
    |   se
    |   enquanto
    |   facaEnquanto
    |   para
    |   escolha
    |   retorne 
    |   pare
    |   atribuicao     
    |   atribuicaoComposta
    |   expressao                      // chamada de função
    ;

atribuicao
    :   expressao OP_ATRIBUICAO expressao ;

atribuicaoComposta
    :   expressao OP_MAIS_IGUAL expressao           #atribuicaoCompostaSoma
    |   expressao OP_MENOS_IGUAL expressao          #atribuicaoCompostaSubtracao
    |   expressao OP_MULTIPLICACAO_IGUAL expressao  #atribuicaoCompostaMultiplicacao
    |   expressao OP_DIVISAO_IGUAL expressao        #atribuicaoCompostaDivisao 
    ;
  

se
    :   SE  expressao  listaComandos FIMSE (senao)? ;
	
senao
	:	SENAO listaComandos ;

enquanto
    :   ENQUANTO  expressao  listaComandos FIMENQUANTO ; 

para
    :   PARA  inicializacaoPara? ATE condicao listaComandos FIMPARA ;

listaComandos
    : ( comando* | comando); // 1 comando ou um bloco de comandos entre chaves, possivelmente vazio

inicializacaoPara
    :   atribuicao                      // quando a variável é declarada fora do loop e apenas inicializada dentro dele
    |   listaDeclaracoes              
    |   ID
; 

condicao
    :   expressao ;

incrementoPara  // TODO essa estrutura se repete na lista de expressões
    :   expressao | atribuicaoComposta | atribuicao;

escolha
    :   ESCOLHA expressao  caso* FACA FIMESCOLHA ;   

caso
    :   CASO (CONTRARIO | expressao)  (comando* | comando*) pare?;

pare
    : PARE ;

indiceArray
    :   ABRE_COLCHETES expressao FECHA_COLCHETES ;

expressao
    :
        escopoBiblioteca? ID  ABRE_PARENTESES listaExpressoes? FECHA_PARENTESES                 #chamadaFuncao    // chamadas de função como f(), f(x), f(1,2) ou Graficos.carregar(...)
    |   escopoBiblioteca? ID indiceArray                                                        #referenciaArray  // array como a[i]
    |   escopoBiblioteca? ID indiceArray indiceArray?                                           #referenciaMatriz // a[i][j]
    |   OP_SUBTRACAO expressao                                                                  #menosUnario
    |   OP_ADICAO expressao                                                                     #maisUnario
    |   OP_NAO expressao                                                                        #negacao
    |   OP_NOT_BITWISE expressao                                                                #negacaoBitwise
    |   ID (indiceArray indiceArray?)? OP_INCREMENTO_UNARIO                                     #incrementoUnarioPosfixado // x++
    |   ID (indiceArray indiceArray?)? OP_DECREMENTO_UNARIO                                     #decrementoUnarioPosfixado // x--    
    |   OP_INCREMENTO_UNARIO ID (indiceArray indiceArray?)?                                     #incrementoUnarioPrefixado // ++x
    |   OP_DECREMENTO_UNARIO ID (indiceArray indiceArray?)?                                     #decrementoUnarioPrefixado // --x
    |   expressao OP_MULTIPLICACAO expressao                                                    #multiplicacao
    |   expressao OP_DIVISAO expressao                                                          #divisao
    |   expressao OP_MOD expressao                                                              #modulo
    |   expressao OP_ADICAO expressao                                                           #adicao
    |   expressao OP_SUBTRACAO expressao                                                        #subtracao
    |   expressao OP_IGUALDADE expressao                                                        #operacaoIgualdade               // equality comparison (lowest priority op)
    |   expressao OP_DIFERENCA expressao                                                        #operacaoDiferenca  // equality comparison (lowest priority op)
    |   expressao OP_MAIOR expressao                                                            #operacaoMaior
    |   expressao OP_MENOR expressao                                                            #operacaoMenor
    |   expressao OP_MENOR_IGUAL expressao                                                      #operacaoMenorIgual
    |   expressao OP_MAIOR_IGUAL expressao                                                      #operacaoMaiorIgual
    |   expressao OP_E_LOGICO expressao                                                         #operacaoELogico
    |   expressao OP_OU_LOGICO expressao                                                        #operacaoOuLogico
    |   expressao OP_XOR expressao                                                              #operacaoXor
    |   expressao OP_SHIFT_LEFT expressao                                                       #operacaoShiftLeft
    |   expressao OP_SHIFT_RIGHT expressao                                                      #operacaoShiftRight
    |   expressao E_COMERCIAL expressao                                                         #operacaoAndBitwise
    |   expressao OP_OU_BITWISE expressao                                                       #operacaoOrBitwise
    |   escopoBiblioteca? ID                                                                    #referenciaParaVariavel           // referência para variável
    |   (INTEIRO | HEXADECIMAL)                                                                     #numeroInteiro 
    |   REAL                                                                                    #numeroReal  
    |   LOGICO                                                                                  #valorLogico
    |   CARACTER                                                                                #caracter
    |   
    LITERAL                                                                                  #string   
    
    ;

listaExpressoes
    :   (expressao | atribuicaoComposta | atribuicao) (VIRGULA (expressao | atribuicaoComposta | atribuicao))* ; 
     
escopoBiblioteca
    :   (ID PONTO) ; 