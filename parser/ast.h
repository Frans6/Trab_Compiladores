#ifndef AST_H
#define AST_H

#include "tabela.h"
#include "types.h"
#include <stdbool.h>
#include <stdlib.h>

typedef struct NoAst NoAst;

typedef struct BlocoDeclaracoes
{
    NoAst **declaracoes;
    int quantidade;
} BlocoDeclaracoes;

struct NoAst
{
    TipoNo tipo;
    int linha;

    union
    {
        // Operações binárias (a + b, a % b, etc)
        struct
        {
            TipoOperador operador;
            NoAst *esquerda;
            NoAst *direita;
        } operacao;

        // Valores (inteiro, float, string, bool)
        struct
        {
            TipoDado tipo;
            union
            {
                int int_val;
                double float_val;
                char *string_val;
                bool bool_val;
            } valor;
        } literal;

        // Identificador (variável)
        char *identificador;

        // Atribuição (x = 10)
        struct
        {
            char *nome;
            NoAst *valor;
        } atribuicao;

        // Chamada de função (print("oi"))
        struct
        {
            char *nome_funcao;
            NoAst **argumentos;
            int num_argumentos;
        } chamada_funcao;

        // Condicional (if/else)
        struct
        {
            NoAst *condicao;
            BlocoDeclaracoes *bloco_if;
            BlocoDeclaracoes *bloco_else;
        } condicional;

        // Loop (while)
        struct
        {
            NoAst *condicao;
            BlocoDeclaracoes *bloco;
        } loop;

        // Bloco de declarações ({ ... })
        BlocoDeclaracoes *bloco;
    } dados;
};

// Métodos para criação de nós
NoAst *criar_no_operacao(TipoOperador op, NoAst *esq, NoAst *dir, int linha);
NoAst *criar_no_valor_int(int valor, int linha);
NoAst *criar_no_valor_float(double valor, int linha);
NoAst *criar_no_valor_string(const char *valor, int linha);
NoAst *criar_no_valor_bool(bool valor, int linha);
NoAst *criar_no_identificador(const char *id, int linha);
NoAst *criar_no_atribuicao(const char *nome, NoAst *valor, int linha);
NoAst *criar_no_chamada_funcao(const char *nome, NoAst **args, int num_args, int linha);
NoAst *criar_no_condicional(NoAst *condicao, BlocoDeclaracoes *bloco_if, BlocoDeclaracoes *bloco_else, int linha);
NoAst *criar_no_loop(NoAst *condicao, BlocoDeclaracoes *bloco, int linha);
BlocoDeclaracoes *criar_bloco_declaracoes(NoAst **declaracoes, int quantidade);
NoAst *criar_no_bloco(BlocoDeclaracoes *bloco, int linha);
NoAst* criar_no_break(int linha);
NoAst* criar_no_continue(int linha);

// Método para destruir a AST
void destruir_ast(NoAst *no);

#endif