%{
#include "parser.tab.h"              // Inclusión del archivo generado por 
#include <string.h>                  // Para manejo de cadenas
#include <stdlib.h>                  // Para asignación dinámica
%}
%%
"int"                   { return INT; }                                  // Pa
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }     // Ide
";"                     { return PUNTOYCOMA; }                           // Pu
"{"                     { return LLAVEIZQ; }                             // Ll
"}"                     { return LLAVEDER; }                             // Ll
[ \t\n]+                ;                                                // Ign
.                       { return yytext[0]; }                            // Re
%%
int yywrap() { return 1; }
