// Instruction memory module with configurable depth and word width
// D = Depth (quantity of memory spaces as in 2^D)
// W = Word width (bits per address)
module instruction_memory #(parameter D=6, W=32)(
	input  logic [D-1:0] address,
	output logic [W-1:0] read
);

	logic [W-1:0] rom [(2**D)-1:0]; // ROM with 2^D memory spaces each of W bits

	initial
		$readmemh("/home/jachm/Documents/Repos/achavarria_computer_architecture_1_2022/proyecto_2/microarchitecture/de1-soc/memory/instructions.mem", rom);
	 
	assign read = rom[address];
	
endmodule