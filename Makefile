CC = gcc
FLEX = flex
BISON = bison

CFLAGS = -I. -Iparser -Wall -Wextra -g

# Diretórios
BUILD_DIR = build
TESTS_DIR = tests
PARSER_DIR = parser
LEXER_DIR = lexer

# Arquivos
LEXER_SRC = $(LEXER_DIR)/lexer.l
PARSER_SRC = $(PARSER_DIR)/parser.y
MAIN_SRC = main.c
TABELA_SRC = $(PARSER_DIR)/tabela.c
AST_SRC = $(PARSER_DIR)/ast.c
AST_EXEC_SRC = $(PARSER_DIR)/ast_exec.c

# Arquivos gerados
LEXER_C = $(BUILD_DIR)/lexer.c
PARSER_C = $(PARSER_DIR)/parser.tab.c
PARSER_H = $(PARSER_DIR)/parser.tab.h

# Objetos
LEXER_O = $(BUILD_DIR)/lexer.o
PARSER_O = $(BUILD_DIR)/parser.o
MAIN_O = $(BUILD_DIR)/main.o
TABELA_O = $(BUILD_DIR)/tabela.o
AST_O = $(BUILD_DIR)/ast.o
AST_EXEC_O = $(BUILD_DIR)/ast_exec.o

# Executáveis
TARGET = $(BUILD_DIR)/main

# Testes
TEST_TABELA_SRC = $(TESTS_DIR)/test_tabela.c
TEST_TABELA_EXE = $(BUILD_DIR)/test_tabela

TEST_AST_SRC = $(TESTS_DIR)/test_ast.c
TEST_AST_EXE = $(BUILD_DIR)/test_ast

# Criar diretório de build se não existir
$(shell mkdir -p $(BUILD_DIR))

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

# Compila tabela
$(TABELA_O): $(TABELA_SRC) $(PARSER_DIR)/tabela.h
	$(CC) $(CFLAGS) -c $(TABELA_SRC) -o $(TABELA_O)

# Compila ast
$(AST_O): $(AST_SRC) $(PARSER_DIR)/ast.h
	$(CC) $(CFLAGS) -c $(AST_SRC) -o $(AST_O)

# Compila ast_exec
$(AST_EXEC_O): $(AST_EXEC_SRC) $(PARSER_DIR)/ast.h
	$(CC) $(CFLAGS) -c $(AST_EXEC_SRC) -o $(AST_EXEC_O)

# Compila main
$(MAIN_O): $(MAIN_SRC)
	$(CC) $(CFLAGS) -c $(MAIN_SRC) -o $(MAIN_O)

# Linka o interpretador principal
$(TARGET): $(LEXER_O) $(PARSER_O) $(MAIN_O) $(TABELA_O) $(AST_O) $(AST_EXEC_O)
	$(CC) $^ -o $@

# Teste da tabela de símbolos
$(TEST_TABELA_EXE): $(TEST_TABELA_SRC) $(TABELA_O)
	$(CC) $(CFLAGS) $^ -o $@

# Teste da AST
$(TEST_AST_EXE): $(TEST_AST_SRC) $(AST_O)
	$(CC) $(CFLAGS) $^ -o $@

# Teste integrado da AST com tabela de símbolos
INTEGRATED_TEST_SRC = tests/test_tabela-ast.c
INTEGRATED_TEST_EXE = build/teste_integrado

$(INTEGRATED_TEST_EXE): $(INTEGRATED_TEST_SRC) $(TABELA_O) $(AST_O)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -rf $(BUILD_DIR)/* $(PARSER_DIR)/parser.tab.*

run: $(TARGET)
	./$(TARGET)

# Testes
test-tabela: $(TEST_TABELA_EXE)
	./$(TEST_TABELA_EXE)

test-ast: $(TEST_AST_EXE) #ainda não está funcionando corretamente, no arquivo tem instruções para rodar
	./$(TEST_AST_EXE)

test-integrado: $(INTEGRATED_TEST_EXE)
	./$(INTEGRATED_TEST_EXE)

test: test-tabela test-ast test-integrado

# Testes específicos do lexer e parser
test-lexer: $(BUILD_DIR)/test_lexer
	@echo "Rodando teste do analisador léxico com $(TESTS_DIR)/test1.txt:"
	./$< $(TESTS_DIR)/test1.txt

test-parser: $(BUILD_DIR)/test_parser
	@echo "Rodando teste do analisador sintático com $(TESTS_DIR)/test2.txt:"
	./$< $(TESTS_DIR)/test2.txt

# Build e run para testes específicos
$(BUILD_DIR)/test_lexer: $(TESTS_DIR)/test_lexer.c $(LEXER_O) $(PARSER_O) $(TABELA_O) $(AST_O) $(AST_EXEC_O)
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/test_parser: $(TESTS_DIR)/test_parser.c $(LEXER_O) $(PARSER_O) $(TABELA_O) $(AST_O) $(AST_EXEC_O)
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: all clean run test test-tabela test-ast test-integrado test-lexer test-parser