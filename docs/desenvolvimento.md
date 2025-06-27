# 👨‍💻 Guia para Desenvolvedores

Este guia é destinado a desenvolvedores que querem contribuir para o projeto do interpretador Python, adicionar novas funcionalidades ou corrigir bugs.

## 🎯 Como Contribuir

### 1. Preparação do Ambiente

Antes de começar a desenvolver, certifique-se de que o ambiente está configurado:

```bash
# Clonar o repositório
git clone https://github.com/Frans6/Trab_Compiladores.git
cd Trab_Compiladores

# Instalar dependências (se necessário)
sudo apt install build-essential flex bison python3 make

# Compilar o projeto
make clean && make

# Executar testes para verificar se tudo está funcionando
make test-complete
```

### 2. Estrutura do Código

#### Convenções de Código

**C (Parser/Interpreter)**:
```c
// Nomes de funções: snake_case
void interpretar_expressao(NoAst *no) {
    // Comentários explicativos para lógica complexa
    if (!no) return;
    
    // Espaçamento consistente
    switch (no->tipo) {
        case NODO_OPERACAO:
            interpretar_operacao(no);
            break;
        case NODO_VALOR:
            interpretar_valor(no);
            break;
        default:
            fprintf(stderr, "Tipo de nó não suportado\n");
    }
}

// Estruturas: PascalCase
typedef struct {
    char *nome;
    Resultado valor;
} Simbolo;
```

**Flex (Lexer)**:
```c
// tokens sempre em MAIÚSCULAS
"if"         { return IF; }
"while"      { return WHILE; }

// Padrões com nomes descritivos
DIGIT       [0-9]
ID          [a-zA-Z_][a-zA-Z0-9_]*
```

**Bison (Parser)**:
```yacc
// Regras gramaticais com comentários
expressao: 
    termo 
        { $$ = $1; }
    | expressao ADD termo 
        { $$ = criar_no_operacao(ADICAO, $1, $3, @1.first_line); }
    ;
```

### 3. Fluxo de Desenvolvimento

#### Adicionando Nova Funcionalidade

1. **Identificar onde adicionar**:
   - **Lexer**: Novos tokens em `lexer/lexer.l`
   - **Parser**: Novas regras gramaticais em `parser/parser.y`
   - **AST**: Novos tipos de nós em `parser/ast.h`
   - **Interpreter**: Nova lógica em `parser/interpretador.c`

2. **Exemplo: Adicionar operador `//` (divisão inteira)**:

```c
// 1. Adicionar token no lexer (lexer/lexer.l)
"//" { return IDIV; }  // Divisão inteira

// 2. Declarar token no parser (parser/parser.y)
%token IDIV

// 3. Adicionar à gramática
termo: 
    fator 
        { $$ = $1; }
    | termo IDIV fator 
        { $$ = criar_no_operacao(DIVISAO_INTEIRA, $1, $3, @1.first_line); }
    ;

// 4. Adicionar tipo de operador (parser/types.h)
typedef enum {
    ADICAO, SUBTRACAO, MULTIPLICACAO, DIVISAO, DIVISAO_INTEIRA, MODULO, POTENCIA,
    // ... outros operadores
} TipoOperador;

// 5. Implementar no interpretador (parser/interpretador.c)
case DIVISAO_INTEIRA:
    if (dir_valor.valor.int_val == 0) {
        fprintf(stderr, "[ERRO]: Divisão por zero\n");
        return resultado_erro();
    }
    resultado.tipo = TIPO_INT;
    resultado.valor.int_val = esq_valor.valor.int_val / dir_valor.valor.int_val;
    break;
```

#### Corrigindo Bugs

1. **Identificar o problema**:
```bash
# Executar com GDB para debugging
make clean && make
gdb --args ./interpretador arquivo_com_bug.py
(gdb) run
(gdb) bt  # Se houver crash
```

2. **Adicionar testes**:
```python
# tests/test_divisao_inteira.py
x = 10
y = 3
resultado = x / y
print("Divisão inteira:", resultado)  # Deve imprimir 3
```

3. **Corrigir e testar**:
```bash
make test-divisao-inteira
```

### 4. Testes

#### Executando Testes Durante Desenvolvimento

```bash
# Teste específico durante desenvolvimento
make test-expressoes

# Todos os testes relacionados
make test-parser-suite

# Testes de erro
make test-erros

# Suite completa (antes do commit)
make test-complete
```

