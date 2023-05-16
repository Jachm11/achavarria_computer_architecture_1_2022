module comparison_unit #(parameter N=32)(
	input  logic[N-1:0] a,
	input  logic[N-1:0] b,
	output logic equal,
    output logic less_than,
    output logic greater_than
);

	always_comb begin
        equal = (a == b);
        less_than = (a < b);
        greater_than = (a > b);
	end
	
endmodule