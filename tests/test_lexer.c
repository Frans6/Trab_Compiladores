/* tests/test_lexer.c (VERSÃO MELHORADA) */
#include <stdio.h>
#include <stdlib.h>
#include "../parser/types.h"
#include "../parser/parser.tab.h"

extern int yylex();
extern char *yytext;
extern FILE *yyin;
extern int yylineno;
extern YYSTYPE yylval;

const char *get_token_name(int token) {
    switch (token) {
        case PRINT: return "PRINT";
        case IF: return "IF";
        case ELSE: return "ELSE";
        case WHILE: return "WHILE";
        case BREAK: return "BREAK";
        case CONTINUE: return "CONTINUE";
        case AND: return "AND";
        case OR: return "OR";
        case NOT: return "NOT";
        case ID: return "ID";
        case INT: return "INT";
        case FLOAT: return "FLOAT";
        case STRING: return "STRING";
        case BOOL: return "BOOL";
        case ADD: return "ADD";
        case SUB: return "SUB";
        case MUL: return "MUL";
        case DIV: return "DIV";
        case POW: return "POW"; // Adicionado
        case MOD: return "MOD"; // Adicionado
        case ASSIGN: return "ASSIGN";
        case EQ: return "EQ";
        case NEQ: return "NEQ";
        case GT: return "GT";
        case LT: return "LT";
        case GTE: return "GTE";
        case LTE: return "LTE";
        case LPAREN: return "LPAREN";
        case RPAREN: return "RPAREN";
        case COLON: return "COLON";
        case COMMA: return "COMMA";
        case INDENT: return "INDENT";
        case DEDENT: return "DEDENT";
        case NEWLINE: return "NEWLINE";
        case INPUT: return "INPUT"; // Adicionado
        default: return "TOKEN_DESCONHECIDO";
    }
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo_de_teste>\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    int token;
    printf("--- Iniciando Analise Lexica de '%s' ---\n\n", argv[1]);

    while ((token = yylex())) {

        printf("Linha %-3d | Token: %-15s | ", yylineno, get_token_name(token));

        // Para INDENT/DEDENT, não imprimimos o yytext
        if (token == INDENT || token == DEDENT || token == NEWLINE) {
            printf("[Controle de Bloco/Linha]");
        } else {
            printf("Texto: '%s'", yytext);
        }

        // Imprime o valor associado ao token, se houver
        switch (token) {
            case INT: printf(" (Valor: %d)", yylval.int_val); break;
            case FLOAT: printf(" (Valor: %f)", yylval.float_val); break;
            case ID: case STRING: printf(" (Valor: \"%s\")", yylval.str_val); break;
            case BOOL: printf(" (Valor: %s)", yylval.bool_val ? "true" : "false"); break;
        }
        printf("\n");
    }

    printf("\n--- Fim da Analise Lexica ---\n");
    fclose(yyin);
    return 0;
}