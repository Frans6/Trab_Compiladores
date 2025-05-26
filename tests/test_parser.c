#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern FILE *yyin;
extern int yydebug;


#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern FILE *yyin;
extern int yydebug;

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo>\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        printf("=== Running test %d: %s ===\n", i, argv[i]);
        yyin = fopen(argv[i], "r");
        if (!yyin) {
            perror("Erro ao abrir arquivo");
            continue;
        }

        yydebug = 1;  // Ativa debug do bison
        int result = yyparse();

        fclose(yyin);

        if (result == 0) {
            printf("Parsing succeeded!\n\n");
        } else {
            printf("Parsing failed with errors!\n\n");
        }
    }

    return 0;
}
