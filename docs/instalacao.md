# 🛠️ Guia de Instalação

Este guia irá ajudá-lo a configurar o ambiente de desenvolvimento necessário para compilar e executar o interpretador Python.

## 📋 Pré-requisitos

### Sistema Operacional
- **Linux** (Ubuntu/Debian recomendado)
- **Windows** (usando WSL ou MinGW)
- **macOS** (usando Homebrew)

### Ferramentas Necessárias

#### 1. Compilador C (GCC)
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install build-essential

# CentOS/RHEL/Fedora
sudo yum groupinstall "Development Tools"
# ou
sudo dnf groupinstall "Development Tools"

# macOS
xcode-select --install
```

#### 2. Flex v2.6.4 (Analisador Léxico)
```bash
# Ubuntu/Debian
sudo apt install flex

# CentOS/RHEL/Fedora
sudo yum install flex
# ou
sudo dnf install flex

# macOS
brew install flex
```

#### 3. Bison v3.8.2 (Analisador Sintático)
```bash
# Ubuntu/Debian
sudo apt install bison

# CentOS/RHEL/Fedora
sudo yum install bison
# ou
sudo dnf install bison

# macOS
brew install bison
```

#### 4. Python 3
```bash
# Ubuntu/Debian
sudo apt install python3 python3-pip

# CentOS/RHEL/Fedora
sudo yum install python3 python3-pip
# ou
sudo dnf install python3 python3-pip

# macOS
brew install python3
```

#### 5. Make
```bash
# Ubuntu/Debian
sudo apt install make

# CentOS/RHEL/Fedora
sudo yum install make
# ou
sudo dnf install make

# macOS
# Já incluído com Xcode Command Line Tools
```

## 🚀 Instalação Rápida (Ubuntu/Debian)

Execute o seguinte comando para instalar todas as dependências de uma vez:

```bash
sudo apt update && sudo apt install -y build-essential flex bison python3 python3-pip make
```

## 🔧 Verificação da Instalação

Após a instalação, verifique se todas as ferramentas estão funcionando:

```bash
# Verificar versões
gcc --version
flex --version
bison --version
python3 --version
make --version
```

Você deve ver saídas similares a:
```
gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
flex 2.6.4
bison (GNU Bison) 3.5.1
Python 3.8.10
GNU Make 4.2.1
```

## 📦 Instalação no Windows

### Opção 1: Windows Subsystem for Linux (WSL) - Recomendado

1. **Instalar WSL2**:
```powershell
wsl --install
```

2. **Reiniciar o computador**

3. **Abrir terminal Ubuntu e seguir os passos do Linux**

### Opção 2: MinGW + MSYS2

1. **Baixar e instalar MSYS2** de https://www.msys2.org/

2. **Abrir MSYS2 terminal e instalar as ferramentas**:
```bash
pacman -S mingw-w64-x86_64-gcc
pacman -S mingw-w64-x86_64-flex
pacman -S mingw-w64-x86_64-bison
pacman -S mingw-w64-x86_64-make
pacman -S mingw-w64-x86_64-python
```

3. **Adicionar MinGW ao PATH do Windows**

## 🍎 Instalação no macOS

### Usando Homebrew (Recomendado)

1. **Instalar Homebrew** (se não tiver):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. **Instalar as ferramentas**:
```bash
brew install gcc flex bison python3 make
```

### Usando MacPorts

```bash
sudo port install gcc flex bison python3 make
```

## 🔍 Solução de Problemas

### Erro: "flex: command not found"
```bash
# Ubuntu/Debian
sudo apt install flex

# Verificar se está no PATH
which flex
```

### Erro: "bison: command not found"
```bash
# Ubuntu/Debian
sudo apt install bison

# Verificar se está no PATH
which bison
```

### Erro: "make: command not found"
```bash
# Ubuntu/Debian
sudo apt install make

# Verificar se está no PATH
which make
```

### Erro de permissão no Windows
- Execute o terminal como administrador
- Verifique se o antivírus não está bloqueando as ferramentas

### Problemas com versões do GCC
```bash
# Verificar versão atual
gcc --version

# Se necessário, instalar versão específica
sudo apt install gcc-9
```

## ✅ Teste da Instalação

Após a instalação, teste se tudo está funcionando:

```bash
# Clonar ou baixar o projeto
cd /caminho/para/Trab_Compiladores

# Tentar compilar
make clean
make

# Se compilar com sucesso, testar execução
make run
```
---

## Histórico de Versão

| Versão | Data          | Descrição                          | Autor(es)     |
| ------ | ------------- | ---------------------------------- | ------------- |
| `1.0`  |  27/06/2025 |  Criação do documento | [Arthur Evangelista](https://github.com/arthurevg) |

*Se encontrar algum problema durante a instalação, consulte a seção de solução de problemas ou abra uma issue no repositório.* 