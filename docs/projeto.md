# Documentação do Projeto

Esta seção contém a documentação técnica detalhada do interpretador Python, incluindo estrutura de arquivos e componentes do sistema.

## Fluxo Geral

O interpretador Python segue um fluxo clássico de compiladores com as seguintes fases:

```
CÓDIGO PYTHON (entrada)
           |
           v
    PRÉ-PROCESSADOR
    (indent_preproc.py)
    • Converte indentação em tokens @INDENT@/@DEDENT@
    • Remove comentários
    • Normaliza quebras de linha
           |
           v
    ANALISADOR LÉXICO
    (Flex/lexer.l)
    • Identifica tokens (palavras-chave, operadores, etc.)
    • Converte texto em sequência de tokens
    • Detecta erros léxicos
           |
           v
    ANALISADOR SINTÁTICO
    (Bison/parser.y)
    • Verifica estrutura gramatical
    • Constrói a Árvore Sintática Abstrata (AST)
    • Detecta erros sintáticos
           |
           v
    ÁRVORE SINTÁTICA ABSTRATA (AST)
    • Representação hierárquica do código
    • Estrutura de dados em árvore
    • Nós para cada tipo de instrução
           |
           v
    INTERPRETADOR
    (interpretador.c)
    • Percorre a AST recursivamente
    • Executa instruções
    • Gerencia tabela de símbolos
    • Trata erros de execução
           |
           v
    RESULTADO (saída)
```

## Estrutura Detalhada do Projeto

### Arquivos Principais

#### main.c
**Função**: Ponto de entrada do programa

**Responsabilidades**:
- Inicialização do sistema
- Abertura e validação do arquivo de entrada
- Chamada do parser (yyparse)
- Execução do interpretador
- Tratamento de erros de alto nível

**Fluxo principal**:
```c
1. Validar argumentos de linha de comando
2. Abrir arquivo Python de entrada
3. Configurar entrada para o lexer (yyin)
4. Executar análise sintática (yyparse)
5. Verificar se AST foi criada com sucesso
6. Executar interpretador na AST
7. Limpar recursos e finalizar
```

#### Makefile
**Função**: Sistema de build automatizado

**Responsabilidades**:
- Compilação do projeto
- Geração de arquivos Flex/Bison
- Execução de testes
- Limpeza de arquivos temporários

**Alvos principais**:
- `make` - Compila o projeto
- `make clean` - Remove arquivos compilados
- `make run` - Compila e executa
- `make test` - Executa suite de testes
- `make test-complete` - Executa todos os testes

#### indent_preproc.py
**Função**: Pré-processador de indentação Python

**Responsabilidades**:
- Converter espaços/tabs em tokens `@INDENT@` e `@DEDENT@`
- Remover comentários (linhas começando com `#`)
- Normalizar quebras de linha
- Detectar erros de indentação inconsistente

**Algoritmo**:
```python
1. Ler arquivo linha por linha
2. Calcular nível de indentação atual
3. Comparar com nível anterior
4. Gerar tokens @INDENT@ ou @DEDENT@ conforme necessário
5. Remover comentários e espaços em branco
6. Validar consistência da indentação
```

### Pasta lexer/

#### lexer.l
**Função**: Especificação do analisador léxico (Flex)

**Responsabilidades**:
- Reconhecimento de tokens Python
- Conversão de texto em sequência de tokens
- Detecção de erros léxicos

**Tokens reconhecidos**:
- **Palavras-chave**: `if`, `else`, `while`, `break`, `continue`, `and`, `or`, `not`, `True`, `False`, `print`, `input`
- **Operadores**: `+`, `-`, `*`, `/`, `%`, `**`, `==`, `!=`, `<`, `>`, `<=`, `>=`, `=`
- **Literais**: Inteiros, floats, strings, booleanos
- **Identificadores**: Nomes de variáveis e funções
- **Especiais**: `@INDENT@`, `@DEDENT@`, `:`, `,`, `(`, `)`, `\n`

### Pasta parser/

