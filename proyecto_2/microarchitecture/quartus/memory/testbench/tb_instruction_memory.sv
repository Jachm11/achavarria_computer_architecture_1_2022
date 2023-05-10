module tb_instruction_memory();

	// Parameters for the register file module
   localparam D = 5;
   localparam W = 32;
	
	logic [5:0]  address;
	logic [31:0] read;

	instruction_memory  #(.D(D), .W(W)) dut(
		.address(address),
		.read(read)
	);

	initial begin
		address = 6'b000000; #5;
		address = 6'b000001; #5;
		address = 6'b000010; #5;
		address = 6'b000110; #5;
	end

endmodule