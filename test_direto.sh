#!/bin/bash

echo "=== TESTE DIRETO PARA IDENTIFICAR O PROBLEMA ==="

# Compilar
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "ERRO: Compilação falhou"
    exit 1
fi

echo "✅ Projeto compilado"
echo ""

# Teste 1: Arquivo que deveria funcionar
echo "1. TESTE DE ARQUIVO QUE DEVERIA FUNCIONAR"
echo "========================================="
cat > test_ok.py << 'EOF'
x = 5
print("Valor:", x)
EOF

echo "Conteúdo do arquivo:"
cat test_ok.py
echo ""

echo "Executando diretamente (sem pré-processador):"
./interpretador test_ok.py 2>&1
status1=$?
echo "Status: $status1"

echo ""
echo "Executando com pré-processador:"
python3 indent_preproc.py test_ok.py > test_ok_proc.py 2>&1
echo "Arquivo processado:"
cat test_ok_proc.py
echo ""
./interpretador test_ok_proc.py 2>&1
status2=$?
echo "Status: $status2"

echo ""
echo "2. TESTE DE ERRO - VARIÁVEL NÃO DEFINIDA"
echo "========================================"
cat > test_erro.py << 'EOF'
print("Inicio")
x = variavel_nao_existe + 5
print("Nunca deve chegar aqui")
EOF

echo "Conteúdo do arquivo de erro:"
cat test_erro.py
echo ""

echo "Executando arquivo de erro:"
output_erro=$(./interpretador test_erro.py 2>&1)
status_erro=$?
echo "Status: $status_erro"
echo "Saída: $output_erro"

if [ $status_erro -ne 0 ]; then
    echo "✅ Erro detectado corretamente (status != 0)"
else
    echo "❌ Erro NÃO foi detectado (status = 0)"
fi

echo ""
echo "3. TESTE DE INTEGRAÇÃO MANUAL"
echo "============================"
cat > test_integracao.py << 'EOF'
x = 10
y = 5
if x > y:
    print("x maior")
contador = 0
while contador < 2:
    print("contador:", contador)
    contador = contador + 1
print("fim")
EOF

echo "Conteúdo do teste de integração:"
cat test_integracao.py
echo ""

python3 indent_preproc.py test_integracao.py > test_integracao_proc.py 2>&1
preproc_status=$?
echo "Status do pré-processador: $preproc_status"

if [ $preproc_status -eq 0 ]; then
    echo "Arquivo processado:"
    cat test_integracao_proc.py
    echo ""
    
    output_int=$(./interpretador test_integracao_proc.py 2>&1)
    status_int=$?
    echo "Status da execução: $status_int"
    echo "Saída: $output_int"
    
    if [ $status_int -eq 0 ]; then
        echo "✅ Teste de integração passou"
    else
        echo "❌ Teste de integração falhou"
    fi
else
    echo "❌ Erro no pré-processador"
    cat test_integracao_proc.py
fi

echo ""
echo "4. VERIFICANDO O QUE O RUN_TESTS.SH ESTÁ FAZENDO"
echo "==============================================="

# Simular exatamente o que o run_tests.sh faz
echo "Simulando o teste de variável não definida do run_tests.sh:"

if [ -f "tests/test_erro_variavel_nao_definida.py" ]; then
    echo "Arquivo existe:"
    cat tests/test_erro_variavel_nao_definida.py
    echo ""
    
    # Exatamente como no run_tests.sh
    python3 indent_preproc.py "tests/test_erro_variavel_nao_definida.py" > "build/processed_test_erro_variavel_nao_definida.py" 2>/dev/null
    timeout 5s ./interpretador "build/processed_test_erro_variavel_nao_definida.py" > /dev/null 2>&1
    test_status=$?
    
    echo "Status do teste (como no run_tests.sh): $test_status"
    
    if [ $test_status -ne 0 ]; then
        echo "✅ O teste deveria PASSAR (erro detectado)"
    else
        echo "❌ O teste está FALHANDO (erro não detectado)"
    fi
    
    # Agora executar sem timeout e ver a saída
    echo ""
    echo "Executando sem timeout para ver a saída:"
    output_completo=$(./interpretador "build/processed_test_erro_variavel_nao_definida.py" 2>&1)
    status_completo=$?
    echo "Status: $status_completo"
    echo "Saída completa: '$output_completo'"
    
else
    echo "❌ Arquivo tests/test_erro_variavel_nao_definida.py não encontrado"
fi

# Cleanup
rm -f test_ok.py test_ok_proc.py test_erro.py test_integracao.py test_integracao_proc.py

echo ""
echo "=== DIAGNÓSTICO CONCLUÍDO ==="