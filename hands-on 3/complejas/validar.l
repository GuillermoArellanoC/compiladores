%{
#include "validar.tab.h"
#include <stdlib.h>
%}

%option noyywrap

%%

"AND"      { return AND; }
"OR"       { return OR; }
"NOT"      { return NOT; }

[0-9]+     { yylval = atoi(yytext); return NUMBER; }
[01]       { yylval = atoi(yytext); return BOOLEAN; }

"("        { return '('; }
")"        { return ')'; }
"\n"       { return '\n'; }

[ \t]+     ;
.          { return yytext[0]; }
%%
