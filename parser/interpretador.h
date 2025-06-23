#ifndef INTERPRETADOR_H
#define INTERPRETADOR_H

#include "ast.h" // Precisa conhecer a estrutura NoAst

/**
 * @brief Inicia o processo de interpretação da Árvore Sintática Abstrata.
 * * Esta é a única função pública do módulo interpretador. Ela cria o escopo global
 * e começa a percorrer a árvore a partir do nó raiz.
 * * @param raiz O ponteiro para o nó raiz da AST gerada pelo parser.
 */
void interpretar(NoAst* raiz);

#endif