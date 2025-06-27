# 🧪 Documentação dos Testes

Esta seção descreve a suite completa de testes do interpretador Python, incluindo como executá-los e entender seus resultados.

## 📋 Visão Geral dos Testes

O projeto inclui uma suite abrangente de testes que cobre:

- ✅ **Testes unitários**: Componentes individuais (AST, tabela de símbolos)
- ✅ **Testes de integração**: Funcionalidades completas
- ✅ **Testes de erro**: Tratamento de exceções e erros
- ✅ **Testes de funcionalidade**: Recursos específicos do Python
- ✅ **Testes de casos extremos**: Cenários limite

## 🚀 Execução dos Testes

### Comandos Principais

```bash
# Executar todos os testes
make test-complete

# Executar testes específicos
make test-expressoes
make test-condicionais
make test-loops
make test-erros
make test-tipos
make test-lexer
...
```
## ⚠️ Atenção para Usuários Windows/WSL

Se você está utilizando o Windows com WSL (Windows Subsystem for Linux):

- **Sempre execute os comandos de compilação e testes pelo terminal do WSL** (Ubuntu, por exemplo), e não pelo CMD ou PowerShell do Windows.
- Antes de rodar os scripts `.sh`, converta os finais de linha dos arquivos para o formato Unix e dê permissão de execução:

```bash
cd Trab_Compiladores
dos2unix scripts/*.sh
chmod +x scripts/*.sh
```

- Depois disso, rode normalmente os comandos:
```bash
make
make run
make test-resultados
```

Se não fizer isso, você pode receber erros como “cannot execute: required file not found” ou “not found”.

### Testes Individuais

```bash
# Testes de componentes
make test-tabela
make test-ast
make test-integrado
make test-lexer

# Testes de funcionalidade
make test-expressoes
make test-condicionais
make test-loops
make test-tipos
make test-comparacoes
make test-casos-extremos
make test-funcoes-builtin
make test-operadores-logicos
make test-precedencia-operadores

# Testes de erro
make test-erros
make test-resultados
```

## 📁 Estrutura dos Testes

### Testes Unitários (C)

#### `test_ast.c` - Testes da Árvore Sintática Abstrata
```c
// Testa criação de nós
void test_criar_no_valor_int() {
    NoAst *no = criar_no_valor_int(42, 1);
    assert(no->tipo == NODO_VALOR);
    assert(no->dados.literal.tipo == TIPO_INT);
    assert(no->dados.literal.valor.int_val == 42);
    destruir_ast(no);
}

// Testa operações
void test_criar_no_operacao() {
    NoAst *esq = criar_no_valor_int(10, 1);
    NoAst *dir = criar_no_valor_int(5, 1);
    NoAst *op = criar_no_operacao(ADICAO, esq, dir, 1);
    
    assert(op->tipo == NODO_OPERACAO);
    assert(op->dados.operacao.operador == ADICAO);
    destruir_ast(op);
}
```

#### `test_tabela.c` - Testes da Tabela de Símbolos
```c
// Testa inserção e busca
void test_inserir_buscar_simbolo() {
    TabelaSimbolos *tabela = criar_tabela_simbolos();
    
    Resultado valor;
    valor.tipo = TIPO_INT;
    valor.valor.int_val = 42;
    
    inserir_simbolo(tabela, "x", valor);
    
    Resultado *encontrado = buscar_simbolo(tabela, "x");
    assert(encontrado != NULL);
    assert(encontrado->tipo == TIPO_INT);
    assert(encontrado->valor.int_val == 42);
    
    destruir_tabela_simbolos(tabela);
}
```

#### `test_lexer.c` - Testes do Analisador Léxico
```c
// Testa reconhecimento de tokens
void test_tokens_basicos() {
    FILE *file = fopen("test1.txt", "r");
    yyin = file;
    
    int token = yylex();
    assert(token == ID); // Primeiro token deve ser um identificador
    
    token = yylex();
    assert(token == ASSIGN); // Segundo token deve ser atribuição
    
    fclose(file);
}
```

### Testes de Funcionalidade (Python)

#### `test_expressoes.py` - Testes de Expressões
```python
# Testa operações aritméticas básicas
x = 10
y = 5
print("Soma:", x + y)
print("Subtração:", x - y)
print("Multiplicação:", x * y)
print("Divisão:", x / y)
print("Módulo:", x % y)
print("Potência:", x ** y)
```

