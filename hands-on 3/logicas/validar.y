/* validar.y */

%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token BOOLEAN AND OR NOT

%left OR
%left AND
%right NOT

%%
input:
    expr '\n'      { printf("Válida\n"); }
  | error '\n'     { printf("Inválida\n"); yyerrok; }
  ;

expr:
      expr AND term
    | expr OR term
    | term
    ;

term:
      NOT factor
    | factor
    ;

factor:
      '(' expr ')'
    | BOOLEAN
    ;
%%

void yyerror(const char *s) {}
int main(void) { return yyparse(); }
