%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%
"int"       { return INT; }
"func"      { return FUNC; }
"return"    { return RETURN; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"="         { return IGUAL; }
"("         { return PARIZQ; }
")"         { return PARDER; }
"{"         { return LLAVEIZQ; }
"}"         { return LLAVEDER; }
";"         { return PUNTOYCOMA; }
","         { return COMA; }
[ \t\n]+    ;
.           { return yytext[0]; }
%%

int yywrap() { return 1; }