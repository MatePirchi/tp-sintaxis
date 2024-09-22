%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

    void yyerror(char *s);
    int yylex();
    
    char buffer[50];
    int yylexerrs;
%}
letra [a-zA-Z]
digito [0-9]
ID {letra}({letra}|{digito})*
constEntera {digito}({digito})* 
%option noyywrap
%%
"inicio" {return INICIO;}
"fin" {return FIN;}
"leer" {return LEER;}
"escribir" {return ESCRIBIR;}
{ID} {return ID;}
{constEntera} {return CONSTANTE;}
":=" {return ASIGNACION;}
"+" {return SUMA;}
"-" {return RESTA;}
";" {return PUNTOYCOMA;}
"," {return COMA;}
")" {return PARENDERERCHO;}
"(" {return PARENIZQUIERDO;}
[ \t\n]                 ;
.                       {yylexerrs++; sprintf(buffer,"Error Lexico: %s es un caracter invalido", yytext); yyerror(buffer);}

%%
