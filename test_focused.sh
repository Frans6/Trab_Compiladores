#!/bin/bash

echo "=== TESTE FOCADO NOS PROBLEMAS ESPECÍFICOS ==="

# Compilar
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

echo "✅ Projeto compilado"
echo ""

# Teste 1: Variável não definida com diferentes abordagens
echo "1. TESTANDO DETECÇÃO DE VARIÁVEL NÃO DEFINIDA"
echo "============================================="

# Abordagem 1: Atribuição direta
cat > build/test_var1.py << 'EOF'
x = variavel_inexistente
EOF

echo "Teste 1 - Atribuição direta:"
cat build/test_var1.py
./interpretador build/test_var1.py 2>&1
echo "Status: $?"
echo ""

# Abordagem 2: Expressão aritmética
cat > build/test_var2.py << 'EOF'
x = variavel_inexistente + 5
EOF

echo "Teste 2 - Expressão aritmética:"
cat build/test_var2.py
./interpretador build/test_var2.py 2>&1
echo "Status: $?"
echo ""

# Abordagem 3: Print direto
cat > build/test_var3.py << 'EOF'
print(variavel_inexistente)
EOF

echo "Teste 3 - Print direto:"
cat build/test_var3.py
./interpretador build/test_var3.py 2>&1
echo "Status: $?"
echo ""

# Teste 2: Problema do loop while
echo "2. TESTANDO SINTAXE DO LOOP WHILE"
echo "================================="

# Teste básico do while
cat > build/test_while1.py << 'EOF'
contador = 0
while contador < 3:
    print("Contador:", contador)
    contador = contador + 1
print("Fim")
EOF

echo "Teste while básico:"
cat build/test_while1.py
echo ""
python3 indent_preproc.py build/test_while1.py > build/test_while1_proc.py
echo "Arquivo processado:"
cat build/test_while1_proc.py
echo ""
./interpretador build/test_while1_proc.py 2>&1
echo "Status: $?"
echo ""

# Teste 3: Integração ultra-simples
echo "3. TESTANDO INTEGRAÇÃO ULTRA-SIMPLES"
echo "===================================="

cat > build/test_ultra_simples.py << 'EOF'
x = 5
y = 3
soma = x + y
print("Soma:", soma)
if x > y:
    print("x maior")
print("Fim")
EOF

echo "Teste ultra-simples (sem loop):"
cat build/test_ultra_simples.py
echo ""
python3 indent_preproc.py build/test_ultra_simples.py > build/test_ultra_simples_proc.py
./interpretador build/test_ultra_simples_proc.py 2>&1
echo "Status: $?"