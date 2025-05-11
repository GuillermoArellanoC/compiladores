%{
#include <stdio.h>    // Para printf
#include <stdlib.h>   // Para malloc/free
#include <string.h>   // Para strcmp/strdup

// Prototipos de funciones
int yylex(void);
int yyerror(const char *s);
void agregar_variable(char *id);
void agregar_funcion(char *id, int aridad);
void entrar_ambito(void);
void salir_ambito(void);
int existe(char *id);
int buscar_tipo(char *id);

#define MAX_SIMB 200

typedef struct {
    char *nombre;
    int tipo;       // 0 = variable, 1 = función
    int aridad;     // Número de parámetros si es función
    int ambito;     // Nivel de ámbito
} Simbolo;

Simbolo tabla[MAX_SIMB];
int ntabla = 0;
int ambito_actual = 0;

void entrar_ambito() { ambito_actual++; }
void salir_ambito() { ambito_actual--; }

void agregar_variable(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].ambito == ambito_actual) {
            printf("Error: redeclaración de '%s'\n", id);
            return;
        }
    }
    tabla[ntabla].nombre = strdup(id);
    tabla[ntabla].tipo = 0;
    tabla[ntabla].ambito = ambito_actual;
    ntabla++;
}

void agregar_funcion(char *id, int aridad) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].ambito == 0) {
            printf("Error: función '%s' ya declarada\n", id);
            return;
        }
    }
    tabla[ntabla].nombre = strdup(id);
    tabla[ntabla].tipo = 1;
    tabla[ntabla].aridad = aridad;
    tabla[ntabla].ambito = 0;
    ntabla++;
}

int buscar_tipo(char *id) {
    for (int i = ntabla-1; i >= 0; i--) {
        if (strcmp(tabla[i].nombre, id) == 0) {
            return tabla[i].tipo;
        }
    }
    return -1;
}

int existe(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0) return 1;
    }
    return 0;
}

int yyerror(const char *s) {
    printf("Error sintáctico: %s\n", s);
    return 0;
}
%}

%union { char *str; int num; }
%token <str> ID
%token <num> NUM
%token INT FUNC RETURN IGUAL
%token PARIZQ PARDER LLAVEIZQ LLAVEDER PUNTOYCOMA COMA

%type <num> lista_param

%%

/* Las reglas gramaticales permanecen igual que en tu versión anterior */
programa: declaraciones asignaciones;
declaraciones: declaracion | declaraciones declaracion;
declaracion: INT ID PUNTOYCOMA { agregar_variable($2); }
           | FUNC ID PARIZQ lista_param PARDER bloque { agregar_funcion($2, $4); };
lista_param: /* vacío */ { $$ = 0; }
           | ID { agregar_variable($1); $$ = 1; }
           | lista_param COMA ID { agregar_variable($3); $$ = $1 + 1; };
bloque: LLAVEIZQ { entrar_ambito(); } instrucciones LLAVEDER { salir_ambito(); };
instrucciones: instruccion | instrucciones instruccion;
instruccion: INT ID PUNTOYCOMA { agregar_variable($2); }
           | ID IGUAL ID PUNTOYCOMA {
               if (!existe($1) || !existe($3))
                   printf("Error: identificador no declarado\n");
               else if (buscar_tipo($1) != buscar_tipo($3))
                   printf("Error: tipos incompatibles\n");
             }
           | RETURN ID PUNTOYCOMA {
               if (!existe($2))
                   printf("Error: '%s' no declarado\n", $2);
             }
           | bloque;
asignaciones: asignacion | asignaciones asignacion;
asignacion: ID IGUAL ID PUNTOYCOMA {
               if (!existe($1) || !existe($3))
                   printf("Error: identificador no declarado\n");
               else if (buscar_tipo($1) != buscar_tipo($3))
                   printf("Error: tipos incompatibles\n");
             };
%%

int main() { 
    return yyparse(); 
}