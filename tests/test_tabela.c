#include "../parser/tabela.h"
#include <stdio.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// impressão para vermos o comportamento da tabela de simbolos
void imprimir_tabela_detalhada(TabelaSimbolos *ts)
{
    if (ts == NULL)
    {
        printf("Tabela de simbolos vazia!\n");
        return;
    }

    printf("\n=== Conteudo Detalhado da Tabela de Simbolos ===\n");
    printf("%-20s | %-8s | %-15s\n", "Nome", "Tipo", "Valor");
    printf("---------------------------------------------------\n");

    int simbolos_imprimidos = 0;

    for (int i = 0; i < TAMANHO_TABELA; i++)
    {
        EntradaTabela *entrada = ts->entradas[i];
        while (entrada != NULL)
        {
            // frmata o valor de acordo com o tipo
            char valor_str[50];
            switch (entrada->simbolo->tipo)
            {
            case TIPO_INT:
                snprintf(valor_str, sizeof(valor_str), "%d", *(int *)entrada->simbolo->valor);
                break;
            case TIPO_FLOAT:
                snprintf(valor_str, sizeof(valor_str), "%.4f", *(float *)entrada->simbolo->valor);
                break;
            case TIPO_STRING:
                snprintf(valor_str, sizeof(valor_str), "\"%s\"", *(char **)entrada->simbolo->valor);
                break;
            case TIPO_BOOL:
                snprintf(valor_str, sizeof(valor_str), "%s", *(bool *)entrada->simbolo->valor ? "true" : "false");
                break;
            case TIPO_NULO:
                strcpy(valor_str, "null");
                break;
            default:
                strcpy(valor_str, "?");
            }

            // formata o nome do tipo
            const char *tipo_str = "";
            switch (entrada->simbolo->tipo)
            {
            case TIPO_INT:
                tipo_str = "int";
                break;
            case TIPO_FLOAT:
                tipo_str = "float";
                break;
            case TIPO_STRING:
                tipo_str = "string";
                break;
            case TIPO_BOOL:
                tipo_str = "bool";
                break;
            case TIPO_NULO:
                tipo_str = "null";
                break;
            }

            printf("%-20s | %-8s | %-15s\n",
                   entrada->simbolo->nome,
                   tipo_str,
                   valor_str);

            entrada = entrada->proximo;
            simbolos_imprimidos++;
        }
    }

    if (simbolos_imprimidos == 0)
    {
        printf("<< Tabela vazia >>\n");
    }
    printf("Total de simbolos: %d\n", simbolos_imprimidos);
}

void teste_criacao_destruicao(TabelaSimbolos *tabela)
{
    printf("\n=== Teste 1: Criacao e Destruicao ===\n");
    assert(tabela != NULL);
    printf("SUCESSO: Tabela criada\n");
}

void teste_insercao_busca(TabelaSimbolos *tabela)
{
    printf("\n=== Teste 2: Insercao e Busca ===\n");

    // int
    int valor_x = 42;
    inserir_simbolo(tabela, "x", TIPO_INT, &valor_x);

    // string
    char *texto_original = "Ola Mundo";
    inserir_simbolo(tabela, "mensagem", TIPO_STRING, &texto_original);

    // float
    float pi = 3.14159f;
    inserir_simbolo(tabela, "pi", TIPO_FLOAT, &pi);

    // booleano
    bool flag = true;
    inserir_simbolo(tabela, "ativo", TIPO_BOOL, &flag);

    // nulo
    inserir_simbolo(tabela, "vazio", TIPO_NULO, NULL);

    // verificações
    Simbolo *s1 = buscar_simbolo(tabela, "x");
    assert(s1 != NULL && s1->tipo == TIPO_INT && *(int *)s1->valor == 42);

    Simbolo *s2 = buscar_simbolo(tabela, "mensagem");
    assert(s2 != NULL && s2->tipo == TIPO_STRING);
    assert(strcmp(*(char **)s2->valor, "Ola Mundo") == 0);

    Simbolo *s3 = buscar_simbolo(tabela, "pi");
    assert(s3 != NULL && s3->tipo == TIPO_FLOAT);
    assert(*(float *)s3->valor == 3.14159f);

    Simbolo *s4 = buscar_simbolo(tabela, "ativo");
    assert(s4 != NULL && s4->tipo == TIPO_BOOL);
    assert(*(bool *)s4->valor == true);

    Simbolo *s5 = buscar_simbolo(tabela, "vazio");
    assert(s5 != NULL && s5->tipo == TIPO_NULO);
    assert(s5->valor == NULL);

    // busca por símbolo inexistente
    assert(buscar_simbolo(tabela, "inexistente") == NULL);

    printf("SUCESSO: Todos os valores foram inseridos e recuperados corretamente\n");
}

