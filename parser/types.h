#ifndef TYPES_H
#define TYPES_H

#include <stdbool.h>

typedef struct {
    int type; // 0=int, 1=float, 2=string, 3=bool
    union {
        int int_val;
        double float_val;
        char* str_val;
        bool bool_val;
    } value;
} Expression;

#endif