#### Adicionando Novos Testes

**Teste de Funcionalidade**:
```python
# tests/test_nova_funcionalidade.py
# Testa a nova funcionalidade implementada
x = 10
y = 5
resultado = x // y  # Nova operação
print("Resultado:", resultado)

# Testa casos extremos
print("Divisão por 1:", x // 1)
print("Divisão por si mesmo:", x // x)
```

**Teste Unitário**:
```c
// tests/test_nova_funcionalidade.c
#include <assert.h>
#include "../parser/ast.h"

void test_nova_operacao() {
    NoAst *esq = criar_no_valor_int(10, 1);
    NoAst *dir = criar_no_valor_int(3, 1);
    NoAst *op = criar_no_operacao(DIVISAO_INTEIRA, esq, dir, 1);
    
    assert(op->tipo == NODO_OPERACAO);
    assert(op->dados.operacao.operador == DIVISAO_INTEIRA);
    
    destruir_ast(op);
}

int main() {
    test_nova_operacao();
    printf("✅ Testes da nova funcionalidade passaram\n");
    return 0;
}
```

### 5. Debugging

#### Usando GDB

```bash
# Compilar com debug
make clean && make CFLAGS="-g -O0"

# Executar com GDB
gdb --args ./interpretador arquivo.py

# Comandos úteis
(gdb) break interpretador.c:150  # Breakpoint na linha 150
(gdb) run
(gdb) next                       # Próxima linha
(gdb) step                       # Entrar na função
(gdb) print variavel             # Imprimir variável
(gdb) info locals               # Ver variáveis locais
(gdb) bt                        # Backtrace
```

#### Logs e Debug

```c
// Adicionar logs de debug
#ifdef DEBUG
    printf("DEBUG: Interpretando operação %d\n", no->dados.operacao.operador);
#endif

// Ou usar fprintf para stderr
fprintf(stderr, "DEBUG: Valor da variável %s = %d\n", nome, valor);
```

### 6. Otimizações

#### Performance

```c
// Usar realloc eficientemente
if (tabela->tamanho >= tabela->capacidade) {
    tabela->capacidade *= 2;
    tabela->simbolos = realloc(tabela->simbolos, 
                              tabela->capacidade * sizeof(Simbolo));
}

// Evitar alocações desnecessárias
static char buffer[1024];  // Buffer estático para strings pequenas
```

#### Memória

```c
// Sempre liberar memória
void destruir_ast(NoAst *no) {
    if (!no) return;
    
    switch (no->tipo) {
        case NODO_OPERACAO:
            destruir_ast(no->dados.operacao.esquerda);
            destruir_ast(no->dados.operacao.direita);
            break;
        case NODO_ATRIBUICAO:
            free(no->dados.atribuicao.nome);
            destruir_ast(no->dados.atribuicao.valor);
            break;
        // ... outros casos
    }
    
    free(no);
}
```

### 7. Documentação

#### Comentários no Código

```c
/**
 * Interpreta uma operação binária
 * @param no Nó da AST contendo a operação
 * @return Resultado da operação
 */
Resultado interpretar_operacao(NoAst *no) {
    // Validação de entrada
    if (!no || no->tipo != NODO_OPERACAO) {
        return resultado_erro();
    }
    
    // Avalia operandos
    Resultado esq = interpretar(no->dados.operacao.esquerda);
    Resultado dir = interpretar(no->dados.operacao.direita);
    
    // Executa operação baseada no tipo
    return executar_operacao(no->dados.operacao.operador, esq, dir);
}
```

#### Atualizar Documentação

Quando adicionar novas funcionalidades, atualize:

1. **README.md**: Lista de funcionalidades
2. **docs/arquitetura.md**: Documentação da arquitetura
3. **docs/uso.md**: Exemplos de uso
4. **docs/testes.md**: Documentação dos testes

### 8. Commits e Versionamento

#### Convenções de Commit

```bash
# Estrutura: tipo(escopo): descrição
feat(lexer): adiciona suporte ao operador //
fix(parser): corrige precedência de operadores
docs(readme): atualiza lista de funcionalidades
test(expressoes): adiciona testes para divisão inteira
refactor(ast): simplifica criação de nós
```

#### Exemplos de Commits

```bash
git add .
git commit -m "feat(operators): adiciona operador de divisão inteira //

- Adiciona token IDIV no lexer
- Implementa regra gramatical para divisão inteira
- Adiciona suporte no interpretador
- Inclui testes unitários e de funcionalidade
- Atualiza documentação"
```

