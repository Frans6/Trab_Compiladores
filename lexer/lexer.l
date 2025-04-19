%{
#include "../parser/types.h"
#include "../parser/parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int line_num = 1;
extern YYSTYPE yylval;

/* Definições de tokens INDENT/DEDENT caso não venham do parser */
#ifndef INDENT
#define INDENT 256
#endif
#ifndef DEDENT
#define DEDENT 257
#endif

#define MAX_INDENT 100
static int indent_stack[MAX_INDENT] = {0};
static int indent_top = 0;
%}

%option noyywrap

DIGIT       [0-9]
ID          [a-zA-Z_][a-zA-Z0-9_]*
INT         [+-]?{DIGIT}+
FLOAT       [+-]?(({DIGIT}+\.{DIGIT}*)|(\.{DIGIT}+))([eE][+-]?{DIGIT}+)?
STRING      \"([^\\\"]|\\.)*\"|'([^\\']|\\.)*'

%%

"\n"[ \t]* {
    line_num++;
    int count = yyleng - 1;  /* espaços após '\n' */
    if (count > indent_stack[indent_top]) {
        /* maior indent: gera INDENT */
        indent_stack[++indent_top] = count;
        yylval.int_val = count;
        return INDENT;
    } else {
        /* menor indent: gera um DEDENT por vez */
        while (count < indent_stack[indent_top]) {
            indent_top--;
            yylval.int_val = indent_stack[indent_top];
            /* retorna DEDENT imediatamente ao detectar */
            return DEDENT;
        }
    }
    /* mesmo nível: apenas NEWLINE */
    return NEWLINE;
}

"\n"          { line_num++; return NEWLINE; }
"print"       { return PRINT; }
"input"       { return INPUT; }
"if"          { return IF; }
"else"        { return ELSE; }
"elif"        { return ELIF; }
"True"        { yylval.bool_val = true; return BOOL; }
"False"       { yylval.bool_val = false; return BOOL; }

"#"           { int c; while((c = input()) != '\n' && c != EOF); line_num++; }

{FLOAT}        { yylval.float_val = atof(yytext); return FLOAT; }
{INT}          { yylval.int_val = atoi(yytext); return INT; }
{STRING}       { 
                  /* Remove aspas e processa escapes */
                  char* s = strdup(yytext);
                  size_t len = strlen(s);
                  yylval.str_val = (char*)malloc(len-1);
                  strncpy(yylval.str_val, s+1, len-2);
                  yylval.str_val[len-2] = '\0';
                  free(s);
                  return STRING;
                }

":"           { return COLON; }
"("           { return LPAREN; }
")"           { return RPAREN; }
"**"          { return POW; }
"*"           { return MUL; }
"//"          { return MOD; /* floor div uso MOD ou criar FLOOR_DIV */ }
"/"           { return DIV; }
"%"           { return MOD; }
"+"           { return ADD; }
"-"           { return SUB; }
"=="          { return EQ; }
"!="          { return NEQ; }
">="          { return GTE; }
"<="          { return LTE; }
">"           { return GT; }
"<"           { return LT; }
"="           { return ASSIGN; }
"!"           { return NOT; }

{ID}           { yylval.id = strdup(yytext); return ID; }

[ \t]+        { /* ignora espaços */ }

.              { fprintf(stderr, "Erro léxico: '%c' (linha %d)\n", yytext[0], line_num); }

%%

/* código C adicional, se houver */
