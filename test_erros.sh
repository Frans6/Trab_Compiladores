#!/bin/bash

# Colors for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Function to print beautiful headers
print_header() {
    echo ""
    echo -e "${PURPLE}╔$(printf '═%.0s' {1..70})╗${NC}"
    echo -e "${PURPLE}║${WHITE}$(printf '%*s' $(((70-${#1})/2)) '')$1$(printf '%*s' $(((70-${#1})/2)) '')${PURPLE}║${NC}"
    echo -e "${PURPLE}╚$(printf '═%.0s' {1..70})╝${NC}"
}

# Function to print test results with elegant formatting
print_test_result() {
    local status=$1
    local description="$2"
    local expected="$3"
    local actual="$4"
    local padding=$((45 - ${#description}))
    
    if [ $status -eq 0 ]; then
        echo -e "${GREEN}  ✅ ${description}$(printf '%*s' $padding '')PASSOU${NC}"
    else
        echo -e "${RED}  ❌ ${description}$(printf '%*s' $padding '')FALHOU${NC}"
        if [ ! -z "$expected" ] && [ ! -z "$actual" ]; then
            echo -e "${GRAY}     Esperado: ${expected}${NC}"
            echo -e "${GRAY}     Obtido:   ${actual}${NC}"
        fi
    fi
}

# Function to print subsection headers
print_subsection() {
    echo -e "\n${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '─%.0s' {1..60})${NC}"
}

print_header "TESTE AUTOMATIZADO DE MENSAGENS DE ERRO"

echo -e "${YELLOW}Verificando tratamento de erros e robustez do compilador...${NC}\n"

# Verificar se o interpretador existe
if [ ! -f "./interpretador" ]; then
    echo -e "${RED}❌ ERRO CRÍTICO: Interpretador não encontrado${NC}"
    echo -e "${YELLOW}   Execute 'make' primeiro para compilar o projeto${NC}"
    exit 1
fi

# Criar diretório build se não existir
mkdir -p build

# Contadores para estatísticas
total=0
passed=0

# Função para testar um erro específico
test_error() {
    local test_file=$1
    local expected_pattern=$2
    local description=$3
    
    echo -e "\n${CYAN}Testando: ${WHITE}$description${NC}"
    
    # Criar nome único para o arquivo processado
    local test_name=$(basename "$test_file" .py)
    local processed_file="build/processed_${test_name}.py"
    
    # Processar indentação
    python3 indent_preproc.py "$test_file" > "$processed_file" 2>/dev/null
    local preproc_result=$?
    
    if [ $preproc_result -ne 0 ]; then
        # Erro no pré-processamento
        output=$(python3 indent_preproc.py "$test_file" 2>&1)
        if echo "$output" | grep -qi "$expected_pattern"; then
            print_test_result 0 "$description"
            ((passed++))
        else
            print_test_result 1 "$description" "$expected_pattern" "$output"
        fi
    else
        # Executar interpretador com o arquivo processado específico
        output=$(timeout 5s ./interpretador "$processed_file" 2>&1)
        if echo "$output" | grep -qi "$expected_pattern"; then
            print_test_result 0 "$description"
            ((passed++))
        else
            print_test_result 1 "$description" "$expected_pattern" "$output"
        fi
    fi
    
    ((total++))
}

# Teste de arquivo não encontrado
print_subsection "Testes de Arquivo e Sistema"
echo -e "${CYAN}Testando: ${WHITE}Arquivo não encontrado${NC}"
output=$(./interpretador arquivo_inexistente_$(date +%s).py 2>&1)
if echo "$output" | grep -qi "não foi possível abrir\|cannot open\|no such file"; then
    print_test_result 0 "Arquivo não encontrado"
    ((passed++))
else
    print_test_result 1 "Arquivo não encontrado" "não foi possível abrir" "$output"
fi
((total++))

# Executar todos os testes de erro específicos
print_subsection "Testes de Erros Semânticos"

if [ -f "tests/test_erro_variavel_nao_definida.py" ]; then
    test_error "tests/test_erro_variavel_nao_definida.py" "variável.*não.*definida\|undefined variable\|variable.*not.*defined\|name.*not.*defined" "Variável Não Definida"
else
    echo -e "${YELLOW}Arquivo test_erro_variavel_nao_definida.py não encontrado${NC}"
fi

print_subsection "Testes de Erros Aritméticos"

if [ -f "tests/test_erro_divisao_zero.py" ]; then
    test_error "tests/test_erro_divisao_zero.py" "divisão por zero\|division by zero" "Divisão por zero"
else
    echo -e "${YELLOW}Arquivo test_erro_divisao_zero.py não encontrado${NC}"
fi

if [ -f "tests/test_erro_modulo_zero.py" ]; then
    test_error "tests/test_erro_modulo_zero.py" "módulo por zero\|modulo by zero" "Módulo por zero"
else
    echo -e "${YELLOW}Arquivo test_erro_modulo_zero.py não encontrado${NC}"
fi

print_subsection "Testes de Erros de Sintaxe"

if [ -f "tests/test_erro_funcao_nao_definida.py" ]; then
    test_error "tests/test_erro_funcao_nao_definida.py" "função.*não definida\|undefined function" "Função não definida"
else
    echo -e "${YELLOW}Arquivo test_erro_funcao_nao_definida.py não encontrado${NC}"
fi

if [ -f "tests/test_erro_sintaxe.py" ]; then
    test_error "tests/test_erro_sintaxe.py" "syntax error\|erro de sintaxe" "Erro de sintaxe"
else
    echo -e "${YELLOW}Arquivo test_erro_sintaxe.py não encontrado${NC}"
fi

if [ -f "tests/test_erro_caractere_invalido.py" ]; then
    test_error "tests/test_erro_caractere_invalido.py" "caractere inválido\|invalid character" "Caractere inválido"
else
    echo -e "${YELLOW}Arquivo test_erro_caractere_invalido.py não encontrado${NC}"
fi

if [ -f "tests/test_erro_indentacao.py" ]; then
    test_error "tests/test_erro_indentacao.py" "indentação inconsistente\|inconsistent indentation" "Indentação inconsistente"
else
    echo -e "${YELLOW}Arquivo test_erro_indentacao.py não encontrado${NC}"
fi

# Resumo final com estatísticas detalhadas
print_header "RELATÓRIO FINAL DE TESTES DE ERRO"

echo -e "${WHITE}Estatísticas Detalhadas:${NC}"
echo -e "${CYAN}  • Total de testes executados: ${WHITE}$total${NC}"
echo -e "${GREEN}  • Testes que passaram: ${WHITE}$passed${NC}"
echo -e "${RED}  • Testes que falharam: ${WHITE}$((total - passed))${NC}"

if [ $total -gt 0 ]; then
    percentage=$((passed * 100 / total))
    echo -e "${BLUE}  • Taxa de sucesso: ${WHITE}${percentage}%${NC}"
fi

echo ""
if [ $passed -eq $total ]; then
    echo -e "${GREEN}╔$(printf '═%.0s' {1..50})╗${NC}"
    echo -e "${GREEN}║${WHITE}$(printf '%*s' $((25-9)) '')TODOS OS TESTES PASSARAM!$(printf '%*s' $((25-9)) '')${GREEN}║${NC}"
    echo -e "${GREEN}╚$(printf '═%.0s' {1..50})╝${NC}"
    echo -e "${CYAN}O sistema de tratamento de erros está funcionando corretamente!${NC}"
    exit 0
else
    echo -e "${YELLOW}╔$(printf '═%.0s' {1..50})╗${NC}"
    echo -e "${YELLOW}║${WHITE}$(printf '%*s' $((25-11)) '')ALGUNS TESTES FALHARAM$(printf '%*s' $((25-10)) '')${YELLOW}║${NC}"
    echo -e "${YELLOW}╚$(printf '═%.0s' {1..50})╝${NC}"
    echo -e "${RED}Verifique os detalhes dos erros acima para melhorar o tratamento.${NC}"
    exit 1
fi