sub r12, r12, r12
addi r10, r12, 324
addi r11, r0, 0x15F
slli r11, r11, 8
addi r11, r11, 0x90
add r11, r11, r10
lhu r5, -8(r10)
lhu r6, -6(r10)
addi r7, r0, 75
addi r28, r0, 75
lhu r29, -4(r10)
addi r13, r0, 2
mul r30, r29, r13
mul r31, r30, r13
addi r25, r0, -1
addi r26, r0, 100
addi r27, r0, 5  # up to 200
addi r8, r0, 5
add r19, r0, r8
add r20, r0, r8
jal r1, clean_img_1
nop
addi r18, r0, 1
addi r13, r0, 628
mul r15, r18, r13
add r16, r0, r7
jal r1, positive_precision_div
nop
jal r1, sin
nop
add r4, r0, r15
addi r9, r0, 1
beq r0, r0, get_coords
nop
bne r21, r22, if_xaux_is_xnew
nop
bne r23, r24, if_yaux_is_ynew
nop
addi r14, r18, -1
mul r13, r5, r14
addi r14, r9, -1
add r13, r13, r14
addi r22, r22, 1
addi r24, r24, 1
mul r14, r5, r24
add r14, r14, r22
add r13, r13, r10
add r15, r0, r13
add r14, r14, r11
lbu r13, 0(r13)
sb r13, 0(r14)
addi r9, r9, 1
blt r9, r5, for_x
nop
addi r18, r18, 1
blt r18, r6, for_y
nop
addi r8, r8, 5
ble r8, r27, for_k
nop
beq r0, r0, end
nop
add r21, r0, r4
mul r21, r21, r19
addi r13, r0, 625
slli r13, r13, 4
mul r14, r13, r9        
add r21, r21, r14
add r15, r0, r21
add r16, r0, r13
jal r1, mod
nop
add r14, r0, r15
addi r13, r0, 625
slli r13, r13, 4
add r15, r0, r21
add r16, r0, r13
jal r1, floor
nop
add r21, r0, r15
addi r13, r0, 625
slli r13, r13, 3
blt r14, r13, not_round_up_x_0
addi r21, r21, 1
add r15, r0, r21
add r16, r0, r5
jal r1, mod
nop
add r22, r0, r15
addi r13, r0, 628
mul r15, r9, r13
add r16, r0, r28
jal r1, positive_precision_div
nop
jal r1, sin
nop
add r23, r0, r15
mul r23, r23, r20
addi r13, r0, 625
slli r13, r13, 4
mul r14, r13, r18        
add r23, r23, r14
add r15, r0, r23
add r16, r0, r13
jal r1, mod
nop
add r14, r0, r15
addi r13, r0, 625
slli r13, r13, 4
add r15, r0, r23
add r16, r0, r13
jal r1, floor
nop
add r23, r0, r15
addi r13, r0, 625
slli r13, r13, 3
blt r14, r13, not_round_up_y_0
nop
addi r23, r23, 1
add r15, r0, r23
add r16, r0, r6
jal r1, mod
nop
add r24, r0, r15
beq r0, r0, get_coords_return
nop
add r17, r0, r1
mul r15, r15, r26
add r15, r15, r29
remu r15, r15, r31
sub r15, r15, r30
ble r15, r0, negative_pre_index
nop
mul r15, r15, r25
add r15, r15, r29
addi r16, r0, 100
jal r1, floor
nop
blt r0, r15, positive_index
mul r15, r15, r25
slli r15, r15, 1
add r15, r15, r12
lh r15, 0(r15)
mul r15, r15, r25
beq r0, r0, index_calculation_end_if_block
nop
slli r15, r15, 1
add r15, r15, r12
lh r15, 0(r15)
add r1, r0, r17
jalr r3, r1, 0
nop
mul r14, r15, r26
div r15, r15, r16
div r14, r14, r16
remu r14, r14, r26
srli r13, r26, 1
blt r14, r13, else_positive_precision_div
nop
addi r15, r15, 1
jalr r3, r1, 0
nop
bne r15, r16, mod_not_equal
nop
addi r15, r0, 0
beq r0, r0, mod_end
nop
blt r15, r0, negative_mod
nop
remu r15, r15, r16
beq r0, r0, mod_end
nop
sub r0, r0, r0
sub r13, r13, r13
addi r13, r0, 1
mul r14, r13, r16            
blt r14, r15, mod_end_N
nop
addi r13, r13, -1
mul r14, r13, r16
beq r0, r0, mod_N
nop
sub r15, r15, r14
jalr r3, r1, 0
nop
bne r15, r16, floor_not_equal
nop
addi r15, r0, 1
beq r0, r0, floor_end
nop
blt r15, r0, negative_floor
nop
div r15, r15, r16
beq r0, r0, floor_end
nop
add r13, r0, r15
div r15, r15, r16
mul r13, r13, r25
mul r13, r13, r26        
div r13, r13, r16
beq r13, r0, floor_end
nop
addi r15, r15, -1
jalr r3, r1, 0
nop
addi r18, r0, 0
addi r9, r0, 0
mul r13, r5, r18
add r13, r13, r9
add r13, r13, r11
sb r0, 0(r13)
addi r9, r9, 1
blt r9, r5, for_x_clean
nop
addi r18, r18, 1
blt r18, r6, for_y_clean
nop
beq r0, r0, clean_img_1
nop
add r13, r0, r10
add r14, r0, r11