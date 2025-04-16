#ifndef TYPES_H
#define TYPES_H

#include <stdbool.h> 

typedef struct {
    enum { INT_T, FLOAT_T, STRING_T, BOOL_T } type;
    union {
        int int_val;
        double float_val;
        char* str_val;
        bool bool_val;
    } value;
} Expression;

#endif