#### parser.y
**Função**: Gramática do analisador sintático (Bison)

**Responsabilidades**:
- Definição da gramática Python simplificada
- Construção da Árvore Sintática Abstrata (AST)
- Detecção de erros sintáticos
- Gerenciamento de precedência de operadores

**Regras gramaticais principais**:
```yacc
programa: statement_list
statement: simple_stmt | compound_stmt
simple_stmt: atribuicao | chamada_funcao | BREAK | CONTINUE
compound_stmt: condicional | loop
expressao: termo | expressao ADD termo | expressao SUB termo
termo: fator | termo MUL fator | termo DIV fator
```

#### ast.h e ast.c
**Função**: Definição e implementação da Árvore Sintática Abstrata

**Responsabilidades**:
- Estrutura de dados para representar o código
- Funções de criação e destruição de nós
- Diferentes tipos de nós (operações, valores, estruturas de controle)

**Tipos de nós**:
```c
typedef enum {
    NODO_OPERACAO,      // Operações binárias (+, -, *, /, etc.)
    NODO_VALOR,         // Valores literais (42, "texto", True)
    NODO_IDENTIFICADOR, // Nomes de variáveis
    NODO_ATRIBUICAO,    // Atribuições (x = 10)
    NODO_CHAMADA_FUNCAO,// Chamadas de função (print(x))
    NODO_CONDICIONAL,   // Estruturas if/else
    NODO_LOOP,          // Loops while
    NODO_BLOCO,         // Blocos de código
    NODO_BREAK,         // Instrução break
    NODO_CONTINUE       // Instrução continue
} TipoNo;
```

#### types.h
**Função**: Definições de tipos de dados do sistema

**Responsabilidades**:
- Tipos de dados suportados (int, float, string, bool)
- Estruturas para resultados de expressões
- Definições de operadores

**Tipos principais**:
```c
typedef enum { 
    TIPO_INT, TIPO_FLOAT, TIPO_STRING, TIPO_BOOL, TIPO_NULO 
} TipoDado;

typedef enum {
    ADICAO, SUBTRACAO, MULTIPLICACAO, DIVISAO, MODULO, POTENCIA,
    IGUAL, DIFERENTE, MENOR, MENOR_IGUAL, MAIOR, MAIOR_IGUAL,
    E_LOGICO, OU_LOGICO, NAO_LOGICO
} TipoOperador;
```

#### tabela.h e tabela.c
**Função**: Tabela de símbolos para gerenciamento de variáveis

**Responsabilidades**:
- Armazenamento de variáveis e seus valores
- Busca e inserção de símbolos
- Gerenciamento de escopo (simplificado)

**Estrutura**:
```c
typedef struct {
    char *nome;
    Resultado valor;
} Simbolo;

typedef struct {
    Simbolo *simbolos;
    int tamanho;
    int capacidade;
} TabelaSimbolos;
```

#### interpretador.h e interpretador.c
**Função**: Motor de execução do interpretador

**Responsabilidades**:
- Interpretação da AST
- Execução de instruções
- Gerenciamento da tabela de símbolos
- Tratamento de erros de execução

**Funções principais**:
```c
void interpretar(NoAst *no);                    // Função principal
Resultado interpretar_expressao(NoAst *no);     // Avalia expressões
void interpretar_atribuicao(NoAst *no);         // Executa atribuições
void interpretar_condicional(NoAst *no);        // Executa if/else
void interpretar_loop(NoAst *no);               // Executa while
```

### Pasta tests/

**Função**: Suite completa de testes do sistema

**Organização**:
- **`test_*.py`** - Testes de funcionalidade (código Python)
- **`test_*.c`** - Testes unitários (componentes C)
- **`test_erro_*.py`** - Testes de tratamento de erros

**Principais categorias**:
1. **Testes de Expressões** - Operações aritméticas e lógicas
2. **Testes de Estruturas** - Condicionais, loops, funções
3. **Testes de Tipos** - Inteiros, floats, strings, booleanos
4. **Testes de Erro** - Tratamento de exceções e erros
5. **Testes Unitários** - Componentes individuais

