#include <stdio.h>

int yyparse();

int main()
{
    printf("Digite os comandos\n");
    yyparse();
    return 0;
}
