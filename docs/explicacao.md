# Interpretador de Linguagem Python 

## Explicação do Projeto

O projeto visa criar um **interpretador simples da linguagem Python** utilizando as ferramentas **Flex** e **Bison**. O objetivo principal é analisar e interpretar um subconjunto da sintaxe de Python, sendo capaz de executar operações como atribuições de variáveis, expressões aritméticas, impressão, e controle de fluxo básico (como estruturas condicionais).

## Por que Python?

A escolha da linguagem Python como base para o interpretador foi estratégica por vários motivos:

### 1. **Simplicidade da Sintaxe**
Python possui uma sintaxe clara e legível, com poucos símbolos especiais. Isso facilita significativamente a implementação do parser, pois reduz a complexidade das regras gramaticais.

### 2. **Indentação Significativa**
Se por um lado a sua sintaxe clara facilita, por outro ela dificulta. O uso de indentação para definir blocos de código oferece um desafio interessante e educacional para o tratamento léxico. Diferente de outras linguagens que usam chaves `{}`, Python requer um pré-processamento especial para converter espaços em tokens de controle de bloco.

### 3. **Popularidade Acadêmica**
Python é amplamente usado em ambientes educacionais e científicos, tornando o projeto mais relevante e familiar para estudantes. A compreensão de como Python funciona internamente é valiosa.

### 4. **Familiaridade do grupo com a linguagem**
Logo nas primeiras aulas nos reunimos para decidir a linguagem do projeto. Por afinidade da maioria, Python foi a linguagem priorizada. 

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


---

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/04/2025 |  Criação do GitPages do grupo | [Jefferson](https://github.com/Frans6)  |
| `1.1`  |  27/04/2025 |  Criação da página "Explicação do projeto" contendo informações sobre o projeto | [Letícia Resende](https://github.com/LeticiaResende23) |
| `1.2`  |  28/04/2025 | Pequenos ajustes no documento | [Arthur Evangelista](https://github.com/arthurevg) |
|`1.3`|27/06/2025| Adição da aba "Por que python?"|[Arthur Evangelista](https://github.com/arthurevg)|

