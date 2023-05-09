module tb_pipeline_register;

  // Parameters for the pipeline module
  localparam N = 8;
  localparam M = 8;
  
  // Declare signals for the testbench
  logic [N-1:0] data_in;
  logic [M-1:0] data_out;
  logic clk, reset, enable;
  
  // Instantiate the pipeline module
  pipeline_register #(N, M) dut(
    .clk(clk),
    .reset(reset),
    .in(data_in),
	 .enable(enable),
    .out(data_out)
  );
  
  // Generate a clock signal with a period of 10 time units
  always #5 clk = ~clk;

  // Drive random data into the input of the DUT, and assert the output
  initial begin
  
	 clk = 0;
	 
	 enable = 1;
    // Reset the DUT and wait for 10 clock cycles
    reset = 0;
    #10;
    reset = 1;
	 
	 assert (data_out == 0) else $error("Error: Output was not reset to 0 after reset");
    
    // Drive random data into the input of the DUT
    repeat (20) begin
      data_in <= $random;
      #20;
      assert (data_out == data_in) else $error("Error: Output did not match input");
    end
  end
  
endmodule