# Teste de precedência de operadores
print("=== INICIANDO TESTES DE PRECEDÊNCIA DE OPERADORES ===")

a = 2
b = 3
c = 4
d = 5

print("Valores iniciais:")
print("a = 2, b = 3, c = 4, d = 5")
print("")

# Precedência aritmética
print("--- PRECEDÊNCIA ARITMÉTICA ---")
resultado1 = a + b * c          # 2 + (3 * 4) = 2 + 12 = 14
resultado2 = (a + b) * c        # (2 + 3) * 4 = 5 * 4 = 20
resultado3 = a * b + c          # (2 * 3) + 4 = 6 + 4 = 10
resultado4 = a + b ** c         # 2 + (3 ** 4) = 2 + 81 = 83
resultado5 = (a + b) ** c       # (2 + 3) ** 4 = 5 ** 4 = 625

print("a + b * c =", resultado1)       # Esperado: 14
print("(a + b) * c =", resultado2)     # Esperado: 20
print("a * b + c =", resultado3)       # Esperado: 10
print("a + b ** c =", resultado4)      # Esperado: 83
print("(a + b) ** c =", resultado5)    # Esperado: 625
print("")

# Precedência com divisão e módulo
print("--- PRECEDÊNCIA COM DIVISÃO E MÓDULO ---")
resultado6 = a + b / c * d      # 2 + ((3 / 4) * 5) = 2 + (0.75 * 5) = 2 + 3.75 = 5.75
resultado7 = a * b % c + d      # ((2 * 3) % 4) + 5 = (6 % 4) + 5 = 2 + 5 = 7
resultado8 = a + b % c * d      # 2 + ((3 % 4) * 5) = 2 + (3 * 5) = 2 + 15 = 17

print("a + b / c * d =", resultado6)   # Esperado: 5.75
print("a * b % c + d =", resultado7)   # Esperado: 7
print("a + b % c * d =", resultado8)   # Esperado: 17
print("")

# Precedência com operadores de comparação
print("--- PRECEDÊNCIA COM COMPARAÇÕES ---")
comp1 = a + b > c * d           # (2 + 3) > (4 * 5) = 5 > 20 = False
comp2 = a * b == c + d          # (2 * 3) == (4 + 5) = 6 == 9 = False
comp3 = a + b <= c ** d         # (2 + 3) <= (4 ** 5) = 5 <= 1024 = True

print("a + b > c * d =", comp1)        # Esperado: False
print("a * b == c + d =", comp2)       # Esperado: False
print("a + b <= c ** d =", comp3)      # Esperado: True
print("")

# Precedência com operadores lógicos
print("--- PRECEDÊNCIA COM OPERADORES LÓGICOS ---")
bool1 = True
bool2 = False
logico1 = bool1 and a > b or bool2     # (True and (2 > 3)) or False = (True and False) or False = False or False = False
logico2 = bool1 or a > b and bool2     # True or ((2 > 3) and False) = True or (False and False) = True or False = True
logico3 = not bool1 and a == b         # (not True) and (2 == 3) = False and False = False

print("bool1 and a > b or bool2 =", logico1)      # Esperado: False
print("bool1 or a > b and bool2 =", logico2)      # Esperado: True
print("not bool1 and a == b =", logico3)          # Esperado: False
print("")

# Expressões complexas
print("--- EXPRESSÕES COMPLEXAS ---")
# a + b * c > d and bool1 or not bool2
# = (2 + (3 * 4)) > 5 and True or (not False)
# = (2 + 12) > 5 and True or True
# = 14 > 5 and True or True
# = True and True or True
# = True or True
# = True
complexo = a + b * c > d and bool1 or not bool2

print("a + b * c > d and bool1 or not bool2 =", complexo)  # Esperado: True
print("")

# Teste adicional de precedência
print("--- TESTES ADICIONAIS DE PRECEDÊNCIA ---")
teste1 = a + b * c / d          # 2 + ((3 * 4) / 5) = 2 + (12 / 5) = 2 + 2.4 = 4.4
teste2 = a ** b + c * d         # (2 ** 3) + (4 * 5) = 8 + 20 = 28
teste3 = a < b and c > d        # (2 < 3) and (4 > 5) = True and False = False

print("a + b * c / d =", teste1)       # Esperado: 4.4
print("a ** b + c * d =", teste2)      # Esperado: 28
print("a < b and c > d =", teste3)     # Esperado: False

print("=== TESTES DE PRECEDÊNCIA CONCLUÍDOS ===")
