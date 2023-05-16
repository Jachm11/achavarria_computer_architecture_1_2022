sub r12, r12, r12
nop
nop
addi r10, r12, 324
nop
nop
addi r11, r0, 0x15F
nop
nop
slli r11, r11, 8
nop
nop
addi r11, r11, 0x90
nop
nop
add r11, r11, r10
nop
nop
lhu r5, -8(r10)
nop
nop
lhu r6, -6(r10)
nop
nop
addi r7, r0, 75
nop
nop
addi r28, r0, 75
nop
nop
lhu r29, -4(r10)
nop
nop
addi r13, r0, 2
nop
nop
mul r30, r29, r13
nop
nop
mul r31, r30, r13
nop
nop
addi r25, r0, -1
nop
nop
addi r26, r0, 100
nop
nop
addi r27, r0, 5  # up to 200
nop
nop
addi r8, r0, 5
nop
nop
for_k:
nop
nop
add r19, r0, r8
nop
nop
add r20, r0, r8
nop
nop
jal r1, clean_img_1
nop
nop
nop
nop
nop
addi r18, r0, 1
nop
nop
for_y:
nop
nop
addi r13, r0, 628
nop
nop
mul r15, r18, r13
nop
nop
add r16, r0, r7
nop
nop
jal r1, positive_precision_div
nop
nop
nop
nop
nop
jal r1, sin
nop
nop
nop
nop
nop
add r4, r0, r15
nop
nop
addi r9, r0, 1
nop
nop
for_x:
nop
nop
beq r0, r0, get_coords
nop
nop
nop
nop
nop
get_coords_return:
nop
nop
bne r21, r22, if_xaux_is_xnew
nop
nop
nop
nop
nop
bne r23, r24, if_yaux_is_ynew
nop
nop
nop
nop
nop
addi r14, r18, -1
nop
nop
mul r13, r5, r14
nop
nop
addi r14, r9, -1
nop
nop
add r13, r13, r14
nop
nop
addi r22, r22, 1
nop
nop
addi r24, r24, 1
nop
nop
mul r14, r5, r24
nop
nop
add r14, r14, r22
nop
nop
add r13, r13, r10
nop
nop
add r15, r0, r13
nop
nop
add r14, r14, r11
nop
nop
lbu r13, 0(r13)
nop
nop
sb r13, 0(r14)
nop
nop
if_xaux_is_xnew:
nop
nop
if_yaux_is_ynew:
nop
nop
addi r9, r9, 1
nop
nop
blt r9, r5, for_x
nop
nop
nop
nop
nop
addi r18, r18, 1
nop
nop
blt r18, r6, for_y
nop
nop
nop
nop
nop
addi r8, r8, 5
nop
nop
ble r8, r27, for_k
nop
nop
nop
nop
nop
beq r0, r0, end
nop
nop
nop
nop
nop
get_coords:
nop
nop
add r21, r0, r4
nop
nop
mul r21, r21, r19
nop
nop
addi r13, r0, 625
nop
nop
slli r13, r13, 4
nop
nop
mul r14, r13, r9        
nop
nop
add r21, r21, r14
nop
nop
add r15, r0, r21
nop
nop
add r16, r0, r13
nop
nop
jal r1, mod
nop
nop
nop
nop
nop
add r14, r0, r15
nop
nop
addi r13, r0, 625
nop
nop
slli r13, r13, 4
nop
nop
add r15, r0, r21
nop
nop
add r16, r0, r13
nop
nop
jal r1, floor
nop
nop
nop
nop
nop
add r21, r0, r15
nop
nop
addi r13, r0, 625
nop
nop
slli r13, r13, 3
nop
nop
blt r14, r13, not_round_up_x_0
nop
nop
addi r21, r21, 1
nop
nop
not_round_up_x_0:
nop
nop
add r15, r0, r21
nop
nop
add r16, r0, r5
nop
nop
jal r1, mod
nop
nop
nop
nop
nop
add r22, r0, r15
nop
nop
addi r13, r0, 628
nop
nop
mul r15, r9, r13
nop
nop
add r16, r0, r28
nop
nop
jal r1, positive_precision_div
nop
nop
nop
nop
nop
jal r1, sin
nop
nop
nop
nop
nop
add r23, r0, r15
nop
nop
mul r23, r23, r20
nop
nop
addi r13, r0, 625
nop
nop
slli r13, r13, 4
nop
nop
mul r14, r13, r18        
nop
nop
add r23, r23, r14
nop
nop
add r15, r0, r23
nop
nop
add r16, r0, r13
nop
nop
jal r1, mod
nop
nop
nop
nop
nop
add r14, r0, r15
nop
nop
addi r13, r0, 625
nop
nop
slli r13, r13, 4
nop
nop
add r15, r0, r23
nop
nop
add r16, r0, r13
nop
nop
jal r1, floor
nop
nop
nop
nop
nop
add r23, r0, r15
nop
nop
addi r13, r0, 625
nop
nop
slli r13, r13, 3
nop
nop
blt r14, r13, not_round_up_y_0
nop
nop
nop
nop
nop
addi r23, r23, 1
nop
nop
not_round_up_y_0:
nop
nop
add r15, r0, r23
nop
nop
add r16, r0, r6
nop
nop
jal r1, mod
nop
nop
nop
nop
nop
add r24, r0, r15
nop
nop
beq r0, r0, get_coords_return
nop
nop
nop
nop
nop
sin:
nop
nop
add r17, r0, r1
nop
nop
mul r15, r15, r26
nop
nop
add r15, r15, r29
nop
nop
remu r15, r15, r31
nop
nop
sub r15, r15, r30
nop
nop
ble r15, r0, negative_pre_index
nop
nop
nop
nop
nop
mul r15, r15, r25
nop
nop
negative_pre_index:
nop
nop
add r15, r15, r29
nop
nop
addi r16, r0, 100
nop
nop
jal r1, floor
nop
nop
nop
nop
nop
blt r0, r15, positive_index
nop
nop
mul r15, r15, r25
nop
nop
slli r15, r15, 1
nop
nop
add r15, r15, r12
nop
nop
lh r15, 0(r15)
nop
nop
mul r15, r15, r25
nop
nop
beq r0, r0, index_calculation_end_if_block
nop
nop
nop
nop
nop
positive_index:
nop
nop
slli r15, r15, 1
nop
nop
add r15, r15, r12
nop
nop
lh r15, 0(r15)
nop
nop
index_calculation_end_if_block:
nop
nop
add r1, r0, r17
nop
nop
jalr r0, r1, 0
nop
nop
nop
nop
nop
positive_precision_div:
nop
nop
mul r14, r15, r26
nop
nop
div r15, r15, r16
nop
nop
div r14, r14, r16
nop
nop
remu r14, r14, r26
nop
nop
srli r13, r26, 1
nop
nop
blt r14, r13, else_positive_precision_div
nop
nop
nop
nop
nop
addi r15, r15, 1
nop
nop
else_positive_precision_div:
nop
nop
jalr r0, r1, 0
nop
nop
nop
nop
nop
mod:
nop
nop
bne r15, r16, mod_not_equal
nop
nop
nop
nop
nop
addi r15, r0, 0
nop
nop
beq r0, r0, mod_end
nop
nop
nop
nop
nop
mod_not_equal:
nop
nop
blt r15, r0, negative_mod
nop
nop
nop
nop
nop
remu r15, r15, r16
nop
nop
beq r0, r0, mod_end
nop
nop
nop
nop
nop
negative_mod:
nop
nop
addi r13, r0, 1
nop
nop
mul r14, r13, r16            
nop
nop
mod_N:
nop
nop
blt r14, r15, mod_end_N
nop
nop
nop
nop
nop
addi r13, r13, -1
nop
nop
mul r14, r13, r16
nop
nop
beq r0, r0, mod_N
nop
nop
nop
nop
nop
mod_end_N:
nop
nop
sub r15, r15, r14
nop
nop
mod_end:
nop
nop
jalr r0, r1, 0
nop
nop
nop
nop
nop
floor:
nop
nop
bne r15, r16, floor_not_equal
nop
nop
nop
nop
nop
addi r15, r0, 1
nop
nop
beq r0, r0, floor_end
nop
nop
nop
nop
nop
floor_not_equal:
nop
nop
blt r15, r0, negative_floor
nop
nop
nop
nop
nop
div r15, r15, r16
nop
nop
beq r0, r0, floor_end
nop
nop
nop
nop
nop
negative_floor:
nop
nop
add r13, r0, r15
nop
nop
div r15, r15, r16
nop
nop
mul r13, r13, r25
nop
nop
mul r13, r13, r26        
nop
nop
div r13, r13, r16
nop
nop
beq r13, r0, floor_end
nop
nop
nop
nop
nop
addi r15, r15, -1
nop
nop
floor_end:
nop
nop
jalr r0, r1, 0
nop
nop
nop
nop
nop
clean_img_1:
nop
nop
addi r18, r0, 0
nop
nop
for_y_clean:
nop
nop
addi r9, r0, 0
nop
nop
for_x_clean:
nop
nop
mul r13, r5, r18
nop
nop
add r13, r13, r9
nop
nop
add r13, r13, r11
nop
nop
sb r0, 0(r13)
nop
nop
addi r9, r9, 1
nop
nop
blt r9, r5, for_x_clean
nop
nop
nop
nop
nop
addi r18, r18, 1
nop
nop
blt r18, r6, for_y_clean
nop
nop
nop
nop
nop
jalr r0, r1, 0
nop
nop
nop
nop
nop
end:
nop
nop
add r13, r0, r10
nop
nop
add r14, r0, r11
nop
nop