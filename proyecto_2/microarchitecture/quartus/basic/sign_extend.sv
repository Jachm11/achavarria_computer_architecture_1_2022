module sign_extend #(parameter N = 12, M = 32)
(
  input logic [N-1:0] a,
  output logic [M-1:0] o
);

  always_comb begin
    if (a[N-1]) begin         // if MSB of input is 1, extend with 1's
      o = { {M-N{1'b1}}, a };
	 end
    else begin                // if MSB of input is 0, extend with 0's
      o = { {M-N{1'b0}}, a };
	 end
  end

endmodule