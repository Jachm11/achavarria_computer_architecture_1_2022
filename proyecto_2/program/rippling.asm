.data
	input: .string "initial_data.bin\0"
	output: .string "image_out.bin\0"
	output_0: .string "image_out_0.bin\0"

.text
# Syscalls

# Open
	# Opens a file from a path Only supported flags (a1) are read-only (0), write-only (1) and write-append (9).
	# write-only flag creates file if it does not exist, so it is technically write-create.
	# write-append will start writing at end of existing file.la a0, input
la a0, input	# path
li a1, 0	# read flag
li a7, 1024	# open call
ecall

# Read
	# Read from a file descriptor into a buffer
	# a0 = file descriptor
	# a1 = addr of the buffer
	# a2 max lenght to read
	
	# metadata = 324 bytes = sin_table + m + n + t_4 + pad + pad
	# img 300x300 = 90 000 bytes
			# same file descriptor
lui a1, 0x10010		# addr for data
addi a1, a1, 0x40	# addr for data
lui a2, 0x16		# 90324 bytes -> 0x16 0D4 ######################### CHANGE WITH IMG RESOLUTION
addi a2, a2, 0xD4	# ################################################# CHANGE WITH IMG RESOLUTION
li a7, 63		# read call
ecall

# Close
li a7, 57	# close call
ecall

# 324 Bytes of metada at start
# Addrs
    # Initial address in RAM
    # (Same as addr for sine table)
    lui a2, 0x10010
    addi a2, a2, 0x40

    # Initial address for img_0 (a0)
    # (After metadata)
    addi a0, a2, 324

    # Initial address for img_1 (a1)
    addi a1, zero, 0x15F # 15F90 = 90 000
    slli a1, a1, 8
    addi a1, a1, 0x90
    add a1, a1, a0


# Constants
    # width x lenght
    lhu t0, -8(a0)	# width
    lhu t1, -6(a0)	# lenght

    # Period and amplitude
    addi t2, zero, 75   # Lx
    addi t3, zero, 75   # Ly

    # Sine calculation
    lhu t4, -4(a0)	# rounded (pi/4) * 10k  = 15708 = 0x3D5C
    addi a3, zero, 2
    mul t5, t4, a3      # rounded pi * 10k      = 31416 = 0x7AB8
    mul t6, t5, a3      # rounded 2pi * 10k     = 62832 = 0xF570

    # Common
    addi s9, zero, -1
    addi s10, zero, 100

    # Iteration limit
    addi s11, zero, 5 # for_k limit #################### CHANGE TO 200


# Start
    #for k = 5:5:200
        addi s0, zero, 5 # k starts in 5 ############## CHANGE TO 5
        for_k:

            add s3, zero, s0 # Ax = k
            add s4, zero, s0 # Ay = k

	jal ra, clean_img_1

        # for y
            addi s2, zero, 1 # y starts in 1
            for_y:
                # Calculates sin() of xaux
                # sin(2 * ~pi * y * 100 / Lx)
                    # args of sin()
                        # div()
                            # args of div()
                                addi a3, zero, 628                      # gen 628
                                mul a5, s2, a3                          # Loads param_1 = 628y
                                add a6, zero, t2                        # Loads param_2 = Lx
              			jal ra, positive_precision_div		# div()
                    jal ra, sin

                # Saves sin()
                    add tp, zero, a5                            # mov sin() to tp
                    
            # for x
                addi s1, zero, 1 # x starts in 1
                for_x:
                    beq zero, zero, get_coords
                    get_coords_return:
                    
		    bne s5, s6, if_xaux_is_xnew
		    	bne s7, s8, if_yaux_is_ynew
		            nop
                	    # get unidimensional current coords
	                    # X + MY
	                    addi a4, s2, -1 # Removes y Offset to get right address
	                    mul a3, t0, a4
	                    addi a4, s1, -1 # Removes x Offset to get right address
	                    add a3, a3, a4

	                    # get unidimensional new coords
			    # Xnew + MYnew
			    nop
			    addi s6, s6, 1	# xnew + 1
			    addi s8, s8, 1	# ynew + 1			    
			    nop
			    
	                    mul a4, t0, s8
	                    add a4, a4, s6

	                    # get addrs
	                    add a3, a3, a0	# img 0
			    add a5, zero, a3
			    add a4, a4, a1	# img 1
			    
			    
	                    # Load and clean pix
	                    lbu a3, 0(a3)
	                    #sb zero, 0(a5)
	                    
	                    # Move pix to new pic
	                    sb a3, 0(a4)
	                    		    		
		    if_xaux_is_xnew:
		    if_yaux_is_ynew:
		

                 addi s1, s1, 1 # x += 1
                 blt s1, t0, for_x
            
            addi s2, s2, 1 # y += 1
            blt s2, t1, for_y
            
        # Flip addresses
        #add a3, zero, a0
        #add a0, zero, a1
        #add a1, zero, a3


        addi s0, s0, 5 # k += 5
        ble s0, s11, for_k

        beq zero, zero, end


