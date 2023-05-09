module register_file_tb;

    // Parameters for the register file module
    localparam D = 5;
    localparam W = 32;
    
    // Declare signals for the register file module
    logic clk, write_enable;
    logic [D-1:0] address1, address2, address3;
    logic [W-1:0] write_data, read_data1, read_data2;
    
    // Instantiate the register file module
    register_file #(.D(D), .W(W)) dut (
        .clk(clk),
        .write_enable(write_enable),
        .address1(address1),
        .address2(address2),
        .address3(address3),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Stimulus process to write to the register file and read from it
    initial begin
        
		clk = 0;
        // Write data to register at address3
        write_data = 32'hAAAA5555;
        write_enable = 1;
        address3 = 5'b00000;
        #10;
        
        // Read data from register at address1 and address2
        address1 = 5'b00001;
        address2 = 5'b00010;
        #10;
        
        // Write data to register at address3
        write_data = 32'h12345678;
        write_enable = 1;
        address3 = 5'b00100;
        #10;
        
        // Read data from register at address1 and address2
        address1 = 5'b00100;
        address2 = 5'b00000;
        #10;
        
        // Write data to register at address3
        write_data = 32'hABCD1234;
        write_enable = 1;
        address3 = 5'b01111;
        #10;
        
        // Read data from register at address1 and address2
        address1 = 5'b01000;
        address2 = 5'b01111;
        #10;
        
        // Stop the simulation
        #10;
    end

    // Create a clock signal with 50% duty cycle
    always #5 clk = ~clk;

endmodule