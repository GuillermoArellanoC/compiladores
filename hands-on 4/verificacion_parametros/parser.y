%{
/* Encabezados y variables globales */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_FUNC 100
char *funciones[MAX_FUNC];  // Tabla de funciones
int aridades[MAX_FUNC];     // Número de parámetros por función
int nfuncs = 0;             // Contador de funciones

int yylex(void);
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }

// Registra una función nueva
void registrar_funcion(char *id, int n) {
    for (int i = 0; i < nfuncs; i++)
        if (strcmp(funciones[i], id) == 0) return;
    funciones[nfuncs] = strdup(id);
    aridades[nfuncs++] = n;
}

// Obtiene el número de parámetros de una función
int obtener_aridad(char *id) {
    for (int i = 0; i < nfuncs; i++)
        if (strcmp(funciones[i], id) == 0) return aridades[i];
    return -1;
}
%}

%union { char *str; int num; }

/* Tokens */
%token <str> ID     // Identificadores
%token <num> NUM    // Números
%token FUNC         // Palabra clave 'func'
%token PARIZQ       // '('
%token PARDER       // ')'
%token PUNTOYCOMA   // ';'
%token COMA         // ','

/* No terminales */
%type <num> lista_parametros lista_args

%%

programa: declaraciones llamadas;

// Declaraciones de funciones
declaraciones: 
    declaracion 
    | declaraciones declaracion
;

declaracion:
    FUNC ID PARIZQ lista_parametros PARDER PUNTOYCOMA {
        registrar_funcion($2, $4);
    }
;

// Parámetros de función
lista_parametros: 
    /* vacío */ { $$ = 0; }
    | ID { $$ = 1; }
    | lista_parametros COMA ID { $$ = $1 + 1; }
;

// Llamadas a funciones
llamadas: 
    llamada 
    | llamadas llamada
;

llamada:
    ID PARIZQ lista_args PARDER PUNTOYCOMA {
        int esperados = obtener_aridad($1);
        if (esperados != $3)
            printf("Error: se esperaban %d argumentos en '%s'\n", esperados, $1);
    }
;

// Argumentos en llamadas
lista_args: 
    /* vacío */ { $$ = 0; }
    | ID { $$ = 1; }
    | NUM { $$ = 1; }
    | lista_args COMA ID { $$ = $1 + 1; }
    | lista_args COMA NUM { $$ = $1 + 1; }
;

%%

int main() { return yyparse(); }