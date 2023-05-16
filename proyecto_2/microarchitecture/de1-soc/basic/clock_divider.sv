module clock_divider #(parameter N=2)(
	input  logic clk_in,
	output logic clock_out
);

logic[27:0]counter = 28'd0;

always @(posedge clk_in) 
	begin
		counter <= counter + 28'd1;
		if (counter >= (N-1)) counter <= 28'd0;
		clock_out <= (counter < N/2) ? 1'b1 : 1'b0;
	end
	
endmodule