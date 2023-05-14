module processor_tb;
    // Inputs
    logic clk;
    logic reset;
    
    // Instantiate the processor module
    processor dut (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generator
    always #5 clk = ~clk;
    
    initial begin
        // Reset the processor
		  #5 reset = 1;
        #5 reset = 0;
        #5 reset = 1;
        #5
        // Wait for a few clock cycles
		  clk = 0;
    end
endmodule
