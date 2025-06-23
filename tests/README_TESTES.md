# Testes Automatizados de Mensagens de Erro

Este diretório contém testes automatizados para verificar se as mensagens de erro do interpretador estão funcionando corretamente.

## Como Executar os Testes

### Opção 1: Script Shell (Recomendado)
```bash
# Compilar o interpretador
make

# Executar todos os testes de erro
./test_erros.sh
```

### Opção 2: Via Makefile
```bash
# Compilar e executar testes
make test-erros
```

## Testes Disponíveis

| Teste | Arquivo | Descrição |
|-------|---------|-----------|
| Variável não definida | `test_erro_variavel_nao_definida.py` | Testa acesso a variável não declarada |
| Divisão por zero | `test_erro_divisao_zero.py` | Testa divisão por zero |
| Módulo por zero | `test_erro_modulo_zero.py` | Testa módulo por zero |
| Função não definida | `test_erro_funcao_nao_definida.py` | Testa chamada de função inexistente |
| Erro de sintaxe | `test_erro_sintaxe.py` | Testa erros de sintaxe |
| Caractere inválido | `test_erro_caractere_invalido.py` | Testa caracteres não reconhecidos |
| Indentação inconsistente | `test_erro_indentacao.py` | Testa erros de indentação |
| Arquivo não encontrado | (automático) | Testa arquivo inexistente |

## Exemplo de Saída

```
==========================================
    TESTE AUTOMATIZADO DE MENSAGENS DE ERRO
==========================================

🧪 Testando: Arquivo não encontrado
✅ Arquivo não encontrado: PASSOU

🧪 Testando: Variável não definida
✅ Variável não definida: PASSOU

🧪 Testando: Divisão por zero
✅ Divisão por zero: PASSOU

...

==========================================
              RESUMO DOS TESTES
==========================================
Total de testes: 8
Testes que passaram: 8
Testes que falharam: 0

🎉 TODOS OS TESTES PASSARAM!
```

## Adicionando Novos Testes

Para adicionar um novo teste:

1. Crie um arquivo Python com o código que deve gerar o erro
2. Adicione o teste ao script `test_erros.sh`:
   ```bash
   test_error "tests/novo_teste.py" "padrão esperado" "Descrição do teste"
   ```
3. Execute `./test_erros.sh` para verificar

## Estrutura dos Arquivos de Teste

Cada arquivo de teste contém código que deve gerar um erro específico:

```python
# Exemplo: test_erro_variavel_nao_definida.py
x = 10
print(y)  # y não foi definida - deve gerar erro
```

## Verificação de Padrões

Os testes verificam se as mensagens de erro contêm padrões específicos:

- `variável.*não definida` - Para variáveis não declaradas
- `divisão por zero` - Para divisão por zero
- `módulo por zero` - Para módulo por zero
- `função.*não definida` - Para funções inexistentes
- `erro de sintaxe` - Para erros de sintaxe
- `caractere inválido` - Para caracteres não reconhecidos
- `indentação inconsistente` - Para erros de indentação
- `não foi possível abrir` - Para arquivos não encontrados

## Troubleshooting

### Interpretador não encontrado
```bash
make  # Compile primeiro
```

### Erro de permissão no script
```bash
chmod +x test_erros.sh
```

### Teste falhando
Verifique se:
1. O arquivo de teste existe
2. O padrão esperado está correto
3. A mensagem de erro foi alterada recentemente

---

# Testes da Tabela de Símbolos

## Como Executar

```bash
# Compilar e executar testes da tabela
make test-tabela
```

## Testes Implementados

O arquivo `test_tabela.c` contém testes abrangentes para a tabela de símbolos:

### 1. Teste de Criação e Destruição
- Verifica se a tabela é criada corretamente
- Testa a destruição segura da memória

### 2. Teste de Inserção e Busca
- Insere símbolos de diferentes tipos (int, float, string, bool, null)
- Verifica se os valores são recuperados corretamente
- Testa busca por símbolos inexistentes

### 3. Teste de Atualização
- Insere um símbolo e depois atualiza seu valor
- Verifica se a atualização funciona corretamente

### 4. Teste de Remoção
- Remove símbolos da tabela
- Verifica se a remoção é segura (não causa erros)
- Testa remoção de símbolos inexistentes

### 5. Teste de Colisões de Hash
- Insere múltiplos símbolos que podem gerar colisões
- Verifica se todos os símbolos são acessíveis
- Testa remoção de símbolos do meio da lista encadeada

### 6. Teste de Estresse
- Insere 10.000 símbolos na tabela
- Verifica se todos podem ser recuperados corretamente
- Testa a performance e estabilidade da estrutura

## Exemplo de Saída

