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

# --- Cores para output ---
GREEN = \033[0;32m
RED = \033[0;31m
BLUE = \033[0;34m
YELLOW = \033[1;33m
NC = \033[0m

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
        test-funcoes-builtin test-operadores-logicos test-precedencia-operadores test-parser-suite

# --- Regras Principais ---
all: $(TARGET)

$(TARGET): $(OBJS_APP)
	@echo -e "$(BLUE)Linkando executável final...$(NC)"
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)
	@echo -e "$(GREEN)Compilação concluída com sucesso!$(NC)"

# --- Regras de Geração e Compilação ---
$(PARSER_DIR)/parser.tab.c $(PARSER_DIR)/parser.tab.h: $(PARSER_DIR)/parser.y
	@echo -e "$(BLUE)Gerando parser com Bison...$(NC)"
	$(BISON) -d -t -o $(PARSER_DIR)/parser.tab.c $<

$(BUILD_DIR)/lexer.c: $(LEXER_DIR)/lexer.l $(PARSER_DIR)/parser.tab.h | $(BUILD_DIR)
	@echo -e "$(BLUE)Gerando lexer com Flex...$(NC)"
	$(FLEX) -o $@ $<

$(BUILD_DIR):
	@echo -e "$(BLUE)Criando diretório build...$(NC)"
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	@echo -e "$(BLUE)Compilando $<...$(NC)"
	$(CC) $(CFLAGS) -c $< -o $@

# --- Comandos Utilitários ---
clean:
	@echo -e "$(YELLOW)Limpando arquivos temporários...$(NC)"
	rm -rf $(BUILD_DIR) $(TARGET) $(PARSER_DIR)/parser.tab.*
	@echo -e "$(GREEN)Limpeza concluída!$(NC)"

run: all
	@echo -e "$(BLUE)Pré-processando '$(SCRIPT)' para resolver indentação...$(NC)"
	@$(PYTHON) indent_preproc.py $(SCRIPT) > $(PROCESSED_SCRIPT)
	@echo -e "$(BLUE)Executando interpretador no script processado$(NC)"
	./$(TARGET) $(PROCESSED_SCRIPT)

# --- Alvos de Teste ---
test: test-tabela test-ast test-integrado test-lexer test-parser-suite test-erros
	@echo -e "$(GREEN)Todos os testes foram executados!$(NC)"

test-tabela: $(BUILD_DIR)/test_tabela
	@if ./$< > /dev/null 2>&1; then \
		echo "✅ Testes da tabela de símbolos"; \
	else \
		echo "❌ Testes da tabela de símbolos"; \
	fi

$(BUILD_DIR)/test_tabela: test_tabela.c $(BUILD_DIR)/tabela.o | $(BUILD_DIR)
	@echo -e "$(BLUE)Compilando teste da tabela...$(NC)"
	$(CC) $(CFLAGS) $^ -o $@

test-ast: $(BUILD_DIR)/test_ast
	@if ./$< > /dev/null 2>&1; then \
		echo "✅ Testes da AST"; \
	else \
		echo "❌ Testes da AST"; \
	fi

$(BUILD_DIR)/test_ast: test_ast.c $(COMMON_OBJS) | $(BUILD_DIR)
	@echo -e "$(BLUE)Compilando teste da AST...$(NC)"
	$(CC) $(CFLAGS) $^ -o $@

test-integrado: $(BUILD_DIR)/test_integrado
	@if ./$< > /dev/null 2>&1; then \
		echo "✅ Testes de integração"; \
	else \
		echo "❌ Testes de integração"; \
	fi

$(BUILD_DIR)/test_integrado: test_tabela-ast.c $(COMMON_OBJS) | $(BUILD_DIR)
	@echo -e "$(BLUE)Compilando teste de integração...$(NC)"
	$(CC) $(CFLAGS) $^ -o $@

test-lexer: $(BUILD_DIR)/test_lexer_exe
	@if [ -f "$(TESTS_DIR)/test1.txt" ]; then \
		$(PYTHON) indent_preproc.py $(TESTS_DIR)/test1.txt > $(BUILD_DIR)/processed_lex_test.txt 2>/dev/null; \
		if ./$< $(BUILD_DIR)/processed_lex_test.txt > /dev/null 2>&1; then \
			echo "✅ Testes do lexer"; \
		else \
			echo "❌ Testes do lexer"; \
		fi; \
	else \
		echo "❌ Testes do lexer (arquivo não encontrado)"; \
	fi

$(BUILD_DIR)/test_lexer_exe: test_lexer.c $(PARSER_OBJS) $(COMMON_OBJS) | $(BUILD_DIR)
	@echo -e "$(BLUE)Compilando teste do lexer...$(NC)"
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

# --- Teste de Mensagens de Erro ---
test-erros: all
	@echo -e "$(BLUE)Executando testes de tratamento de erros...$(NC)"
	@if [ -x "./test_erros.sh" ]; then \
		chmod +x ./test_erros.sh; \
		./test_erros.sh; \
	else \
		echo -e "$(YELLOW)Script test_erros.sh não encontrado ou não executável$(NC)"; \
	fi

# --- Suite de testes do parser ---
test-parser-suite: test-expressoes test-condicionais test-loops test-tipos test-comparacoes test-casos-extremos \
                   test-funcoes-builtin test-operadores-logicos test-precedencia-operadores
	@echo -e "$(GREEN)Suite de testes do parser concluída!$(NC)"

# --- Testes individuais ---
RUN_PARSER_TEST = $(BUILD_DIR)/test_parser
$(RUN_PARSER_TEST): test_parser.c $(PARSER_OBJS) $(COMMON_OBJS) | $(BUILD_DIR)
	@echo -e "$(BLUE)Compilando executável de teste do parser...$(NC)"
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

define RUN_TEST_TEMPLATE
.PHONY: $(1)
$(1): $(RUN_PARSER_TEST)
	@if [ -f "$(TESTS_DIR)/$(2).py" ]; then \
		if $(PYTHON) indent_preproc.py $(TESTS_DIR)/$(2).py > $(BUILD_DIR)/processed_$(2).py 2>/dev/null; then \
			if ./$(RUN_PARSER_TEST) $(BUILD_DIR)/processed_$(2).py > /dev/null 2>&1; then \
				echo "✅ $(1)"; \
			else \
				echo "❌ $(1)"; \
			fi; \
		else \
			echo "❌ $(1) (erro no pré-processamento)"; \
		fi; \
	else \
		echo "❌ $(1) (arquivo não encontrado)"; \
	fi
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