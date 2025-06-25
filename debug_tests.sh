#!/bin/bash

echo "=== DIAGNÓSTICO DETALHADO ==="

# 1. Verificar se o interpretador foi compilado
echo "1. Verificando compilação..."
if [ ! -f "./interpretador" ]; then
    echo "ERRO: interpretador não encontrado"
    make clean > /dev/null 2>&1
    make all
    if [ $? -ne 0 ]; then
        echo "ERRO: Falha na compilação"
        exit 1
    fi
fi
echo "✅ Interpretador encontrado"

# 2. Testar pré-processador
echo ""
echo "2. Testando pré-processador..."
cat > test_simple_cond.py << 'EOF'
x = 5
if x > 0:
    print("positivo")
print("fim")
EOF

echo "Arquivo original:"
cat test_simple_cond.py
echo ""

python3 indent_preproc.py test_simple_cond.py > test_processed.py 2>&1
preproc_status=$?
echo "Status do pré-processador: $preproc_status"
echo "Arquivo processado:"
cat test_processed.py
echo ""

# 3. Testar interpretador com arquivo processado
echo "3. Testando interpretador..."
if [ $preproc_status -eq 0 ]; then
    echo "Executando: ./interpretador test_processed.py"
    ./interpretador test_processed.py 2>&1
    echo "Status do interpretador: $?"
else
    echo "Erro no pré-processamento, tentando executar diretamente..."
    ./interpretador test_simple_cond.py 2>&1
    echo "Status do interpretador (direto): $?"
fi

# 4. Testar cada arquivo de teste individualmente
echo ""
echo "4. Testando arquivos individuais..."

for test_file in test_condicionais test_comparacoes test_operadores_logicos; do
    echo ""
    echo "--- Testando $test_file ---"
    if [ -f "tests/${test_file}.py" ]; then
        echo "Conteúdo do arquivo:"
        head -10 "tests/${test_file}.py"
        echo ""
        
        python3 indent_preproc.py "tests/${test_file}.py" > "build/processed_${test_file}.py" 2>&1
        proc_status=$?
        echo "Status pré-processamento: $proc_status"
        
        if [ $proc_status -eq 0 ]; then
            echo "Arquivo processado:"
            head -10 "build/processed_${test_file}.py"
            echo ""
            
            ./interpretador "build/processed_${test_file}.py" 2>&1
            echo "Status interpretador: $?"
        else
            echo "Erro no pré-processamento:"
            cat "build/processed_${test_file}.py"
        fi
    else
        echo "Arquivo tests/${test_file}.py não encontrado"
    fi
done

# Cleanup
rm -f test_simple_cond.py test_processed.py

echo ""
echo "=== FIM DO DIAGNÓSTICO ==="