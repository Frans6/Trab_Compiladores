%{
#include "../parser/types.h"
#include "../parser/parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int line_num = 1;
extern YYSTYPE yylval;
%}

%option noyywrap

DIGIT       [0-9]
ID          [a-zA-Z_][a-zA-Z0-9_]*
INT         [+-]?{DIGIT}+
FLOAT       [+-]?(({DIGIT}+\.{DIGIT}*)|(\.{DIGIT}+))([eE][+-]?{DIGIT}+)?
STRING      \"([^\\"]|\\.)*\"|\'([^\\']|\\.)*\'

%%

"print"         { return PRINT; }
"input"         { return INPUT; }
"if"            { return IF; }
"else"          { return ELSE; }
"elif"          { return ELIF; }
"True"          { yylval.bool_val = true; return BOOL; }
"False"         { yylval.bool_val = false; return BOOL; }

"#"             { int c; while((c = input()) != '\n' && c != EOF); line_num++; }

{FLOAT}         { yylval.float_val = atof(yytext); return FLOAT; }
{INT}           { yylval.int_val = atoi(yytext); return INT; }
{STRING}        { 
                  // Remove aspas e processa escapes
                  char* s = strdup(yytext);
                  size_t len = strlen(s);
                  yylval.str_val = (char*)malloc(len-1);
                  strncpy(yylval.str_val, s+1, len-2);
                  yylval.str_val[len-2] = '\0';
                  free(s);
                  return STRING; }

":"             { return COLON; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"+"             { return ADD; }
"-"             { return SUB; }
"*"             { return MUL; }
"/"             { return DIV; }
"**"            { return POW; }
"%"             { return MOD; }
"="             { return ASSIGN; }
"!"             { return NOT; }
"=="            { return EQ; }
"!="            { return NEQ; }
">"             { return GT; }
"<"             { return LT; }
">="            { return GTE; }
"<="            { return LTE; }

{ID}            { yylval.id = strdup(yytext); return ID; }

[ \t]+          { /* Ignora espaços */ }
\n              { line_num++; return NEWLINE; }  // Corrigido

.               { fprintf(stderr, "Erro léxico: '%c' (linha %d)\n", yytext[0], line_num); }

%%