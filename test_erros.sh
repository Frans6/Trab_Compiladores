#!/bin/bash

# Script para testar automaticamente todas as mensagens de erro
# Uso: ./test_erros.sh

echo "=========================================="
echo "    TESTE AUTOMATIZADO DE MENSAGENS DE ERRO"
echo "=========================================="

# Verificar se o interpretador existe
if [ ! -f "./interpretador" ]; then
    echo "❌ Interpretador não encontrado. Execute 'make' primeiro."
    exit 1
fi

# Contadores
total=0
passed=0

# Função para testar um erro
test_error() {
    local test_file=$1
    local expected_pattern=$2
    local description=$3
    
    echo ""
    echo "🧪 Testando: $description"
    
    # Criar nome único para o arquivo processado
    local test_name=$(basename "$test_file" .py)
    local processed_file="build/processed_${test_name}.py"
    
    # Processar indentação
    python3 indent_preproc.py "$test_file" > "$processed_file" 2>/dev/null
    if [ $? -ne 0 ]; then
        # Erro no pré-processamento
        output=$(python3 indent_preproc.py "$test_file" 2>&1)
        if echo "$output" | grep -qi "$expected_pattern"; then
            echo "✅ $description: PASSOU"
            ((passed++))
        else
            echo "❌ $description: FALHOU"
            echo "   Esperado: $expected_pattern"
            echo "   Obtido: $output"
        fi
    else
        # Executar interpretador com o arquivo processado específico
        output=$(./interpretador "$processed_file" 2>&1)
        if echo "$output" | grep -qi "$expected_pattern"; then
            echo "✅ $description: PASSOU"
            ((passed++))
        else
            echo "❌ $description: FALHOU"
            echo "   Esperado: $expected_pattern"
            echo "   Obtido: $output"
        fi
    fi
    
    ((total++))
}

# Teste de arquivo não encontrado
echo ""
echo "🧪 Testando: Arquivo não encontrado"
output=$(./interpretador arquivo_inexistente.py 2>&1)
if echo "$output" | grep -qi "não foi possível abrir"; then
    echo "✅ Arquivo não encontrado: PASSOU"
    ((passed++))
else
    echo "❌ Arquivo não encontrado: FALHOU"
    echo "   Esperado: não foi possível abrir"
    echo "   Obtido: $output"
fi
((total++))

# Executar todos os testes
test_error "tests/test_erro_variavel_nao_definida.py" "variável.*não definida" "Variável não definida"
test_error "tests/test_erro_divisao_zero.py" "divisão por zero" "Divisão por zero"
test_error "tests/test_erro_modulo_zero.py" "módulo por zero" "Módulo por zero"
test_error "tests/test_erro_funcao_nao_definida.py" "função.*não definida" "Função não definida"
test_error "tests/test_erro_sintaxe.py" "syntax error" "Erro de sintaxe"
test_error "tests/test_erro_caractere_invalido.py" "caractere inválido" "Caractere inválido"
test_error "tests/test_erro_indentacao.py" "indentação inconsistente" "Indentação inconsistente"

# Resumo final
echo ""
echo "=========================================="
echo "              RESUMO DOS TESTES"
echo "=========================================="
echo "Total de testes: $total"
echo "Testes que passaram: $passed"
echo "Testes que falharam: $((total - passed))"

if [ $passed -eq $total ]; then
    echo ""
    echo "🎉 TODOS OS TESTES PASSARAM!"
    exit 0
else
    echo ""
    echo "⚠️  ALGUNS TESTES FALHARAM"
    exit 1
fi 