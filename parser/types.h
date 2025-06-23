#ifndef TYPES_H
#define TYPES_H
#include <stdbool.h>

struct NoAst;

typedef struct {
    struct NoAst** args;
    int count;
} ArgList;

typedef enum { TIPO_INT, TIPO_FLOAT, TIPO_STRING, TIPO_BOOL, TIPO_NULO } TipoDado;

typedef struct {
    TipoDado tipo;
    union { int int_val; double float_val; char* string_val; bool bool_val; } valor;
    bool is_break; bool is_continue;
} Resultado;

typedef enum {
    NODO_OPERACAO, NODO_VALOR, NODO_IDENTIFICADOR, NODO_ATRIBUICAO,
    NODO_CHAMADA_FUNCAO, NODO_CONDICIONAL, NODO_LOOP, NODO_BLOCO,
    NODO_BREAK, NODO_CONTINUE
} TipoNo;

typedef enum {
    ADICAO, SUBTRACAO, MULTIPLICACAO, DIVISAO, MODULO, POTENCIA,
    IGUAL, DIFERENTE, MENOR, MENOR_IGUAL, MAIOR, MAIOR_IGUAL,
    E_LOGICO, OU_LOGICO, NAO_LOGICO
} TipoOperador;
#endif