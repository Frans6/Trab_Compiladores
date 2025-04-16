#include <stdio.h>
#include <stdlib.h>
#include "../parser/types.h"
#include "../parser/parser.tab.h"

extern int yylex();
extern char *yytext;
extern FILE *yyin;
extern int line_num;

const char *token_name(int token)
{
    switch (token)
    {
    case COLON:
        return "COLON";
    case PRINT:
        return "PRINT";
    case INPUT:
        return "INPUT";
    case IF:
        return "IF";
    case ELSE:
        return "ELSE";
    case ELIF:
        return "ELIF";
    case BOOL:
        return "BOOL";
    case FLOAT:
        return "FLOAT";
    case INT:
        return "INT";
    case STRING:
        return "STRING";
    case LPAREN:
        return "LPAREN";
    case RPAREN:
        return "RPAREN";
    case ADD:
        return "ADD";
    case SUB:
        return "SUB";
    case MUL:
        return "MUL";
    case DIV:
        return "DIV";
    case POW:
        return "POW";
    case MOD:
        return "MOD";
    case ASSIGN:
        return "ASSIGN";
    case NOT:
        return "NOT";
    case EQ:
        return "EQ";
    case NEQ:
        return "NEQ";
    case GT:
        return "GT";
    case LT:
        return "LT";
    case GTE:
        return "GTE";
    case LTE:
        return "LTE";
    case ID:
        return "ID";
    case NEWLINE:
        return "NEWLINE";
    default:
        return "UNKNOWN";
    }
}

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("Uso: %s <arquivo_de_teste>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin)
    {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    int token;
    int current_line = 1;
    printf("Linha %d:\n", current_line);

    while ((token = yylex()))
    {
        if (line_num > current_line)
        {
            current_line = line_num;
            printf("\nLinha %d:\n", current_line);
        }

        printf("%s = (%s) ", token_name(token), yytext);
    }

    fclose(yyin);
    return 0;
}
