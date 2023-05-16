module cpu_tb;

    // Define inputs
    logic clk_50Mhz;
    logic rst;
    logic init;

    // Define outputs
    logic h_sync;
    logic v_sync;
    logic vga_clk;
    logic [7:0] red;
    logic [7:0] green;
    logic [7:0] blue;

    // Instantiate the DUT (Design Under Test)
    cpu dut (
        .clk_50Mhz(clk_50Mhz),
        .rst(rst),
        .init(init),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .vga_clk(vga_clk),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // Add clock generation
    always begin
        #5 clk_50Mhz = ~clk_50Mhz;
    end

    // Add initial values for inputs
    initial begin
        rst = 0;
		  #5
		  rst = 1;
		  #5
		  rst = 0;
		  clk_50Mhz = 0;
        init = 0;
        #1000; // Run the simulation for some time
		  init = 1;
    end

endmodule

