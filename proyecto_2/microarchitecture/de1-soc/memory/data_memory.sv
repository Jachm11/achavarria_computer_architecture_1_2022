// Data memory module with configurable depth and word width
// D = Depth (quantity of memory spaces as in 2^D)
// W = Word width (bits per address)
module data_memory #(parameter D=6, W=32, mem_file="/home/jachm/Documents/Repos/achavarria_computer_architecture_1_2022/proyecto_2/microarchitecture/de1-soc/memory/even_ram.mem")(
	input logic clk,
	input logic clk_2,
	input logic write_enable,
	input logic write_enable_2,
	input logic [D-1:0] address,
	input logic [D-1:0] address_2,
	input logic [W-1:0] data_in,
	output logic [W-1:0] data_out,
	output logic [W-1:0] data_out_2
);
	logic [W-1:0] mem [(2**D)-1:0];
	
   initial begin
       $readmemh(mem_file, mem);
   end
	
	always_ff @(negedge clk) begin
		if(write_enable) begin
			mem[address] <= data_in;
		end
		else begin
			data_out <= mem[address];
		end
	end
		
	always_ff @(negedge clk_2) begin
		if(write_enable_2) begin
			mem[address_2] <= data_in;
		end
		else begin
			data_out_2 <= mem[address_2];
		end
	end
	
endmodule