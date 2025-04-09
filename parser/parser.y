%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char* msg);
int yylex(void);
%}

%union {
    int ival;
}

%token <ival> NUMBER
%token PRINT
%token EQ NEQ GTE LTE GT LT

%type <ival> expr

%left '+' '-'
%left '*' '/'
%left EQ NEQ GTE LTE GT LT

%%

program:
    program stmt
    | /* vazio */
    ;

stmt:
    PRINT expr ';'     { printf("Resultado: %d\n", $2); }
    ;

expr:
      NUMBER             { $$ = $1; }
    | expr '+' expr      { $$ = $1 + $3; }
    | expr '-' expr      { $$ = $1 - $3; }
    | expr '*' expr      { $$ = $1 * $3; }
    | expr '/' expr      { $$ = $1 / $3; }
    | expr EQ expr       { $$ = ($1 == $3); }
    | expr NEQ expr      { $$ = ($1 != $3); }
    | expr GTE expr      { $$ = ($1 >= $3); }
    | expr LTE expr      { $$ = ($1 <= $3); }
    | expr GT expr       { $$ = ($1 > $3); }
    | expr LT expr       { $$ = ($1 < $3); }
    | '(' expr ')'       { $$ = $2; }
    ;

%%

void yyerror(const char* msg) {
    fprintf(stderr, "Erro: %s\n", msg);
}
