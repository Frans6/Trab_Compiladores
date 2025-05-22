%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "ast.h"       
#include "types.h"
#include "symbol_table.h"

ASTNode* raiz_ast = NULL; 
%}



%union {
    Expression expr;
    char* id;
    int int_val;
    double float_val;
    char* str_val;
    bool bool_val;
    ASTNode* ast;
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

%type <ast> program statement
%type <expr> expr expr_int expr_float expr_bool

%nonassoc LPAREN RPAREN
%left ADD SUB
%left MUL DIV MOD
%right POW
%right UMINUS
%nonassoc IF
%nonassoc ELSE ELIF

%%

program:
      /* vazio */ { raiz_ast = NULL; }
    | statement { raiz_ast = $1; }
    | program statement { raiz_ast = create_seq_node(raiz_ast, $2); }
;

statement: 
    PRINT LPAREN expr RPAREN NEWLINE {
        switch($3.type) {
            case 0: printf("%d\n", $3.value.int_val); break;
            case 1: printf("%.2f\n", $3.value.float_val); break;
            case 2: printf("%s\n", $3.value.str_val ? $3.value.str_val : "(null)"); break;
            case 3: printf("%s\n", $3.value.bool_val ? "True" : "False"); break;
            default: printf("Tipo desconhecido para impressão\n");
        }
    }
    | ID ASSIGN expr NEWLINE { 
        add_symbol($1, $3);
        free($1);
    }
    | if_statement
    ;

expr:
      expr ADD expr   { $$.type = ($1.type == 1 || $3.type == 1) ? 1 : 0;
                        if ($$.type == 1)
                            $$.value.float_val = (($1.type == 1 ? $1.value.float_val : $1.value.int_val) +
                                                 ($3.type == 1 ? $3.value.float_val : $3.value.int_val));
                        else
                            $$.value.int_val = $1.value.int_val + $3.value.int_val;
                      }
    | expr SUB expr   { $$.type = ($1.type == 1 || $3.type == 1) ? 1 : 0;
                        if ($$.type == 1)
                            $$.value.float_val = (($1.type == 1 ? $1.value.float_val : $1.value.int_val) -
                                                 ($3.type == 1 ? $3.value.float_val : $3.value.int_val));
                        else
                            $$.value.int_val = $1.value.int_val - $3.value.int_val;
                      }
    | expr MUL expr   { $$.type = ($1.type == 1 || $3.type == 1) ? 1 : 0;
                        if ($$.type == 1)
                            $$.value.float_val = (($1.type == 1 ? $1.value.float_val : $1.value.int_val) *
                                                 ($3.type == 1 ? $3.value.float_val : $3.value.int_val));
                        else
                            $$.value.int_val = $1.value.int_val * $3.value.int_val;
                      }
    | expr DIV expr   { $$.type = 1;
                        $$.value.float_val = (($1.type == 1 ? $1.value.float_val : $1.value.int_val) /
                                              ($3.type == 1 ? $3.value.float_val : $3.value.int_val));
                      }
    | INT             { $$.type = 0; $$.value.int_val = $1; }
    | FLOAT           { $$.type = 1; $$.value.float_val = $1; }
    | STRING          { $$.type = 2; $$.value.str_val = $1; }
    | BOOL            { $$.type = 3; $$.value.bool_val = $1; }
    | ID              { Symbol* sym = find_symbol($1);
                        if (sym) { $$ = sym->expr; }
                        else { yyerror("Variável não definida"); $$.type = 0; $$.value.int_val = 0; }
                        free($1);
                      }
    | LPAREN expr RPAREN { $$ = $2; }
    | SUB expr %prec UMINUS { 
                        if ($2.type == 1) { $$.type = 1; $$.value.float_val = -$2.value.float_val; }
                        else { $$.type = 0; $$.value.int_val = -$2.value.int_val; }
                      }
;

expr_int: 
    INT           { $$.type = 0; $$.value.int_val = $1; }
    | expr_int ADD expr_int { $$.type = 0; $$.value.int_val = $1.value.int_val + $3.value.int_val; }
    | expr_int SUB expr_int { $$.type = 0; $$.value.int_val = $1.value.int_val - $3.value.int_val; }
    | expr_int MUL expr_int { $$.type = 0; $$.value.int_val = $1.value.int_val * $3.value.int_val; }
    | expr_int DIV expr_int { 
        if($3.value.int_val == 0) yyerror("Divisão por zero");
        $$.type = 0; 
        $$.value.int_val = $1.value.int_val / $3.value.int_val; 
    }
    | LPAREN expr_int RPAREN { $$ = $2; }
    | SUB expr_int %prec UMINUS { $$.type = 0; $$.value.int_val = -$2.value.int_val; }
    ;

expr_float: 
    FLOAT         { $$.type = 1; $$.value.float_val = $1; }
    | expr_float ADD expr_float { $$.type = 1; $$.value.float_val = $1.value.float_val + $3.value.float_val; }
    | expr_float SUB expr_float { $$.type = 1; $$.value.float_val = $1.value.float_val - $3.value.float_val; }
    | expr_float MUL expr_float { $$.type = 1; $$.value.float_val = $1.value.float_val * $3.value.float_val; }
    | expr_float DIV expr_float { $$.type = 1; $$.value.float_val = $1.value.float_val / $3.value.float_val; }
    | LPAREN expr_float RPAREN { $$ = $2; }
    | SUB expr_float %prec UMINUS { $$.type = 1; $$.value.float_val = -$2.value.float_val; }
    ;

expr_bool: 
    BOOL          { $$.type = 3; $$.value.bool_val = $1; }
    | expr_int EQ expr_int { $$.type = 3; $$.value.bool_val = $1.value.int_val == $3.value.int_val; }
    | expr_int NEQ expr_int { $$.type = 3; $$.value.bool_val = $1.value.int_val != $3.value.int_val; }
    | expr_int GT expr_int { $$.type = 3; $$.value.bool_val = $1.value.int_val > $3.value.int_val; }
    | expr_int LT expr_int { $$.type = 3; $$.value.bool_val = $1.value.int_val < $3.value.int_val; }
    | expr_int GTE expr_int { $$.type = 3; $$.value.bool_val = $1.value.int_val >= $3.value.int_val; }
    | expr_int LTE expr_int { $$.type = 3; $$.value.bool_val = $1.value.int_val <= $3.value.int_val; }
    | LPAREN expr_bool RPAREN { $$ = $2; }
    ;

if_statement: 
    IF '(' expr_bool ')' '{' program '}' else_part 
    ;

else_part: 
    | ELSE '{' program '}' 
    | ELIF '(' expr_bool ')' '{' program '}' else_part 
    ;

%%

void yyerror(const char* msg) {
    fprintf(stderr, "Erro: %s\n", msg);
}