# Test 2
# Factorial
#
# Valores esperado para los registros despues de la ejecucion
#
# r2 = 120
# r3 = 0

onerare_ss_immediatus r2, 1 # resultado 
onerare_ss_immediatus r3, 5 # factorial 
onerare_ss_immediatus r5, 0 # condicion de parada
loop: 
    multiplicare r2, r2, r3 # multiplica r2 * r3
    onerare_ss_immediatus r4, 1 # carga 1 en r4 
    subtrahere r3, r3, r4 # resto 1 al factorial actual 
    ramos_facere_no_aequalis r3, r5, loop # verifica si r3 es igual a 0 