```
=== Teste 1: Criacao e Destruicao ===
SUCESSO: Tabela criada

=== Conteudo Detalhado da Tabela de Simbolos ===
Nome                 | Tipo     | Valor          
---------------------------------------------------
<< Tabela vazia >>
Total de simbolos: 0

=== Teste 2: Insercao e Busca ===
SUCESSO: Todos os valores foram inseridos e recuperados corretamente

=== Conteudo Detalhado da Tabela de Simbolos ===
Nome                 | Tipo     | Valor          
---------------------------------------------------
x                    | int      | 42             
mensagem             | string   | "Ola Mundo"    
pi                   | float    | 3.1416         
ativo                | bool     | true           
vazio                | null     | null           
Total de simbolos: 5

---


## Funcionalidades Testadas

- ✅ Criação e destruição da tabela
- ✅ Inserção de símbolos de todos os tipos
- ✅ Busca de símbolos existentes e inexistentes
- ✅ Atualização de valores
- ✅ Remoção segura de símbolos
- ✅ Tratamento de colisões de hash
- ✅ Performance com grande volume de dados
- ✅ Gerenciamento correto de memória

## Estrutura da Tabela

A tabela de símbolos usa:
- **Hash table** com 256 entradas
- **Lista encadeada** para resolver colisões
- **Função hash** DJB2 para distribuição uniforme
- **Alocação dinâmica** para valores de diferentes tipos

---

# Testes da AST

## Como Executar

```bash
# Compilar e executar testes da AST
make test-ast
```

## Testes Implementados

O arquivo `test_ast.c` contém testes abrangentes para a Árvore Sintática Abstrata:

### 1. Teste de Criação de Nós Básicos
- Criação de nós de valor (int, string)
- Criação de nós identificador
- Verificação de tipos e valores corretos

### 2. Teste de Operações Aritméticas
- Criação de operações binárias (adição, módulo)
- Verificação de operadores e operandos
- Teste de estrutura de árvore

### 3. Teste de Estruturas de Controle
- Criação de condicionais if/else
- Criação de loops while
- Verificação de blocos de declarações

### 4. Teste de Chamada de Função
- Criação de chamadas de função com argumentos
- Verificação de nome da função e número de argumentos
- Teste de argumentos de diferentes tipos

### 5. Teste de Destruição Completa
- Criação de AST complexa com múltiplos níveis
- Destruição completa sem vazamentos de memória
- Verificação com valgrind

### 6. Teste de Impressão da AST
- Impressão visual da estrutura da árvore
- Demonstração da hierarquia de nós
- Verificação da formatação

## Exemplo de Saída

```
=== Teste 1: Criacao de Nos basicos ===
SUCESSO: No valor int
SUCESSO: No valor string
SUCESSO: No identificador

=== Teste 2: Operacoes Aritmeticas ===
SUCESSO: Operação de adicao
SUCESSO: Operacao de mod

=== Teste 3: Estruturas de Controle ===
SUCESSO: Condicional if/else
SUCESSO: Loop while

=== Teste 4: Chamada de Funaoo ===
SUCESSO: Chamada de funcao com argumentos

=== Teste 5: Destruio Completa ===
SUCESSO: AST complexa destruida sem vazamentos

=== Teste 6: Impressao da AST ===
AST para (2 + 3) * 4:
OP: 2 (linha 1)
  OP: 0 (linha 1)
    VALOR: 2 (linha 1)
    VALOR: 3 (linha 1)
  VALOR: 4 (linha 1)

Todos os testes da AST passaram com sucesso!
```

## Funcionalidades Testadas

- ✅ Criação de todos os tipos de nós
- ✅ Operações aritméticas e lógicas
- ✅ Estruturas de controle (if/else, while)
- ✅ Chamadas de função com argumentos
- ✅ Blocos de declarações
- ✅ Destruição segura de memória
- ✅ Impressão "visual" da AST
- ✅ Gerenciamento de ponteiros

## Tipos de Nós Testados

- **NODO_VALOR**: Inteiros, floats, strings, booleanos
- **NODO_IDENTIFICADOR**: Variáveis
- **NODO_OPERACAO**: Operações binárias e unárias
- **NODO_ATRIBUICAO**: Atribuições de variáveis
- **NODO_CHAMADA_FUNCAO**: Chamadas de função
- **NODO_CONDICIONAL**: Estruturas if/else
- **NODO_LOOP**: Loops while
- **NODO_BLOCO**: Blocos de declarações

---

# Testes do Analisador Léxico

## Como Executar

```bash
# Compilar e executar testes do analisador léxico
make test-lexer
```

## Testes Implementados

O arquivo `test_lexer.c` contém testes manuais para o analisador léxico (Flex):

### Funcionalidades Testadas

- ✅ **Reconhecimento de todos os tokens** da linguagem
- ✅ **Valores associados aos tokens** (inteiros, floats, strings, booleanos)
- ✅ **Controle de linha** (NEWLINE, INDENT, DEDENT)
- ✅ **Palavras-chave** (if, else, while, print, input, etc.)
- ✅ **Operadores** (aritméticos, lógicos, de comparação)
- ✅ **Identificadores** e literais
- ✅ **Números de linha** corretos

## Exemplo de Saída

```
--- Iniciando Analise Lexica de 'test1.txt' ---

