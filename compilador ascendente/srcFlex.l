%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"

    void yyerror(char *s);
    int yylex();
    
    char buffer[128];
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
{ID} {yylval.cadena = strdup(yytext); return ID;}
{constEntera} {yylval.num = atoi(yytext); return CONSTANTE;}
":=" {return ASIGNACION;}
"+" {return SUMA;}
"-" {return RESTA;}
"*" {return MULTIPLICACION;}
";" {return PUNTOYCOMA;}
"," {return COMA;}
")" {return PARENDERERCHO;}
"(" {return PARENIZQUIERDO;}
[ \t\n]                 ;
.                       {yylexerrs++; sprintf(buffer,"Error Lexico: %s es un caracter invalido", yytext); yyerror(buffer);}

%%