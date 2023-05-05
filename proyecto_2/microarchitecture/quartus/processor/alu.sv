module alu #(parameter N=32) (
	input  logic[3:0] operation,
	input  logic[N-1:0] a,
	input  logic[N-1:0] b,
	output logic[N-1:0] out
);

	localparam OP0 = 4'b0000; //SUM
	localparam OP1 = 4'b0001; //SUB
	localparam OP2 = 4'b0010; //XOR
	localparam OP3 = 4'b0011; //OR
	localparam OP4 = 4'b0100; //AND
	localparam OP5 = 4'b0101; //SLL
	localparam OP6 = 4'b0110; //SRL
	localparam OP7 = 4'b0111; //SRA
	localparam OP8 = 4'b1000; //SLT

	always_comb begin
		case(operation)
			OP0: out = a + b;
			OP1: out = a - b;
			OP2: out = a ^ b;
			OP3: out = a | b;
			OP4: out = a & b;
			OP5: out = a << b;
			OP6: out = a >> b;
			OP7: out = a >>> b;
			OP8: out = a < b ? 1 : 0;
			default: out = 0;
		endcase
	end
	
endmodule