void teste_atualizacao(TabelaSimbolos *tabela)
{
    printf("\n=== Teste 3: Atualizacao de Valores ===\n");

    int valor1 = 10;
    inserir_simbolo(tabela, "variavel", TIPO_INT, &valor1);

    int valor2 = 20;
    inserir_simbolo(tabela, "variavel", TIPO_INT, &valor2);

    Simbolo *s = buscar_simbolo(tabela, "variavel");
    assert(s != NULL);
    assert(*(int *)s->valor == 20);
    printf("SUCESSO: Valor atualizado corretamente\n");
}

void teste_remocao(TabelaSimbolos *tabela)
{
    printf("\n=== Teste 4: Remoção ===\n");

    float temp = 36.5;
    inserir_simbolo(tabela, "temperatura", TIPO_FLOAT, &temp);

    remover_simbolo(tabela, "temperatura");
    assert(buscar_simbolo(tabela, "temperatura") == NULL);
    printf("SUCESSO: Simbolo removido corretamente\n");

    // remoção de simbolo inexistente(na teoria não é para dar erro)
    remover_simbolo(tabela, "fantasma");
    printf("SUCESSO: Remocao segura de símbolo inexistente\n");
}

void teste_colisoes_hash(TabelaSimbolos *tabela)
{
    printf("\n=== Teste 5: Colisoes de Hash ===\n");

    // Estes símbolos devem gerar colisão (dependendo da função hash)
    int a = 1, b = 2, c = 3;
    inserir_simbolo(tabela, "chave1", TIPO_INT, &a);
    inserir_simbolo(tabela, "chave2", TIPO_INT, &b);
    inserir_simbolo(tabela, "chave3", TIPO_INT, &c);

    Simbolo *s1 = buscar_simbolo(tabela, "chave1");
    Simbolo *s2 = buscar_simbolo(tabela, "chave2");
    Simbolo *s3 = buscar_simbolo(tabela, "chave3");

    assert(s1 != NULL && *(int *)s1->valor == 1);
    assert(s2 != NULL && *(int *)s2->valor == 2);
    assert(s3 != NULL && *(int *)s3->valor == 3);

    // Remover do meio da lista
    remover_simbolo(tabela, "chave2");
    assert(buscar_simbolo(tabela, "chave2") == NULL);
    assert(*(int *)buscar_simbolo(tabela, "chave1")->valor == 1);
    assert(*(int *)buscar_simbolo(tabela, "chave3")->valor == 3);

    printf("SUCESSO: Colisoes tratadas corretamente\n");
}

void teste_estresse()
{
    printf("\n=== Teste 6: Estresse ===\n");
    TabelaSimbolos *tabela = criar_tabela();
    const int NUM_INSERCOES = 10000;

    for (int i = 0; i < NUM_INSERCOES; i++)
    {
        char nome[50];
        sprintf(nome, "var%d", i);

        int *valor = malloc(sizeof(int));
        *valor = i;
        inserir_simbolo(tabela, nome, TIPO_INT, valor);
    }

    // Verificar todas as inserções
    for (int i = 0; i < NUM_INSERCOES; i++)
    {
        char nome[50];
        sprintf(nome, "var%d", i);

        Simbolo *s = buscar_simbolo(tabela, nome);
        assert(s != NULL);
        assert(*(int *)s->valor == i);
    }

    printf("SUCESSO: %d insercoes/verificacoes realizadas\n", NUM_INSERCOES);

    // Imprime resumo em vez de todos os símbolos
    int total_simbolos = 0;
    for (int i = 0; i < TAMANHO_TABELA; i++)
    {
        EntradaTabela *entrada = tabela->entradas[i];
        while (entrada != NULL)
        {
            total_simbolos++;
            entrada = entrada->proximo;
        }
    }
    printf("\nTotal de simbolos na tabela: %d\n", total_simbolos);

    destruir_tabela(tabela);
}

int main()
{
    // Cria uma tabela persistente para a maioria dos testes
    TabelaSimbolos *tabela_principal = criar_tabela();

    teste_criacao_destruicao(tabela_principal);
    imprimir_tabela_detalhada(tabela_principal);

    teste_insercao_busca(tabela_principal);
    imprimir_tabela_detalhada(tabela_principal);

    teste_atualizacao(tabela_principal);
    imprimir_tabela_detalhada(tabela_principal);

    teste_remocao(tabela_principal);
    imprimir_tabela_detalhada(tabela_principal);

    teste_colisoes_hash(tabela_principal);
    imprimir_tabela_detalhada(tabela_principal);

    // teste de estresse usa sua própria tabela por motivos de: mil linhas kkkkk
    teste_estresse();

    destruir_tabela(tabela_principal);

    printf("\nOS TESTES FORAM CONCLUIDOS, GALERA!\n");
    return 0;
}