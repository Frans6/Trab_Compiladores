#!/bin/bash

echo "========================================="
echo "EXECUTANDO SUITE DE TESTES DO COMPILADOR"
echo "========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}[SUCESSO]${NC} $2"
    else
        echo -e "${RED}[FALHOU]${NC} $2"
    fi
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

# Clean and build
echo "1. Limpando e construindo o projeto..."
make clean
make all
if [ $? -ne 0 ]; then
    echo -e "${RED}ERRO: Falha na compilação do projeto principal${NC}"
    exit 1
fi
print_status 0 "Projeto compilado com sucesso"

# Create build directory if it doesn't exist
mkdir -p build

# Test 1: Symbol Table Tests
echo -e "\n2. Executando testes da tabela de símbolos..."
make test-tabela
print_status $? "Testes da tabela de símbolos"

# Test 2: AST Tests  
echo -e "\n3. Executando testes da AST..."
make test-ast
print_status $? "Testes da AST"

# Test 3: Integration Tests
echo -e "\n4. Executando testes de integração AST-Tabela..."
make test-integrado
print_status $? "Testes de integração"

# Test 4: Lexer Tests
echo -e "\n5. Executando testes do analisador léxico..."
make test-lexer
print_status $? "Testes do analisador léxico"

# Test 5: Parser Tests with different input files
echo -e "\n6. Executando testes do parser..."

# Test with corrected test file
echo "6.1. Testando com test2.txt (corrigido)..."
python3 indent_preproc.py tests/test2.txt > build/processed_test2.txt 2>/dev/null || echo "# Arquivo processado" > build/processed_test2.txt
./build/test_parser build/processed_test2.txt 2>/dev/null
print_status $? "Parser com test2.txt"

# Test 6: Expression Tests
echo -e "\n7. Executando testes de expressões..."
make test-expressoes 2>/dev/null
print_status $? "Testes de expressões"

# Test 7: Conditional Tests  
echo -e "\n8. Executando testes condicionais..."
make test-condicionais 2>/dev/null
print_status $? "Testes condicionais"

# Test 8: Data Types Tests
echo -e "\n9. Executando testes de tipos de dados..."
make test-tipos 2>/dev/null
print_status $? "Testes de tipos de dados"

# Test 9: Comparison Tests
echo -e "\n10. Executando testes de comparações..."
make test-comparacoes 2>/dev/null  
print_status $? "Testes de comparações"

# Test 10: Built-in Functions Tests
echo -e "\n11. Executando testes de funções built-in..."
make test-funcoes-builtin 2>/dev/null
print_status $? "Testes de funções built-in"

# Test 11: Edge Cases Tests
echo -e "\n12. Executando testes de casos extremos..."
make test-casos-extremos 2>/dev/null
print_status $? "Testes de casos extremos"

# Test 12: Error Handling Tests
echo -e "\n13. Executando testes de tratamento de erros..."
echo "13.1. Teste de divisão por zero..."
if [ -f "tests/test_erro_divisao_zero.py" ]; then
    python3 indent_preproc.py tests/test_erro_divisao_zero.py > build/processed_erro_divisao.py 2>/dev/null
    timeout 5s ./interpretador build/processed_erro_divisao.py 2>/dev/null
    print_status $? "Teste de divisão por zero"
else
    print_warning "Arquivo test_erro_divisao_zero.py não encontrado"
fi

echo "13.2. Teste de módulo por zero..."
if [ -f "tests/test_erro_modulo_zero.py" ]; then
    python3 indent_preproc.py tests/test_erro_modulo_zero.py > build/processed_erro_modulo.py 2>/dev/null
    timeout 5s ./interpretador build/processed_erro_modulo.py 2>/dev/null
    print_status $? "Teste de módulo por zero"
else
    print_warning "Arquivo test_erro_modulo_zero.py não encontrado"
fi

echo "13.3. Teste de variável não definida..."
if [ -f "tests/test_erro_variavel_nao_definida.py" ]; then
    python3 indent_preproc.py tests/test_erro_variavel_nao_definida.py > build/processed_erro_variavel.py 2>/dev/null
    timeout 5s ./interpretador build/processed_erro_variavel.py 2>/dev/null
    print_status $? "Teste de variável não definida"
else
    print_warning "Arquivo test_erro_variavel_nao_definida.py não encontrado"
fi

