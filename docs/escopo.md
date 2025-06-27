# Escopo do Projeto

## Objetivo

Desenvolver um interpretador simplificado para um subconjunto da linguagem Python, utilizando **Flex** para análise léxica e **Bison** para análise sintática. O interpretador é capaz de executar operações básicas como atribuições de variáveis, expressões aritméticas, controle de fluxo com estruturas condicionais e loops.

## Funcionalidades Implementadas

### Tipos de Dados
- **Inteiros**: `42`, `-10`, `+5`
- **Ponto flutuante**: `3.14`, `-2.5`, `1e-10`
- **Strings**: `"Hello"`, `'World'`
- **Booleanos**: `True`, `False`

### Operadores
- **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `**`
- **Comparação**: `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Lógicos**: `and`, `or`, `not`

### Estruturas de Controle
- **Condicionais**: `if`/`else` com blocos aninhados
- **Loops**: `while` com suporte a `break` e `continue`
- **Blocos**: Indentação Python completa

### Funções Built-in
- **`print()`**: Saída formatada com múltiplos argumentos

### Tratamento de Erros
- **Erros léxicos**: Caracteres inválidos
- **Erros sintáticos**: Estrutura gramatical incorreta
- **Erros semânticos**: Variáveis não definidas, divisão por zero
- **Erros de indentação**: Inconsistência na indentação


## Limitações do Escopo Atual

### Não Implementado
- **Funções definidas pelo usuário**: Apenas funções built-in
- **Estruturas de dados complexas**: Listas, dicionários, tuplas
- **Classes e objetos**: Programação orientada a objetos
- **Módulos**: Sistema de importação
- **Exceções**: Try/catch
- **Operadores de bit**: `&`, `|`, `^`, `<<`, `>>`
- **Operadores de atribuição composta**: `+=`, `-=`, etc.
- **Loop `for`**: Apenas `while` implementado
- **`elif`**: Apenas `if`/`else` básico

### Implementado
- **Operações aritméticas básicas**: Todas as operações fundamentais
- **Controle de fluxo**: `if`/`else` e `while`
- **Variáveis**: Declaração e atribuição
- **Tipos básicos**: Int, float, string, bool
- **Indentação**: Suporte completo
- **Comentários**: Linhas com `#`
- **Tratamento de erros**: Mensagens detalhadas
- **Suite de testes**: Cobertura completa

## Arquivos Principais

### Código Fonte
- `main.c`: Ponto de entrada
- `lexer/lexer.l`: Especificação do lexer
- `parser/parser.y`: Gramática do parser
- `parser/ast.h/.c`: Implementação da AST
- `parser/tabela.h/.c`: Tabela de símbolos
- `parser/interpretador.h/.c`: Interpretador
- `parser/types.h`: Definições de tipos

### Scripts e Configuração
- `Makefile`: Sistema de build
- `indent_preproc.py`: Pré-processador
- `run_tests.sh`: Suite de testes
- `scripts/`: Scripts de automação

### Testes
- `tests/test_*.py`: Testes de funcionalidade
- `tests/test_*.c`: Testes unitários
- `tests/test_erro_*.py`: Testes de erro


## Conclusão

Este projeto demonstra com sucesso a implementação de um interpretador Python simplificado usando as ferramentas Flex e Bison. O escopo foi bem definido e implementado, cobrindo os conceitos fundamentais de compiladores: análise léxica, análise sintática, construção de AST e interpretação.

O projeto oferece uma base sólida para futuras extensões e serve como excelente material educacional para o estudo de compiladores e interpretadores.


<br>

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `0.1`  |  27/04/2025 |  Criação do GitPages do grupo | [Jefferson](https://github.com/Frans6) |
| `1.0`  |  27/04/2025 |  Criação da página "Escopo" contendo informações sobre o escopo do projeto |[Letícia Resende](https://github.com/LeticiaResende23)|
| `1.1`  |  28/04/2025 |  Ajustes e correções em inconsistências no documento | [Arthur Evangelista](https://github.com/arthurevg) |
| `1.2`  |  27/06/2025 |  Atualização completa do escopo para refletir o projeto implementado | [Arthur Evangelista](https://github.com/arthurevg) |
