CC = gcc
FLEX = flex
BISON = bison

CFLAGS = -I. -Iparser

# Arquivos
LEXER_SRC = lexer/lexer.l
PARSER_SRC = parser/parser.y
MAIN_SRC = main.c
SYMBOL_TABLE_SRC = parser/symbol_table.c      # ADICIONADO
AST_SRC = parser/ast.c                       # ADICIONADO

# Arquivos gerados
LEXER_C = build/lexer.c
PARSER_C = parser/parser.tab.c
PARSER_H = parser/parser.tab.h

# Objetos
LEXER_O = build/lexer.o
PARSER_O = build/parser.o
MAIN_O = build/main.o
SYMBOL_TABLE_O = build/symbol_table.o         # ADICIONADO
AST_O = build/ast.o                           # ADICIONADO

# Executável
TARGET = build/main

all: $(TARGET)

# Gera parser.tab.c e parser.tab.h com debug ativado (-t)
$(PARSER_C) $(PARSER_H): $(PARSER_SRC)
	$(BISON) -d -t -o $(PARSER_C) $(PARSER_SRC)

# Gera lexer.c
$(LEXER_C): $(LEXER_SRC) $(PARSER_H)
	$(FLEX) -o $(LEXER_C) $(LEXER_SRC)

# Compila lexer
$(LEXER_O): $(LEXER_C)
	$(CC) $(CFLAGS) -c $(LEXER_C) -o $(LEXER_O)

# Compila parser
$(PARSER_O): $(PARSER_C)
	$(CC) $(CFLAGS) -c $(PARSER_C) -o $(PARSER_O)

# Compila symbol_table
$(SYMBOL_TABLE_O): $(SYMBOL_TABLE_SRC)
	$(CC) $(CFLAGS) -c $(SYMBOL_TABLE_SRC) -o $(SYMBOL_TABLE_O)

# Compila ast
$(AST_O): $(AST_SRC)
	$(CC) $(CFLAGS) -c $(AST_SRC) -o $(AST_O)

# Compila main
$(MAIN_O): $(MAIN_SRC)
	$(CC) $(CFLAGS) -c $(MAIN_SRC) -o $(MAIN_O)

# Linka tudo
$(TARGET): $(LEXER_O) $(PARSER_O) $(MAIN_O) $(SYMBOL_TABLE_O) $(AST_O)
	$(CC) $(LEXER_O) $(PARSER_O) $(MAIN_O) $(SYMBOL_TABLE_O) $(AST_O) -o $(TARGET)

clean:
	rm -f build/* parser/parser.tab.*

run: all
	./$(TARGET)

# Teste do analisador léxico
TEST_LEXER_SRC = tests/test_lexer.c
TEST_LEXER_EXE = build/test_lexer

build/test_lexer: $(LEXER_O) $(PARSER_O) $(SYMBOL_TABLE_O) $(AST_O) $(TEST_LEXER_SRC)
	$(CC) $(CFLAGS) $(TEST_LEXER_SRC) $(LEXER_O) $(PARSER_O) $(SYMBOL_TABLE_O) $(AST_O) -o $(TEST_LEXER_EXE)

test-lexer: build/test_lexer
	@echo "Rodando teste do analisador léxico com tests/test1.txt:"
	./build/test_lexer tests/test1.txt


# Teste do analisador sintático
TEST_PARSER_SRC = tests/test_parser.c
TEST_PARSER_EXE = build/test_parser
TEST_PARSER_INPUT = tests/test2.txt

build/test_parser: $(LEXER_O) $(PARSER_O) $(SYMBOL_TABLE_O) $(AST_O) $(TEST_PARSER_SRC)
	$(CC) $(CFLAGS) $(TEST_PARSER_SRC) $(LEXER_O) $(PARSER_O) $(SYMBOL_TABLE_O) $(AST_O) -o $(TEST_PARSER_EXE)

test-parser: build/test_parser
	@echo "Rodando teste do analisador sintático com $(TEST_PARSER_INPUT):"
	./build/test_parser $(TEST_PARSER_INPUT)

ast_exec.o: ast_exec.c ast.h
    $(CC) $(CFLAGS) -c ast_exec.c
