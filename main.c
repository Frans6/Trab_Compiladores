#include <stdio.h>
#include "parser/ast.h"
int yyparse();
extern ASTNode* raiz_ast; // Defina a raiz da AST no parser
int main()
{
    printf("Digite os comandos\n");
    yyparse();
    print_ast(raiz_ast, 0);
    return 0;
}
