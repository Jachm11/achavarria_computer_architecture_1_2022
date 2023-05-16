module tb_alu_sub;

    // Parameters
    localparam N = 8;

    // Inputs
    logic signed [3:0] operation;
    logic signed [N-1:0] a;
    logic signed [N-1:0] b;

    // Outputs
    logic signed [N-1:0] out;

    // Instantiate the ALU
    alu #(N) dut (
        .operation(operation),
        .a(a),
        .b(b),
        .out(out)
    );

    // Clock generation
    logic clk = 0;
    always #5 clk = ~clk;

    initial begin

		  // Testcase 1
        operation = 4'b0001; //SUB
        a = 8'h03;
        b = 8'h01;
        #10; // Wait for 10 time units
        if (out !== 8'h02) begin
            $error("Testcase 1 failed: Expected out=%0d, but got out=%0d", 32'h02, out);
        end 
		  else begin
            $display("Testcase 1 passed");
        end
		  
		  // Testcase 2
        operation = 4'b0001; //SUB
        a = 8'hFC;
        b = 8'h01;
        #10; // Wait for 10 time units
        if (out !== 8'hFB) begin
            $error("Testcase 2 failed: Expected out=%0d, but got out=%0d", 32'h02, out);
        end 
		  else begin
            $display("Testcase 2 passed");
        end
		  
		  // Testcase 3
        operation = 4'b0001; //SUB
        a = 8'hFF;
        b = 8'h01;
        #10; // Wait for 10 time units
        if (out !== 8'h02) begin
            $error("Testcase 3 failed: Expected out=%0d, but got out=%0d", 32'h02, out);
        end 
		  else begin
            $display("Testcase 3 passed");
        end
		  
		  // Testcase 4
        operation = 4'b0001; //SUB
        a = 8'h81;
        b = 8'h01;
        #10; // Wait for 10 time units
        if (out !== 8'h02) begin
            $error("Testcase 4 failed: Expected out=%0d, but got out=%0d", 32'h02, out);
        end 
		  else begin
            $display("Testcase 4 passed");
        end
		  
		  // Testcase 5
        operation = 4'b0001; //SUB
        a = 8'h03;
        b = 8'h81;
        #10; // Wait for 10 time units
        if (out !== 8'h02) begin
            $error("Testcase 5 failed: Expected out=%0d, but got out=%0d", 32'h02, out);
        end 
		  else begin
            $display("Testcase 5 passed");
        end
		  
    end
endmodule