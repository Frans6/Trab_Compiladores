# Teste de estruturas de repetição (loops)
print("=== TESTE DE LOOPS ===")

# Loop básico
contador = 0
print("Loop básico (0 a 4):")
while contador < 5:
    print("Contador:", contador)
    contador = contador + 1

# Loop com condições mais complexas
print("Loop com condições complexas:")
i = 0
while i < 3:
    print("i =", i)
    i = i + 1

# Loop aninhado
print("Loop aninhado:")
x = 0
while x < 2:
    y = 0
    while y < 2:
        print("x =", x, "y =", y)
        y = y + 1
    x = x + 1

# Loop com operações aritméticas
print("Loop com operações:")
soma = 0
num = 1
while num <= 5:
    soma = soma + num
    num = num + 1
print("Soma de 1 a 5:", soma)

print("=== TESTE DE LOOPS CONCLUÍDO ===")