# ========================================
# TESTE COMPLETO DO INTERPRETADOR PYTHON
# ========================================

print("=== INICIANDO TESTE COMPLETO DO INTERPRETADOR ===")

# ========================================
# 1. TESTE DE TIPOS DE DADOS BÁSICOS
# ========================================
print("\n--- 1. TESTE DE TIPOS DE DADOS ---")

# Números inteiros
idade = 25
ano = 2024
print("Idade:", idade)
print("Ano:", ano)

# Números de ponto flutuante
altura = 1.75
peso = 70.5
print("Altura:", altura)
print("Peso:", peso)

# Strings
nome = "João Silva"
cidade = "São Paulo"
print("Nome:", nome)
print("Cidade:", cidade)

# Booleanos
ativo = True
vip = False
print("Ativo:", ativo)
print("VIP:", vip)

# ========================================
# 2. TESTE DE OPERAÇÕES ARITMÉTICAS
# ========================================
print("\n--- 2. TESTE DE OPERAÇÕES ARITMÉTICAS ---")

# Operações básicas
a = 10
b = 3
soma = a + b
subtracao = a - b
multiplicacao = a * b
divisao = a / b
modulo = a % b
potencia = a ** b

print("a =", a, "b =", b)
print("Soma:", soma)
print("Subtração:", subtracao)
print("Multiplicação:", multiplicacao)
print("Divisão:", divisao)
print("Módulo:", modulo)
print("Potência:", potencia)

# Operações com números negativos
negativo = -a
print("Negativo de a:", negativo)

# ========================================
# 3. TESTE DE OPERADORES DE COMPARAÇÃO
# ========================================
print("\n--- 3. TESTE DE OPERADORES DE COMPARAÇÃO ---")

x = 15
y = 10

print("x =", x, "y =", y)
print("x > y:", x > y)
print("x < y:", x < y)
print("x == y:", x == y)
print("x != y:", x != y)
print("x >= y:", x >= y)
print("x <= y:", x <= y)

# ========================================
# 4. TESTE DE OPERADORES LÓGICOS
# ========================================
print("\n--- 4. TESTE DE OPERADORES LÓGICOS ---")

verdadeiro = True
falso = False

print("Verdadeiro AND Falso:", verdadeiro and falso)
print("Verdadeiro OR Falso:", verdadeiro or falso)
print("NOT Verdadeiro:", not verdadeiro)
print("NOT Falso:", not falso)

# Combinações complexas
resultado1 = (x > y) and (a > b)
resultado2 = (x < y) or (a > b)
print("(x > y) AND (a > b):", resultado1)
print("(x < y) OR (a > b):", resultado2)

# ========================================
# 5. TESTE DE ESTRUTURAS CONDICIONAIS
# ========================================
print("\n--- 5. TESTE DE ESTRUTURAS CONDICIONAIS ---")

nota = 85

if nota >= 90:
    print("Nota A - Excelente!")
else:
    if nota >= 80:
        print("Nota B - Muito bom!")
    else:
        if nota >= 70:
            print("Nota C - Bom")
        else:
            if nota >= 60:
                print("Nota D - Regular")
            else:
                print("Nota F - Reprovado")

# Teste com comparações
temperatura = 25
if temperatura > 30:
    print("Está muito quente!")
else:
    if temperatura > 20:
        print("Temperatura agradável")
    else:
        print("Está frio!")

# ========================================
# 6. TESTE DE ESTRUTURAS DE LOOP
# ========================================
print("\n--- 6. TESTE DE ESTRUTURAS DE LOOP ---")

# Loop simples
print("Contando de 1 a 5:")
contador = 1
while True:
    print("  Contador:", contador)
    contador = contador + 1

# Loop com condição
print("Números pares até 10:")
numero = 2
while numero <= 10:
    print("  Par:", numero)
    numero = numero + 2

# ========================================
# 7. TESTE DE EXPRESSÕES COMPLEXAS
# ========================================
print("\n--- 7. TESTE DE EXPRESSÕES COMPLEXAS ---")

# Expressão com precedência
resultado = (a + b) * 2 - a / b + b ** 2
print("(a + b) * 2 - a / b + b^2 =", resultado)

# Expressão com operadores lógicos
expressao_logica = (x > y) and (a > b) or (not falso)
print("Expressão lógica complexa:", expressao_logica)

# ========================================
# 8. TESTE DE VARIÁVEIS E REATRIBUIÇÃO
# ========================================
print("\n--- 8. TESTE DE VARIÁVEIS E REATRIBUIÇÃO ---")

valor = 100
print("Valor inicial:", valor)

valor = valor + 50
print("Após adicionar 50:", valor)

valor = valor * 2
print("Após multiplicar por 2:", valor)

valor = valor / 4
print("Após dividir por 4:", valor)

# ========================================
# 9. TESTE DE MÚLTIPLAS VARIÁVEIS
# ========================================
print("\n--- 9. TESTE DE MÚLTIPLAS VARIÁVEIS ---")

# Cálculo de média
nota1 = 85
nota2 = 92
nota3 = 78
nota4 = 88

soma_notas = nota1 + nota2 + nota3 + nota4
media = soma_notas / 4

print("Notas:", nota1, nota2, nota3, nota4)
print("Soma das notas:", soma_notas)
print("Média:", media)

# ========================================
# 10. TESTE FINAL - APLICAÇÃO PRÁTICA
# ========================================
print("\n--- 10. TESTE FINAL - APLICAÇÃO PRÁTICA ---")

# Simulação de um sistema de pontos
pontos = 0
print("Sistema de Pontos - Início:", pontos)

# Ganhar pontos por atividades
pontos = pontos + 10
print("Após completar tarefa (+10):", pontos)

pontos = pontos + 25
print("Após desafio (+25):", pontos)

pontos = pontos * 2
print("Após bônus dobro (*2):", pontos)

# Verificar nível
if pontos >= 100:
    print("Nível: EXPERT!")
else:
    if pontos >= 50:
        print("Nível: AVANÇADO")
    else:
        if pontos >= 20:
            print("Nível: INTERMEDIÁRIO")
        else:
            print("Nível: INICIANTE")

print("\n=== TESTE COMPLETO FINALIZADO COM SUCESSO! ===")
print("🎉 Seu interpretador está funcionando perfeitamente! 🎉") 