#### `test_condicionais.py` - Testes de Estruturas Condicionais
```python
# Testa if/else básico
x = 10
if x > 5:
    print("x é maior que 5")
else:
    print("x é menor ou igual a 5")

# Testa condicionais aninhadas
if x > 15:
    print("x é muito grande")
elif x > 10:
    print("x é grande")
elif x > 5:
    print("x é médio")
else:
    print("x é pequeno")
```

#### `test_loops.py` - Testes de Loops
```python
# Testa loop while básico
contador = 0
while contador < 5:
    print("Contador:", contador)
    contador = contador + 1

# Testa break
i = 0
while True:
    if i >= 10:
        break
    print("i =", i)
    i = i + 1

# Testa continue
j = 0
while j < 10:
    j = j + 1
    if j % 2 == 0:
        continue
    print("Ímpar:", j)
```

#### `test_tipos_dados.py` - Testes de Tipos de Dados
```python
# Testa todos os tipos suportados
inteiro = 42
float_num = 3.14
string_texto = "Hello, World!"
booleano = True

print("Inteiro:", inteiro)
print("Float:", float_num)
print("String:", string_texto)
print("Booleano:", booleano)

# Testa operações entre tipos
resultado = inteiro + float_num
print("Soma int + float:", resultado)
```

### Testes de Erro

#### `test_erro_sintaxe.py` - Testes de Erro Sintático
```python
# Código com erro de sintaxe
x = 10
y =  # Erro: valor faltando
print(x)
```

#### `test_erro_variavel_nao_definida.py` - Testes de Variável Não Definida
```python
# Tenta usar variável não definida
print(x)  # x não foi definida
```

#### `test_erro_divisao_zero.py` - Testes de Divisão por Zero
```python
# Tenta dividir por zero
resultado = 10 / 0
```

#### `test_erro_indentacao.py` - Testes de Erro de Indentação
```python
# Código com indentação inconsistente
if True:
    print("Correto")
  print("Indentação errada")  # Erro de indentação
```

## 🔧 Scripts de Automação

### `scripts/run_tests.sh` - Script Principal de Testes
```bash
#!/bin/bash
# Executa todos os testes do projeto

echo "🧪 Executando suite completa de testes..."

# Testes unitários
echo "📋 Testes unitários..."
make test-tabela
make test-ast
make test-integrado

# Testes de funcionalidade
echo "🔧 Testes de funcionalidade..."
make test-expressoes
make test-condicionais
make test-loops
make test-tipos

# Testes de erro
echo "⚠️ Testes de erro..."
make test-erros

echo "✅ Todos os testes concluídos!"
```

### `scripts/test_erros.sh` - Testes de Tratamento de Erros
```bash
#!/bin/bash
# Testa o tratamento de erros do interpretador

echo "⚠️ Testando tratamento de erros..."

# Testa erro de sintaxe
echo "Testando erro de sintaxe..."
./interpretador tests/test_erro_sintaxe.py 2>&1 | grep -q "ERRO"

# Testa variável não definida
echo "Testando variável não definida..."
./interpretador tests/test_erro_variavel_nao_definida.py 2>&1 | grep -q "não definida"

# Testa divisão por zero
echo "Testando divisão por zero..."
./interpretador tests/test_erro_divisao_zero.py 2>&1 | grep -q "Divisão por zero"
```

### `scripts/test_resultados.sh` - Testes de Resultados
```bash
#!/bin/bash
# Testa se os resultados estão corretos

echo "📊 Testando resultados..."

# Testa operações aritméticas
echo "Testando operações aritméticas..."
resultado=$(./interpretador tests/test_expressoes.py 2>/dev/null | grep "Soma:" | cut -d' ' -f2)
if [ "$resultado" = "15" ]; then
    echo "✅ Operações aritméticas OK"
else
    echo "❌ Erro nas operações aritméticas"
fi
```

## 📊 Interpretação dos Resultados

### Saída de Testes Bem-sucedidos
```bash
$ make test
📋 Testes unitários...
✅ Testes da tabela de símbolos
✅ Testes da AST
✅ Testes de integração
🔧 Testes de funcionalidade...
✅ test-expressoes
✅ test-condicionais
✅ test-loops
✅ test-tipos
⚠️ Testes de erro...
✅ test-erros
✅ Todos os testes foram executados!
```

### Saída de Testes com Falha
```bash
$ make test
📋 Testes unitários...
❌ Testes da tabela de símbolos
✅ Testes da AST
✅ Testes de integração
🔧 Testes de funcionalidade...
❌ test-expressoes
✅ test-condicionais
✅ test-loops
✅ test-tipos
⚠️ Testes de erro...
✅ test-erros
```