### 9. Checklist Antes do Commit

- [ ] Código compila sem warnings
- [ ] Todos os testes passam (`make test-complete`)
- [ ] Novos testes foram adicionados
- [ ] Documentação foi atualizada
- [ ] Código segue as convenções do projeto
- [ ] Memória é liberada corretamente
- [ ] Tratamento de erros foi implementado



#### Referências

- [Flex Manual](https://westes.github.io/flex/manual/)
- [Bison Manual](https://www.gnu.org/software/bison/manual/)
- [GCC Documentation](https://gcc.gnu.org/onlinedocs/)
- [Python Language Reference](https://docs.python.org/3/reference/)

## 📚 Próximos Passos

Para começar a contribuir:

1. **[Configure o ambiente](instalacao.md)** se ainda não fez
2. **[Execute os testes](testes.md)** para entender o que já funciona
3. **[Estude a arquitetura](arquitetura.md)** para entender o código
4. **Escolha uma funcionalidade** da lista de sugestões
5. **Implemente e teste** seguindo este guia

---

*Contribuições são bem-vindas! Este projeto é uma excelente oportunidade para aprender sobre compiladores e interpretadores.*

# Processo de Desenvolvimento

Esta seção documenta o processo de desenvolvimento do interpretador Python, incluindo as dificuldades encontradas, soluções implementadas e lições aprendidas.

## Desafios Encontrados

### 1. Tratamento da Indentação Python

**Problema**: Python usa indentação para definir blocos de código, mas Flex/Bison trabalham com tokens tradicionais como chaves `{}`.

**Dificuldades**:
- Como converter espaços/tabs em tokens que o parser possa entender?
- Como detectar erros de indentação inconsistente?
- Como manter a estrutura hierárquica dos blocos?

**Solução Implementada**:
O grupo perdeu muito tempo tentando processar a indentação, após muita pesquisa nós:
- Criamos um pré-processador Python (`indent_preproc.py`) que:
  - Converte indentação em tokens `@INDENT@` e `@DEDENT@`
  - Remove comentários e normaliza quebras de linha
  - Detecta e reporta erros de indentação inconsistente

**Código da solução**:
```python
def process_file(filepath):
    indent_stack = [0]
    
    for line in lines:
        leading_spaces = len(line) - len(line.lstrip())
        
        if leading_spaces > indent_stack[-1]:
            indent_stack.append(leading_spaces)
            print('@INDENT@')
        
        while leading_spaces < indent_stack[-1]:
            indent_stack.pop()
            print('@DEDENT@')
```

### 2. Gerenciamento de Memória

**Problema**: C é uma linguagem sem garbage collection, exigindo gerenciamento manual de memória.

**Dificuldades**:
- Como evitar memory leaks na AST?
- Como gerenciar strings dinâmicas?
- Como liberar estruturas complexas recursivamente?

**Soluções Implementadas**:
- Função `destruir_ast()` que percorre recursivamente a árvore
- Uso de `strdup()` para strings e `free()` correspondente
- Estruturas de dados com funções de criação/destruição

**Exemplo de solução**:
```c
void destruir_ast(NoAst *no) {
    if (!no) return;
    
    switch (no->tipo) {
        case NODO_OPERACAO:
            destruir_ast(no->dados.operacao.esquerda);
            destruir_ast(no->dados.operacao.direita);
            break;
        case NODO_ATRIBUICAO:
            free(no->dados.atribuicao.nome);
            destruir_ast(no->dados.atribuicao.valor);
            break;
    }
    
    free(no);
}
```

### 3. Precedência de Operadores

**Problema**: Como implementar a precedência correta de operadores em Bison?

**Dificuldades**:
- Operadores com diferentes níveis de precedência
- Operadores unários vs binários
- Associatividade (esquerda vs direita)

**Solução Implementada**:
- Uso das diretivas de precedência do Bison:
```yacc
%left  OR AND
%nonassoc EQ NEQ GT LT GTE LTE
%left  ADD SUB
%left  MUL DIV MOD
%right NOT POW UMINUS
%precedence ELSE
```

### 4. Tratamento de Erros

**Problema**: Como fornecer mensagens de erro úteis e específicas?

**Dificuldades**:
- Erros em diferentes fases (léxica, sintática, semântica)
- Como reportar a linha exata do erro?
- Como distinguir diferentes tipos de erro?

**Soluções Implementadas**:
- Uso de `yylineno` para rastrear linha atual
- Mensagens específicas para cada tipo de erro
- Tratamento de erros em diferentes níveis

**Exemplos**:
```c
// Erro léxico
fprintf(stderr, "[ERRO] (linha %d): Caractere inválido '%s'\n", yylineno, yytext);

// Erro semântico
fprintf(stderr, "[ERRO]: Variável '%s' não definida\n", nome);

// Erro de execução
fprintf(stderr, "[ERRO]: Divisão por zero\n");
```

## Decisões de Design

### 1. Estrutura da AST

**Decisão**: Usar union em C para diferentes tipos de nós
**Justificativa**: Permite representar diferentes tipos de instruções em uma única estrutura

```c
typedef struct NoAst {
    TipoNo tipo;
    int linha;
    union {
        struct { TipoOperador operador; NoAst *esquerda; NoAst *direita; } operacao;
        struct { TipoDado tipo; union { int int_val; double float_val; char *string_val; bool bool_val; } valor; } literal;
        char *identificador;
        struct { char *nome; NoAst *valor; } atribuicao;
    } dados;
} NoAst;
```

### 2. Tabela de Símbolos

**Decisão**: A princípio, a tabela de símbolos foi criada como uma lista encadeada, devido a sua simplicidade na hora de fazer. No entanto, após a aula de tabela de símbolos, vimos que a melhor opção seria a Tabela Hash.
**Justificativa**: Performance
**Alternativas consideradas**: Lista encadeada(mais simples)


### 3. Sistema de Tipos

**Decisão**: Tipos dinâmicos com union
**Justificativa**: Flexibilidade para operações entre tipos diferentes
**Alternativas consideradas**: Tipos estáticos, sistema de tipos mais rigoroso

```c
typedef struct {
    TipoDado tipo;
    union { 
        int int_val; 
        double float_val; 
        char* string_val; 
        bool bool_val; 
    } valor;
} Resultado;
```

## Lições Aprendidas

### 1. Planejamento 

**Lição**: O planejamento bem definido desde o início facilita muito o desenvolvimento
**Aplicação**: Seguindo o 'guia de um interpretador' do professor, conseguimos nos planejar para cada etapa do desenvolvimento.

### 2. Testes Incrementais

**Lição**: Testar cada componente individualmente antes da integração
**Aplicação**: Criamos testes unitários para AST, tabela de símbolos, etc.

### 3. Documentação Durante o Desenvolvimento

**Lição**: Documentar decisões e problemas enquanto ainda estão frescos
**Aplicação**: Comentários no código e documentação técnica(falhamos aqui em alguns momentos)

### 4. Gerenciamento de Memória

**Lição**: Em C, sempre pensar sobre alocação e liberação de memória
**Aplicação**: Funções de criação e destruição para cada estrutura

### 5. Tratamento de Erros

**Lição**: Mensagens de erro claras são essenciais para debugging
**Aplicação**: Sistema de mensagens de erro detalhadas e específicas

## Ferramentas e Tecnologias

### Flex v2.6.4 (Analisador Léxico)
**Vantagens**:
- Geração automática de código C
- Reconhecimento eficiente de padrões
- Integração fácil com Bison

**Desafios**:
- Curva de aprendizado inicial
- Debugging de regras complexas

### Bison v3.8.2 (Analisador Sintático)
**Vantagens**:
- Suporte a gramáticas complexas
- Precedência de operadores automática
- Geração de código otimizado

**Desafios**:
- Sintaxe específica para ações semânticas
- Debugging de conflitos de gramática


### Funcionalidades Implementadas
- **Tipos de dados**: 4 (int, float, string, bool)
- **Operadores**: 15 (aritméticos, comparação, lógicos)
- **Estruturas de controle**: 2 (if/else, while)
- **Funções built-in**: 1 (print)
- **Testes**: 9 categorias principais


## Próximos Passos


### Melhorias de Desenvolvimento
1. **CI/CD**: Integração contínua
2. **Cobertura de Testes**: Aumentar cobertura
3. **Documentação**: Documentação da API
4. **Benchmarks**: Testes de performance

---
## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/06/2025 |  Criação do documento | Arthur Evangelista |

---

*Este documento reflete o processo de desenvolvimento real e as decisões tomadas durante a implementação do interpretador Python.* 

