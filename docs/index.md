# Interpretador Python - Documentação Completa

## 📋 Visão Geral


<p align="justify"> &emsp;&emsp;Este projeto consiste na implementação de um interpretador de Python, desenvolvido como trabalho acadêmico para a disciplina de Compiladores. O objetivo principal é aplicar os conceitos estudados ao longo da disciplina, como análise léxica, análise sintática e execução de comandos, utilizando as ferramentas Flex (para o analisador léxico) e Bison (para o analisador sintático).</p>


## Integrantes

<div style="display: grid; align-items: center; gap: 25px;">
    <div style="display: flex; align-items: end; justify-content: center; gap: 50px;">
        <div style="text-align: center;">
            <br/>
            <img src="https://github.com/anabfs.png" width="160px" height="50%" style="border-radius:50%"/>
            <br/>
            <a href="https://github.com/anabfs" target="_blank">Ana Beatriz</a>
        </div>
        <div style="text-align: center;">
            <br/>
            <img src="https://github.com/arthurevg.png" width="160px" height="50%" style="border-radius:50%"/>
            <br/>
            <a href="https://github.com/arthurevg" target="_blank">Arthur Evangelista</a>
        </div>
        <div style="text-align: center;">
            <br/>
            <img src="https://github.com/YuriBre.png" width="160px" height="50%" style="border-radius:50%"/>
            <br/>
            <a href="https://github.com/YuriBre" target="_blank">Breno Yuri</a>
        </div>
    </div>
</div>


<div style="display: grid; align-items: center; gap: 25px;">
    <div style="display: flex; align-items: end; justify-content: center; gap: 50px;">
        <div style="text-align: center;">
            <br/>
            <img src="https://github.com/CarolinaBarb.png" width="160px" height="50%" style="border-radius:50%"/>
            <br/>
            <a href="https://github.com/CarolinaBarb" target="_blank">Carolina Barbosa</a>
        </div>
        <div style="text-align: center;">
            <br/>
            <img src="https://github.com/Frans6.png" width="160px" height="50%" style="border-radius:50%"/>
            <br/>
            <a href="https://github.com/Frans6" target="_blank">Jefferson França</a>
        </div>
        <div style="text-align: center;">
            <br/>
            <img src="https://github.com/LeticiaResende23.png" width="160px" height="50%" style="border-radius:50%"/>
            <br/>
            <a href="https://github.com/LeticiaResende23" target="_blank">Letícia Resende</a>
        </div>
    </div>
</div>


### 🎯 Objetivos

- Implementar um analisador léxico completo usando Flex
- Desenvolver um analisador sintático robusto usando Bison
- Criar uma árvore sintática abstrata (AST) para representação do código
- Implementar um interpretador que executa o código Python
- Demonstrar tratamento de erros e debugging
- Fornecer uma suite completa de testes

### 🏗️ Fluxo do Sistema

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Código Python │───▶│  Pré-processor  │───▶│     Lexer       │
│   (entrada)     │    │  (indentação)   │    │   (Flex)        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Interpretador │◀───│      AST        │◀───│     Parser      │
│   (execução)    │    │  (árvore)       │    │   (Bison)       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Funcionalidades Implementadas

### ✅ Tipos de Dados Suportados
- **Inteiros**: `42`, `-10`, `+5`
- **Ponto flutuante**: `3.14`, `-2.5`, `1e-10`
- **Strings**: `"Hello"`, `'World'`
- **Booleanos**: `True`, `False`

### ✅ Operadores
- **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `**`
- **Comparação**: `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Lógicos**: `and`, `or`, `not`

### ✅ Estruturas de Controle
- **Condicionais**: `if`/`else`
- **Loops**: `while`
- **Controle de fluxo**: `break`, `continue`

### ✅ Funções Built-in
- **`print()`**: Exibe valores no console

### ✅ Recursos Avançados
- **Indentação**: Suporte completo à indentação Python
- **Comentários**: Linhas começando com `#`
- **Tratamento de erros**: Mensagens detalhadas de erro
- **Debugging**: Suporte a GDB para debugging

## 📁 Estrutura do Projeto

```
Trab_Compiladores/
├── 📄 main.c                    # Ponto de entrada do programa
├── 📄 Makefile                  # Script de compilação
├── 📄 indent_preproc.py         # Pré-processador de indentação
├── 📄 teste.py                  # Arquivo de teste principal
├── 📄 README.md                 # Documentação básica
├── 📄 mkdocs.yml               # Configuração do MkDocs
│
├── 📂 lexer/
│   └── 📄 lexer.l              # Especificação do analisador léxico (Flex)
│
├── 📂 parser/
│   ├── 📄 parser.y             # Gramática do analisador sintático (Bison)
│   ├── 📄 ast.h                # Definições da AST
│   ├── 📄 ast.c                # Implementação da AST
│   ├── 📄 types.h              # Definições de tipos
│   ├── 📄 tabela.h             # Interface da tabela de símbolos
│   ├── 📄 tabela.c             # Implementação da tabela de símbolos
│   ├── 📄 interpretador.h      # Interface do interpretador
│   └── 📄 interpretador.c      # Implementação do interpretador
│
├── 📂 tests/                   # Suite de testes
│   ├── 📄 test_*.py            # Testes automatizados
│   ├── 📄 test_*.c             # Testes manuais
│   └── 📄 test*.txt            # Arquivos de teste
│
├── 📂 scripts/                 # Scripts de automação
│   ├── 📄 run_tests.sh         # Execução de todos os testes
│   ├── 📄 test_erros.sh        # Testes de tratamento de erros
│   ├── 📄 test_resultados.sh   # Testes de resultados
│   └── 📄 quick_test.sh        # Teste rápido
│
└── 📂 docs/                    # Documentação completa
    ├── 📄 index.md             # Esta página
    ├── 📄 instalacao.md        # Guia de instalação
    ├── 📄 uso.md               # Guia de uso
    ├── 📄 testes.md            # Documentação dos testes
    └──📄 ...                   # Outros arquivos de documentação
     
```

## 🛠️ Tecnologias Utilizadas

- **Flex**: Gerador de analisadores léxicos
- **Bison**: Gerador de analisadores sintáticos
- **GCC**: Compilador C
- **Make**: Sistema de build
- **Python 3**: Pré-processamento e scripts de teste
- **MkDocs**: Geração de documentação

## 📖 Próximos Passos

1. **[Instalação](instalacao.md)**: Configure o ambiente de desenvolvimento
2. **[Uso Básico](uso.md)**: Aprenda a compilar e executar o interpretador
3. **[Testes](testes.md)**: Execute e entenda a suite de testes
4. **[Desenvolvimento](desenvolvimento.md)**: Contribua para o projeto

---

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/04/2025 |  Criação do GitPages do grupo | [Jefferson](https://github.com/Frans6) |
| `1.1`  |  27/04/2025 |  Criação da Home do grupo | [Jefferson](https://github.com/Frans6) |
| `1.2`  |  28/04/2025 |  Atualização da Home no GitPages | [Arthur Evangelista](https://github.com/arthurevg) |
| `1.3`  |  27/06/2025 |  Adição do fluxo do sistema e funcionalidades implementadas | [Arthur Evangelista](https://github.com/arthurevg) |

---

*Esta documentação foi criada para o trabalho de Compiladores, demonstrando a implementação completa de um interpretador Python usando as ferramentas Flex e Bison.*