## 🐛 Debugging de Testes

### Usando GDB para Debugging
```bash
# Compilar com debug
make clean && make

# Executar teste específico com GDB
gdb --args ./interpretador tests/test_expressoes.py

# Dentro do GDB
(gdb) run
(gdb) bt  # Se houver crash
(gdb) info locals  # Ver variáveis locais
```

### Logs Detalhados
```bash
# Executar com output detalhado
make test 2>&1 | tee test_log.txt

# Ver apenas erros
make test 2>&1 | grep -i error

# Ver apenas warnings
make test 2>&1 | grep -i warning
```

## 📈 Cobertura de Testes

### Funcionalidades Testadas

| Funcionalidade | Testes | Status |
|----------------|--------|--------|
| **Operações Aritméticas** | `test_expressoes.py` | ✅ |
| **Estruturas Condicionais** | `test_condicionais.py` | ✅ |
| **Loops** | `test_loops.py` | ✅ |
| **Tipos de Dados** | `test_tipos_dados.py` | ✅ |
| **Operadores Lógicos** | `test_operadores_logicos.py` | ✅ |
| **Precedência de Operadores** | `test_precedencia_operadores.py` | ✅ |
| **Funções Built-in** | `test_funcoes_builtin.py` | ✅ |
| **Tratamento de Erros** | `test_erro_*.py` | ✅ |
| **Casos Extremos** | `test_casos_extremos.py` | ✅ |

### Componentes Testados

| Componente | Teste | Status |
|------------|-------|--------|
| **AST** | `test_ast.c` | ✅ |
| **Tabela de Símbolos** | `test_tabela.c` | ✅ |
| **Lexer** | `test_lexer.c` | ✅ |
| **Parser** | `test_parser.c` | ✅ |
| **Interpretador** | Testes de integração | ✅ |


### Mensagens de Erro Testadas

| Tipo de Erro | Arquivo de Teste | Mensagem Esperada | Status |
|--------------|------------------|-------------------|--------|
| **Divisão por Zero** | `test_erro_divisao_zero.py` | `"Divisão por zero"` | ✅ |
| **Módulo por Zero** | `test_erro_modulo_zero.py` | `"Módulo por zero"` | ✅ |
| **Variável Não Definida** | `test_erro_variavel_nao_definida.py` | `"Variável 'x' não definida"` | ✅ |
| **Função Não Definida** | `test_erro_funcao_nao_definida.py` | `"Função 'add' não definida"` | ✅ |
| **Erro de Sintaxe** | `test_erro_sintaxe.py` | `"syntax error"` | ✅ |
| **Erro de Indentação** | `test_erro_indentacao.py` | `"Indentação inconsistente na linha"` | ✅ |
| **Caractere Inválido** | `test_erro_caractere_invalido.py` | `"Caractere inválido '@'"` | ✅ |
| **Arquivo Inexistente** | `test_erro_arquivo_inexistente.py` | `"Não foi possível abrir o arquivo"` | ✅ |


## 🔄 Adicionando Novos Testes

### Criando Teste de Funcionalidade
1. **Criar arquivo Python** em `tests/`:
```python
# tests/test_nova_funcionalidade.py
# Testa nova funcionalidade
x = 10
y = 20
resultado = x + y
print("Resultado:", resultado)
```

2. **Adicionar ao Makefile**:
```makefile
test-nova-funcionalidade: $(TARGET)
	@if [ -f "$(TESTS_DIR)/test_nova_funcionalidade.py" ]; then \
		# ... lógica do teste
	fi
```

### Criando Teste Unitário
1. **Criar arquivo C** em `tests/`:
```c
// tests/test_novo_componente.c
#include <assert.h>
#include "../parser/novo_componente.h"

void test_nova_funcionalidade() {
    // Teste da nova funcionalidade
    assert(1 == 1); // Placeholder
}

int main() {
    test_nova_funcionalidade();
    return 0;
}
```

2. **Adicionar ao Makefile**:
```makefile
test-novo-componente: $(BUILD_DIR)/test_novo_componente
	@if ./$< > /dev/null 2>&1; then \
		echo "✅ Testes do novo componente"; \
	else \
		echo "❌ Testes do novo componente"; \
	fi

$(BUILD_DIR)/test_novo_componente: test_novo_componente.c $(BUILD_DIR)/novo_componente.o | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@
```

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/06/2025 |  Criação do documento | [Arthur Evangelista](https://github.com/arthurevg) |

---

*Os testes garantem que o interpretador funcione corretamente e ajudam a detectar regressões durante o desenvolvimento.* 