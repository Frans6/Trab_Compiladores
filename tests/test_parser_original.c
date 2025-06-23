#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern FILE *yyin;
extern int yydebug;

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        fprintf(stderr, "Uso: %s <arquivo>\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++)
    {
        printf("\n=== Teste %d: Executando parser no arquivo '%s' ===\n", i, argv[i]);
        yyin = fopen(argv[i], "r");
        if (!yyin)
        {
            perror("ERRO: não foi possível abrir o arquivo\n");
            continue;
        }

        yydebug = 1; // Ativa debug do bison
        int result = yyparse();

        fclose(yyin);

        if (result == 0)
        {
            printf("SUCESSO: parsing concluído sem erros!\n");
        }
        else
        {
            printf("FALHA: erros encontrados durante o parsing\n");
        }
    }

    return 0;
}
