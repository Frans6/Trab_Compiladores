#include "ast.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

NoAst* criar_no_operacao(TipoOperador op, NoAst* esq, NoAst* dir, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_OPERACAO;
    no->linha = linha;
    no->dados.operacao.operador = op;
    no->dados.operacao.esquerda = esq;
    no->dados.operacao.direita = dir;
    return no;
}

NoAst* criar_no_valor_int(int valor, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_VALOR;
    no->linha = linha;
    no->dados.literal.tipo = TIPO_INT;
    no->dados.literal.valor.int_val = valor;
    return no;
}

NoAst* criar_no_valor_float(double valor, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_VALOR;
    no->linha = linha;
    no->dados.literal.tipo = TIPO_FLOAT;
    no->dados.literal.valor.float_val = valor;
    return no;
}

NoAst* criar_no_valor_string(const char* valor, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_VALOR;
    no->linha = linha;
    no->dados.literal.tipo = TIPO_STRING;
    no->dados.literal.valor.string_val = strdup(valor);
    return no;
}

NoAst* criar_no_valor_bool(bool valor, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_VALOR;
    no->linha = linha;
    no->dados.literal.tipo = TIPO_BOOL;
    no->dados.literal.valor.bool_val = valor;
    return no;
}

NoAst* criar_no_identificador(const char* id, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_IDENTIFICADOR;
    no->linha = linha;
    no->dados.identificador = strdup(id);
    return no;
}

NoAst* criar_no_atribuicao(const char* nome, NoAst* valor, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_ATRIBUICAO;
    no->linha = linha;
    no->dados.atribuicao.nome = strdup(nome);
    no->dados.atribuicao.valor = valor;
    return no;
}

NoAst* criar_no_chamada_funcao(const char* nome, NoAst** args, int num_args, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_CHAMADA_FUNCAO;
    no->linha = linha;
    no->dados.chamada_funcao.nome_funcao = strdup(nome);
    no->dados.chamada_funcao.argumentos = args;
    no->dados.chamada_funcao.num_argumentos = num_args;
    return no;
}

NoAst* criar_no_condicional(NoAst* condicao, BlocoDeclaracoes* bloco_if, BlocoDeclaracoes* bloco_else, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_CONDICIONAL;
    no->linha = linha;
    no->dados.condicional.condicao = condicao;
    no->dados.condicional.bloco_if = bloco_if;
    no->dados.condicional.bloco_else = bloco_else;
    return no;
}

NoAst* criar_no_loop(NoAst* condicao, BlocoDeclaracoes* bloco, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_LOOP;
    no->linha = linha;
    no->dados.loop.condicao = condicao;
    no->dados.loop.bloco = bloco;
    return no;
}

BlocoDeclaracoes* criar_bloco_declaracoes(NoAst** declaracoes, int quantidade) {
    BlocoDeclaracoes* bloco = malloc(sizeof(BlocoDeclaracoes));
    if (bloco == NULL) return NULL;
    
    bloco->declaracoes = declaracoes;
    bloco->quantidade = quantidade;
    return bloco;
}

NoAst* criar_no_bloco(BlocoDeclaracoes* bloco, int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_BLOCO;
    no->linha = linha;
    no->dados.bloco = bloco;
    return no;
}
NoAst* criar_no_break(int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_BREAK;
    no->linha = linha;
    return no;
}

NoAst* criar_no_continue(int linha) {
    NoAst* no = malloc(sizeof(NoAst));
    no->tipo = NODO_CONTINUE;
    no->linha = linha;
    return no;
}

void destruir_ast(NoAst* no) {
    if (no == NULL) return;
    
    switch (no->tipo) {
        case NODO_OPERACAO:
            destruir_ast(no->dados.operacao.esquerda);
            destruir_ast(no->dados.operacao.direita);
            break;
            
        case NODO_VALOR:
            if (no->dados.literal.tipo == TIPO_STRING && no->dados.literal.valor.string_val != NULL) {
                free(no->dados.literal.valor.string_val);
            }
            break;
            
        case NODO_IDENTIFICADOR:
            if (no->dados.identificador != NULL) {
            free(no->dados.identificador);
            }
            break;
            
        case NODO_ATRIBUICAO:
            if (no->dados.atribuicao.nome != NULL) {
            free(no->dados.atribuicao.nome);
            }
            destruir_ast(no->dados.atribuicao.valor);
            break;
            
        case NODO_CHAMADA_FUNCAO:
            if (no->dados.chamada_funcao.nome_funcao != NULL) {
            free(no->dados.chamada_funcao.nome_funcao);
            }
            if (no->dados.chamada_funcao.argumentos != NULL) {
            for (int i = 0; i < no->dados.chamada_funcao.num_argumentos; i++) {
                    if (no->dados.chamada_funcao.argumentos[i] != NULL) {
                destruir_ast(no->dados.chamada_funcao.argumentos[i]);
                    }
                }
                free(no->dados.chamada_funcao.argumentos);
            }
            break;
            
        case NODO_CONDICIONAL:
            destruir_ast(no->dados.condicional.condicao);
            if (no->dados.condicional.bloco_if != NULL) {
            for (int i = 0; i < no->dados.condicional.bloco_if->quantidade; i++) {
                    if (no->dados.condicional.bloco_if->declaracoes[i] != NULL) {
                destruir_ast(no->dados.condicional.bloco_if->declaracoes[i]);
            }
                }
                if (no->dados.condicional.bloco_if->declaracoes != NULL) {
            free(no->dados.condicional.bloco_if->declaracoes);
                }
            free(no->dados.condicional.bloco_if);
            }
            
            if (no->dados.condicional.bloco_else != NULL) {
                for (int i = 0; i < no->dados.condicional.bloco_else->quantidade; i++) {
                    if (no->dados.condicional.bloco_else->declaracoes[i] != NULL) {
                    destruir_ast(no->dados.condicional.bloco_else->declaracoes[i]);
                    }
                }
                if (no->dados.condicional.bloco_else->declaracoes != NULL) {
                free(no->dados.condicional.bloco_else->declaracoes);
                }
                free(no->dados.condicional.bloco_else);
            }
            break;
            
        case NODO_LOOP:
            destruir_ast(no->dados.loop.condicao);
            if (no->dados.loop.bloco != NULL) {
            for (int i = 0; i < no->dados.loop.bloco->quantidade; i++) {
                    if (no->dados.loop.bloco->declaracoes[i] != NULL) {
                destruir_ast(no->dados.loop.bloco->declaracoes[i]);
            }
                }
                if (no->dados.loop.bloco->declaracoes != NULL) {
            free(no->dados.loop.bloco->declaracoes);
                }
            free(no->dados.loop.bloco);
            }
            break;
            
        case NODO_BLOCO:
            if (no->dados.bloco != NULL) {
            for (int i = 0; i < no->dados.bloco->quantidade; i++) {
                    if (no->dados.bloco->declaracoes[i] != NULL) {
                destruir_ast(no->dados.bloco->declaracoes[i]);
            }
                }
                if (no->dados.bloco->declaracoes != NULL) {
            free(no->dados.bloco->declaracoes);
                }
            free(no->dados.bloco);
            }
            break;
            
        case NODO_BREAK:
        case NODO_CONTINUE:
            // Esses nós não têm filhos nem dados alocados dinamicamente
            break;
    }
    
    free(no);
}