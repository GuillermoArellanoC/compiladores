%{
#include "parser.tab.h"              // Inclusión del encabezado generado por Bison
#include <string.h>                  // Para funciones de manejo de cadenas
#include <stdlib.h>                  // Para funciones estándar
%}
%%
"int"                   { return INT; }                                  // Palabra clave int
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }     // Identificador válido
"="                     { return IGUAL; }                               // Operador de asignación
";"                     { return PUNTOYCOMA; }                          // Punto y coma
[ \t\n]+                ;                                               // Espacios ignorados
.                       { return yytext[0]; }                           // Cualquier otro símbolo
%%

int yywrap() {
  return 1;
}
