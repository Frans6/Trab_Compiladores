/*
 * ===================================================================
 * parser/parser.y (VERSÃO FINAL E CORRIGIDA)
 * ===================================================================
 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "ast.h"
#include "types.h"
#include "interpretador.h"

extern int yylex();
extern int yylineno;
extern char* yytext;
void yyerror(const char* s);

NoAst* raiz_ast = NULL;
%}

/* ========================== DEFINIÇÕES ========================== */

/* A %union define todos os tipos possíveis para tokens e regras */
%union {
    int                 int_val;
    double              float_val;
    char*               str_val;
    bool                bool_val;
    struct NoAst*       node;
    struct BlocoDeclaracoes* bloco;
    ArgList*            args;
}

/* Tokens que carregam valor (associados a um campo da union) */
%token <int_val>    INT
%token <float_val>  FLOAT
%token <str_val>    STRING
%token <bool_val>   BOOL
%token <str_val>    ID

/* Tokens que não carregam valor (palavras-chave e símbolos) */
%token PRINT INPUT IF ELSE WHILE BREAK CONTINUE AND OR NOT
%token NEWLINE INDENT DEDENT COLON COMMA LPAREN RPAREN
%token POW EQ NEQ GTE LTE GT LT ASSIGN
%token ADD SUB MUL DIV MOD

/* Tipos das regras da gramática (não-terminais) e seus tipos da union */
%type <node>  statement simple_stmt compound_stmt atribuicao expressao termo fator chamada_funcao condicional loop valor
%type <bloco> suite statement_list else_part
%type <args>  arg_lista_opt arg_lista
%type <str_val> nome_funcao // O nome de uma função é uma string

/* ========================== PRECEDÊNCIA ========================== */
%left  OR AND
%nonassoc EQ NEQ GT LT GTE LTE
%left  ADD SUB
%left  MUL DIV MOD
%right NOT POW UMINUS
%precedence ELSE

%%
/* ========================== REGRAS DA GRAMÁTICA ========================== */

programa:
    statement_list NEWLINE
        { raiz_ast = criar_no_bloco($1, 1); }
    | statement_list
        { raiz_ast = criar_no_bloco($1, 1); }
    ;

statement_list:
      /* vazio */ { 
          BlocoDeclaracoes* bloco = malloc(sizeof(BlocoDeclaracoes));
          bloco->declaracoes = NULL;
          bloco->quantidade = 0;
          $$ = bloco; 
      }
    | statement_list statement
        {
            if ($2) {
                $1->quantidade++;
                $1->declaracoes = realloc($1->declaracoes, $1->quantidade * sizeof(NoAst*));
                $1->declaracoes[$1->quantidade - 1] = $2;
            }
            $$ = $1;
        }
    | statement_list NEWLINE
        { $$ = $1; }
    ;

statement:
      simple_stmt NEWLINE     { $$ = $1; }
    | simple_stmt             { $$ = $1; }
    | compound_stmt           { $$ = $1; }
    | NEWLINE                 { $$ = NULL; }
    ;

simple_stmt:
    atribuicao              { $$ = $1; }
    | chamada_funcao        { $$ = $1; }
    | BREAK                 { $$ = criar_no_break(@1.first_line); }
    | CONTINUE              { $$ = criar_no_continue(@1.first_line); }
    ;

compound_stmt:
    condicional             { $$ = $1; }
    | loop                  { $$ = $1; }
    ;

suite:
    COLON NEWLINE INDENT statement_list DEDENT
        { $$ = $4; }
    ;

atribuicao:
    ID ASSIGN expressao
        { $$ = criar_no_atribuicao($1, $3, @1.first_line); free($1); }
    ;

chamada_funcao:
    nome_funcao LPAREN arg_lista_opt RPAREN
        { $$ = criar_no_chamada_funcao($1, $3->args, $3->count, @1.first_line); free($1); free($3); }
    ;

nome_funcao:
    ID      { $$ = $1; } // O ID já é uma string (char*)
    | PRINT { $$ = strdup("print"); }
    | INPUT { $$ = strdup("input"); }
    ;

