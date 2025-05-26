#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "symbol_table.h"

Symbol* symbol_table = NULL;


Symbol* find_symbol(char* name) {
    Symbol* s = symbol_table;
    while(s) {
        if(strcmp(s->name, name) == 0) return s;
        s = s->next;
    }
    return NULL;
}

void add_symbol(char* name, Expression expr) {
    Symbol* s = find_symbol(name);
    if (s) {
        s->expr = expr;
        return;
    }
    s = (Symbol*)malloc(sizeof(Symbol));
    s->name = strdup(name);
    s->expr = expr;
    s->next = symbol_table;
    symbol_table = s;
}

void free_symbol_table() {
    Symbol* s = symbol_table;
    while (s) {
        Symbol* next = s->next;
        free(s->name);
        if (s->expr.type == 2 && s->expr.value.str_val)
            free(s->expr.value.str_val);
        free(s);
        s = next;
    }
    symbol_table = NULL;
}