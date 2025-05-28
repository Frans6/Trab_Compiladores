%{
#include "ast.h"
#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "types.h"

ASTNode* raiz_ast = NULL;  // raiz da AST global
%}

%union {
    Expression expr;
    char* id;
    int int_val;
    double float_val;
    char* str_val;
    bool bool_val;
}

%token LPAREN RPAREN
%token PRINT INPUT IF ELSE ELIF
%token <int_val> INT
%token <float_val> FLOAT
%token <str_val> STRING
%token <bool_val> BOOL
%token ADD SUB MUL DIV POW MOD
%token ASSIGN EQ NOT NEQ GT LT GTE LTE
%token <id> ID
%token NEWLINE
%token COLON
%token COMMA SEMICOLON DOT
%token LBRACKET RBRACKET LBRACE RBRACE AT
%token DEF RETURN CLASS WHILE FOR BREAK CONTINUE NONE AND OR
%token IN   /* Corrigido: token IN adicionado aqui */

%type <expr> expr expr_int expr_float expr_bool

%nonassoc LPAREN RPAREN
%left ADD SUB
%left MUL DIV MOD
%right POW
%right UMINUS
%nonassoc IF
%nonassoc ELSE ELIF

%%

program
    : stmt_list { raiz_ast = $1; }
    ;

stmt_list
    : stmt                      { $$ = $1; }
    | stmt_list stmt            { $$ = create_seq_node($1, $2); }
    ;

statement
    : PRINT LPAREN expr RPAREN NEWLINE {
          exec_print($3);
      }
    | ID ASSIGN expr NEWLINE { 
          raiz_ast = create_seq_node(raiz_ast,
                      create_assign_node($1, $3));
          free($1);
      }
    | if_statement
    | while_statement
    | for_statement
    | break_statement
    | continue_statement
    ;

while_statement:
    WHILE LPAREN expr_bool RPAREN LBRACE program RBRACE
    ;

for_statement:
    FOR ID IN expr LBRACE program RBRACE
    ;

break_statement:
    BREAK NEWLINE
    ;

continue_statement:
    CONTINUE NEWLINE
    ;

expr
    : expr_int      { $$ = $1; }
    | expr_float    { $$ = $1; }
    | expr_bool     { $$ = $1; }
    | STRING        { $$.type = VAL_STRING; $$.value.s = $1; }
    | ID            { $$ = create_var_node($1); free($1); }
    | INPUT LPAREN RPAREN {
        $$ = create_input_node();
      }
    | LPAREN expr RPAREN { $$ = $2; }
    ;

expr_int
    : INT                { $$.type = VAL_INT; $$.value.i = $1; }
    | expr_int ADD expr_int { $$.type = VAL_INT; $$.value.i = $1.value.i + $3.value.i; }
    | expr_int SUB expr_int { $$.type = VAL_INT; $$.value.i = $1.value.i - $3.value.i; }
    | expr_int MUL expr_int { $$.type = VAL_INT; $$.value.i = $1.value.i * $3.value.i; }
    | expr_int DIV expr_int {
        if($3.value.i == 0) yyerror("Divisão por zero");
        $$.type = VAL_INT; $$.value.i = $1.value.i / $3.value.i;
      }
    | LPAREN expr_int RPAREN { $$ = $2; }
    | SUB expr_int %prec UMINUS { $$.type = VAL_INT; $$.value.i = -$2.value.i; }
    ;

expr_float
    : FLOAT              { $$.type = VAL_FLOAT; $$.value.f = $1; }
    | expr_float ADD expr_float { $$.type = VAL_FLOAT; $$.value.f = $1.value.f + $3.value.f; }
    | expr_float SUB expr_float { $$.type = VAL_FLOAT; $$.value.f = $1.value.f - $3.value.f; }
    | expr_float MUL expr_float { $$.type = VAL_FLOAT; $$.value.f = $1.value.f * $3.value.f; }
    | expr_float DIV expr_float { $$.type = VAL_FLOAT; $$.value.f = $1.value.f / $3.value.f; }
    | LPAREN expr_float RPAREN { $$ = $2; }
    | SUB expr_float %prec UMINUS { $$.type = VAL_FLOAT; $$.value.f = -$2.value.f; }
    ;

expr_bool
    : BOOL               { $$.type = VAL_BOOL; $$.value.b = $1; }
    | expr_int EQ expr_int { $$.type = VAL_BOOL; $$.value.b = $1.value.i == $3.value.i; }
    | expr_int NEQ expr_int { $$.type = VAL_BOOL; $$.value.b = $1.value.i != $3.value.i; }
    | expr_int GT expr_int { $$.type = VAL_BOOL; $$.value.b = $1.value.i > $3.value.i; }
    | expr_int LT expr_int { $$.type = VAL_BOOL; $$.value.b = $1.value.i < $3.value.i; }
    | expr_int GTE expr_int { $$.type = VAL_BOOL; $$.value.b = $1.value.i >= $3.value.i; }
    | expr_int LTE expr_int { $$.type = VAL_BOOL; $$.value.b = $1.value.i <= $3.value.i; }
    | LPAREN expr_bool RPAREN { $$ = $2; }
    ;

if_statement:
    IF LPAREN expr_bool RPAREN LBRACE program RBRACE else_part
    ;

else_part:
    | /* empty */
    | ELSE LBRACE program RBRACE
    | ELIF LPAREN expr_bool RPAREN LBRACE program RBRACE else_part
    ;

%%

int main(int argc, char** argv) {
    if (yyparse() == 0) {
        exec_ast(raiz_ast);
        free_ast(raiz_ast);
    }
    return 0;
}

void yyerror(const char* msg) {
    fprintf(stderr, "Erro: %s\n", msg);
}
