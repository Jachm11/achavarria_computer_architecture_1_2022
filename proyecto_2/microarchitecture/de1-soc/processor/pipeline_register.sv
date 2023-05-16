module pipeline_register #(parameter N = 32, parameter M = 32) (
  input clk,
  input reset,
  input enable,
  input logic [N-1:0] in,
  output reg [M-1:0] out
);

  always_ff @(posedge clk, negedge reset) begin
    if (!reset) begin
      out <= '0;
    end
    else begin
      if (enable) begin
        out <= in;
      end
      else begin
        out <= out;
      end
    end
  end

endmodule