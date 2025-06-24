# Teste de operadores lógicos
print("=== INICIANDO TESTES DE OPERADORES LÓGICOS ===")

x = True
y = False
z = True

print("Valores iniciais:")
print("x = True, y = False, z = True")
print("")

# Operador AND
print("--- TESTES DO OPERADOR AND ---")
resultado_and1 = x and y    # True and False = False
resultado_and2 = x and z    # True and True = True
resultado_and3 = y and z    # False and True = False

print("x and y =", resultado_and1)  # Esperado: False
print("x and z =", resultado_and2)  # Esperado: True
print("y and z =", resultado_and3)  # Esperado: False
print("")

# Operador OR
print("--- TESTES DO OPERADOR OR ---")
resultado_or1 = x or y      # True or False = True
resultado_or2 = x or z      # True or True = True
resultado_or3 = y or z      # False or True = True

print("x or y =", resultado_or1)    # Esperado: True
print("x or z =", resultado_or2)    # Esperado: True
print("y or z =", resultado_or3)    # Esperado: True
print("")

# Operador NOT
print("--- TESTES DO OPERADOR NOT ---")
resultado_not1 = not x      # not True = False
resultado_not2 = not y      # not False = True
resultado_not3 = not z      # not True = False

print("not x =", resultado_not1)    # Esperado: False
print("not y =", resultado_not2)    # Esperado: True
print("not z =", resultado_not3)    # Esperado: False
print("")

# Combinações complexas
print("--- TESTES DE COMBINAÇÕES COMPLEXAS ---")
complexo1 = x and y or z    # (True and False) or True = False or True = True
complexo2 = not x or y and z    # (not True) or (False and True) = False or False = False
complexo3 = (x or y) and (not z)    # (True or False) and (not True) = True and False = False

print("x and y or z =", complexo1)         # Esperado: True
print("not x or y and z =", complexo2)     # Esperado: False
print("(x or y) and (not z) =", complexo3) # Esperado: False
print("")

# Operadores com comparações
print("--- TESTES COM COMPARAÇÕES ---")
comp1 = x and (10 > 5)      # True and True = True
comp2 = y or (3 < 8)        # False or True = True
comp3 = not (15 == 15)      # not True = False

print("x and (10 > 5) =", comp1)       # Esperado: True
print("y or (3 < 8) =", comp2)         # Esperado: True
print("not (15 == 15) =", comp3)       # Esperado: False
print("")

# Testes de curto-circuito (se implementado)
print("--- TESTES ADICIONAIS ---")
teste_and = False and True    # False (curto-circuito)
teste_or = True or False      # True (curto-circuito)

print("False and True =", teste_and)    # Esperado: False
print("True or False =", teste_or)      # Esperado: True

print("=== TESTES DE OPERADORES LÓGICOS CONCLUÍDOS ===")
