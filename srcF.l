%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "y.tab.h"
%}
ID [a-zA-Z][a-zA-Z0-9]*
%option noyywrap
%%
"inicio" {return INICIO;}
"fin" {return FIN;}
"leer" {return LEER;}
"escribir" {return ESCRIBIR;}
{ID} {return ID;}
[0-9][0-9]* {return CONSTANTE;}
":=" {return ASIGNACION;}
"+" {return SUMA;}
"-" {return RESTA;}
";" {return PUNTOYCOMA;}
"," {return COMA;}
")" {return PARENDERERCHO;}
"(" {return PARENIZQUIERDO;}
"-1" {return FDT;}
%%
int main(){
    yylex();
    return 0;
}