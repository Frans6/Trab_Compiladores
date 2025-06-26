#!/bin/bash

echo "=== DIAGNÓSTICO DE TESTES ==="

# Compilar o projeto
echo "1. Compilando..."
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "ERRO: Falha na compilação"
    exit 1
fi

echo "2. Testando pré-processador..."
echo -e "x = 5\nif x > 0:\n    print('ok')" > test_temp.py
python3 indent_preproc.py test_temp.py > test_temp_processed.py 2>&1
if [ $? -eq 0 ]; then
    echo "   Pré-processador OK"
    cat test_temp_processed.py
else
    echo "   ERRO no pré-processador:"
    cat test_temp_processed.py
fi

echo ""
echo "3. Testando interpretador com arquivo simples..."
echo "x = 5" > test_simple.py
echo "print(x)" >> test_simple.py
./interpretador test_simple.py 2>&1
echo "Status: $?"

echo ""
echo "4. Testando interpretador com condicional..."
python3 indent_preproc.py test_temp.py > test_temp_processed.py 2>/dev/null
./interpretador test_temp_processed.py 2>&1
echo "Status: $?"

# Cleanup
rm -f test_temp.py test_temp_processed.py test_simple.py