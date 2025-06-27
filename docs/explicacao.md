# Interpretador de Linguagem Python 

## Explicação do Projeto

O projeto visa criar um **interpretador de uma versão simplificada da linguagem Python** utilizando as ferramentas **Flex** e **Bison**. O objetivo principal é analisar e interpretar um subconjunto da sintaxe de Python, sendo capaz de executar operações como atribuições de variáveis, expressões aritméticas, impressão, e controle de fluxo básico (como estruturas condicionais).

### Por que usar Flex e Bison?

- **Flex** é uma ferramenta para gerar analisadores léxicos, ou seja, programas que são responsáveis por dividir o código em tokens, como palavras-chave, identificadores, operadores e literais. Isso é essencial para entender a estrutura básica do código.
- **Bison** é utilizado para gerar o analisador sintático, que interpreta a organização dos tokens gerados pelo Flex e valida a sintaxe do código. O Bison cria uma árvore de sintaxe abstrata (AST), que descreve a estrutura do código de maneira hierárquica.

### Como Funciona o Interpretador?

1. **Análise Léxica (Flex)**: 
   - <p align="justify"> O Flex irá percorrer o código de entrada, identificando tokens (como palavras-chave, operadores e variáveis) e os classificando conforme a gramática definida.</p>
   
2. **Análise Sintática (Bison)**:
   - <p align="justify">O Bison utilizará os tokens identificados pelo Flex para construir a árvore de sintaxe abstrata (AST), que representa a estrutura do código. Isso permite ao interpretador entender a relação entre os elementos do código (por exemplo, quais operadores se aplicam a quais operandos).</p>
   
3. **Execução do Código**:
   - <p align="justify"> Após a construção da AST, o interpretador processará essa estrutura e executará as instruções correspondentes, como calcular expressões aritméticas ou controlar o fluxo de execução com estruturas condicionais.</p>

### Funcionalidades Básicas do Interpretador:

- **Declaração e Atribuição de Variáveis**: Atribuir valores a variáveis e utilizá-las em expressões.
- **Operações Aritméticas**: Suporte para operações básicas como soma, subtração, multiplicação e divisão.
- **Controle de Fluxo**: Implementação de estruturas de decisão (`if`, `else`, `elif`).
- **Execução Simples**: Impressão de resultados e execução das instruções diretamente.

<p align="justify"> &emsp;&emsp;Este projeto serve como uma introdução à construção de compiladores e interpretadores, permitindo que o aluno compreenda como ferramentas como Flex e Bison funcionam e como elas podem ser usadas para analisar e executar código.</p>

---

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/04/2025 |  Criação do GitPages do grupo | [Jefferson](https://github.com/Frans6)  |
| `1.1`  |  27/04/2025 |  Criação da página "Explicação do projeto" contendo informações sobre o projeto | [Letícia Resende](https://github.com/LeticiaResende23) |
| `1.2`  |  28/04/2025 | Pequenos ajustes no documento | [Arthur Evangelista](https://github.com/arthurevg) |