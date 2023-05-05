module tb_instruction_memory();

	// Parameters for the register file module
   localparam D = 5;
   localparam W = 32;
	
	logic [5:0]  address;
	logic [31:0] read;

	instruction_memory  #(.D(D), .W(W)) dut(
		.address1(address),
		.read(read)
	);

	initial begin
		address = 6'h000000; #5;
		address = 6'h000001; #5;
		address = 6'h000010; #5;
		address = 6'h000110; #5;
		$finish;
	end

endmodule