#include "../parser/ast.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

//PARA RODAR ESSE TESTE, USE OS COMANDOS NA PASTA TESTS:
// gcc ../parser/ast.c test_ast.c -o testes_ast
// ./testes_ast

void teste_criacao_nos_basicos()
{
    printf("\n=== Teste 1: Criacao de Nos basicos ===\n");

    // Teste nó de valor inteiro
    NoAst *valor_int = criar_no_valor_int(42, 1);
    assert(valor_int->tipo == NODO_VALOR);
    assert(valor_int->dados.literal.tipo == TIPO_INT);
    assert(valor_int->dados.literal.valor.int_val == 42);
    printf("SUCESSO: No valor int\n");

    // Teste nó de string
    NoAst *valor_str = criar_no_valor_string("hello", 2);
    assert(valor_str->tipo == NODO_VALOR);
    assert(valor_str->dados.literal.tipo == TIPO_STRING);
    assert(strcmp(valor_str->dados.literal.valor.string_val, "hello") == 0);
    printf("SUCESSO: No valor string\n");

    // Teste nó identificador
    NoAst *ident = criar_no_identificador("variavel", 3);
    assert(ident->tipo == NODO_IDENTIFICADOR);
    assert(strcmp(ident->dados.identificador, "variavel") == 0);
    printf("SUCESSO: No identificador\n");

    destruir_ast(valor_int);
    destruir_ast(valor_str);
    destruir_ast(ident);
}

void teste_operacoes_aritmeticas()
{
    printf("\n=== Teste 2: Operacoes Aritmeticas ===\n");

    NoAst *num1 = criar_no_valor_int(10, 1);
    NoAst *num2 = criar_no_valor_int(5, 1);
    NoAst *soma = criar_no_operacao(ADICAO, num1, num2, 1);

    assert(soma->tipo == NODO_OPERACAO);
    assert(soma->dados.operacao.operador == ADICAO);
    assert(soma->dados.operacao.esquerda == num1);
    assert(soma->dados.operacao.direita == num2);
    printf("SUCESSO: Operação de adicao\n");

    NoAst *modulo = criar_no_operacao(MODULO,
                                      criar_no_valor_int(17, 2),
                                      criar_no_valor_int(5, 2),
                                      2);

    assert(modulo->dados.operacao.operador == MODULO);
    printf("SUCESSO: Operacao de mod\n");

    destruir_ast(soma);
    destruir_ast(modulo);
}

void teste_estruturas_controle()
{
    printf("\n=== Teste 3: Estruturas de Controle ===\n");

    // Criação de bloco if/else
    NoAst *condicao = criar_no_operacao(MAIOR,
                                        criar_no_identificador("x", 1),
                                        criar_no_valor_int(0, 1),
                                        1);

    BlocoDeclaracoes *bloco_if = criar_bloco_declaracoes(
        (NoAst *[]){
            criar_no_atribuicao("y", criar_no_valor_int(1, 2), 2)},
        1);

    BlocoDeclaracoes *bloco_else = criar_bloco_declaracoes(
        (NoAst *[]){
            criar_no_atribuicao("y", criar_no_valor_int(0, 4), 4)},
        1);

    NoAst *if_else = criar_no_condicional(condicao, bloco_if, bloco_else, 1);

    assert(if_else->tipo == NODO_CONDICIONAL);
    assert(if_else->dados.condicional.condicao == condicao);
    assert(if_else->dados.condicional.bloco_if->quantidade == 1);
    assert(if_else->dados.condicional.bloco_else->quantidade == 1);
    printf("SUCESSO: Condicional if/else\n");

    // Criação de loop while
    BlocoDeclaracoes *bloco_while = criar_bloco_declaracoes(
        (NoAst *[]){
            criar_no_atribuicao("contador",
                                criar_no_operacao(ADICAO,
                                                  criar_no_identificador("contador", 6),
                                                  criar_no_valor_int(1, 6),
                                                  6),
                                6)},
        1);

    NoAst *loop = criar_no_loop(
        criar_no_operacao(MENOR,
                          criar_no_identificador("contador", 5),
                          criar_no_valor_int(10, 5),
                          5),
        bloco_while,
        5);

    assert(loop->tipo == NODO_LOOP);
    assert(loop->dados.loop.condicao->dados.operacao.operador == MENOR);
    printf("SUCESSO: Loop while\n");

    destruir_ast(if_else);
    destruir_ast(loop);
}

