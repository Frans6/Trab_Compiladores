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
        indent_stack[++indent_top] = count;
        yylval.int_val = count;
        return INDENT;
    } else {
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
"True"        { yylval.bool_val = true; return BOOL; }
"False"       { yylval.bool_val = false; return BOOL; }

/* Adicionando mais palavras-chave do Python */
"def"         { return DEF; }
"return"      { return RETURN; }
"class"       { return CLASS; }
"for"         { return FOR; }
"while"       { return WHILE; }
"break"       { return BREAK; }
"continue"    { return CONTINUE; }
"pass"        { return PASS; }
"try"         { return TRY; }
"except"      { return EXCEPT; }
"finally"     { return FINALLY; }
"raise"       { return RAISE; }
"with"        { return WITH; }
"as"          { return AS; }
"import"      { return IMPORT; }
"from"        { return FROM; }
"global"      { return GLOBAL; }
"nonlocal"    { return NONLOCAL; }
"async"       { return ASYNC; }
"await"       { return AWAIT; }
"and"         { return AND; }
"or"          { return OR; }
"is"          { return IS; }
"not"         { return NOT; }
"in"          { return IN; }
"lambda"      { return LAMBDA; }
"yield"       { return YIELD; }
"yield from"  { return YIELD_FROM; }

/* Fim da declaração das palavras-chave */

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
","            { return COMMA; }
";"            { return SEMICOLON; }
"\."          { return DOT; }
"\["          { return LBRACKET; }
"\]"          { return RBRACKET; }
"\{"          { return LBRACE; }
"\}"          { return RBRACE; }
"@"            { return AT; }
"("            { return LPAREN; }
")"            { return RPAREN; }
"**"          { return POW; }
"*"           { return MUL; }
"//"          { return MOD; }
"/"           { return DIV; }
"%"
           { return MOD; }
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
