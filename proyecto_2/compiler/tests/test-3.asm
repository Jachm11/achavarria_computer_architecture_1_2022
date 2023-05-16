

# Test 3 
#
# Valores esperados para los registros despues de la ejecucion
#
# r4 -> 20
# r5 -> 0
# r6 -> 32 *
#
# Memoria 
#  0x0 -> 20 


addi r4, r4, 1
addi r5, r4, 20
addi r6, r6, 10

loop:
    addi r4, r4, 1
    bne r4, r6, loop

loop_2:
    beq r4, r5, end
    addi r4, r4, 1
    jal x6, loop_2

end:
    sub r5, r5, r5
    addi r5, r5, 0
    sb r4, 0(r5)
