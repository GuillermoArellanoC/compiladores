/* validar.l */

%{
#include "validar.tab.h"
#include <stdlib.h>
%}

%option noyywrap

%%
AND     { return AND; }
OR      { return OR; }
NOT     { return NOT; }

[01]    { yylval = atoi(yytext); return BOOLEAN; }

"\("  { return '('; }
"\)"  { return ')'; }
"\n"  { return '\n'; }

[ \t]+ ;

.       { return yytext[0]; }
%%