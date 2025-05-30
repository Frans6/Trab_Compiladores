#include "../parser/ast.h"
#include "../parser/tabela.h"
#include <stdio.h>

// Protótipos das funções de avaliação
int avaliar_expressao(NoAst *no, TabelaSimbolos *tabela);
void avaliar_atribuicao(NoAst *no, TabelaSimbolos *tabela);

int avaliar_operacao(NoAst *no, TabelaSimbolos *tabela)
{
    int esq = avaliar_expressao(no->dados.operacao.esquerda, tabela);
    int dir = avaliar_expressao(no->dados.operacao.direita, tabela);

    switch (no->dados.operacao.operador)
    {
    case ADICAO:
        return esq + dir;
    case SUBTRACAO:
        return esq - dir;
    case MULTIPLICACAO:
        return esq * dir;
    case DIVISAO:
        return esq / dir;
    case MODULO:
        return esq % dir;
    default:
        fprintf(stderr, "Operador desconhecido\n");
        return 0;
    }
}

int avaliar_expressao(NoAst *no, TabelaSimbolos *tabela)
{
    if (!no)
        return 0;

    switch (no->tipo)
    {
    case NODO_VALOR:
        return no->dados.literal.valor.int_val;

    case NODO_IDENTIFICADOR:
    {
        Simbolo *sym = buscar_simbolo(tabela, no->dados.identificador);
        if (sym && sym->tipo == TIPO_INT)
        {
            return *(int *)sym->valor;
        }
        else
        {
            fprintf(stderr, "Variável não encontrada: %s\n", no->dados.identificador);
            return 0;
        }
    }

    case NODO_OPERACAO:
        return avaliar_operacao(no, tabela);

    case NODO_ATRIBUICAO:
        avaliar_atribuicao(no, tabela);
        return 0;

    default:
        fprintf(stderr, "Tipo de nó não suportado: %d\n", no->tipo);
        return 0;
    }
}

void avaliar_atribuicao(NoAst *no, TabelaSimbolos *tabela)
{
    int valor = avaliar_expressao(no->dados.atribuicao.valor, tabela);

    // Verificar se a variável já existe
    Simbolo *sym = buscar_simbolo(tabela, no->dados.atribuicao.nome);
    if (sym)
    {
        // Atualizar valor existente
        *(int *)sym->valor = valor;
    }
    else
    {
        // Criar novo símbolo
        int *valor_alocado = malloc(sizeof(int));
        *valor_alocado = valor;
        inserir_simbolo(tabela, no->dados.atribuicao.nome, TIPO_INT, valor_alocado);
    }
}

int main()
{
    TabelaSimbolos *tabela = criar_tabela();

    // Criar AST: resultado = (10 + 5) * 2
    NoAst *soma = criar_no_operacao(ADICAO, criar_no_valor_int(10, 1), criar_no_valor_int(5, 1), 1);

    NoAst *multiplicacao = criar_no_operacao(MULTIPLICACAO, soma, criar_no_valor_int(2, 1), 1);

    NoAst *atribuicao = criar_no_atribuicao("resultado", multiplicacao, 1);

    // Avaliar a expressão
    avaliar_expressao(atribuicao, tabela);

    // Verificar resultado
    Simbolo *sym = buscar_simbolo(tabela, "resultado");
    if (sym && sym->tipo == TIPO_INT)
    {
        printf("\n=== CASO 1 - RESULTADO ESPERADO === \n");
        printf("\n resultado = (10 + 5) * 2   ---> 30 \n");
        printf("\n=== CASO 1 - RESULTADO OBTIDO === \n");
        printf("Resultado: %d\n", *(int *)sym->valor); // Agora deve imprimir 30
    }
    else
    {
        printf("Erro: Variável 'resultado' não encontrada!\n");
    }

    TabelaSimbolos *tabela2 = criar_tabela();

    // Criar AST para:
    // a = 20
    // b = 5
    // resultado = (a * 3) - (b + 10) / 3

    // a = 20
    NoAst *atrib_a = criar_no_atribuicao("a", criar_no_valor_int(20, 1), 1);

    // b = 5
    NoAst *atrib_b = criar_no_atribuicao("b", criar_no_valor_int(5, 2), 2);

    // Expressão principal:
    NoAst *expr = criar_no_operacao(SUBTRACAO,
                                    criar_no_operacao(MULTIPLICACAO,
                                                      criar_no_identificador("a", 3),
                                                      criar_no_valor_int(3, 3),
                                                      3),
                                    criar_no_operacao(DIVISAO,
                                                      criar_no_operacao(ADICAO,
                                                                        criar_no_identificador("b", 3),
                                                                        criar_no_valor_int(10, 3),
                                                                        3),
                                                      criar_no_valor_int(3, 3),
                                                      3),
                                    3);

    NoAst *atrib_resultado = criar_no_atribuicao("resultado", expr, 3);

    // Criar bloco de instruções
    NoAst **instrucoes = malloc(sizeof(NoAst *) * 3);
    instrucoes[0] = atrib_a;
    instrucoes[1] = atrib_b;
    instrucoes[2] = atrib_resultado;

    BlocoDeclaracoes *bloco = criar_bloco_declaracoes(instrucoes, 3);
    NoAst *no_bloco = criar_no_bloco(bloco, 1);

    // Avaliar todo o bloco
    for (int i = 0; i < bloco->quantidade; i++)
    {
        avaliar_expressao(bloco->declaracoes[i], tabela);
    }

    // Verificar resultados
    Simbolo *s;

    printf("\n=== CASO 2 - RESULTADO ESPERADO === \n");
    printf("\n a = 20; b = 5; resultado = (20*3) - (5+10)/3 = 60 - 15/3 = 60 - 5   ---> 55 \n");
    s = buscar_simbolo(tabela, "a");
    printf("\n=== CASO 2 - RESULTADO OBTIDO === \n");
    printf("a = %d\n", *(int *)s->valor); // 20

    s = buscar_simbolo(tabela, "b");
    printf("b = %d\n", *(int *)s->valor); // 5

    s = buscar_simbolo(tabela, "resultado");
    printf("resultado = %d\n", *(int *)s->valor); // (20*3) - (5+10)/3 = 60 - 15/3 = 60 - 5 = 55

    // Limpeza
    destruir_ast(atribuicao);
    destruir_tabela(tabela);
    destruir_ast(no_bloco);
    destruir_tabela(tabela2);

    return 0;
}