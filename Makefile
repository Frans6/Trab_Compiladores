# --- Ferramentas ---
CC = gcc
BISON = bison
FLEX = flex
PYTHON = python3

# --- Diretórios ---
PARSER_DIR = parser
LEXER_DIR  = lexer
BUILD_DIR  = build
TESTS_DIR  = tests

# --- Configurações de Compilação ---
CFLAGS   = -I$(PARSER_DIR) -Wall -Wextra -g
LDFLAGS  = -lfl -lm

# --- Descoberta de Arquivos ---
VPATH = . $(PARSER_DIR) $(TESTS_DIR)
SRCS_APP = main.c $(wildcard $(PARSER_DIR)/*.c)
GENERATED_SRCS = $(PARSER_DIR)/parser.tab.c $(BUILD_DIR)/lexer.c
SRCS_APP += $(GENERATED_SRCS)
OBJS_APP = $(addprefix $(BUILD_DIR)/, $(notdir $(SRCS_APP:.c=.o)))

# Objetos comuns que os testes podem precisar
COMMON_OBJS = $(BUILD_DIR)/ast.o $(BUILD_DIR)/tabela.o
PARSER_OBJS = $(BUILD_DIR)/lexer.o $(BUILD_DIR)/parser.tab.o

# --- Alvos ---
TARGET = interpretador
SCRIPT ?= teste.py
PROCESSED_SCRIPT = $(BUILD_DIR)/processed.py

.PHONY: all clean run test test-tabela test-ast test-integrado test-lexer test-parser

# --- Regras Principais ---
all: $(TARGET)

$(TARGET): $(OBJS_APP)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

# --- Regras de Geração e Compilação ---
$(PARSER_DIR)/parser.tab.c $(PARSER_DIR)/parser.tab.h: $(PARSER_DIR)/parser.y
	$(BISON) -d -t -o $(PARSER_DIR)/parser.tab.c $<

$(BUILD_DIR)/lexer.c: $(LEXER_DIR)/lexer.l $(PARSER_DIR)/parser.tab.h | $(BUILD_DIR)
	$(FLEX) -o $@ $<

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# --- Comandos Utilitários ---
clean:
	@echo "Limpando..."
	rm -rf $(BUILD_DIR) $(TARGET) $(PARSER_DIR)/parser.tab.*

run: all
	@echo "--- Pré-processando '$(SCRIPT)' para resolver indentação... ---"
	@$(PYTHON) indent_preproc.py $(SCRIPT) > $(PROCESSED_SCRIPT)
	@echo "--- Executando interpretador no script processado ---"
	./$(TARGET) $(PROCESSED_SCRIPT)

# --- Alvos de Teste ---
test: test-tabela test-ast test-integrado test-lexer test-parser

test-tabela: $(BUILD_DIR)/test_tabela
	./$<
$(BUILD_DIR)/test_tabela: test_tabela.c $(BUILD_DIR)/tabela.o | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@

test-ast: $(BUILD_DIR)/test_ast
	./$<
$(BUILD_DIR)/test_ast: test_ast.c $(COMMON_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@

test-integrado: $(BUILD_DIR)/test_integrado
	./$<
$(BUILD_DIR)/test_integrado: test_tabela-ast.c $(COMMON_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@

test-lexer: $(BUILD_DIR)/test_lexer_exe
	@echo "--- Pré-processando '$(TESTS_DIR)/test1.txt'... ---"
	@$(PYTHON) indent_preproc.py $(TESTS_DIR)/test1.txt > $(BUILD_DIR)/processed_lex_test.txt
	@echo "--- Rodando teste do analisador léxico... ---"
	./$< $(BUILD_DIR)/processed_lex_test.txt
$(BUILD_DIR)/test_lexer_exe: test_lexer.c $(PARSER_OBJS) $(COMMON_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

test-parser: $(BUILD_DIR)/test_parser
	@echo "--- Pré-processando '$(TESTS_DIR)/test2.txt'... ---"
	@$(PYTHON) indent_preproc.py $(TESTS_DIR)/test2.txt > $(BUILD_DIR)/processed_parser_test.txt
	@echo "--- Rodando teste do analisador sintático... ---"
	./$< $(BUILD_DIR)/processed_parser_test.txt
$(BUILD_DIR)/test_parser: test_parser.c $(PARSER_OBJS) $(COMMON_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)