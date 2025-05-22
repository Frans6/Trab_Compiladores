%{
#include "../parser/ast.h"
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
STRING      \"([^\\\"]|\\.)*\"|'([^\\\']|\\.)*'

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
            return DEDENT;
        }
    }
    return NEWLINE;
}

"\n"          { line_num++; return NEWLINE; }
"print"       { return PRINT; }
"input"       { return INPUT; }
"if"          { return IF; }
"else"        { return ELSE; }
"elif"        { return ELIF; }
"def"         { return DEF; }
"return"      { return RETURN; }
"class"       { return CLASS; }
"while"       { return WHILE; }
"for"         { return FOR; }
"break"       { return BREAK; }
"continue"    { return CONTINUE; }
"None"        { return NONE; }
"and"         { return AND; }
"or"          { return OR; }
"not"         { return NOT; }
"True"        { yylval.bool_val = true; return BOOL; }
"False"       { yylval.bool_val = false; return BOOL; }

(r|f|u|rf|fr)?'''([^'\\]|\\.)*''' {
    char* s = strdup(yytext);
    size_t len = strlen(s);
    yylval.str_val = (char*)malloc(len - 6);
    strncpy(yylval.str_val, s + 3, len - 6);
    yylval.str_val[len - 6] = '\0';
    free(s);
    return STRING;
}

(r|f|u|rf|fr)?"""([^'\\]|\\.)*""" {
    char* s = strdup(yytext);
    size_t len = strlen(s);
    yylval.str_val = (char*)malloc(len - 6);
    strncpy(yylval.str_val, s + 3, len - 6);
    yylval.str_val[len - 6] = '\0';
    free(s);
    return STRING;
}

"#"           { int c; while((c = input()) != '\n' && c != EOF); line_num++; }

{FLOAT}        { yylval.float_val = atof(yytext); return FLOAT; }
{INT}          { yylval.int_val   = atoi(yytext); return INT; }
{STRING}       {
                  char* s = strdup(yytext);
                  size_t len = strlen(s);
                  yylval.str_val = (char*)malloc(len-1);
                  strncpy(yylval.str_val, s+1, len-2);
                  yylval.str_val[len-2] = '\0';
                  free(s);
                  return STRING;
                }

":"           { return COLON; }
","           { return COMMA; }
";"           { return SEMICOLON; }
"\."          { return DOT; }
"\["          { return LBRACKET; }
"\]"          { return RBRACKET; }
"\{"          { return LBRACE; }
"\}"          { return RBRACE; }
"@"           { return AT; }
"("           { return LPAREN; }
")"           { return RPAREN; }
"**"          { return POW; }
"*"           { return MUL; }
"//"          { return MOD; }
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

{ID}          { yylval.id = strdup(yytext); return ID; }

[ \t]+        { /* ignora espaços */ }

.             { fprintf(stderr, "Erro léxico: '%c' (linha %d)\n", yytext[0], line_num); }

%%
