

# Test 1 
#
# Valores esperados para los registros despues de la ejecucion
#
# r0 -> 5
# r1 -> 6
# r2 -> 30 
# r3 -> 0x0
# r4 -> 24 
# r5 -> 6
#
# Memoria 
#  0x0 -> 30
#  0x1 -> 6 


addi r0, r0, 5 # carga 5 en r0
addi r1, r1, 6 # carga 6 en r1
mul r2, r1, r0 # multiplica r1 * r0
addi r3, r3, 0x0 # carga la direccion 0x0 en r3
sb r2, 0(r3) # guarda r2 en el byte 0 de r3
sb r1, 1(r3) # guarda r1 en el byte 1 de r3
lbu r4, 0(r3) # carga el byte 0 de r3 en r4
lbu r5, 1(r3)  # carga el byte 1 de r3 en r5
sub r4, r4, r5 # resta r4 - r5
sb r4, 1(r3) # guarda r4 en el byte 0 de r3
