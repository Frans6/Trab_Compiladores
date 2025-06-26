#!/bin/bash

echo "=== DIAGNÓSTICO DOS TESTES FALHANDO ==="

# Compilar o projeto
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "ERRO: Falha na compilação"
    exit 1
fi

echo "✅ Projeto compilado"
echo ""

# Teste 1: Diagnóstico da variável não definida
echo "1. TESTANDO VARIÁVEL NÃO DEFINIDA"
echo "=================================="

if [ -f "tests/test_erro_variavel_nao_definida.py" ]; then
    echo "Conteúdo do arquivo:"
    cat tests/test_erro_variavel_nao_definida.py
    echo ""
    
    echo "Processando com indent_preproc.py..."
    python3 indent_preproc.py tests/test_erro_variavel_nao_definida.py > build/debug_var.py 2>&1
    preproc_status=$?
    echo "Status do pré-processador: $preproc_status"
    
    echo "Arquivo processado:"
    cat build/debug_var.py
    echo ""
    
    echo "Executando interpretador..."
    output=$(./interpretador build/debug_var.py 2>&1)
    status=$?
    echo "Status da execução: $status"
    echo "Saída completa:"
    echo "$output"
    echo ""
    
    if [ $status -ne 0 ]; then
        echo "✅ TESTE PASSOU - Erro detectado corretamente"
        echo "Mensagem de erro: $output"
    else
        echo "❌ TESTE FALHOU - Erro não foi detectado"
        echo "O interpretador deveria ter falhado mas retornou status 0"
    fi
else
    echo "❌ Arquivo de teste não encontrado"
fi

echo ""
echo "2. TESTANDO INTEGRAÇÃO"
echo "====================="

# Criar teste de integração simples
cat > build/debug_integration.py << 'EOF'
print("Inicio")
x = 5
y = 3
soma = x + y
print("Soma:", soma)
if x > y:
    print("x maior")
contador = 0
while contador < 2:
    print("Loop:", contador)
    contador = contador + 1
print("Fim")
EOF

echo "Conteúdo do teste de integração:"
cat build/debug_integration.py
echo ""

echo "Processando com indent_preproc.py..."
python3 indent_preproc.py build/debug_integration.py > build/debug_integration_proc.py 2>&1
preproc_status=$?
echo "Status do pré-processador: $preproc_status"

echo "Arquivo processado:"
cat build/debug_integration_proc.py
echo ""

echo "Executando interpretador..."
output=$(./interpretador build/debug_integration_proc.py 2>&1)
status=$?
echo "Status da execução: $status" 
echo "Saída completa:"
echo "$output"
echo ""

if [ $status -eq 0 ]; then
    echo "✅ TESTE DE INTEGRAÇÃO PASSOU"
else
    echo "❌ TESTE DE INTEGRAÇÃO FALHOU"
    echo "Erro: $output"
fi

echo ""
echo "3. TESTANDO ARQUIVO ULTRA-SIMPLES"
echo "================================="

cat > build/ultra_simples.py << 'EOF'
x = 42
print(x)
EOF

echo "Teste ultra-simples:"
cat build/ultra_simples.py
echo ""

./interpretador build/ultra_simples.py 2>&1
status=$?
echo "Status: $status"

if [ $status -eq 0 ]; then
    echo "✅ Teste ultra-simples passou"
else
    echo "❌ Teste ultra-simples falhou"
fi