void teste_chamada_funcao()
{
    printf("\n=== Teste 4: Chamada de Funaoo ===\n");

    NoAst **args = (NoAst *[]){
        criar_no_valor_string("Mundo", 1),
        criar_no_valor_int(42, 1)};

    NoAst *chamada = criar_no_chamada_funcao("saudacao", args, 2, 1);

    assert(chamada->tipo == NODO_CHAMADA_FUNCAO);
    assert(strcmp(chamada->dados.chamada_funcao.nome_funcao, "saudacao") == 0);
    assert(chamada->dados.chamada_funcao.num_argumentos == 2);
    assert(chamada->dados.chamada_funcao.argumentos[0]->dados.literal.valor.string_val != NULL);
    printf("SUCESSO: Chamada de funcao com argumentos\n");

    destruir_ast(chamada);
}

void teste_destruicao_ast()
{
    printf("\n=== Teste 5: Destruio Completa ===\n");

    // Cria uma AST complexa
    NoAst *ast_complexa = criar_no_bloco(
        criar_bloco_declaracoes(
            (NoAst *[]){
                criar_no_atribuicao("total",
                                    criar_no_operacao(ADICAO,
                                                      criar_no_valor_int(10, 1),
                                                      criar_no_operacao(MULTIPLICACAO,
                                                                        criar_no_identificador("x", 1),
                                                                        criar_no_valor_int(5, 1),
                                                                        1),
                                                      1),
                                    1),
                criar_no_condicional(
                    criar_no_operacao(MAIOR_IGUAL,
                                      criar_no_identificador("total", 2),
                                      criar_no_valor_int(100, 2),
                                      2),
                    criar_bloco_declaracoes(
                        (NoAst *[]){
                            criar_no_chamada_funcao("imprimir",
                                                    (NoAst *[]){criar_no_valor_string("Grande!", 3)},
                                                    1, 3)},
                        1),
                    NULL,
                    2)},
            2),
        1);

    // Destroi toda a AST (verificação com valgrind)
    destruir_ast(ast_complexa);
    printf("SUCESSO: AST complexa destruida sem vazamentos\n");
}

void teste_impressao_ast()
{
    printf("\n=== Teste 6: Impressao da AST ===\n");

    // Função auxiliar para imprimir a AST (implementada abaixo)
    void imprimir_ast(NoAst * no, int nivel);

    NoAst *expr = criar_no_operacao(
        MULTIPLICACAO,
        criar_no_operacao(
            ADICAO,
            criar_no_valor_int(2, 1),
            criar_no_valor_int(3, 1),
            1),
        criar_no_valor_int(4, 1),
        1);

    printf("AST para (2 + 3) * 4:\n");
    imprimir_ast(expr, 0);

    destruir_ast(expr);
}

// Função auxiliar recursiva para imprimir a AST
void imprimir_ast(NoAst *no, int nivel)
{
    if (!no)
        return;

    for (int i = 0; i < nivel; i++)
        printf("  ");

    switch (no->tipo)
    {
    case NODO_VALOR:
        if (no->dados.literal.tipo == TIPO_INT)
        {
            printf("VALOR: %d (linha %d)\n", no->dados.literal.valor.int_val, no->linha);
        }
        else if (no->dados.literal.tipo == TIPO_STRING)
        {
            printf("VALOR: \"%s\" (linha %d)\n", no->dados.literal.valor.string_val, no->linha);
        }
        break;

    case NODO_OPERACAO:
        printf("OP: %d (linha %d)\n", no->dados.operacao.operador, no->linha);
        imprimir_ast(no->dados.operacao.esquerda, nivel + 1);
        imprimir_ast(no->dados.operacao.direita, nivel + 1);
        break;

    case NODO_IDENTIFICADOR:
        printf("ID: %s (linha %d)\n", no->dados.identificador, no->linha);
        break;

    case NODO_ATRIBUICAO:
        printf("ATRIB: %s (linha %d)\n", no->dados.atribuicao.nome, no->linha);
        imprimir_ast(no->dados.atribuicao.valor, nivel + 1);
        break;

    case NODO_CONDICIONAL:
        printf("IF (linha %d)\n", no->linha);
        imprimir_ast(no->dados.condicional.condicao, nivel + 1);
        printf("  THEN:\n");
        for (int i = 0; i < no->dados.condicional.bloco_if->quantidade; i++)
        {
            imprimir_ast(no->dados.condicional.bloco_if->declaracoes[i], nivel + 2);
        }
        if (no->dados.condicional.bloco_else)
        {
            printf("  ELSE:\n");
            for (int i = 0; i < no->dados.condicional.bloco_else->quantidade; i++)
            {
                imprimir_ast(no->dados.condicional.bloco_else->declaracoes[i], nivel + 2);
            }
        }
        break;

        // Implementar outros casos conforme necessário
    }
}

int main()
{
    teste_criacao_nos_basicos();
    teste_operacoes_aritmeticas();
    teste_estruturas_controle();
    teste_chamada_funcao();
    teste_destruicao_ast();
    teste_impressao_ast();

    printf("\nTodos os testes da AST passaram com sucesso!\n");
    return 0;
}