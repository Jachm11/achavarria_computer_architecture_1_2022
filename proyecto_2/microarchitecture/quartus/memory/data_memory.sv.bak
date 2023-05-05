// Data memory module with configurable depth and word width
// D = Depth (quantity of memory spaces as in 2^D)
// W = Word width (bits per address)
module data_memory #(parameter D=6, W=32)(
	input clk,
	input write_enable,
	input [D-1:0] address,
	input [W-1:0] data_in,
	output [W-1:0] data_out
);
	logic [W-1:0] mem [(2**D)-1:0];
	
	always_ff @(posedge clk)
		if(write_enable) mem[address] <= data_in;
	
	assign data_out = mem[address];
	
endmodule