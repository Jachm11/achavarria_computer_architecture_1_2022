// Register file module with configurable depth and word width
// D = Depth (quantity of registers as in 2^D)
// W = Word width (bits per register)
module register_file #(parameter D=5, W=32)(
    input logic clk,                // Clock input
	input logic rst,                // Reset
    input logic [D-1:0] address1,   // Address input 1
    input logic [D-1:0] address2,   // Address input 2
    input logic [D-1:0] address3,   // Address input 3
    input logic [W-1:0] write_data, // Write data input
    input logic write_enable,       // Write enable input
    output logic [W-1:0] read_data1,// Read data output 1
    output logic [W-1:0] read_data2 // Read data output 2
);

    logic [W-1:0] register_file [(2**D)-1:0]; // Register file with 2^D registers of width W bits
	 integer i;
	 
    initial begin
        for (i = 0; i < (2**D); i = i + 1) begin
            register_file[i] <= 0;
        end
    end

    always_ff @(posedge clk) begin
		  if(write_enable) begin
             register_file[address3] <= write_data;
        end
    end
	 
    assign read_data1 = register_file[address1];
    assign read_data2 = register_file[address2];

endmodule