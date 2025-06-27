# 📚 Documentação do Interpretador Python

Bem-vindo à documentação completa do interpretador Python desenvolvido com Flex e Bison!

## 📋 Sumário

### 🎯 Documentação Principal
- **[📖 Visão Geral](index.md)** - Introdução completa ao projeto, objetivos e arquitetura geral

### 🛠️ Guias Práticos
- **[🛠️ Instalação](instalacao.md)** - Como configurar o ambiente de desenvolvimento
- **[🚀 Uso](uso.md)** - Como compilar, executar e usar o interpretador
- **[🧪 Testes](testes.md)** - Como executar e entender a suite de testes

### 🔍 Documentação Técnica
- **[🏗️ Arquitetura](arquitetura.md)** - Como o sistema funciona internamente
- **[👨‍💻 Desenvolvimento](desenvolvimento.md)** - Guia para contribuidores

## 🚀 Começando

### Para Usuários
1. **[Instale o ambiente](instalacao.md)**
2. **[Aprenda a usar](uso.md)**
3. **[Execute os testes](testes.md)**

### Para Desenvolvedores
1. **[Configure o ambiente](instalacao.md)**
2. **[Entenda a arquitetura](arquitetura.md)**
3. **[Contribua para o projeto](desenvolvimento.md)**

## 📁 Estrutura da Documentação

```
docs/
├── README.md           # Este arquivo (sumário)
├── index.md            # Visão geral do projeto
├── instalacao.md       # Guia de instalação
├── uso.md              # Guia de uso
├── arquitetura.md      # Documentação da arquitetura
├── testes.md           # Documentação dos testes
└── desenvolvimento.md  # Guia para desenvolvedores
```

## 🔍 Navegação Rápida

### Funcionalidades Principais
- **[Tipos de Dados](uso.md#tipos-de-dados)** - Inteiros, floats, strings, booleanos
- **[Operadores](uso.md#operadores)** - Aritméticos, comparação, lógicos
- **[Estruturas de Controle](uso.md#estruturas-de-controle)** - if/else, while, break/continue
- **[Funções Built-in](uso.md#funções-built-in)** - print(), input()

### Componentes do Sistema
- **[Pré-processador](arquitetura.md#1-pré-processador-indent_preprocpy)** - Tratamento de indentação
- **[Analisador Léxico](arquitetura.md#2-analisador-léxico-lexerlexerl)** - Reconhecimento de tokens
- **[Analisador Sintático](arquitetura.md#3-analisador-sintático-parserparsery)** - Construção da AST
- **[Interpretador](arquitetura.md#5-interpretador-parserinterpretadorc)** - Execução do código

### Testes Disponíveis
- **[Testes Unitários](testes.md#testes-unitários-c)** - AST, tabela de símbolos, lexer
- **[Testes de Funcionalidade](testes.md#testes-de-funcionalidade-python)** - Expressões, condicionais, loops
- **[Testes de Erro](testes.md#testes-de-erro)** - Tratamento de exceções

## 💡 Dicas de Uso

### Comandos Mais Usados
```bash
# Compilar e executar
make run SCRIPT=arquivo.py

# Executar testes
make test

# Debugging
gdb --args ./interpretador arquivo.py
```

### Exemplos Práticos
- **[Exemplo Básico](uso.md#exemplo-de-uso)** - Primeiro programa
- **[Operações Aritméticas](uso.md#operações-aritméticas)** - Cálculos matemáticos
- **[Estruturas Condicionais](uso.md#condicionais)** - if/else
- **[Loops](uso.md#loops)** - while, break, continue

## 🐛 Solução de Problemas

### Problemas Comuns
- **[Erros de Compilação](instalacao.md#solução-de-problemas)** - Dependências faltando
- **[Erros de Execução](uso.md#tratamento-de-erros)** - Problemas no código Python
- **[Debugging](uso.md#debugging)** - Como usar GDB

### Logs e Debug
- **[Comandos GDB](uso.md#comandos-gdb-úteis)** - Debugging avançado
- **[Logs de Teste](testes.md#logs-detalhados)** - Análise de resultados

## 📚 Recursos Adicionais

### Referências Técnicas
- [Flex Manual](https://westes.github.io/flex/manual/)
- [Bison Manual](https://www.gnu.org/software/bison/manual/)
- [Python Language Reference](https://docs.python.org/3/reference/)

### Ferramentas Úteis
- **[Valgrind](desenvolvimento.md#ferramentas-de-desenvolvimento)** - Detecção de memory leaks
- **[Cppcheck](desenvolvimento.md#ferramentas-de-desenvolvimento)** - Análise estática
- **[Clang-format](desenvolvimento.md#ferramentas-de-desenvolvimento)** - Formatação de código

## 🤝 Contribuindo

### Como Contribuir
1. **[Leia o guia de desenvolvimento](desenvolvimento.md)**
2. **[Escolha uma área](desenvolvimento.md#áreas-para-contribuição)**
3. **[Siga as convenções](desenvolvimento.md#convenções-de-código)**
4. **[Adicione testes](desenvolvimento.md#adicionando-novos-testes)**

### Áreas de Melhoria
- Novos operadores e funcionalidades
- Otimizações de performance
- Melhorias na documentação
- Novos testes

---

*Esta documentação foi criada para facilitar o uso e desenvolvimento do interpretador Python. Para dúvidas ou sugestões, consulte a seção de desenvolvimento.* 