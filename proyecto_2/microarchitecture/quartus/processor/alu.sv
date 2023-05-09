module alu #(parameter N=32) (
	input  logic[2:0] operation,
	input  logic[N-1:0] a,
	input  logic[N-1:0] b,
	output logic[N-1:0] out
);

	localparam OP0 = 3'b000; //SUM
	localparam OP1 = 3'b001; //SUB
	localparam OP2 = 3'b010; //MUL
	localparam OP3 = 3'b011; //DIV
	localparam OP4 = 3'b100; //MOD
	localparam OP5 = 3'b101; //SLL
	localparam OP6 = 3'b110; //SRL

	always_comb begin
		case(operation)
			OP0: out = a + b;
			OP1: out = a - b;
			OP2: out = a * b;
			OP3: out = a / b;
			OP4: out = a % b;
			OP5: out = a << b;
			OP6: out = a >> b;
			default: out = 0;
		endcase
	end
	
endmodule