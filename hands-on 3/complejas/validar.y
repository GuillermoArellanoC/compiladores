%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(const char *s);
%}

/* Tokens */
%token NUMBER BOOLEAN
%token AND OR NOT

/* Precedencia: aritmética primero, luego lógica */
%left OR
%left AND
%right NOT
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

input:
    expr '\n'     { printf("Válida\n"); }
  | error '\n'    { printf("Inválida\n"); yyerrok; }
  ;

expr:
      expr OR expr
    | expr AND expr
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | NOT expr         %prec NOT
    | '(' expr ')'
    | NUMBER
    | BOOLEAN
    ;

%%

void yyerror(const char *s) { /* vacío */ }
int main(void)    { return yyparse(); }
