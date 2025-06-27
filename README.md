# Interpretador Python usando Flex e Bison

Este projeto consiste na implementação de um interpretador de Python, desenvolvido como trabalho acadêmico para a disciplina de Compiladores. O objetivo principal é aplicar os conceitos estudados ao longo da disciplina, como análise léxica, análise sintática e execução de comandos, utilizando as ferramentas Flex (para o analisador léxico) e Bison (para o analisador sintático).

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
    ├── 📄 arquitetura.md       # Documentação da arquitetura
    ├── 📄 testes.md            # Documentação dos testes
    └── 📄 desenvolvimento.md   # Guia para desenvolvedores
```

---

## ⚙️ Requisitos

- GCC (compilador C)
- Flex 2.6.4
- Bison 3.8.2
- Make
- Python 3

Você pode instalar tudo no Ubuntu com:

```bash
sudo apt install build-essential flex bison python3 make
```

---

## 🥪 Como Compilar e Executar

### Compilação básica (vai rodar o arquivo teste.py por padrão)
1. Compile o projeto com `make`:

```bash
# compilar apenas
make

# roda arquivo teste.py
make run
```

### Compilar um arquivo específico
2. Compile o projeto com `make`
```bash
# Compilar apenas
make

# Limpar arquivos compilados
make clean

# Compilar e executar com arquivo específico
make run SCRIPT=meu_arquivo.py

```
---

## DOCUMENTAÇÃO

Para mais informações acerca do projeto, acesse a nossa documentação: [https://frans6.github.io/Trab_Compiladores/](https://frans6.github.io/Trab_Compiladores/)

---

