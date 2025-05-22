%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "types.h"

// Tabela de símbolos
typedef struct Symbol {
    char* name;
    Expression expr;
    struct Symbol* next;
} Symbol;

Symbol* symbol_table = NULL;

Symbol* find_symbol(char* name) {
    Symbol* s = symbol_table;
    while(s) {
        if(strcmp(s->name, name) == 0) return s;
        s = s->next;
    }
    return NULL;
}

void add_symbol(char* name, Expression expr) {
    Symbol* s = (Symbol*)malloc(sizeof(Symbol));
    s->name = strdup(name);
    s->expr = expr;
    s->next = symbol_table;
    symbol_table = s;
}

void yyerror(const char* msg);
int yylex(void);
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

program: 
    | program statement
    ;

statement: 
      PRINT LPAREN expr RPAREN NEWLINE {
          switch($3.type) {
              case 0: printf("%d\n", $3.value.int_val); break;
              case 1: printf("%.2f\n", $3.value.float_val); break;
              case 2: printf("%s\n", $3.value.str_val); break;
              case 3: printf("%s\n", $3.value.bool_val ? "True" : "False"); break;
          }
      }
    | ID ASSIGN expr NEWLINE { 
          add_symbol($1, $3);
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

expr: 
    expr_int      { $$ = $1; }
    | expr_float  { $$ = $1; }
    | expr_bool   { $$ = $1; }
    | STRING      { $$.type = 2; $$.value.str_val = $1; }
    | ID          { 
        Symbol* sym = find_symbol($1);
        if (sym) {
            $$ = sym->expr;
        } else {
            yyerror("Variável não definida");
            $$.type = 0;
            $$.value.int_val = 0;
        }
        free($1);
    }
    | INPUT LPAREN RPAREN {
        char buffer[1024];
        if(fgets(buffer, sizeof(buffer), stdin) == NULL) {
            yyerror("Erro ao ler entrada");
            $$.type = 2;
            $$.value.str_val = strdup("");
        } else {
            size_t len = strlen(buffer);
            if(len > 0 && buffer[len-1] == '\n') buffer[len-1] = '\0';
            $$.type = 2;
            $$.value.str_val = strdup(buffer);
        }
    }
    | LPAREN expr RPAREN { $$ = $2; }
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
    IF LPAREN expr_bool RPAREN LBRACE program RBRACE else_part 
    ;

else_part: 
    | ELSE LBRACE program RBRACE 
    | ELIF LPAREN expr_bool RPAREN LBRACE program RBRACE else_part 
    ;

%%

void yyerror(const char* msg) {
    fprintf(stderr, "Erro: %s\n", msg);
}
