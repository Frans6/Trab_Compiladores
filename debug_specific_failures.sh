#!/bin/bash

echo "=== DIAGNÓSTICO ESPECÍFICO DOS TESTES FALHANDO ==="

# Compilar o projeto
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ ERRO: Falha na compilação"
    exit 1
fi

echo "✅ Projeto compilado"
echo ""

# TESTE 1: Diagnóstico detalhado da variável não definida
echo "1. DIAGNÓSTICO: VARIÁVEL NÃO DEFINIDA"
echo "====================================="

# Criar um teste simples de variável não definida
cat > build/test_var_simples.py << 'EOF'
print("Teste iniciado")
resultado = variavel_que_nao_existe
print("Esta linha nunca deve aparecer")
EOF

echo "Arquivo de teste criado:"
cat build/test_var_simples.py
echo ""

echo "Executando interpretador diretamente (sem pré-processador):"
output=$(./interpretador build/test_var_simples.py 2>&1)
status=$?
echo "Status: $status"
echo "Saída: '$output'"

if [ $status -ne 0 ]; then
    echo "✅ FUNCIONANDO: Erro detectado corretamente"
else
    echo "❌ PROBLEMA: Interpretador não detectou o erro"
fi

echo ""
echo "Testando com pré-processador:"
python3 indent_preproc.py build/test_var_simples.py > build/test_var_proc.py 2>&1
echo "Arquivo processado:"
cat build/test_var_proc.py
echo ""

output2=$(./interpretador build/test_var_proc.py 2>&1)
status2=$?
echo "Status: $status2"
echo "Saída: '$output2'"

echo ""
echo "Testando o arquivo oficial do teste:"
if [ -f "tests/test_erro_variavel_nao_definida.py" ]; then
    echo "Conteúdo do arquivo oficial:"
    cat tests/test_erro_variavel_nao_definida.py
    
    python3 indent_preproc.py tests/test_erro_variavel_nao_definida.py > build/oficial_proc.py 2>&1
    output3=$(./interpretador build/oficial_proc.py 2>&1)
    status3=$?
    echo "Status do arquivo oficial: $status3"
    echo "Saída: '$output3'"
else
    echo "❌ Arquivo oficial não encontrado"
fi

echo ""
echo "2. DIAGNÓSTICO: TESTE DE INTEGRAÇÃO"
echo "==================================="

# Criar teste de integração ultra-simples
cat > build/test_integracao_minimal.py << 'EOF'
print("Iniciando integração")
x = 10
print("x definido")
y = 5
print("y definido")
soma = x + y
print("Soma calculada:", soma)
if x > y:
    print("Condicional funcionou")
print("Integração concluída")
EOF

echo "Teste de integração minimal:"
cat build/test_integracao_minimal.py
echo ""

python3 indent_preproc.py build/test_integracao_minimal.py > build/integracao_proc.py 2>&1
preproc_status=$?
echo "Status do pré-processador: $preproc_status"

if [ $preproc_status -eq 0 ]; then
    echo "Arquivo processado:"
    cat build/integracao_proc.py
    echo ""
    
    output4=$(./interpretador build/integracao_proc.py 2>&1)
    status4=$?
    echo "Status da execução: $status4"
    echo "Saída: '$output4'"
    
    if [ $status4 -eq 0 ]; then
        echo "✅ Teste de integração minimal funcionou"
    else
        echo "❌ Problema no teste de integração"
    fi
else
    echo "❌ Erro no pré-processamento do teste de integração"
    cat build/integracao_proc.py
fi

echo ""
echo "3. TESTANDO A LÓGICA DO RUN_TESTS.SH"
echo "==================================="

# Simular exatamente o que o run_tests.sh faz para esses testes
echo "Simulando teste de variável não definida do run_tests.sh:"

if [ -f "tests/test_erro_variavel_nao_definida.py" ]; then
    python3 indent_preproc.py "tests/test_erro_variavel_nao_definida.py" > "build/processed_test_erro_variavel_nao_definida.py" 2>/dev/null
    ./interpretador "build/processed_test_erro_variavel_nao_definida.py" > /dev/null 2>&1
    run_test_status=$?
    
    echo "Status que o run_tests.sh vê: $run_test_status"
    
    # Para testes de erro, status != 0 significa PASSOU
    if [ $run_test_status -ne 0 ]; then
        echo "✅ Teste DEVERIA passar (erro detectado)"
    else
        echo "❌ Teste está falhando (erro não detectado)"
    fi
fi

echo ""
echo "Simulando teste de integração do run_tests.sh:"

# Criar o mesmo teste que está no run_tests.sh
cat > build/integration_test.py << 'EOF'
# Teste de integração básico
print("Iniciando teste de integração")

# Variáveis simples
x = 10
y = 5
nome = "teste"

# Operação aritmética
soma = x + y
print("Soma:", soma)

# Condicional simples
if x > y:
    print("x é maior que y")

# Loop básico
contador = 0
while contador < 3:
    print("Contador:", contador)
    contador = contador + 1

print("Teste de integração finalizado")
EOF

python3 indent_preproc.py build/integration_test.py > build/integration_test_processed.py 2>/dev/null
integ_preproc_status=$?

if [ $integ_preproc_status -eq 0 ]; then
    ./interpretador build/integration_test_processed.py > /dev/null 2>&1
    integ_status=$?
    
    echo "Status do teste de integração: $integ_status"
    
    if [ $integ_status -eq 0 ]; then
        echo "✅ Teste de integração DEVERIA passar"
    else
        echo "❌ Teste de integração está falhando"
        echo "Executando sem redirecionamento para ver o erro:"
        ./interpretador build/integration_test_processed.py 2>&1
    fi
else
    echo "❌ Erro no pré-processamento do teste de integração"
fi

echo ""
echo "=== DIAGNÓSTICO CONCLUÍDO ==="