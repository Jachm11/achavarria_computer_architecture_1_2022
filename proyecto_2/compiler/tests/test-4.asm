
# Test 4 
# Loop inside a loop

# Valores esperados para los registros despues de la ejecucion
#
# r4 -> 5
# r5 -> 5
# r6 -> 15
# r7 -> 5
# r8 -> 128
# r9 -> 5
# Memoria 
#  0x0 -> 0 
#  0x3 -> 32
#  0x6 -> 64
#  0x9 -> 96
#  0x12 -> 128s
#

addi r4, r4, 0 # contador 
addi r5, r5, 5 # condicion de parada 
addi r6, r6, 0x0 # direccion de memoria 
addi r7, r7, 5 # condicion de parada 
loop:
    sub r9, r9, r9 # contador internal loop, comienza en 0   
    sub r8, r8, r8 # reinicia r8 
    add r8, r8, r4 # guarda r4 en r8
    internal_loop:
        
        slli r8, r8, 1 # shift left 1
        addi r9, r9, 1 # suma 1 al contador
        blt r9, r7, internal_loop # verifica r9 < r7
        nop
     
    
    sb r8, 0(r6) #
    addi r6, r6, 3
    addi r4 ,r4, 1
    blt r4, r5, loop