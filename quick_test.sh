#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                   TESTE RÁPIDO DO COMPILADOR               ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Build the project
echo -e "${BLUE}1. Compilando o projeto...${NC}"
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "   ✅ Compilação bem-sucedida"
else
    echo -e "   ❌ Falha na compilação"
    exit 1
fi

# Test basic functionality
echo -e "\n${BLUE}2. Testando funcionalidade básica...${NC}"
cat > build/test_basico.py << 'EOF'
# Teste básico do interpretador
x = 42
y = 3.14
nome = "Teste Compilador"
resultado = x + 10
print("Resultado:", resultado)
print("Nome:", nome)
print("Sucesso no teste básico!")
EOF

./interpretador build/test_basico.py > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "   ✅ Interpretador executou com sucesso"
else
    echo -e "   ❌ Falha na execução do interpretador"
fi

# Test symbol table
echo -e "\n${BLUE}3. Testando tabela de símbolos...${NC}"
make test-tabela > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "   ✅ Testes da tabela de símbolos passaram"
else
    echo -e "   ❌ Falha nos testes da tabela de símbolos"
fi

echo ""
echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                 TESTE RÁPIDO CONCLUÍDO                     ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
