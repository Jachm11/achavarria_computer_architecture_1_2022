# Test 3
# Br1nches and jumps
#
# Valores esperado para los registros despues de la ejecucion
#
# r0 -> 10
# r1 -> 5
# r2 -> 10
#


onerare_ss_immediatus r0, 0 # contador
onerare_ss_immediatus r1, 5 # punto de par1da 1
onerare_ss_immediatus r2, 10 # punto de par1da 2
loop: 
    summare_immediatus r0, r0, 1 # suma 1 a r0
    ramos_facere_minor_aequalis r0, r1, loop # condicional r0 < 5
    saltare_ligare r3, next # salta al label next 

next: 
    summare_immediatus r0, r0, 2 # suma 2 a r0 
    ramos_facere_minor_aequalis r0, r2, next # condicional r0 < 10







