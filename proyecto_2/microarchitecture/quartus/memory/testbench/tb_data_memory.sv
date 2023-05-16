module tb_data_memory;

	// Parameters
	parameter D = 6;
	parameter W = 32;

	// Inputs
	logic clk;
	logic write_enable;
	logic [D-1:0] address;
	logic [W-1:0] data_in;

	// Outputs
	logic [W-1:0] data_out;

	// Instantiate the module to be tested
	data_memory #(.D(D),.W(W)) dut(
		.clk(clk),
		.write_enable(write_enable),
		.address(address),
		.data_in(data_in),
		.data_out(data_out)
	);

	// Clock generation
	always #5 clk = ~clk;

	// Test scenario
	initial begin

		// Initialize inputs
		clk = 0;
		write_enable = 0;
		address = 0;
		data_in = 0;

		// Write and read multiple data
		for (int i = 0; i < (1 << D); i++) begin // Write to all memory locations
			write_enable = 1;
			address = i;
			data_in = i * 10;
			#10 write_enable = 0;
			data_in = 0;
		end

		for (int i = 0; i < (1 << D); i++) begin // Read from all memory locations
			address = i;
			#10 $display("Data Out[%0d]: %h", i, data_out);
		end
		
	end
    
endmodule