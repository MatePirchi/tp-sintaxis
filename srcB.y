
%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
int variable=0;
%}

%union{
    char* cadena;
    int num;
}
%token INICIO FIN LEER ESCRIBIR ASIGNACION PUNTOYCOMA COMA SUMA RESTA PARENDERERCHO PARENIZQUIERDO FDT
%token <cadena> ID
%token <num> CONSTANTE

%%
objetivo: programa FDT
;

programa: INICIO listaSentencia FIN
;

operadorAditivo: SUMA
|RESTA
;

listaSentencia: listaSentencia sentencia
|sentencia {printf("lista de sentencias identificada\n");}
;

sentencia: ID {printf("sentencia con id %s identificada", yytext);} ASIGNACION expresion PUNTOYCOMA 
|LEER PARENIZQUIERDO listaIdentificadores PARENDERERCHO PUNTOYCOMA {printf("sentencia con LEER identificada");}
|ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERERCHO PUNTOYCOMA {printf("sentencia con ESCRIBIR identificada");}
;

listaIdentificadores: listaIdentificadores COMA ID
|ID {printf("lista de identificadores identificada\n");}
;

listaExpresiones: listaExpresiones COMA expresion
|expresion {printf("lista de expresiones identificada\n");}
;

expresion:primaria
|expresion operadorAditivo primaria
;

primaria: ID
|CONSTANTE
|PARENIZQUIERDO expresion PARENDERERCHO
;

%%
int main(){
    yyparse();
    return 0;
}
void yyerror(char *S){
    printf("errorazo");
}
int yywrap(){
    return 1;
}