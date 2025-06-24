#!/bin/bash

echo "=== TESTE RÁPIDO DO COMPILADOR ==="

# Build the project
echo "1. Compilando..."
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Compilação bem-sucedida"
else
    echo "✗ Falha na compilação"
    exit 1
fi

# Test basic functionality
echo "2. Testando funcionalidade básica..."
cat > build/test_basico.py << 'EOF'
x = 42
y = 3.14
nome = "Teste"
resultado = x + 10
print(resultado)
print(nome)
EOF

./interpretador build/test_basico.py > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Interpretador executou com sucesso"
else
    echo "✗ Falha na execução do interpretador"
fi

# Test symbol table
echo "3. Testando tabela de símbolos..."
make test-tabela > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Testes da tabela de símbolos passaram"
else
    echo "✗ Falha nos testes da tabela de símbolos"
fi

echo "=== TESTE RÁPIDO CONCLUÍDO ==="
