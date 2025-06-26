#!/bin/bash

echo "=== TESTE DOS ARQUIVOS DE ERRO CORRIGIDOS ==="

# Compilar o projeto
make clean > /dev/null 2>&1
make all > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ ERRO: Falha na compilação"
    exit 1
fi

echo "✅ Projeto compilado com sucesso"
echo ""

# Função para testar um arquivo de erro
test_error_file() {
    local filename="$1"
    local description="$2"
    
    echo "Testando: $description"
    echo "Arquivo: tests/$filename"
    
    if [ -f "tests/$filename" ]; then
        echo "Conteúdo:"
        cat "tests/$filename" | head -5
        echo ""
        
        # Processar com pré-processador
        python3 indent_preproc.py "tests/$filename" > "build/processed_$filename" 2>&1
        preproc_status=$?
        
        if [ $preproc_status -eq 0 ]; then
            # Executar interpretador
            output=$(./interpretador "build/processed_$filename" 2>&1)
            interpreter_status=$?
            
            echo "Status do interpretador: $interpreter_status"
            echo "Saída: $output"
            
            if [ $interpreter_status -ne 0 ]; then
                echo "✅ TESTE PASSOU - Erro detectado corretamente"
            else
                echo "❌ TESTE FALHOU - Erro não foi detectado"
            fi
        else
            echo "Erro no pré-processamento:"
            cat "build/processed_$filename"
            echo "✅ TESTE PASSOU - Erro detectado no pré-processamento"
        fi
    else
        echo "❌ Arquivo não encontrado"
    fi
    
    echo ""
    echo "----------------------------------------"
    echo ""
}

# Testar todos os arquivos de erro
test_error_file "test_erro_sintaxe.py" "Erro de Sintaxe"
test_error_file "test_erro_variavel_nao_definida.py" "Variável Não Definida"
test_error_file "test_erro_divisao_zero.py" "Divisão por Zero"
test_error_file "test_erro_modulo_zero.py" "Módulo por Zero"
test_error_file "test_erro_caractere_invalido.py" "Caractere Inválido"
test_error_file "test_erro_indentacao.py" "Erro de Indentação"

echo "=== TESTE CONCLUÍDO ==="