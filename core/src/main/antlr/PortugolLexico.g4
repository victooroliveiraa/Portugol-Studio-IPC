lexer grammar PortugolLexico;

// Tipos de dado
TIPO:           'real' | 'inteiro' | 'logico' | 'literal' ;  

// Palavras reservadas
FACA:           'faca' ;
ENQUANTO:       'enquanto' ;
FIMENQUANTO:    'fim-enquanto';
PARA:           'para' ;
FIMPARA         'fim-para';
ATE:            'ate';
SE:             'se' ;
ENTAO:          'entao';
FIMSE:          'fim-se';
SENAO:          'senao' ;
ESCOLHA:        'escolha' ;
FIMESCOLHA:     'fim-escolha';
CASO:           'caso' ;
REPITA:         'repita';
FIMREPITA:      'fim-repita';
INICIOALGORITMO:'algoritmo';
FIMALGORITMO    'fim-algoritmo';
DECLARE         'declare';
ESCREVA         'escreva';
LEIA            'leia';


OP_NAO:                 'nao' ;
OP_E_LOGICO:            'e' ;
OP_OU_LOGICO:           'ou' ;
OP_SUBTRACAO:           '-' ;
OP_ADICAO:              '+' ;
OP_MULTIPLICACAO:       '*' ;
OP_DIVISAO:             '/' ;
OP_MOD:                 'mod' ;
OP_ATRIBUICAO:          '<-' ;
OP_IGUALDADE:           '=' ;
OP_DIFERENCA:           '<>' ;
OP_MAIOR:               '>' ;
OP_MENOR:               '<' ;
OP_MENOR_IGUAL:         '<=' ;
OP_MAIOR_IGUAL:         '>=' ;
OP_MAIS_IGUAL:          '+=' ;
OP_MENOS_IGUAL:         '-=' ;
OP_MULTIPLICACAO_IGUAL: '*=' ;
OP_DIVISAO_IGUAL:       '/=' ;

LOGICO: VERDADEIRO | FALSO ;

VERDADEIRO:    'verdadeiro' ;
FALSO:         'falso' ;


fragment SEQ_ESC:       '\\' [btnrf"\\]   |   ESC_UNICODE  |   ESC_OCTAL   ;

fragment ESC_OCTAL:	'\\' ('0'..'3') ('0'..'7') ('0'..'7')  |   '\\' ('0'..'7') ('0'..'7')    |   '\\' ('0'..'7')    ;

fragment ESC_UNICODE:	'\\' 'u' DIGIT_HEX DIGIT_HEX DIGIT_HEX DIGIT_HEX  ;

fragment ESC_CARACTER:  SEQ_ESC | '\\\'' ;

fragment DIGIT_HEX: ('0'..'9'|'a'..'f'|'A'..'F') ;

LITERAL : '"' ( SEQ_ESC | . )*? '"' ;

ID:             (LETRA | '_') (LETRA | [0-9] | '_')* ;

fragment LETRA: [a-zA-Z] ;

REAL:   DIGITO+ '.' DIGITO* 
        | '.' DIGITO+          
        ;

fragment DIGITO: [0-9] ; 

INTEIRO:    DIGITO+ { 
    try {
        Integer.parseInt(getText());
    }
    catch(NumberFormatException e) {
        LexerNoViableAltException ex = new LexerNoViableAltException(this, _input, actionIndex, null);
        ex.initCause(e);
	throw ex;
    }
};

HEXADECIMAL: '0'[xX] SIMBOLO_HEXADECIMAL (SIMBOLO_HEXADECIMAL (SIMBOLO_HEXADECIMAL (SIMBOLO_HEXADECIMAL (SIMBOLO_HEXADECIMAL (SIMBOLO_HEXADECIMAL)?)?)?)?)?; // 3 ou 6 símbolos

fragment SIMBOLO_HEXADECIMAL:   DIGITO | [A-Fa-f] ;

COMENTARIO:         '/*' .*? '*/' -> channel(HIDDEN) ;
//COMENTARIO_SIMPLES: '//' .*? $ -> channel(HIDDEN) ; // acho que o ideal seria mandar os comentários para outro canal como no livro no Antlr4
COMENTARIO_SIMPLES: '//' .*? ('\n' | EOF) -> channel(HIDDEN) ; // acho que o ideal seria mandar os comentários para outro canal como no livro no Antlr4

WS      : [ \t\r\n]+ -> channel(HIDDEN);

PONTO : '.';

VIRGULA : ',';

PONTOVIRGULA : ';';

DOISPONTOS : ':';