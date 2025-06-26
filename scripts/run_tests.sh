#!/bin/bash

# Colors for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo ""
    echo -e "${CYAN}╔$(printf '═%.0s' {1..60})╗${NC}"
    echo -e "${CYAN}║${WHITE}$(printf '%*s' $(((60-${#1})/2)) '')$1$(printf '%*s' $(((60-${#1})/2)) '')${CYAN}║${NC}"
    echo -e "${CYAN}╚$(printf '═%.0s' {1..60})╝${NC}"
}

# Function to print test status with beautiful formatting
print_test_result() {
    local status=$1
    local test_name="$2"
    local padding=$((50 - ${#test_name}))
    
    if [ $status -eq 0 ]; then
        echo -e "${GREEN}✅ ${test_name}$(printf '%*s' $padding '')PASSOU${NC}"
    else
        echo -e "${RED}❌ ${test_name}$(printf '%*s' $padding '')FALHOU${NC}"
    fi
}

# Function to print subsection
print_subsection() {
    echo -e "\n${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '─%.0s' {1..50})${NC}"
}

print_header "SUITE COMPLETA DE TESTES DO COMPILADOR"

echo -e "${YELLOW}Iniciando execução da suite de testes...${NC}\n"

# Clean and build
print_subsection "Preparação do Ambiente"
echo -e "${BLUE}Limpando e construindo o projeto...${NC}"
make clean > /dev/null 2>&1
make all > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ ERRO CRÍTICO: Falha na compilação do projeto principal${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Projeto compilado com sucesso${NC}"

# Create build directory if it doesn't exist
mkdir -p build

# Core Component Tests
print_header "TESTES DOS COMPONENTES PRINCIPAIS"

print_subsection "Tabela de Símbolos"
make test-tabela > /dev/null 2>&1
print_test_result $? "Testes da tabela de símbolos"

print_subsection "Árvore Sintática Abstrata (AST)"
make test-ast > /dev/null 2>&1
print_test_result $? "Testes da AST"

print_subsection "Integração AST-Tabela"
make test-integrado > /dev/null 2>&1
print_test_result $? "Testes de integração"

print_subsection "Analisador Léxico"
make test-lexer > /dev/null 2>&1
print_test_result $? "Testes do analisador léxico"

# Parser Tests
print_header "TESTES DO ANALISADOR SINTÁTICO"

# Array of parser tests
declare -a parser_tests=(
    "test-expressoes:Expressões Aritméticas"
    "test-condicionais:Estruturas Condicionais"
    "test-loops:Estruturas de Repetição"
    "test-tipos:Tipos de Dados"
    "test-comparacoes:Operadores de Comparação"
    "test-casos-extremos:Casos Extremos"
    "test-funcoes-builtin:Funções Built-in"
    "test-operadores-logicos:Operadores Lógicos"
    "test-precedencia-operadores:Precedência de Operadores"
)

for test_pair in "${parser_tests[@]}"; do
    IFS=':' read -r test_command test_name <<< "$test_pair"
    make $test_command > /dev/null 2>&1
    print_test_result $? "$test_name"
done

# Advanced Tests
print_header "TESTES AVANÇADOS"

print_subsection "Tratamento de Erros"
# Testes de erro com verificação de mensagem
error_tests_passed=0
total_error_tests=0

declare -A error_tests_msgs
error_tests_msgs["test_erro_divisao_zero.py"]="Divisão por zero"
error_tests_msgs["test_erro_modulo_zero.py"]="Módulo por zero"
error_tests_msgs["test_erro_variavel_nao_definida.py"]="Variável 'x' não definida"
error_tests_msgs["test_erro_funcao_nao_definida.py"]="Função 'add' não definida"
error_tests_msgs["test_erro_sintaxe.py"]="syntax error"
error_tests_msgs["test_erro_indentacao.py"]="Indentação inconsistente na linha"
error_tests_msgs["test_erro_caractere_invalido.py"]="Caractere inválido '@'"
error_tests_msgs["test_erro_arquivo_inexistente.py"]="Não foi possível abrir o arquivo"

test_files=(
    "test_erro_divisao_zero.py:Divisão por Zero"
    "test_erro_modulo_zero.py:Módulo por Zero"
    "test_erro_variavel_nao_definida.py:Variável Não Definida"
    "test_erro_funcao_nao_definida.py:Função Não Definida"
    "test_erro_sintaxe.py:Erro de Sintaxe"
    "test_erro_indentacao.py:Erro de Indentação"
    "test_erro_caractere_invalido.py:Caractere Inválido"
    "test_erro_arquivo_inexistente.py:Arquivo Inexistente"
)

for test_pair in "${test_files[@]}"; do
    IFS=':' read -r filename test_desc <<< "$test_pair"
    ((total_error_tests++))
    expected_msg="${error_tests_msgs[$filename]}"
    if [ "$filename" = "test_erro_arquivo_inexistente.py" ]; then
        # Testa arquivo inexistente
        output=$(timeout 5s ./interpretador build/arquivo_que_nao_existe.py 2>&1)
        status=$?
        if [ $status -ne 0 ] && echo "$output" | grep -q "$expected_msg"; then
            ((error_tests_passed++))
            print_test_result 0 "$test_desc"
        else
            print_test_result 1 "$test_desc"
            echo -e "${YELLOW}${WARNING} Saída obtida:${NC}\n$output"
        fi
    else
        if [ -f "tests/$filename" ]; then
            if [ "$filename" = "test_erro_indentacao.py" ]; then
                # Para erro de indentação, capturar saída do pré-processador
                output=$(python3 indent_preproc.py "tests/$filename" 2>&1)
                status=$?
                if [ $status -ne 0 ] && echo "$output" | grep -q "$expected_msg"; then
                    ((error_tests_passed++))
                    print_test_result 0 "$test_desc"
                else
                    print_test_result 1 "$test_desc"
                    echo -e "${YELLOW}${WARNING} Saída obtida:${NC}\n$output"
                fi
            else
                python3 indent_preproc.py "tests/$filename" > "build/processed_$filename" 2>/dev/null
                output=$(timeout 5s ./interpretador "build/processed_$filename" 2>&1)
                status=$?
                if [ $status -ne 0 ] && echo "$output" | grep -q "$expected_msg"; then
                    ((error_tests_passed++))
                    print_test_result 0 "$test_desc"
                else
                    print_test_result 1 "$test_desc"
                    echo -e "${YELLOW}${WARNING} Saída obtida:${NC}\n$output"
                fi
            fi
        else
            echo -e "${YELLOW}${WARNING} Arquivo tests/$filename não encontrado${NC}"
        fi
    fi
done

# Integration Test
print_subsection "Teste de Integração Final"
cat > build/integration_test.py << 'EOF'
x = 5
print("Teste integração")
EOF

# Process the integration test through the preprocessor
python3 indent_preproc.py build/integration_test.py > build/processed_integration_test.py 2>/dev/null

./interpretador build/processed_integration_test.py > /dev/null 2>&1
print_test_result $? "Teste de Integração Completo"

# Final Summary
print_header "RESUMO FINAL"

echo -e "${WHITE}Estatísticas dos Testes:${NC}"
echo -e "${CYAN}• Componentes principais testados${NC}"
echo -e "${CYAN}• ${#parser_tests[@]} tipos de construções sintáticas verificadas${NC}"
echo -e "${CYAN}• $total_error_tests cenários de erro testados${NC}"
echo -e "${CYAN}• Teste de integração executado${NC}"

echo ""
echo -e "${GREEN}SUITE DE TESTES CONCLUÍDA${NC}"
echo -e "${YELLOW}Verifique os resultados detalhados acima.${NC}"
echo -e "${BLUE}Logs individuais disponíveis para análise específica.${NC}"

print_header "FINALIZADO"