### Pasta scripts/

**Função**: Scripts de automação e teste

**Scripts principais**:
- **`run_tests.sh`** - Suite completa de testes
- **`test_resultados.sh`** - Verificação de resultados
- **`test_erros.sh`** - Testes de tratamento de erros
- **`quick_test.sh`** - Teste rápido

## Componentes do Sistema

### 1. Pré-processador (indent_preproc.py)
O pré-processador resolve um dos maiores desafios da linguagem Python: a indentação. Ele converte a indentação baseada em espaços em tokens explícitos que podem ser processados pelo lexer.

**Desafios resolvidos**:
- Detecção de níveis de indentação
- Validação de consistência
- Geração de tokens `@INDENT@` e `@DEDENT@`

### 2. Analisador Léxico (lexer.l)
O lexer identifica e categoriza os elementos básicos da linguagem Python.

**Características**:
- Reconhecimento de todos os tokens Python básicos
- Tratamento de strings com aspas simples e duplas
- Suporte a números inteiros, floats e notação científica
- Detecção de palavras-chave e identificadores

### 3. Analisador Sintático (parser.y)
O parser verifica a estrutura gramatical e constrói a AST.

**Funcionalidades**:
- Gramática Python simplificada mas completa
- Precedência de operadores correta
- Construção hierárquica da AST
- Detecção de erros sintáticos

### 4. Árvore Sintática Abstrata (AST)
A AST é a representação intermediária do código fonte.

**Vantagens**:
- Estrutura hierárquica clara
- Fácil navegação e interpretação
- Separação entre análise e execução
- Base para otimizações futuras

### 5. Interpretador (interpretador.c)
O interpretador executa o código representado pela AST.

**Capacidades**:
- Execução de expressões aritméticas e lógicas
- Controle de fluxo (if/else, while)
- Gerenciamento de variáveis
- Funções built-in (print)

### 6. Tabela de Símbolos (tabela.c)
Gerencia o armazenamento e acesso a variáveis.

**Funcionalidades**:
- Inserção e busca eficiente de símbolos
- Armazenamento de diferentes tipos de dados
- Gerenciamento de memória automático

## Funcionalidades Implementadas

### Tipos de Dados
- **Inteiros**: Suporte completo a números inteiros positivos e negativos
- **Ponto Flutuante**: Números decimais e notação científica
- **Strings**: Texto entre aspas simples ou duplas
- **Booleanos**: Valores `True` e `False`

### Operadores
- **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `**`
- **Comparação**: `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Lógicos**: `and`, `or`, `not`

### Estruturas de Controle
- **Condicionais**: `if`/`else` com suporte a blocos aninhados
- **Loops**: `while` com suporte a `break` e `continue`
- **Blocos**: Indentação Python completa

### Funções Built-in
- **`print()`**: Saída formatada com múltiplos argumentos

### Tratamento de Erros
- **Erros léxicos**: Caracteres inválidos
- **Erros sintáticos**: Estrutura gramatical incorreta
- **Erros semânticos**: Variáveis não definidas, divisão por zero
- **Erros de indentação**: Inconsistência na indentação

## Fluxo de Dados

### 1. Compilação
```bash
# Flex gera lexer.c
flex -o build/lexer.c lexer/lexer.l

# Bison gera parser.tab.c e parser.tab.h
bison -d -t -o parser/parser.tab.c parser/parser.y

# GCC compila todos os arquivos
gcc -Iparser -Wall -Wextra -g *.c parser/*.c build/*.c -o interpretador -lfl -lm
```

### 2. Execução
```bash
# 1. Pré-processamento
python3 indent_preproc.py arquivo.py > build/processed.py

# 2. Análise léxica e sintática
./interpretador build/processed.py

# 3. Interpretação
# O interpretador percorre a AST e executa as instruções
```

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/06/2025 |  Criação do documento | [Arthur Evangelista](https://github.com/arthurevg) |

---

*Esta documentação técnica fornece uma visão completa da arquitetura e implementação do interpretador Python.* 