
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
int variable=0;
extern int yynerrs;
extern int yylexerrs;
extern FILE* yyin;
%}

%union{
    char* cadena;
    int num;
}
%token INICIO FIN LEER ESCRIBIR ASIGNACION PUNTOYCOMA COMA SUMA RESTA PARENDERERCHO PARENIZQUIERDO
%token <cadena> ID
%token <num> CONSTANTE

%%
objetivo: programa 
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

////// MAIN //////
int main(int argc, char** argv) {
    
    // Argumentos
    if (argc > 2){
        printf("Numero incorrecto de argumentos.");
        return EXIT_FAILURE;
    }
    else if (argc == 2) {
        char filename[50];                  // Nombre del archivo
        sprintf(filename, "%s", argv[1]);   // El 2do argumento
        int largo = strlen(filename);       // Largo del nombre del archivo

        // Si no termina en .m dar error
        if (argv[1][largo-1] != 'm' || argv[1][largo-2] != '.'){
            printf("Extension incorrecta (debe ser .m)");
            return EXIT_FAILURE;
        }

        yyin = fopen(filename, "r");
    }
    else
        yyin = stdin;

    //init_TS(); // Inicializa la tabla con todo en -1

    // Parser
    switch (yyparse()){
        case 0: printf("\n\nProceso de compilacion termino exitosamente");
        break;
        case 1: printf("\n\nErrores de compilacion");
        break;
        case 2: printf("\n\nNo hay memoria suficiente");
        break;
    }
    printf("\n\nErrores sintacticos: %i\tErrores lexicos: %i\n", yynerrs, yylexerrs);

    return 0;
}
void yyerror(char *s){
    printf ("%s\n", s);}
    
int yywrap(){
    return 1;
}