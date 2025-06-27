# 🚀 Guia de Uso

Este guia irá ensiná-lo como compilar, executar e usar o interpretador Python.

## 🔨 Compilação

### Compilação Básica

```bash
# Compilar o projeto
make

# Ou compilar e executar em um comando
make run
```

### Comandos de Compilação Disponíveis

```bash
# Compilar apenas
make

# Limpar arquivos compilados
make clean

# Compilar e executar com arquivo específico
make run SCRIPT=meu_arquivo.py

# Executar todos os testes
make test

# Executar suite completa de testes
make test-complete
```

## 🎯 Execução

### Execução Básica

```bash
# Executar com arquivo Python
./interpretador arquivo.py

# Usar o Makefile (recomendado)
make run SCRIPT=arquivo.py
```

### Exemplo de Uso

1. **Criar um arquivo Python** (`teste.py`):
```python
x = 10
y = 5
print("Soma:", x + y)

if x > y:
    print("x é maior que y")
else:
    print("y é maior que x")
```

2. **Executar o interpretador**:
```bash
make run SCRIPT=teste.py
```

3. **Saída esperada**:
```
Análise sintática concluída com sucesso!
AST criada com sucesso
--- INÍCIO DA EXECUÇÃO ---
Soma: 15
x é maior que y
--- FIM DA EXECUÇÃO ---
Programa finalizado.
```
**O arquivo só funcionará corretamente se estiver dentro do [escopo](escopo.md)**

## 🐛 Debugging

### Usando GDB

O projeto inclui suporte para debugging com GDB:

```bash
# Compilar com informações de debug
make clean && make

# Pré-processar o arquivo
python3 indent_preproc.py teste.py > build/processed.py

# Executar com GDB
gdb --args ./interpretador build/processed.py

# Dentro do GDB:
(gdb) run
# Se houver segmentation fault:
(gdb) bt
(gdb) quit
```

### Comandos GDB Úteis

```bash
# Executar até encontrar erro
(gdb) run

# Ver backtrace (pilha de chamadas)
(gdb) bt

# Ver variáveis locais
(gdb) info locals

# Definir breakpoint
(gdb) break main.c:25

# Continuar execução
(gdb) continue

# Sair do GDB
(gdb) quit
```

## ⚠️ Tratamento de Erros

O interpretador fornece mensagens de erro detalhadas:

### Erros Comuns

1. **Erro de sintaxe**:
```python
x = 10
y =  # Erro: valor faltando
```
```
[ERRO]: Análise sintática falhou
```

2. **Variável não definida**:
```python
print(x)  # x não foi definida
```
```
[ERRO]: Variável 'x' não definida
```

3. **Divisão por zero**:
```python
resultado = 10 / 0
```
```
[ERRO]: Divisão por zero
```

4. **Caractere inválido**:
```python
x = @  # @ não é válido
```
```
[ERRO] (linha 1): Caractere inválido '@'
```

## 🔧 Configurações Avançadas

### Variáveis de Ambiente

```bash
# Definir arquivo de teste padrão
export SCRIPT=meu_teste.py

# Executar com arquivo personalizado
make run
```

### Flags de Compilação

O Makefile suporta várias flags de compilação:

```bash
# Compilar com debug
make CFLAGS="-g -O0"

# Compilar com otimização
make CFLAGS="-O2"

# Compilar com warnings extras
make CFLAGS="-Wall -Wextra -Werror"
```

## 📚 Próximos Passos

Agora que você sabe como usar o interpretador:

1. **[Execute os testes](testes.md)** para verificar se tudo está funcionando
2. **[Contribua para o desenvolvimento](desenvolvimento.md)** se quiser adicionar funcionalidades

---

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/06/2025 |  Criação do documento | [Arthur Evangelista](https://github.com/arthurevg) |

---
*Para mais informações sobre funcionalidades específicas, consulte a documentação da arquitetura.* 