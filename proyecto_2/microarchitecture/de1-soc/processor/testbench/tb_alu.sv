module tb_alu;

    // Parameters
    localparam N = 32;

    // Inputs
    logic [3:0] operation;
    logic [N-1:0] a;
    logic [N-1:0] b;

    // Outputs
    logic [N-1:0] out;

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
        operation = 4'b0000; //SUM
        a = 32'h00000001;
        b = 32'h00000002;
        #10; // Wait for 10 time units
        if (out !== 32'h00000003) begin
            $error("Testcase 1 failed: Expected out=%0d, but got out=%0d", 32'h00000003, out);
        end 
		  else begin
            $display("Testcase 1 passed");
        end

		// Testcase 2
        operation = 4'b0001; //SUB
        a = 32'h00000003;
        b = 32'h00000001;
        #10; // Wait for 10 time units
        if (out !== 32'h00000002) begin
            $error("Testcase 2 failed: Expected out=%0d, but got out=%0d", 32'h00000002, out);
        end 
		  else begin
            $display("Testcase 2 passed");
        end

        // Testcase 3
        operation = 4'b0010; //XOR
        a = 32'h0000000F;
        b = 32'h000000AA;
        #10; // Wait for 10 time units
        if (out !== 32'h000000A5) begin
            $error("Testcase 3 failed: Expected out=%0h, but got out=%0h", 32'h000000A5, out);
        end 
		  else begin
            $display("Testcase 3 passed");
        end

        // Testcase 4
        operation = 4'b0111; //SRA
        a = 32'h80000000;
        b = 32'h00000001;
        #10; // Wait for 10 time units
        if (out !== 32'hC0000000) begin
            $error("Testcase 4 failed: Expected out=%0h, but got out=%0h", 32'hC0000000, out);
        end 
		  else begin
            $display("Testcase 4 passed");
        end

        // Testcase 5
        operation = 4'b1000; //SLT
        a = 32'h7FFFFFFF;
        b = 32'hFFFFFFFF;
        #10; // Wait for 10 time units
        if (out !== 1'b1) begin
            $error("Testcase 5 failed: Expected out=%0d, but got out=%0d", 1, out);
        end 
		  else begin
            $display("Testcase 5 passed");
        end

        // Testcase 6
        operation = 4'b0000; //SUM
        a = 32'h7FFFFFFF;
        b = 32'h00000001;
        #10; // Wait for 10 time units
        if (out !== 32'h80000000) begin
            $error("Testcase 6 failed: Expected out=%0h, but got out=%0h", 32'h80000000, out);
        end 
		  else begin
            $display("Testcase 6 passed");
        end

        // Testcase 7
        operation = 4'b0100; //AND
        a = 32'hFF00FF00;
        b = 32'h00FF00FF;
        #10; // Wait for 10 time units
        if (out !== 32'h00000000) begin
            $error("Testcase 7 failed: Expected out=%0h, but got out=%0h", 32'h00000000, out);
        end 
		  else begin
            $display("Testcase 7 passed");
        end

        // Testcase 8
        operation = 4'b0110; //SRL
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        #10; // Wait for 10 time units
        if (out !== 32'h7FFFFFFF) begin
            $error("Testcase 8 failed: Expected out=%0h, but got out=%0h", 32'h7FFFFFFF, out);
        end 
		  else begin
            $display("Testcase 8 passed");
        end

        // Testcase 9
        operation = 4'b1001; //Invalid operation
        a = 32'h12345678;
        b = 32'h87654321;
        #10; // Wait for 10 time units
        if (out !== 0) begin
            $error("Testcase 9 failed: Expected out=0, but got out=%0h", out);
        end 
		  else begin
            $display("Testcase 9 passed");
        end
    end
endmodule