#include <stdio.h>
#include "parser/ast.h"
#include "parser/interpretador.h"

extern int yyparse();
extern FILE* yyin;
extern NoAst* raiz_ast;

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo.py>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Nao foi possivel abrir o arquivo");
        return 1;
    }

    yyin = file;

    if (yyparse() == 0) {
        printf("Analise sintatica concluida com sucesso!\n");
        if (raiz_ast) {
            printf("AST criada com sucesso\n");
        } else {
            printf("ERRO: AST raiz é NULL!\n");
            return 1;
        }
        printf("--- INICIO DA EXECUCAO ---\n");
        interpretar(raiz_ast);
        printf("--- FIM DA EXECUCAO ---\n");
    } else {
        printf("Analise sintatica falhou.\n");
    }

    fclose(file);
    printf("Programa finalizado.\n");
    return 0;
}

//comando para ver a causa do segmentation fault:
//make clean && make
//python3 indent_preproc.py teste.py > build/processed.py
//gdb --args ./interpretador build/processed.py
//dps q tiver dentro, ele roda até travar, quando aparecer (gdb) digite:
//(gdb) run
//o programa vai rodar e terminar com a seguinnte mensagem Program received signal SIGSEGV, Segmentation fault.
//aí você pode usar o comando bt para ver o backtrace e descobrir onde está o erro.
//(gdb) bt OU (gdb) backtrace
// Isso vai mostrar a pilha de chamadas e onde ocorreu o erro.
//para sair basta digitar quit ou q
// (gdb) quit
