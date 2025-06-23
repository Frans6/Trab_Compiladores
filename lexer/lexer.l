%{
#include <stdio.h>
#include <string.h>
#include "../parser/types.h"
#include "../parser/parser.tab.h"

void yyerror(const char* s);
extern int yylineno;
%}

%option noyywrap yylineno

DIGIT       [0-9]
ID          [a-zA-Z_][a-zA-Z0-9_]*
INT         [+-]?{DIGIT}+
FLOAT       [+-]?(({DIGIT}+\.{DIGIT}*)|(\.{DIGIT}+))([eE][+-]?{DIGIT}+)?
STRING      \"([^\\\"]|\\.)*\"|'([^\\\']|\\.)*'

%%

\xEF\xBB\BF { /* Ignora BOM */ }

"@INDENT@"   { return INDENT; }
"@DEDENT@"   { return DEDENT; }

\n           { return NEWLINE; }
[ \t\r]+     { /* Ignora espaços */ }
#.* { /* Ignora comentários */ }

"if"         { return IF; }
"else"       { return ELSE; }
"while"      { return WHILE; }
"break"      { return BREAK; }
"continue"   { return CONTINUE; }
"and"        { return AND; }
"or"         { return OR; }
"not"        { return NOT; }
"True"       { yylval.bool_val = true; return BOOL; }
"False"      { yylval.bool_val = false; return BOOL; }
"print"      { return PRINT; }
"input"      { return INPUT; }

"**" { return POW; } 
"==" { return EQ; } 
"!=" { return NEQ; }
">=" { return GTE; } 
"<=" { return LTE; }
":"  { return COLON; } 
"," { return COMMA; } 
"(" { return LPAREN; } 
")" { return RPAREN; }
"*"  { return MUL; } 
"/" { return DIV; } 
"%" { return MOD; }
"+"  { return ADD; } 
"-" { return SUB; } 
">" { return GT; } 
"<" { return LT; }
"="  { return ASSIGN; } 
"!" { return NOT; }

{FLOAT}  { yylval.float_val = atof(yytext); return FLOAT; }
{INT}    { yylval.int_val = atoi(yytext); return INT; }
{STRING} { 
    char* s = strdup(yytext); 
    size_t len = strlen(s); 
    yylval.str_val = malloc(len-1); 
    strncpy(yylval.str_val, s+1, len-2); 
    yylval.str_val[len-2] = '\0'; 
    free(s); 
    return STRING; 
}
{ID}     { yylval.str_val = strdup(yytext); return ID; }

.        { 
    fprintf(stderr, "[ERRO] (linha %d): Caractere inválido '%s'\n", yylineno, yytext);
}

%%
