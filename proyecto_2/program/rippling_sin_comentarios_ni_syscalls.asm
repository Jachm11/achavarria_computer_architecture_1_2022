lui a2, 0x10010
addi a2, a2, 0x40
addi a0, a2, 324
addi a1, zero, 0x15F
slli a1, a1, 8
addi a1, a1, 0x90
add a1, a1, a0
lhu t0, -8(a0)
lhu t1, -6(a0)
addi t2, zero, 75
addi t3, zero, 75
lhu t4, -4(a0)
addi a3, zero, 2
mul t5, t4, a3
mul t6, t5, a3
addi s9, zero, -1
addi s10, zero, 100
addi s11, zero, 5
addi s0, zero, 5
for_k:
add s3, zero, s0
add s4, zero, s0
jal ra, clean_img_1
addi s2, zero, 1
for_y:
addi a3, zero, 628
mul a5, s2, a3
add a6, zero, t2
jal ra, positive_precision_div
jal ra, sin
add tp, zero, a5
addi s1, zero, 1
for_x:
beq zero, zero, get_coords
get_coords_return:
bne s5, s6, if_xaux_is_xnew
bne s7, s8, if_yaux_is_ynew
addi a4, s2, -1
mul a3, t0, a4
addi a4, s1, -1
add a3, a3, a4
addi s6, s6, 1
addi s8, s8, 1
mul a4, t0, s8
add a4, a4, s6
add a3, a3, a0
add a5, zero, a3
add a4, a4, a1
lbu a3, 0(a3)
sb a3, 0(a4)
if_xaux_is_xnew:
if_yaux_is_ynew:
addi s1, s1, 1
blt s1, t0, for_x
addi s2, s2, 1
blt s2, t1, for_y
addi s0, s0, 5
ble s0, s11, for_k
beq zero, zero, end
get_coords:
add s5, zero, tp
mul s5, s5, s3
addi a3, zero, 625
slli a3, a3, 4
mul a4, a3, s1        
add s5, s5, a4
add a5, zero, s5
add a6, zero, a3
jal ra, mod
add a4, zero, a5
addi a3, zero, 625
slli a3, a3, 4
add a5, zero, s5
add a6, zero, a3
jal ra, floor
add s5, zero, a5
addi a3, zero, 625
slli a3, a3, 3
blt a4, a3, not_round_up_x_0
addi s5, s5, 1
not_round_up_x_0:
add a5, zero, s5
add a6, zero, t0
jal ra, mod
add s6, zero, a5
addi a3, zero, 628
mul a5, s1, a3
add a6, zero, t3
jal ra, positive_precision_div
jal ra, sin
add s7, zero, a5
mul s7, s7, s4
addi a3, zero, 625
slli a3, a3, 4
mul a4, a3, s2        
add s7, s7, a4
add a5, zero, s7
add a6, zero, a3
jal ra, mod
add a4, zero, a5
addi a3, zero, 625
slli a3, a3, 4
add a5, zero, s7
add a6, zero, a3
jal ra, floor
add s7, zero, a5
addi a3, zero, 625
slli a3, a3, 3
blt a4, a3, not_round_up_y_0
addi s7, s7, 1
not_round_up_y_0:
add a5, zero, s7
add a6, zero, t1
jal ra, mod
add s8, zero, a5
beq zero, zero, get_coords_return
sin:
add a7, zero, ra
mul a5, a5,s10
add a5, a5, t4
remu a5, a5, t6
sub a5, a5, t5
ble a5, zero, negative_pre_index
mul a5, a5, s9
negative_pre_index:
add a5, a5, t4
addi a6, zero, 100
jal ra, floor
bge a5, zero, positive_index
mul a5, a5, s9
slli a5, a5, 1
add a5, a5, a2
lh a5, 0(a5)
mul a5, a5, s9
beq zero, zero, index_calculation_end_if_block
positive_index:
slli a5, a5, 1
add a5, a5, a2
lh a5, 0(a5)
index_calculation_end_if_block:
add ra, zero, a7
jalr zero, ra, 0
positive_precision_div:
mul a4, a5, s10
div a5, a5, a6
div a4, a4, a6
remu a4, a4, s10
srli a3, s10, 1
blt a4, a3, else_positive_precision_div
addi a5, a5, 1
else_positive_precision_div:
jalr zero, ra, 0
mod:
bne a5, a6, mod_not_equal
addi a5, zero, 0
beq zero, zero, mod_end
mod_not_equal:
blt a5, zero, negative_mod
remu a5, a5, a6
beq zero, zero, mod_end
negative_mod:
addi a3, zero, 1
mul a4, a3, a6            
mod_N:
blt a4, a5, mod_end_N
addi a3, a3, -1
mul a4, a3, a6
beq zero, zero, mod_N
mod_end_N:
sub a5, a5, a4
mod_end:
jalr zero, ra, 0
floor:
bne a5, a6, floor_not_equal
addi a5, zero, 1
beq zero, zero, floor_end
floor_not_equal:
blt a5, zero, negative_floor
div a5, a5, a6
beq zero, zero, floor_end
negative_floor:
add a3, zero, a5
div a5, a5, a6
mul a3, a3, s9
mul a3, a3, s10        
div a3, a3, a6
beq a3, zero, floor_end
addi a5, a5, -1
floor_end:
jalr zero, ra, 0
clean_img_1:
addi s2, zero, 0
for_y_clean:
addi s1, zero, 0
for_x_clean:
mul a3, t0, s2
add a3, a3, s1
add a3, a3, a1
sb zero, 0(a3)
addi s1, s1, 1
blt s1, t0, for_x_clean
addi s2, s2, 1
blt s2, t1, for_y_clean
jalr zero, ra, 0
end:
add a3, zero, a0
add a4, zero, a1