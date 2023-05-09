module pipeline_register #(parameter N = 32, parameter M = 32) (
  input clk,
  input reset,
  input enable,
  input logic [N-1:0] in,
  output logic [M-1:0] out
);

  logic [N-1:0] stage_out;
  logic [M-1:0] enabled_out;

  always_ff @(posedge clk) begin
    if (!reset) begin
      stage_out <= '0;
      enabled_out <= '0;
    end 
    else begin
      stage_out <= in;
      if (enable) begin
        enabled_out <= stage_out;
      end
    end
  end

  always_ff @(negedge clk) begin
    if (!reset) begin
      out <= '0;
    end 
    else begin
      out <= enabled_out;
    end
  end

endmodule