get_coords:
    # calculates xaux and xnew
        add s5, zero, tp        # xaux = sin()
        mul s5, s5, s3          # xaux *= Ax

        #gen 10k
        addi a3, zero, 625
        slli a3, a3, 4          # a3 = 10k

        mul a4, a3, s1          # c = x * 10k        
        add s5, s5, a4          # xaux += c

        # mod()
            # args
                add a5, zero, s5        # Loads param_1 = xaux
                add a6, zero, a3        # Loads param_2 = 10k
            jal ra, mod

        add a4, zero, a5                # MOV -> b = a4

        #gen 10k
        addi a3, zero, 625
        slli a3, a3, 4                  # a3 = 10k

        #floor()
            # args
                add a5, zero, s5
                add a6, zero, a3
            jal ra, floor

        add s5, zero, a5

        #gen 5k
        addi a3, zero, 625
        slli a3, a3, 3          # a3 = 5k

        # round
        blt a4, a3, not_round_up_x_0      # if(b >= 5k)
            addi s5, s5, 1      # round up
        not_round_up_x_0:
        #s5 = xaux

        #s6 = xnew
        # mod()
            # args
                add a5, zero, s5
                add a6, zero, t0
            jal ra, mod
            
        add s6, zero, a5
        
    # calculates yaux and ynew
        # Calculates sin() of yaux
        # sin(2 * ~pi * x * 100 / Ly)
            # args of sin()
                # div()
                    # args of div()
                        addi a3, zero, 628                      # gen 628
                        mul a5, s1, a3                          # Loads param_1 = 628x
                        add a6, zero, t3                        # Loads param_2 = Ly
                        
                    jal ra, positive_precision_div      # div()

            jal ra, sin 

        add s7, zero, a5        # yaux = sin()
        mul s7, s7, s4          # yaux *= Ay

        #gen 10k
        addi a3, zero, 625
        slli a3, a3, 4          # a3 = 10k

        mul a4, a3, s2          # c = y * 10k        
        add s7, s7, a4          # yaux += c

        # mod()
            # args
                add a5, zero, s7        # Loads param_1 = yaux
                add a6, zero, a3        # Loads param_2 = 10k
            jal ra, mod

        add a4, zero, a5                # MOV -> b = a4

        #gen 10k
        addi a3, zero, 625
        slli a3, a3, 4                  # a3 = 10k

        #floor()
            # args
                add a5, zero, s7
                add a6, zero, a3
            jal ra, floor

        add s7, zero, a5

        #gen 5k
        addi a3, zero, 625
        slli a3, a3, 3          # a3 = 5k

        # round
        blt a4, a3, not_round_up_y_0      # if(b >= 5k)
            addi s7, s7, 1      # round up
        not_round_up_y_0:
        #s7 = yaux

        #s8 = ynew
        # mod()
            # args
                add a5, zero, s7
                add a6, zero, t1
            jal ra, mod
            
        add s8, zero, a5

    beq zero, zero, get_coords_return


sin:
    add a7, zero, ra
    # index calculation
        # =-ABS(MOD(100*a5 + 15708, 62832) - 31416) + 15708
        mul a5, a5,s10                      # index *= 100
        add a5, a5, t4                      # index += 15 708
        remu a5, a5, t6                     # index %= 62 832
        sub a5, a5, t5                      # index -= 31 416

        # -ABS()
        ble a5, zero, negative_pre_index    # if(index > 0)
            mul a5, a5, s9                      # index *= -1
        negative_pre_index:                 # end if

        add a5, a5, t4                      # index += 15 708

    # floor()
                                            # Loads param_1 = a5 = betos(a5)
        addi a6, zero, 100                  # Loads param_2 = 100
	jal ra, floor
	
    bge a5, zero, positive_index            # if(index < 0)
        mul a5, a5, s9                          # index *= -1

        # Loads from sine_table
            slli a5, a5, 1                  # index * 2 (bytes of sine result)
            add a5, a5, a2                  # addr = initial addr + index
            lh a5, 0(a5)                    # sin_table[index]

        mul a5, a5, s9                      # *= -1
    beq zero, zero, index_calculation_end_if_block
    positive_index:                     # else
        # Loads from sine_table
            slli a5, a5, 1                      # index * 2 (bytes of sine result)
            add a5, a5, a2                      # addr = initial addr + index
            lh a5, 0(a5)                        # s7 = sin_table(index)
    index_calculation_end_if_block:

    add ra, zero, a7
    jalr zero, ra, 0


