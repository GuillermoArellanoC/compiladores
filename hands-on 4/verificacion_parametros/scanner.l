%{
#include "parser.tab.h"
#include <string.h>
%}

%%
"func"      { return FUNC; }     // Palabra clave

[a-zA-Z_][a-zA-Z0-9_]* {         // Identificadores
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+      { yylval.num = atoi(yytext); return NUM; }  // Números

[()]        { return yytext[0]; } // Paréntesis
";"         { return PUNTOYCOMA; } // Punto y coma
","         { return COMA; }      // Coma

[ \t\n]+    ; // Ignorar espacios
.           { return yytext[0]; } // Otros caracteres
%%

int yywrap() { return 1; }