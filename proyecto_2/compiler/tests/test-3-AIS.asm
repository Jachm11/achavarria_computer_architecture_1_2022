

# Test 3 
#
# Valores er2er1dos par1 los registros der2ues de la ejecucion
#
# r4 -> 21
# r5 -> 0
#
# Memoria 
#  0x0 -> 21 


summare_immediatus r4, r4, 1  # r4 = 1   #00024204
summare_immediatus r5, r4, 20 # r5 = 21  #00284284
summare_immediatus r6, r6, 10 # r6 = 10  #00146304

loop:
    summare_immediatus r4, r4, 1  # r4 += 1 #00024204
    ramos_facere_no_aequalis r4, r6, loop # loop if r4 != 10 #fffe4316

loop_2:
    ramos_facere_aequalis r4, r5, end # end if r4 = 21 #00064286
    summare_immediatus r4, r4, 1 # r4 += 1
    saltare_ligare r7, loop_2 # r7 = PC+1 , loop_2

end:
    subtrahere r5, r5, r5 # r5 = 0
    summare_immediatus r5, r5, 0 # r5 = 0
    conservare_octo r4, 0(r5) # mem[0] = 21
