#!/bin/bash

echo "=== DIAGNÓSTICO ESPECÍFICO DO TESTE DE INTEGRAÇÃO ==="

# Compilar
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

echo "✅ Projeto compilado"
echo ""

# Testar exatamente o que o run_tests.sh está fazendo
echo "1. REPRODUZINDO O TESTE DE INTEGRAÇÃO DO RUN_TESTS.SH"
echo "====================================================="

# Criar exatamente o mesmo arquivo que está no run_tests.sh
cat > build/integration_test.py << 'EOF'
x = 5
y = 3
soma = x + y
print("Soma:", soma)
if x > y:
    print("x maior")
print("Fim")
EOF

echo "Arquivo de teste criado:"
cat build/integration_test.py
echo ""

echo "Processando com pré-processador:"
python3 indent_preproc.py build/integration_test.py > build/integration_test_processed.py 2>&1
preproc_status=$?
echo "Status do pré-processador: $preproc_status"

if [ $preproc_status -eq 0 ]; then
    echo "Arquivo processado:"
    cat build/integration_test_processed.py
    echo ""
    
    echo "Executando interpretador:"
    output=$(./interpretador build/integration_test_processed.py 2>&1)
    exec_status=$?
    echo "Status da execução: $exec_status"
    echo "Saída completa:"
    echo "$output"
    
    if [ $exec_status -eq 0 ]; then
        echo "✅ Teste deveria passar"
    else
        echo "❌ Teste está falhando - analisando erro..."
        echo "Linha do erro: $(echo "$output" | grep -o 'linha [0-9]*')"
    fi
else
    echo "❌ Erro no pré-processamento:"
    cat build/integration_test_processed.py
fi

echo ""
echo "2. TESTANDO VERSÕES AINDA MAIS SIMPLES"
echo "======================================"

# Teste sem if
cat > build/test_sem_if.py << 'EOF'
x = 5
y = 3
soma = x + y
print("Soma:", soma)
print("Fim")
EOF

echo "Teste sem condicional:"
python3 indent_preproc.py build/test_sem_if.py > build/test_sem_if_proc.py
./interpretador build/test_sem_if_proc.py 2>&1
echo "Status: $?"
echo ""

# Teste só com variáveis
cat > build/test_so_vars.py << 'EOF'
x = 5
y = 3
print("Fim")
EOF

echo "Teste só com variáveis:"
python3 indent_preproc.py build/test_so_vars.py > build/test_so_vars_proc.py
./interpretador build/test_so_vars_proc.py 2>&1
echo "Status: $?"
echo ""

echo "3. VERIFICANDO PROBLEMAS DE PARSING LINHA POR LINHA"
echo "=================================================="

# Testar linha por linha para identificar onde está o problema
test_lines=(
    "x = 5"
    "x = 5\ny = 3"
    "x = 5\ny = 3\nsoma = x + y"
    "x = 5\ny = 3\nsoma = x + y\nprint(\"Soma:\", soma)"
)

for i in "${!test_lines[@]}"; do
    echo "Teste linha $((i+1)):"
    echo -e "${test_lines[$i]}" > build/test_linha_$i.py
    cat build/test_linha_$i.py
    
    python3 indent_preproc.py build/test_linha_$i.py > build/test_linha_${i}_proc.py 2>&1
    ./interpretador build/test_linha_${i}_proc.py > /dev/null 2>&1
    status=$?
    
    if [ $status -eq 0 ]; then
        echo "✅ Status: $status"
    else
        echo "❌ Status: $status - PROBLEMA IDENTIFICADO"
        ./interpretador build/test_linha_${i}_proc.py 2>&1
        break
    fi
    echo ""
done

echo ""
echo "=== DIAGNÓSTICO CONCLUÍDO ==="