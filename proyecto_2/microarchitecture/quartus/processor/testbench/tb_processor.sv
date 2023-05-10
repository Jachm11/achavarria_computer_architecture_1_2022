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
		  #1 reset = 1;
        #1 reset = 0;
        #10 reset = 1;
        
        // Wait for a few clock cycles
		  clk = 0;
		  #1;
    end
endmodule
