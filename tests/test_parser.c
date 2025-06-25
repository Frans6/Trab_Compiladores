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
        yyin = fopen(argv[i], "r");
        if (!yyin)
        {
            printf("❌ Erro ao abrir arquivo '%s'\n", argv[i]);
            continue;
        }

        yydebug = 0;
        int result = yyparse();
        fclose(yyin);

        if (result == 0)
        {
            printf("✅ %s\n", argv[i]);
        }
        else
        {
            printf("❌ %s\n", argv[i]);
        }
    }

    return 0;
}
