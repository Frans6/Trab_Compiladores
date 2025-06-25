#!/bin/bash

echo "=== TESTE MANUAL DIRETO ==="

# Compilar se necessário
if [ ! -f "./interpretador" ]; then
    make clean > /dev/null 2>&1
    make all > /dev/null 2>&1
fi

# Testar arquivo ultra-simples
echo "x = 5" > test_ultra_simples.py
echo "print(x)" >> test_ultra_simples.py

echo "Testando arquivo ultra-simples:"
cat test_ultra_simples.py
echo ""

echo "Executando diretamente:"
./interpretador test_ultra_simples.py
echo "Status: $?"

echo ""
echo "Executando com pré-processador:"
python3 indent_preproc.py test_ultra_simples.py > test_ultra_simples_proc.py
cat test_ultra_simples_proc.py
./interpretador test_ultra_simples_proc.py
echo "Status: $?"

# Testar o executável test_parser se existir
if [ -f "build/test_parser" ]; then
    echo ""
    echo "Testando com test_parser:"
    ./build/test_parser test_ultra_simples_proc.py
    echo "Status: $?"
fi

rm -f test_ultra_simples.py test_ultra_simples_proc.py