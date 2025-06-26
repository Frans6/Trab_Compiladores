#!/bin/bash

# Script para testar automaticamente se os resultados estão corretos
# Uso: ./test_resultados.sh

echo "=========================================="
echo "    TESTE AUTOMATIZADO DE RESULTADOS"
echo "=========================================="

# Verificar se o interpretador existe
if [ ! -f "./interpretador" ]; then
    echo "❌ Interpretador não encontrado. Execute 'make' primeiro."
    exit 1
fi

# Contadores
total=0
passed=0

# Função para testar um resultado
test_result() {
    local test_name=$1
    local test_file=$2
    
    echo ""
    echo "🧪 Testando: $test_name"
    echo "📁 Arquivo: $test_file"
    echo "────────────────────────────────────────"
    
    # Criar nome único para o arquivo processado
    local test_name_file=$(basename "$test_file" .py)
    local processed_file="build/processed_${test_name_file}.py"
    
    # Processar indentação
    python3 indent_preproc.py "$test_file" > "$processed_file" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "❌ ERRO no pré-processamento"
        ((total++))
        return
    fi
    
    # Executar interpretador e mostrar saída
    echo "🚀 Executando interpretador..."
    echo "--- SAÍDA DO INTERPRETADOR ---"
    ./interpretador "$processed_file"
    local exit_code=$?
    echo "--- FIM DA SAÍDA ---"
    
    if [ $exit_code -eq 0 ]; then
        echo "✅ $test_name: EXECUTOU COM SUCESSO"
        ((passed++))
    else
        echo "❌ $test_name: FALHOU (código de saída: $exit_code)"
    fi
    
    ((total++))
    echo ""
}

# Array de testes (mesmos do run_tests.sh)
declare -a tests=(
    "tests/test_expressoes.py:Expressões Aritméticas"
    "tests/test_tipos_dados.py:Tipos de Dados"
    "tests/test_operadores_logicos.py:Operadores Lógicos"
    "tests/test_comparacoes.py:Operadores de Comparação"
    "tests/test_condicionais.py:Estruturas Condicionais"
    "tests/test_loops.py:Estruturas de Loop"
    "tests/test_funcoes_builtin.py:Funções Built-in"
    "tests/test_precedencia_operadores.py:Precedência de Operadores"
    "tests/test_casos_extremos.py:Casos Extremos"
)

# Executar todos os testes
for test_pair in "${tests[@]}"; do
    IFS=':' read -r test_file test_name <<< "$test_pair"
    
    if [ -f "$test_file" ]; then
        test_result "$test_name" "$test_file"
    else
        echo "❌ Arquivo não encontrado: $test_file"
        ((total++))
    fi
done

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