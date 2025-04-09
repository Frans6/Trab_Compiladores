#include <stdio.h>

int yyparse();

int main()
{
    printf("Digite comandos (ex: print 2 + 3;):\n");
    yyparse();
    return 0;
}
