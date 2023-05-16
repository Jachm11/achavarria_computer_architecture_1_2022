//N channels of M bits per channel
module multiplexer #(parameter N=5, M=4)
(
	input logic [bit_lenght()-1:0] select,
	input logic [N-1:0][M-1:0] channels,
	output logic [M-1:0] out
);
	
	assign out = channels[select];
	
	// Function to get the roundup of log2 of N (bits to represent channels quantity)
	function int bit_lenght();
		if(0<N && N<=2) begin
			return 1;
		end
		if(2<N && N<=4) begin
			return 2;
		end
		if(4<N && N<=8) begin
			return 3;
		end
		if(8<N && N<=16) begin
			return 4;
		end
		if(16<N && N<=32) begin
			return 5;
		end
		if(32<N && N<=64) begin
			return 6;
		end
		if(64<N && N<=128) begin
			return 7;
		end
	endfunction

endmodule