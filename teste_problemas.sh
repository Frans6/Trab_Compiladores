#!/bin/bash

echo "=== TESTE ESPECÍFICO DOS PROBLEMAS RELATADOS ==="

# Compilar o projeto
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "ERRO: Falha na compilação"
    exit 1
fi

echo "✅ Projeto compilado com sucesso"
echo ""

# Teste 1: Variável não definida
echo "1. Testando variável não definida..."
if [ -f "tests/test_erro_variavel_nao_definida.py" ]; then
    python3 indent_preproc.py tests/test_erro_variavel_nao_definida.py > build/test_var_proc.py 2>/dev/null
    output=$(./interpretador build/test_var_proc.py 2>&1)
    status=$?
    
    if [ $status -ne 0 ]; then
        echo "✅ Teste passou - erro detectado corretamente"
        echo "   Saída: $output"
    else
        echo "❌ Teste falhou - erro não foi detectado"
        echo "   Saída: $output"
    fi
else
    echo "❌ Arquivo de teste não encontrado"
fi

echo ""

# Teste 2: Integração simples
echo "2. Testando integração básica..."
cat > build/test_integracao_simples.py << 'EOF'
# Teste de integração super simples
x = 10
y = 5
resultado = x + y
print("Resultado:", resultado)

if x > y:
    print("x é maior")

contador = 0
while contador < 2:
    print("Loop:", contador)
    contador = contador + 1

print("Fim do teste")
EOF

python3 indent_preproc.py build/test_integracao_simples.py > build/test_integracao_proc.py 2>/dev/null
output=$(./interpretador build/test_integracao_proc.py 2>&1)
status=$?

if [ $status -eq 0 ]; then
    echo "✅ Teste de integração passou"
    echo "   Saída:"
    echo "$output" | sed 's/^/     /'
else
    echo "❌ Teste de integração falhou"
    echo "   Erro: $output"
fi

echo ""
echo "=== DIAGNÓSTICO DETALHADO ==="

# Verificar se os arquivos processados estão corretos  
echo "3. Verificando pré-processamento..."
echo "Arquivo original:"
head -5 tests/test_erro_variavel_nao_definida.py | sed 's/^/   /'
echo ""
echo "Arquivo processado:"
head -5 build/test_var_proc.py | sed 's/^/   /'

echo ""
echo "4. Testando interpretador diretamente..."
echo "x = 42" > build/test_direto.py
echo "print(x)" >> build/test_direto.py
./interpretador build/test_direto.py
echo "Status do teste direto: $?"