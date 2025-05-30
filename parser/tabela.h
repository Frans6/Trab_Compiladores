#ifndef TABELA_H
#define TABELA_H

#include <stdlib.h>
#include <stdbool.h>

#define TAMANHO_TABELA 256

typedef enum {
    TIPO_INT,
    TIPO_FLOAT,
    TIPO_STRING,
    TIPO_BOOL,
    TIPO_NULO,
} TipoDado;

typedef struct Simbolo {
    char* nome;
    TipoDado tipo;
    void* valor;
} Simbolo;

typedef struct EntradaTabela {
    char* chave;
    Simbolo* simbolo;
    struct EntradaTabela* proximo;
} EntradaTabela;

typedef struct {
    EntradaTabela** entradas;
} TabelaSimbolos;

TabelaSimbolos* criar_tabela();
void destruir_tabela(TabelaSimbolos* tabela);
void inserir_simbolo(TabelaSimbolos* tabela, const char* nome, TipoDado tipo, void* valor);
Simbolo* buscar_simbolo(TabelaSimbolos* tabela, const char* nome);
void remover_simbolo(TabelaSimbolos* tabela, const char* nome);
void imprimir_tabela(TabelaSimbolos* tabela);

#endif