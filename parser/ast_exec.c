#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

// estrutura simples de tabela de símbolos:
typedef struct Var
{
    char *name;
    Value value;
    struct Var *next;
} Var;

static Var *env = NULL;

// procura uma variável no ambiente
static Var *lookup(const char *name)
{
    for (Var *v = env; v; v = v->next)
        if (strcmp(v->name, name) == 0)
            return v;
    return NULL;
}

// atribui ou atualiza uma variável
static void set_var(const char *name, Value val)
{
    Var *v = lookup(name);
    if (!v)
    {
        v = malloc(sizeof(Var));
        v->name = strdup(name);
        v->next = env;
        env = v;
    }
    // para strings, duplicar
    if (val.type == VAL_STRING)
        v->value.data.s = strdup(val.data.s);
    else
        v->value = val;
}

// recupera valor de variável
static Value get_var(const char *name)
{
    Var *v = lookup(name);
    if (!v)
    {
        fprintf(stderr, "Erro: variável '%s' não foi definida no ambiente atual.\n", name);
        exit(1);
    }
    return v->value;
}

// imprime um Value
static void print_value(Value v)
{
    switch (v.type)
    {
    case VAL_INT:
        printf("%d\n", v.data.i);
        break;
    case VAL_FLOAT:
        printf("%g\n", v.data.f);
        break;
    case VAL_BOOL:
        printf(v.data.b ? "true\n" : "false\n");
        break;
    case VAL_STRING:
        printf("%s\n", v.data.s);
        break;
    }
}

// função recursiva de avaliação de expressões
Value eval_node(ASTNode *node)
{
    if (!node)
    {
        Value v = {VAL_INT, .data.i = 0};
        return v;
    }
    switch (node->type)
    {
    case AST_INT:
    {
        Value v = {VAL_INT, .data.i = node->data.int_val};
        return v;
    }
    case AST_FLOAT:
    {
        Value v = {VAL_FLOAT, .data.f = node->data.float_val};
        return v;
    }
    case AST_STRING:
    {
        Value v = {VAL_STRING, .data.s = node->data.str_val};
        return v;
    }
    case AST_BOOL:
    {
        Value v = {VAL_BOOL, .data.b = node->data.bool_val};
        return v;
    }
    case AST_VAR:
    {
        return get_var(node->data.var_name);
    }
    case AST_BINOP:
    {
        Value L = eval_node(node->data.binop.left);
        Value R = eval_node(node->data.binop.right);
        // ex.: apenas INT/FLOAT para simplificar
        if (L.type == VAL_INT && R.type == VAL_INT)
        {
            int a = L.data.i, b = R.data.i;
            int r = 0;
            switch (node->data.binop.op)
            {
            case '+':
                r = a + b;
                break;
            case '-':
                r = a - b;
                break;
            case '*':
                r = a * b;
                break;
            case '/':
                r = a / b;
                break;
            case '<':
                r = a < b;
                break;
            case '>':
                r = a > b;
                break;
            case '=':
                r = a == b;
                break;
            }
            Value v = {VAL_INT, .data.i = r};
            return v;
        }

        fprintf(stderr, "Erro de tipo: operação binária não suportada para os tipos dos operandos fornecidos.\n");
        exit(1);
    }
    case AST_ASSIGN:
    {
        Value v = eval_node(node->data.assign.expr);
        set_var(node->data.assign.var, v);
        return v;
    }
    default:
    {
        fprintf(stderr, "Erro interno: tipo de nó desconhecido em 'eval_node'.\n");
        exit(1);
    }
    }
}

void exec_ast(ASTNode *node)
{
    if (!node)
        return;
    switch (node->type)
    {
    case AST_SEQ:
        exec_ast(node->data.seq.first);
        exec_ast(node->data.seq.second);
        break;
    case AST_PRINT:
    {
        Value v = eval_node(node->data.print.expr);
        print_value(v);
        break;
    }
    case AST_ASSIGN:

        eval_node(node);
        break;
    case AST_IF:
    {
        Value c = eval_node(node->data.if_stmt.cond);
        if (c.type != VAL_BOOL)
        {
            fprintf(stderr, "Erro de tipo: a condição do 'if' deve ser booleana (true ou false).\n");
            exit(1);
        }
        if (c.data.b)
            exec_ast(node->data.if_stmt.then_branch);
        else if (node->data.if_stmt.else_branch)
            exec_ast(node->data.if_stmt.else_branch);
        break;
    }
    default:
        eval_node(node);
    }
}
