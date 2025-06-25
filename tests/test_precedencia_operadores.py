# Teste de precedência de operadores
print("=== TESTE DE PRECEDÊNCIA DE OPERADORES ===")

# Precedência aritmética básica
resultado1 = 2 + 3 * 4      # Esperado: 14 (multiplicação primeiro)
resultado2 = (2 + 3) * 4    # Esperado: 20 (parênteses primeiro)
resultado3 = 10 - 6 / 2     # Esperado: 7 (divisão primeiro)
resultado4 = (10 - 6) / 2   # Esperado: 2 (parênteses primeiro)

print("2 + 3 * 4 =", resultado1)
print("(2 + 3) * 4 =", resultado2)
print("10 - 6 / 2 =", resultado3)
print("(10 - 6) / 2 =", resultado4)

# Precedência com múltiplas operações
resultado5 = 2 + 3 * 4 - 5      # Esperado: 9 (2 + 12 - 5)
resultado6 = 2 * 3 + 4 * 5      # Esperado: 26 (6 + 20)
resultado7 = 20 / 4 + 3 * 2     # Esperado: 11 (5 + 6)

print("2 + 3 * 4 - 5 =", resultado5)
print("2 * 3 + 4 * 5 =", resultado6)
print("20 / 4 + 3 * 2 =", resultado7)

# Precedência com comparações
a = 5
b = 3
c = 2

comp1 = a > b + c       # Esperado: False (5 > 5)
comp2 = a + b > c * 2   # Esperado: True (8 > 4)
comp3 = a * b > c + 10  # Esperado: True (15 > 12)

print("a > b + c =", comp1)
print("a + b > c * 2 =", comp2)
print("a * b > c + 10 =", comp3)

# Precedência com operadores lógicos
log1 = True or False and False    # Esperado: True (and primeiro)
log2 = True and False or True     # Esperado: True (and primeiro)
log3 = not False and True        # Esperado: True (not primeiro)

print("True or False and False =", log1)
print("True and False or True =", log2)
print("not False and True =", log3)

# Precedência mista (aritmética + comparação + lógica)
x = 10
y = 5
z = 3

misto1 = x > y and y > z          # Esperado: True (10 > 5 and 5 > 3)
misto2 = x + y > z * 4 or False   # Esperado: True (15 > 12 or False)
misto3 = not x < y or y == z + 2  # Esperado: True (not False or True)

print("x > y and y > z =", misto1)
print("x + y > z * 4 or False =", misto2)
print("not x < y or y == z + 2 =", misto3)

# Precedência com parênteses complexos
complexo1 = (x + y) * (z - 1)     # Esperado: 30 (15 * 2)
complexo2 = x * (y + z) - 10      # Esperado: 70 (10 * 8 - 10)
complexo3 = (x > y) and (y > z)   # Esperado: True (True and True)

print("(x + y) * (z - 1) =", complexo1)
print("x * (y + z) - 10 =", complexo2)
print("(x > y) and (y > z) =", complexo3)

print("=== TESTE DE PRECEDÊNCIA CONCLUÍDO ===")
