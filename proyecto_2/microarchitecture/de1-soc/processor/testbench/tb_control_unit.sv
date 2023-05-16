module tb_control_unit();

    logic[1:0] inst_type;
    logic[1:0] dir_mode;
    logic[2:0] opcode;
    logic[1:0] result_source;
    logic alu_source;
    logic mem_write;
    logic reg_write;
    logic jump;
    logic branch;
    logic[2:0] alu_control;
	 
	 function void assert_control_signals(logic[9:0] expected);
        if (result_source !== expected[9:8] ||
            alu_source !== expected[7] ||
            mem_write !== expected[6] ||
            reg_write !== expected[5] ||
            jump !== expected[4] ||
            branch !== expected[3] ||
            alu_control !== expected[2:0])
            $display("Control signals mismatch: Expected=%b, Actual=%b", expected, {result_source, alu_source, mem_write, reg_write, jump, branch, alu_control});
			else 
				$display("Test passed!");
    endfunction

    control_unit dut (
        .inst_type(inst_type),
        .dir_mode(dir_mode),
        .opcode(opcode),
        .result_source(result_source),
        .alu_source(alu_source),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .jump(jump),
        .branch(branch),
        .alu_control(alu_control)
    );

    initial begin
        #5;
        // Test case 1: ADD instruction
        inst_type = 2'b00;
        dir_mode = 2'b00;
        opcode = 3'b000; 
        #5;
        assert_control_signals(10'b0000100000);
		#5;

        // Test case 2: SLL instruction
        inst_type = 2'b00;
        dir_mode = 2'b01; 
        opcode = 3'b001; 
        #5;
        assert_control_signals(10'b0010100101);
		#5;

        // Test case 3: LBU instruction
        inst_type = 2'b01; 
        dir_mode = 2'b01;
        opcode = 3'b001;
        #5;
        assert_control_signals(10'b0110100000);
		#5;

        // Test case 4: JAL instruction
        inst_type = 2'b10;
        dir_mode = 2'b10;
        opcode = 3'b000;
        #5;
        assert_control_signals(10'b0010110000);
		#5;

        // Test case 5: SB instruction
        inst_type = 2'b01;
        dir_mode = 2'b01;
        opcode = 3'b000;
        #5;
        assert_control_signals(10'b0111000000);
		#5;

        // Test case 6: BNE instruction
        inst_type = 2'b10;
        dir_mode = 2'b01;
        opcode = 3'b010;
        #5;
        assert_control_signals(10'b0000001000);
		#5;

        // Test case 7: BLT instruction
        inst_type = 2'b10;
        dir_mode = 2'b01;
        opcode = 3'b100;
        #5;
        assert_control_signals(10'b0000001000);
		#5;

        // Test case 8: MUL instruction
        inst_type = 2'b00;
        dir_mode = 2'b00;
        opcode = 3'b010;
        #5;
        assert_control_signals(10'b0000100010);
		#5;

        // Test case 9: Invalid opcode
        inst_type = 2'b00;
        dir_mode = 2'b00;
        opcode = 3'b111;
        #5;
        assert_control_signals(10'b0000000000);
		#5;
		  
    end

endmodule