#ifndef AST_H
#define AST_H

#include <stdbool.h>

typedef enum {
    AST_INT,
    AST_FLOAT,
    AST_STRING,
    AST_BOOL,
    AST_VAR,
    AST_BINOP,
    AST_ASSIGN,
    AST_PRINT,
    AST_SEQ,
    AST_IF
} ASTNodeType;

typedef struct ASTNode {
    ASTNodeType type;
    union {
        int int_val;
        double float_val;
        char* str_val;
        bool bool_val;
        char* var_name;
        struct { struct ASTNode* left; struct ASTNode* right; char op; } binop;
        struct { char* var; struct ASTNode* expr; } assign;
        struct { struct ASTNode* expr; } print;
        struct { struct ASTNode* cond; struct ASTNode* then_branch; struct ASTNode* else_branch; } if_stmt;
        struct { struct ASTNode* first; struct ASTNode* second; } seq;
    } data;
    struct ASTNode* next;
} ASTNode;

// Funções para criar nós (exemplo)
ASTNode* create_int_node(int value);
ASTNode* create_float_node(double value);
ASTNode* create_string_node(char* value);
ASTNode* create_bool_node(bool value);
ASTNode* create_var_node(char* name);
ASTNode* create_binop_node(char op, ASTNode* left, ASTNode* right);
ASTNode* create_assign_node(char* var, ASTNode* expr);
ASTNode* create_print_node(ASTNode* expr);
ASTNode* create_if_node(ASTNode* cond, ASTNode* then_branch, ASTNode* else_branch);
ASTNode* create_seq_node(ASTNode* first, ASTNode* second);
void free_ast(ASTNode* node);
void print_ast(ASTNode* node, int level);

typedef enum { VAL_INT, VAL_FLOAT, VAL_BOOL, VAL_STRING } ValueType;

typedef struct Value {
    ValueType type;
    union {
        int    i;
        double f;
        bool   b;
        char*  s;
    } data;
} Value;

// protótipos para o interpretador
void    exec_ast(ASTNode* root);
Value   eval_node(ASTNode* node);


#endif