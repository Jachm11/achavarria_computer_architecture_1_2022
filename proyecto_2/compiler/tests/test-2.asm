# Test 2
# Factorial
#
# Valores esperado para los registros despues de la ejecucion
#
# r4 -> 120 
# r5 -> 0 
# r6 -> 1
# r7 -> 1
#
# Memory 
#   0x0 -> 120


addi r4, r4, 1 # resultado 
addi r5, r5, 5 # factorial 
addi r6, r6, 1 # carga 1 en r4 
addi r7, r7, 0 # condicion de parada
loop: 
    mul r4, r4, r5 # verifica si r3 es igual a 0 
    sub r5, r5, r6 # multiplica r2 * r3
    ble r7, r5, loop # resto 1 al factorial actual 
end:
    sub r5, r5, r5
    addi r5, r5, 0 
    sb r4, 0(r5)

# Test 2
# Factorial
#
# Valores esperado para los registros despues de la ejecucion
#
# r4 -> 120 
# r5 -> 0 
# r6 -> 1
# r7 -> 1
#
# Memory 
#   0x0 -> 120


addi r4, r4, 1 # resultado
addi r5, r5, 5 # factorial de 5 
addi r6, r6, 1 # carga 1 en r6 
addi r7, r7, 1 # condicion de parada
loop: 
    mul r4, r4, r5 # r4 = r4 * r5
    sub r5, r5, r6 # r5 = r5 - 1
    ble r7, r5, loop # loop if r5 > 0 
end:
    nop
    sb r4, 0(r5)
