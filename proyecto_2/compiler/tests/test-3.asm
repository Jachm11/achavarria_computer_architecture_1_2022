

# Test 3 
#
# Valores esperados para los registros despues de la ejecucion
#
# r4 -> 21
# r5 -> 0
#
# Memoria 
#  0x0 -> 21 


addi r4, r4, 1  # r4 = 1   #00024204
addi r5, r4, 20 # r5 = 21  #00284284
addi r6, r6, 10 # r6 = 10  #00146304

loop:
    addi r4, r4, 1  # r4 += 1 #00024204
    bne r4, r6, loop # loop if r4 != 10 #fffe4316
    nop

loop_2:
    beq r4, r5, end # end if r4 = 21 #00064286
    nop
    addi r4, r4, 1 # r4 += 1
    jal r7, loop_2 # r7 = PC+1 , loop_2
    nop

end:
    sub r5, r5, r5 # r5 = 0
    addi r5, r5, 0 # r5 = 0
    sb r4, 0(r5) # mem[0] = 21
