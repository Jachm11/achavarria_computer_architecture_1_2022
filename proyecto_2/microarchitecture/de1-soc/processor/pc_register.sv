module pc_register #(parameter N = 32, parameter M = 32) (
  input clk,
  input reset,
  input enable,
  input logic [N-1:0] in,
  output logic [M-1:0] out
);

  always_ff @(negedge clk or negedge reset) begin
    if (!reset) begin
      out <= -1;
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