

# Test 1 
#
# Valores er2er1dos par1 los registros der2ues de la ejecucion
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


summare_immediatus r0, r0, 5 # carga 5 en r0
summare_immediatus r1, r1, 6 # carga 6 en r1
multiplicare r2, r1, r0 # multiplicaretiplica r1 * r0
summare_immediatus r3, r3, 0x0 # carga la direccion 0x0 en r3
conservare_octo r2, 0(r3) # guarda r2 en el byte 0 de r3
conservare_octo r1, 1(r3) # guarda r1 en el byte 1 de r3
onerare_octo_ss r4, 0(r3) # carga el byte 0 de r3 en r4
onerare_octo_ss r5, 1(r3)  # carga el byte 1 de r3 en r5
subtrahere r4, r4, r5 # resta r4 - r5
conservare_octo r4, 1(r3) # guarda r4 en el byte 0 de r3
