#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include "types.h"

typedef struct Symbol {
    char* name;
    Expression expr;
    struct Symbol* next;
} Symbol;

extern Symbol* symbol_table;

Symbol* find_symbol(char* name);
void add_symbol(char* name, Expression expr);
void free_symbol_table();

#endif