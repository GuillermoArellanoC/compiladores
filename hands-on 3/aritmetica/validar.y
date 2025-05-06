/* validar.y */

%{
#include <stdio.h>
#include <stdlib.h>

/* Prototipos para evitar declaraciones implícitas */
int yylex(void);
void yyerror(const char *s);
%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

input:
  expr '\n'  { printf("Válida\n"); }
| error '\n' { printf("Inválida\n"); yyerrok; }
;

expr:
  expr '+' term
| expr '-' term
| term
;

term:
  term '*' factor
| term '/' factor
| factor
;

factor:
  '(' expr ')'
| '-' factor %prec UMINUS
| NUMBER
;
%%

void yyerror(const char *s) {
    /* Simplemente ignoramos el mensaje */
}

int main(void) {
    return yyparse();
}

