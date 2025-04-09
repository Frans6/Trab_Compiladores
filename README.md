# Interpretador Python usando Flex e Bison

Este projeto consiste na implementação de um interpretador de Python, desenvolvido como trabalho acadêmico para a disciplina de Compiladores. O objetivo principal é aplicar os conceitos estudados ao longo da disciplina, como análise léxica, análise sintática e execução de comandos, utilizando as ferramentas Flex (para o analisador léxico) e Bison (para o analisador sintático).

## 📁 Estrutura de Pastas

```
.
├── build/             # Arquivos compilados (gerados pelo Makefile)
├── docs/              # Documentação (não utilizado ainda)
├── lexer/             # Analisador léxico (lexer.l)
├── parser/            # Analisador sintático (parser.y)
├── tests/             # Casos de teste (opcional)
├── main.c             # Função principal
└── Makefile           # Script de compilação
```

---

## ⚙️ Requisitos

- GCC (compilador C)
- Flex
- Bison
- Make

Você pode instalar tudo no Ubuntu com:

```bash
sudo apt install build-essential flex bison
```

---

## 🥪 Como Compilar e Executar

1. Compile o projeto com `make`:

```bash
make
```

2. Execute o interpretador:

```bash
make run
```

---

## 💡 Observações

- O lexer está em `lexer/lexer.l`.
- O parser está em `parser/parser.y`.
- O `Makefile` gera os arquivos `.c` do Bison e Flex dentro da pasta `build/`.

---
