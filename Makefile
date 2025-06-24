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

.PHONY: all clean run test test-tabela test-ast test-integrado test-lexer test-parser test-erros \
        test-expressoes test-condicionais test-loops test-tipos test-comparacoes test-casos-extremos \
        test-funcoes-builtin test-operadores-logicos test-precedencia-operadores

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
test: test-tabela test-ast test-integrado test-lexer test-parser-suite test-erros

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

# --- Teste de Mensagens de Erro ---
test-erros: all
	@echo "Executando testes automatizados de mensagens de erro..."
	@./test_erros.sh

# --- Suite de testes do parser ---
test-parser-suite: test-expressoes test-condicionais test-loops test-tipos test-comparacoes test-casos-extremos \
                   test-funcoes-builtin test-operadores-logicos test-precedencia-operadores

# --- Testes individuais ---
RUN_PARSER_TEST = $(BUILD_DIR)/test_parser
$(RUN_PARSER_TEST): test_parser.c $(PARSER_OBJS) $(COMMON_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

define RUN_TEST_TEMPLATE
.PHONY: $(1)
$(1): $(RUN_PARSER_TEST)
	@echo "--- Pré-processando e rodando teste de $(1)... ---"
	@$(PYTHON) indent_preproc.py $(TESTS_DIR)/$(2).py > $(BUILD_DIR)/processed_$(2).py
	./$(RUN_PARSER_TEST) $(BUILD_DIR)/processed_$(2).py
endef

$(eval $(call RUN_TEST_TEMPLATE,test-expressoes,test_expressoes))
$(eval $(call RUN_TEST_TEMPLATE,test-condicionais,test_condicionais))
$(eval $(call RUN_TEST_TEMPLATE,test-loops,test_loops))
$(eval $(call RUN_TEST_TEMPLATE,test-tipos,test_tipos_dados))
$(eval $(call RUN_TEST_TEMPLATE,test-comparacoes,test_comparacoes))
$(eval $(call RUN_TEST_TEMPLATE,test-casos-extremos,test_casos_extremos))
$(eval $(call RUN_TEST_TEMPLATE,test-funcoes-builtin,test_funcoes_builtin))
$(eval $(call RUN_TEST_TEMPLATE,test-operadores-logicos,test_operadores_logicos))
$(eval $(call RUN_TEST_TEMPLATE,test-precedencia-operadores,test_precedencia_operadores))