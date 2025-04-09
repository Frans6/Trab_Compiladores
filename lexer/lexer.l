%{
#include "parser/parser.tab.h"
#include <stdio.h>
%}

%option noyywrap

%%

"print"         { return PRINT; }

[0-9]+          { yylval.ival = atoi(yytext); return NUMBER; }

"=="            { return EQ; }
"!="            { return NEQ; }
">="            { return GTE; }
"<="            { return LTE; }
">"             { return GT; }
"<"             { return LT; }

"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"("             { return '('; }
")"             { return ')'; }
";"             { return ';'; }

[ \t\n]         { /* ignora espaços */ }

.               { printf("Caractere desconhecido: %s\n", yytext); }

%%
