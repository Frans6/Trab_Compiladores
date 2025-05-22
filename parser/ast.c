#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "ast.h"

ASTNode* create_int_node(int value) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_INT;
    node->data.int_val = value;
    node->next = NULL;
    return node;
}

ASTNode* create_float_node(double value) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_FLOAT;
    node->data.float_val = value;
    node->next = NULL;
    return node;
}

ASTNode* create_string_node(char* value) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_STRING;
    node->data.str_val = strdup(value);
    node->next = NULL;
    return node;
}

ASTNode* create_bool_node(bool value) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_BOOL;
    node->data.bool_val = value;
    node->next = NULL;
    return node;
}

ASTNode* create_var_node(char* name) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_VAR;
    node->data.var_name = strdup(name);
    node->next = NULL;
    return node;
}

ASTNode* create_binop_node(char op, ASTNode* left, ASTNode* right) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_BINOP;
    node->data.binop.left = left;
    node->data.binop.right = right;
    node->data.binop.op = op;
    node->next = NULL;
    return node;
}

ASTNode* create_assign_node(char* var, ASTNode* expr) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_ASSIGN;
    node->data.assign.var = strdup(var);
    node->data.assign.expr = expr;
    node->next = NULL;
    return node;
}

ASTNode* create_print_node(ASTNode* expr) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_PRINT;
    node->data.print.expr = expr;
    node->next = NULL;
    return node;
}

ASTNode* create_if_node(ASTNode* cond, ASTNode* then_branch, ASTNode* else_branch) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_IF;
    node->data.if_stmt.cond = cond;
    node->data.if_stmt.then_branch = then_branch;
    node->data.if_stmt.else_branch = else_branch;
    node->next = NULL;
    return node;
}

ASTNode* create_seq_node(ASTNode* first, ASTNode* second) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = AST_SEQ;
    node->data.seq.first = first;
    node->data.seq.second = second;
    node->next = NULL;
    return node;
}

void print_ast(ASTNode* node, int level) {
    if (!node) return;
    for (int i = 0; i < level; i++) printf("  ");
    switch (node->type) {
        case AST_INT:
            printf("INT: %d\n", node->data.int_val);
            break;
        case AST_FLOAT:
            printf("FLOAT: %f\n", node->data.float_val);
            break;
        case AST_STRING:
            printf("STRING: %s\n", node->data.str_val);
            break;
        case AST_BOOL:
            printf("BOOL: %s\n", node->data.bool_val ? "True" : "False");
            break;
        case AST_VAR:
            printf("VAR: %s\n", node->data.var_name);
            break;
        case AST_ASSIGN:
            printf("ASSIGN: %s =\n", node->data.assign.var);
            print_ast(node->data.assign.expr, level + 1);
            break;
        case AST_PRINT:
            printf("PRINT:\n");
            print_ast(node->data.print.expr, level + 1);
            break;
        case AST_BINOP:
            printf("BINOP: %c\n", node->data.binop.op);
            print_ast(node->data.binop.left, level + 1);
            print_ast(node->data.binop.right, level + 1);
            break;
        case AST_SEQ:
            printf("SEQ:\n");
            print_ast(node->data.seq.first, level + 1);
            print_ast(node->data.seq.second, level + 1);
            break;
        case AST_IF:
            printf("IF:\n");
            print_ast(node->data.if_stmt.cond, level + 1);
            print_ast(node->data.if_stmt.then_branch, level + 1);
            print_ast(node->data.if_stmt.else_branch, level + 1);
            break;
        default:
            printf("UNKNOWN NODE\n");
    }
}

void free_ast(ASTNode* node) {
    if (!node) return;
    switch (node->type) {
        case AST_STRING:
            free(node->data.str_val);
            break;
        case AST_VAR:
            free(node->data.var_name);
            break;
        case AST_BINOP:
            free_ast(node->data.binop.left);
            free_ast(node->data.binop.right);
            break;
        case AST_ASSIGN:
            free(node->data.assign.var);
            free_ast(node->data.assign.expr);
            break;
        case AST_PRINT:
            free_ast(node->data.print.expr);
            break;
        case AST_IF:
            free_ast(node->data.if_stmt.cond);
            free_ast(node->data.if_stmt.then_branch);
            free_ast(node->data.if_stmt.else_branch);
            break;
        case AST_SEQ:
            free_ast(node->data.seq.first);
            free_ast(node->data.seq.second);
            break;
        default:
            break;
    }
    free(node);
}