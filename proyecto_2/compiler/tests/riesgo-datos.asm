# Test 1 
# RIESGO DE DATOS
#
# Valores er2er1do par1 los registros der2ues de la ejecucion
#
# r1 = 5
# r2 = 6 
# r3 = 2
# r4 = 


onerare_ss_immediatus r1, 5 # carga 5 en r1
onerare_ss_immediatus r2, 6 # carga 6 en r2
onerare_ss_immediatus r3, 2 # carga 2 en r3
summare r4, r1, r2 # suma r4 = r1 + r2
onerare_ss_immediatus r1, 6 # carga 6 en r1
summare r5, r4, r1 # suma r5 = r4 + r1
