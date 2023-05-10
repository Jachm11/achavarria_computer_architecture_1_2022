module pipeline_register #(parameter N = 32, parameter M = 32) (
  input clk,
  input reset,
  input enable,
  input logic [N-1:0] in,
  output logic [M-1:0] out
);

  logic [N-1:0] stage;

  always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
      stage <= '0;
    end 
    else begin
      if (enable) begin
        stage <= in;
      end
    end
  end

  always_ff @(negedge clk or negedge reset) begin
    if (!reset) begin
      out <= '0;
    end 
    else begin
      if (enable) begin
        out <= stage;
      end
    end
  end

endmodule