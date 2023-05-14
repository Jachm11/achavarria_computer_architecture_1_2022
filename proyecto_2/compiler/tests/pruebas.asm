hola:
    addi r5, r5, 10
    addi r4, r4, 10
    add r5, r5, r5
    add r5, r5, r5
    sb r5, 0(r0)
    lhu r1, 0(r0)
    sub r2, r1, r4
    jal r7, hola  
    addi r9, r9, 11