arg_lista_opt:
    { $$ = calloc(1, sizeof(ArgList)); }
    | arg_lista { $$ = $1; }
    ;

arg_lista:
    expressao
        { $$ = malloc(sizeof(ArgList)); $$->args = malloc(sizeof(NoAst*)); $$->args[0] = $1; $$->count = 1; }
    | arg_lista COMMA expressao
        { $1->count++; $1->args = realloc($1->args, $1->count * sizeof(NoAst*)); $1->args[$1->count - 1] = $3; $$ = $1; }
    ;

condicional:
    IF expressao suite else_part
        { $$ = criar_no_condicional($2, $3, $4, @1.first_line); }
    ;

else_part:
      /* vazio */ { $$ = NULL; }
    | ELSE suite { $$ = $2; }
    | NEWLINE ELSE suite { $$ = $3; }
    ;

loop:
    WHILE expressao suite
        { $$ = criar_no_loop($2, $3, @1.first_line); }
    ;

expressao: 
    termo 
        { $$ = $1; }
    | expressao ADD termo 
        { $$ = criar_no_operacao(ADICAO, $1, $3, @1.first_line); }
    | expressao SUB termo 
        { $$ = criar_no_operacao(SUBTRACAO, $1, $3, @1.first_line); }
    | expressao AND termo 
        { $$ = criar_no_operacao(E_LOGICO, $1, $3, @1.first_line); }
    | expressao OR termo 
        { $$ = criar_no_operacao(OU_LOGICO, $1, $3, @1.first_line); }
    | expressao EQ termo 
        { $$ = criar_no_operacao(IGUAL, $1, $3, @1.first_line); }
    | expressao NEQ termo 
        { $$ = criar_no_operacao(DIFERENTE, $1, $3, @1.first_line); }
    | expressao GT termo 
        { $$ = criar_no_operacao(MAIOR, $1, $3, @1.first_line); }
    | expressao LT termo 
        { $$ = criar_no_operacao(MENOR, $1, $3, @1.first_line); }
    | expressao GTE termo 
        { $$ = criar_no_operacao(MAIOR_IGUAL, $1, $3, @1.first_line); }
    | expressao LTE termo 
        { $$ = criar_no_operacao(MENOR_IGUAL, $1, $3, @1.first_line); }
    ;

termo: 
    fator 
        { $$ = $1; }
    | termo MUL fator 
        { $$ = criar_no_operacao(MULTIPLICACAO, $1, $3, @1.first_line); }
    | termo DIV fator 
        { $$ = criar_no_operacao(DIVISAO, $1, $3, @1.first_line); }
    | termo MOD fator 
        { $$ = criar_no_operacao(MODULO, $1, $3, @1.first_line); }
    ;

fator: 
    valor 
        { $$ = $1; }
    | SUB valor %prec UMINUS 
        { $$ = criar_no_operacao(SUBTRACAO, criar_no_valor_int(0, @1.first_line), $2, @1.first_line); }
    | NOT valor 
        { $$ = criar_no_operacao(NAO_LOGICO, $2, NULL, @1.first_line); }
    | valor POW fator 
        { $$ = criar_no_operacao(POTENCIA, $1, $3, @1.first_line); }
    ;

valor: 
    INT 
        { $$ = criar_no_valor_int($1, @1.first_line); }
    | FLOAT 
        { $$ = criar_no_valor_float($1, @1.first_line); }
    | STRING 
        { $$ = criar_no_valor_string($1, @1.first_line); free($1); }
    | BOOL 
        { $$ = criar_no_valor_bool($1, @1.first_line); }
    | ID 
        { $$ = criar_no_identificador($1, @1.first_line); free($1); }
    | chamada_funcao 
        { $$ = $1; }
    | LPAREN expressao RPAREN 
        { $$ = $2; }
    ;
%%
void yyerror(const char* s) { fprintf(stderr, "Erro de Sintaxe na linha %d: %s\n", yylineno, s); exit(1); }