positive_precision_div:
    mul a4, a5, s10                         # D' = D*100
    div a5, a5, a6                          # D = D/d
    div a4, a4, a6                          # D' = D'/d
    remu a4, a4, s10                        # gets D's last 2 digits
    srli a3, s10, 1                         # Comparation const
    blt a4, a3, else_positive_precision_div # if()
        addi a5, a5, 1
    else_positive_precision_div:
    jalr zero, ra, 0


mod:
    bne a5, a6, mod_not_equal       # if(A == B)
        addi a5, zero, 0
        beq zero, zero, mod_end
    mod_not_equal:

    blt a5, zero, negative_mod      # if(A >= 0)
        remu a5, a5, a6
        beq zero, zero, mod_end
    
    negative_mod:                   # if(A < 0)
        # calculate N
            addi a3, zero, 1            # N = 1
            mul a4, a3, a6              # NB
            
            mod_N:
            blt a4, a5, mod_end_N
                addi a3, a3, -1         # N--
                mul a4, a3, a6          # NB
                beq zero, zero, mod_N
        mod_end_N:
        sub a5, a5, a4                  # %

    mod_end:
    jalr zero, ra, 0


floor:
    bne a5, a6, floor_not_equal       # if(A == B)
        addi a5, zero, 1
        beq zero, zero, floor_end
    floor_not_equal:

    blt a5, zero, negative_floor      # if(A >= 0)
        div a5, a5, a6
        beq zero, zero, floor_end
    
    negative_floor:                   # if(A < 0)

        add a3, zero, a5            # copy
        div a5, a5, a6              # partial result

        mul a3, a3, s9              # make pos
        mul a3, a3, s10             # D' *= 100        
        div a3, a3, a6              # D' = D' / d

        beq a3, zero, floor_end
            addi a5, a5, -1         # 

    floor_end:
    jalr zero, ra, 0


clean_img_1:
# for y
	addi s2, zero, 0
	for_y_clean:
	# for x
	addi s1, zero, 0
	for_x_clean:
		# get unidimensional current coords
		# X + MY
		mul a3, t0, s2
		add a3, a3, s1
		# get addr
		add a3, a3, a1# img 1
		# Move pix to new pic
		sb zero, 0(a3)
                    
		addi s1, s1, 1 # x += 1
		blt s1, t0, for_x_clean
            
	addi s2, s2, 1 # y += 1
	blt s2, t1, for_y_clean

	jalr zero, ra, 0


end:

add a3, zero, a0	# copies img 0 addr
add a4, zero, a1	# copies img 1 addr

nop


# Syscalls

# Open
	# Opens a file from a path Only supported flags (a1) are read-only (0), write-only (1) and write-append (9).
	# write-only flag creates file if it does not exist, so it is technically write-create.
	# write-append will start writing at end of existing file.la a0, input
la a0, output	# path
li a1, 1	# write flag
li a7, 1024	# open call
ecall

# Write
			# a0 = the file descriptor
add a1, zero, a4	# a1 = the buffer addres = a4 = img 1
mul a2, t0, t1		# a2 = the length to write = m x n
li a7, 64
ecall

# Close
li a7, 57	# close call
ecall












# Open
	# Opens a file from a path Only supported flags (a1) are read-only (0), write-only (1) and write-append (9).
	# write-only flag creates file if it does not exist, so it is technically write-create.
	# write-append will start writing at end of existing file.la a0, input
la a0, output_0	# path
li a1, 1	# write flag
li a7, 1024	# open call
ecall

# Write
			# a0 = the file descriptor
add a1, zero, a3	# a1 = the buffer addres = a4 = img 1
mul a2, t0, t1		# a2 = the length to write = m x n
li a7, 64
ecall

# Close
li a7, 57	# close call
ecall


# Exit
	# Exits the program with a code
li a0, 666
li a7, 93
ecall
