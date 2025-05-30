#include "tabela.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static unsigned int funcao_hash(const char *chave)
{
    unsigned long valor = 5381;
    int c;
    while ((c = *chave++))
        valor = ((valor << 5) + valor) + c;
    return valor % TAMANHO_TABELA;
}

TabelaSimbolos *criar_tabela()
{
    TabelaSimbolos *tabela = malloc(sizeof(TabelaSimbolos));
    tabela->entradas = calloc(TAMANHO_TABELA, sizeof(EntradaTabela *));
    return tabela;
}

// Função auxiliar para liberar valor de um símbolo
static void liberar_valor_simbolo(Simbolo *simbolo)
{
    if (simbolo->valor != NULL)
    {
        if (simbolo->tipo == TIPO_STRING)
        {
            free(*(char **)simbolo->valor);
            free(simbolo->valor);
        }
        else if (simbolo->tipo != TIPO_NULO)
        {
            free(simbolo->valor);
        }
    }
}

void destruir_tabela(TabelaSimbolos *tabela)
{
    if (!tabela)
        return;

    for (int i = 0; i < TAMANHO_TABELA; i++)
    {
        EntradaTabela *entrada = tabela->entradas[i];
        while (entrada != NULL)
        {
            EntradaTabela *temp = entrada;
            entrada = entrada->proximo;

            if (temp->simbolo)
            {
                liberar_valor_simbolo(temp->simbolo);
                free(temp->simbolo->nome);
                free(temp->simbolo);
            }
            free(temp->chave);
            free(temp);
        }
    }
    free(tabela->entradas);
    free(tabela);
}

//função auxiliar para duplicar valores -> assim conseguimos "arrumar" os problemas de variaveis locais e globais
static void *duplicar_valor(TipoDado tipo, void *valor)
{
    if (valor == NULL)
    {
        return NULL;
    }

    switch (tipo)
    {
    case TIPO_INT:
    {
        int *copia = malloc(sizeof(int));
        *copia = *(int *)valor;
        return copia;
    }
    case TIPO_FLOAT:
    {
        float *copia = malloc(sizeof(float));
        *copia = *(float *)valor;
        return copia;
    }
    case TIPO_BOOL:
    {
        bool *copia = malloc(sizeof(bool));
        *copia = *(bool *)valor;
        return copia;
    }
    case TIPO_STRING:
    {
        // Duplica a string
        char *str_original = *(char **)valor;
        char **copia_ptr = malloc(sizeof(char *));
        *copia_ptr = strdup(str_original);
        return copia_ptr;
    }
    case TIPO_NULO:
        return NULL;
    default:
        return NULL;
    }
}

void inserir_simbolo(TabelaSimbolos *tabela, const char *nome, TipoDado tipo, void *valor)
{
    if (!tabela || !nome)
        return;

    unsigned int slot = funcao_hash(nome);
    EntradaTabela *entrada = tabela->entradas[slot];
    EntradaTabela *anterior = NULL;

    // Verificar se o símbolo já existe
    while (entrada != NULL)
    {
        if (strcmp(entrada->chave, nome) == 0)
        {
            // Liberar valor antigo se necessário
            liberar_valor_simbolo(entrada->simbolo);

            // Atualizar tipo e valor
            entrada->simbolo->tipo = tipo;

            if (tipo == TIPO_NULO)
            {
                entrada->simbolo->valor = NULL;
            }
            else
            {
                entrada->simbolo->valor = duplicar_valor(tipo, valor);
            }
            return;
        }
        anterior = entrada;
        entrada = entrada->proximo;
    }

    // Criar novo símbolo
    Simbolo *novo_simbolo = malloc(sizeof(Simbolo));
    novo_simbolo->nome = strdup(nome);
    novo_simbolo->tipo = tipo;

    if (tipo == TIPO_NULO)
    {
        novo_simbolo->valor = NULL;
    }
    else
    {
        novo_simbolo->valor = duplicar_valor(tipo, valor);
    }

    // Criar nova entrada
    EntradaTabela *nova_entrada = malloc(sizeof(EntradaTabela));
    nova_entrada->chave = strdup(nome);
    nova_entrada->simbolo = novo_simbolo;
    nova_entrada->proximo = tabela->entradas[slot];
    tabela->entradas[slot] = nova_entrada;
}

Simbolo *buscar_simbolo(TabelaSimbolos *tabela, const char *nome)
{
    if (!tabela || !nome)
        return NULL;

    unsigned int slot = funcao_hash(nome);
    EntradaTabela *entrada = tabela->entradas[slot];

    while (entrada != NULL)
    {
        if (strcmp(entrada->chave, nome) == 0)
            return entrada->simbolo;
        entrada = entrada->proximo;
    }
    return NULL;
}

void remover_simbolo(TabelaSimbolos *tabela, const char *nome)
{
    if (!tabela || !nome)
        return;

    unsigned int slot = funcao_hash(nome);
    EntradaTabela *entrada = tabela->entradas[slot];
    EntradaTabela *anterior = NULL;

    while (entrada != NULL)
    {
        if (strcmp(entrada->chave, nome) == 0)
        {
            if (anterior == NULL)
            {
                tabela->entradas[slot] = entrada->proximo;
            }
            else
            {
                anterior->proximo = entrada->proximo;
            }

            // Liberar memória do símbolo
            if (entrada->simbolo)
            {
                liberar_valor_simbolo(entrada->simbolo);
                free(entrada->simbolo->nome);
                free(entrada->simbolo);
            }

            free(entrada->chave);
            free(entrada);
            return;
        }
        anterior = entrada;
        entrada = entrada->proximo;
    }
}

void imprimir_tabela(TabelaSimbolos *tabela)
{
    if (!tabela)
        return;

    printf("--- Tabela de Simbolos ---\n");
    for (int i = 0; i < TAMANHO_TABELA; i++)
    {
        EntradaTabela *entrada = tabela->entradas[i];
        while (entrada != NULL)
        {
            printf("Chave: %s, Tipo: %d\n", entrada->chave, entrada->simbolo->tipo);
            entrada = entrada->proximo;
        }
    }
}