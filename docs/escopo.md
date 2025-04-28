# Escopo do Projeto

### Objetivo:
Desenvolver um interpretador simplificado para um subconjunto da linguagem Python, utilizando **Flex** para análise léxica e **Bison** para análise sintática. O interpretador será capaz de executar operações básicas como atribuições de variáveis, expressões aritméticas e controle de fluxo com estruturas condicionais e de repetição.

### Ferramentas Utilizadas:
- **Flex**: Para gerar o analisador léxico, que identificará e classificará os tokens no código Python.
- **Bison**: Para gerar o analisador sintático, que verificará a estrutura do código e gerará a árvore de sintaxe abstrata (AST).

### Estrutura do Projeto:

1. **Flex (Analisador Léxico)**:
   - Arquivo `.l` que define os tokens que serão reconhecidos, como:
     - **Palavras-chave**: `if`, `else`, `for`, `while`, `def`, etc.
     - **Operadores**: `+`, `-`, `*`, `/`, `=`, etc.
     - **Identificadores e Literais**: Como números e nomes de variáveis.
     - **Delimitadores**: Parênteses, chaves, colchetes, etc.
     - **Comentários**: Código após o símbolo `#`.
   
2. **Bison (Analisador Sintático)**:
   - Arquivo `.y` que define a gramática simplificada para o Python.
   - Definição das regras de produção para expressões aritméticas, controle de fluxo, declarações de variáveis, etc.
   - O Bison vai gerar uma árvore de sintaxe abstrata (AST) a partir dos tokens gerados pelo Flex.

3. **Tabela de Símbolos**:
   - Estrutura para armazenar variáveis e seus respectivos valores durante a execução do código.

4. **Execução do Código**:
   - <p align="justify">Usa após a análise sintática e a criação da AST, o interpretador irá executar o código, utilizando uma estrutura para calcular expressões, controlar o fluxo de execução e imprimir resultados.</p>

### Funcionalidades do Interpretador:

1. **Declaração e Atribuição de Variáveis**:
   - O interpretador deve ser capaz de declarar variáveis e atribuir valores a elas.
   
2. **Operações Aritméticas**:
   - Implementação de operações básicas como adição, subtração, multiplicação e divisão.
   
3. **Estruturas Condicionais e de Repetição**:
   - Suporte para `if`, `else`, `for`, `while`.

4. **Execução de Comandos**:
   - O interpretador deve ser capaz de executar as instruções fornecidas no código, como calcular expressões aritméticas ou executar blocos condicionais.

### Fluxo de Execução:

1. **Entrada**: O código Python simplificado é fornecido como entrada.
2. **Analisador Léxico**: O Flex lê o código e gera tokens.
3. **Analisador Sintático**: O Bison verifica a sintaxe e constrói a árvore de sintaxe abstrata (AST).
4. **Execução**: O interpretador processa a AST e executa as operações descritas, exibindo os resultados.

### Possíveis Extensões Futuras:

- Suporte a **funções**: Implementação de funções e chamadas de funções.
- Suporte a **objetos**: Adição de classes e manipulação de objetos.
- **Biblioteca Padrão**: Inclusão de funções como `print`, `input`, etc.
- **Erros e Depuração**: Melhorias no tratamento de erros e na geração de mensagens de depuração.

### Conclusão:
<p align="justify"> &emsp;&emsp;Este projeto oferece uma excelente oportunidade para aprender sobre os fundamentos da construção de compiladores e interpretadores, utilizando ferramentas como Flex e Bison. O interpretador construído permitirá a execução de um código Python simplificado, com uma estrutura que pode ser expandida para incluir funcionalidades mais complexas no futuro.</p>