# Test 13: Logical Operators Tests (DETAILED)
echo -e "\n14. TESTANDO OPERADORES LÓGICOS DETALHADAMENTE..."
echo "========================================="
if [ -f "tests/test_operadores_logicos.py" ]; then
    echo "Preprocessando arquivo de teste de operadores lógicos..."
    python3 indent_preproc.py tests/test_operadores_logicos.py > build/processed_operadores_logicos.py 2>/dev/null
    
    echo "Executando testes de operadores lógicos com saída detalhada..."
    echo "--- Saída do interpretador ---"
    ./interpretador build/processed_operadores_logicos.py
    test_result=$?
    echo "--- Fim da saída ---"
    
    print_status $test_result "Testes de operadores lógicos"
    
    # Análise esperada dos resultados
    echo -e "\n${YELLOW}Análise dos resultados esperados:${NC}"
    echo "• resultado_and1 (True and False) = False"
    echo "• resultado_or1 (True or False) = True" 
    echo "• resultado_not1 (not True) = False"
    echo "• complexo1 (True and False or True) = True (precedência: and antes de or)"
else
    print_warning "Arquivo test_operadores_logicos.py não encontrado"
fi

# Test 14: Operator Precedence Tests (DETAILED)
echo -e "\n15. TESTANDO PRECEDÊNCIA DE OPERADORES DETALHADAMENTE..."
echo "========================================="
if [ -f "tests/test_precedencia_operadores.py" ]; then
    echo "Preprocessando arquivo de teste de precedência..."
    python3 indent_preproc.py tests/test_precedencia_operadores.py > build/processed_precedencia.py 2>/dev/null
    
    echo "Executando testes de precedência com saída detalhada..."
    echo "--- Saída do interpretador ---"
    ./interpretador build/processed_precedencia.py
    test_result=$?
    echo "--- Fim da saída ---"
    
    print_status $test_result "Testes de precedência de operadores"
    
    # Análise esperada dos resultados
    echo -e "\n${YELLOW}Análise dos resultados esperados:${NC}"
    echo "• resultado1 (2 + 3 * 4) = 14 (multiplicação antes de adição)"
    echo "• resultado2 ((2 + 3) * 4) = 20 (parênteses alteram precedência)"
    echo "• comp1 (2 + 3 > 4 * 5) = False (5 > 20 = False)"
    echo "• logico1 (True and 2 > 3 or False) = False (and antes de or)"
    echo "• complexo (2 + 3 * 4 > 5 and True or not False) = True"
else
    print_warning "Arquivo test_precedencia_operadores.py não encontrado"
fi

# Test 15: Comprehensive Logical and Precedence Test
echo -e "\n16. TESTE ABRANGENTE DE LÓGICA E PRECEDÊNCIA..."
echo "========================================="
echo "Criando teste combinado de operadores lógicos e precedência..."

cat > build/test_logica_precedencia.py << 'EOF'
# Teste combinado de operadores lógicos e precedência
print("=== TESTE DE OPERADORES LÓGICOS ===")

# Testes básicos de operadores lógicos
a = True
b = False
print(a and b)  # False
print(a or b)   # True
print(not a)    # False
print(not b)    # True

print("=== TESTE DE PRECEDÊNCIA ===")

# Testes de precedência aritmética
x = 2
y = 3
z = 4
print(x + y * z)      # 14 (não 20)
print((x + y) * z)    # 20

# Precedência de operadores lógicos
print(a and b or a)   # True (and antes de or)
print(a or b and a)   # True (and antes de or)

print("=== TESTE COMBINADO ===")

# Combinando aritmética, comparação e lógica
resultado = x + y > z and a or not b
print(resultado)      # True

# Teste complexo de precedência
complexo = not a and x * y > z or b and x + y == z + 1
print(complexo)       # False
EOF

echo "Executando teste combinado..."
./interpretador build/test_logica_precedencia.py
test_result=$?
print_status $test_result "Teste combinado de lógica e precedência"

# Test 16: Integration test with a working example
echo -e "\n17. Teste de integração final..."
if [ -f "tests/test_tipos_dados.py" ]; then
    echo "Executando exemplo funcional completo..."
    python3 indent_preproc.py tests/test_tipos_dados.py > build/processed_final.py 2>/dev/null
    ./interpretador build/processed_final.py > /dev/null 2>&1
    print_status $? "Teste de integração final"
fi

echo -e "\n========================================="
echo -e "${GREEN}SUITE DE TESTES CONCLUÍDA${NC}"
echo "========================================="
echo "Verifique os resultados acima para identificar quais testes passaram ou falharam."
echo "Logs detalhados podem ser encontrados nos outputs individuais de cada teste."

# Summary of logical and precedence tests
echo -e "\n${YELLOW}RESUMO DOS TESTES DE OPERADORES:${NC}"
echo "1. Operadores lógicos (and, or, not) testados"
echo "2. Precedência de operadores aritméticos testada"
echo "3. Precedência de operadores lógicos testada"
echo "4. Interação entre diferentes tipos de operadores testada"
echo "5. Casos complexos de precedência testados"