Linha 1   | Token: ID           | Texto: 'x' (Valor: "x")
Linha 1   | Token: ASSIGN       | Texto: '='
Linha 1   | Token: INT          | Texto: '10' (Valor: 10)
Linha 1   | Token: NEWLINE      | [Controle de Bloco/Linha]
Linha 2   | Token: IF           | Texto: 'if'
Linha 2   | Token: ID           | Texto: 'x' (Valor: "x")
Linha 2   | Token: GT           | Texto: '>'
Linha 2   | Token: INT          | Texto: '5' (Valor: 5)
Linha 2   | Token: COLON        | Texto: ':'
Linha 2   | Token: NEWLINE      | [Controle de Bloco/Linha]
Linha 3   | Token: INDENT       | [Controle de Bloco/Linha]
Linha 3   | Token: PRINT        | Texto: 'print'
Linha 3   | Token: LPAREN       | Texto: '('
Linha 3   | Token: STRING       | Texto: '"x é maior que 5"' (Valor: "x é maior que 5")
Linha 3   | Token: RPAREN       | Texto: ')'
Linha 3   | Token: NEWLINE      | [Controle de Bloco/Linha]
Linha 4   | Token: DEDENT       | [Controle de Bloco/Linha]

[...]

--- Fim da Analise Lexica ---
```

## Tokens Reconhecidos

### Palavras-chave
- `if`, `else`, `while`, `break`, `continue`
- `and`, `or`, `not`
- `print`, `input`
- `True`, `False`

### Operadores
- **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `**`
- **Comparação**: `==`, `!=`, `>`, `<`, `>=`, `<=`
- **Atribuição**: `=`
- **Lógicos**: `and`, `or`, `not`

### Literais
- **Inteiros**: `42`, `-10`, `+5`
- **Floats**: `3.14`, `-2.5`, `1e-3`
- **Strings**: `"hello"`, `'world'`
- **Booleanos**: `True`, `False`

### Controle
- **NEWLINE**: Quebras de linha
- **INDENT**: Indentação (processada pelo pré-processador)
- **DEDENT**: Redução de indentação

---

# Testes da Integração AST - Tabela

## Como Executar

```bash
# Compilar e executar testes de integração
make test-integrado
```

## Testes Implementados

O arquivo `test_tabela-ast.c` contém testes de integração entre a AST e a tabela de símbolos:

### 1. Teste de Avaliação de Expressões
- Avaliação de expressões aritméticas simples
- Integração entre nós da AST e busca na tabela
- Verificação de resultados corretos

### 2. Teste de Atribuições
- Criação de variáveis na tabela através da AST
- Atualização de valores existentes
- Verificação de persistência dos dados

### 3. Teste de Blocos de Instruções
- Execução sequencial de múltiplas instruções
- Compartilhamento de contexto entre instruções
- Verificação de dependências entre variáveis

## Exemplo de Saída

```
=== CASO 1 - RESULTADO ESPERADO === 

 resultado = (10 + 5) * 2   ---> 30 

=== CASO 1 - RESULTADO OBTIDO === 
Resultado: 30

=== CASO 2 - RESULTADO ESPERADO === 

 a = 20; b = 5; resultado = (20*3) - (5+10)/3 = 60 - 15/3 = 60 - 5   ---> 55 

=== CASO 2 - RESULTADO OBTIDO === 
a = 20
b = 5
resultado = 55
```

## Funcionalidades Testadas

- ✅ **Avaliação de expressões** aritméticas
- ✅ **Integração AST-Tabela** para busca de variáveis
- ✅ **Atribuições** com criação/atualização de símbolos
- ✅ **Execução de blocos** de instruções
- ✅ **Precedência de operadores** correta
- ✅ **Gerenciamento de memória** integrado

## Casos de Teste

### Caso 1: Expressão Simples
```c
resultado = (10 + 5) * 2
// Resultado esperado: 30
```

### Caso 2: Bloco Complexo
```c
a = 20
b = 5
resultado = (a * 3) - (b + 10) / 3
// Resultado esperado: 55
```

## Arquitetura Testada

- **AST**: Representação da estrutura do código
- **Tabela de Símbolos**: Armazenamento de variáveis
- **Avaliador**: Interpretação das expressões
- **Integração**: Comunicação entre os componentes

