
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern char *yytext;
extern int yylex(void);
extern void yyerror(char*);
extern int yynerrs;
extern int yylexerrs;
extern FILE* yyin;
#define MAXTAM 32+1
#define MAXSIMBOLS 100

typedef struct{
    char id[MAXTAM];
    int val;
}regTS;

regTS TS[MAXSIMBOLS] = { {"$",-1} }; //$ es el valor centinela que marca el fin de la lista

/* PROTOTIPOS */

void escribirEnTS(char* idAgreg, int valAgreg);
int indiceEnTS(char* idBuscado);
int valorID(char* id);
int procOperacion(int num1, int op, int num2);
void mostrarIDyValor(char* id);

%}

%union{
    char* cadena;
    int num;
    short operacion;
}
%token INICIO FIN LEER ESCRIBIR PUNTOYCOMA PARENDERERCHO PARENIZQUIERDO 
%token <cadena> ID
%token <num> CONSTANTE 
%left SUMA RESTA COMA MULTIPLICACION
%right ASIGNACION
%type <num> primaria expresion operadorAditivo termino listaIdentificadores listaExpresiones

%%
objetivo: programa 
;

programa: INICIO listaSentencia FIN
;

operadorAditivo: SUMA {$$ = 1;}
|RESTA {$$ = 2;}
;

listaSentencia: sentencia 
|listaSentencia sentencia
;

sentencia: ID ASIGNACION expresion PUNTOYCOMA {escribirEnTS($1, $3); printf("Se declara id %s, Almacenada con valor %d \n", $1, $3);}
|LEER {printf("READ[");} PARENIZQUIERDO listaIdentificadores PARENDERERCHO PUNTOYCOMA {printf("]\n");}
|ESCRIBIR{printf("WRITE( ");} PARENIZQUIERDO listaExpresiones PARENDERERCHO PUNTOYCOMA {printf(")\n");}
;

listaIdentificadores: ID {mostrarIDyValor($1);}
|listaIdentificadores COMA ID {printf(", "); mostrarIDyValor($3);}
;

listaExpresiones: expresion {printf("%d", $1);}
|listaExpresiones COMA expresion {printf(", %d", $3);} 
;

expresion: termino {$$ = $1;}
|expresion operadorAditivo termino  {$$ = procOperacion($1, $2, $3);}
;

termino: primaria {/* Creo "termino" para que se haga primero la multiplicacion y luego la suma/resta */}
|termino MULTIPLICACION primaria {$$ = $1 * $3;}
;

primaria: ID {$$ = valorID($1);}
|CONSTANTE {$$ = $1;}
|PARENIZQUIERDO expresion PARENDERERCHO {$$ = $2;}
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

    // Parser
    switch (yyparse()){
        case 0: printf("\n\nProceso de compilacion exitoso");
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

////////FUNCIONES TS//////////

int valorID(char* id){
    int ind = indiceEnTS(id);
    if (TS[ind].id[0] == '$'){
        yyerror("ERROR Intentando obtener valor de ID sin valor asignado");
    }
    else{
        return TS[ind].val;
    }
}

int indiceEnTS(char* idBuscado){ //retorna indice de un ID ya guardado, retorna indice del valor centinela si no lo encuentra
    int i = 0;
    while(TS[i].id[0] != '$'){ //busqueda secuencial hasta encontrar valor centinela "$"
        if (strcmp(TS[i].id, idBuscado) == 0){
            return i;
        }
        else{
            i++;
        }
    }
    return i; //Hago que retorne el indice del final de la lista asi me ahorro otra busqueda secuencial en "escribirEnTS"
}

void escribirEnTS(char* idAgreg, int valAgreg){ //agrega idAgreg a TS con valor valAgreg, si id ya existe, solo se actualiza el val
    int ind = indiceEnTS(idAgreg);
    if(TS[ind].id[0] == '$'){ //verifica si indice esta al final de la lista
        sprintf(TS[ind].id, idAgreg); //guardamos el ID y el valor en el final de la lista
        TS[ind].val = valAgreg;
        TS[ind+1].id[0] = '$';  //Marcamos el nuevo final de la lista con el valor centinela
    }
    else{
        TS[ind].val = valAgreg;
    }

}

//////////AUXILIARES/////////
void mostrarIDyValor(char* id){
    int ind = indiceEnTS(id);
    printf("%s:", id);
    if(TS[ind].id[0] == '$'){
        printf("SinValor");
    }
    else{
        printf("%d",TS[ind].val);
    }
}

int procOperacion(int num1, int op, int num2){
    if (op == 1){
        return num1 + num2;
    }
    else if (op == 2){
        return num1 - num2;
    }
    else{
        return num1 * num2;
    }
}

