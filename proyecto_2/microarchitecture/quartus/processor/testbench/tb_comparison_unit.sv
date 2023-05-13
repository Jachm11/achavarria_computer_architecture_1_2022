module tb_comparison_unit;
    // Testbench inputs
    logic signed[31:0] a;
    logic signed[31:0] b;
    
    // Testbench outputs
    logic equal;
    logic less_than;
    logic greater_than;
    
    // Instantiate the comparison_unit module
    comparison_unit #(32) dut (
        .a(a),
        .b(b),
        .equal(equal),
        .less_than(less_than),
        .greater_than(greater_than)
    );
    
    // Stimulus generation
    initial begin
        // Testcase 1: a = 10, b = 20
        a = 10;
        b = 20;
        #1;  // Wait for 1 time unit
        
        // Assertions for testcase 1
        assert(!equal) else $error("Testcase 1 failed: Expected equal to be 0");
        assert(less_than) else $error("Testcase 1 failed: Expected less_than to be 1");
        assert(!greater_than) else $error("Testcase 1 failed: Expected greater_than to be 0");
        
        // Testcase 2: a = 50, b = -30
        a = 50;
        b = -30;
        #1;  // Wait for 1 time unit
        
        // Assertions for testcase 2
        assert(!equal) else $error("Testcase 2 failed: Expected equal to be 0");
        assert(!less_than) else $error("Testcase 2 failed: Expected less_than to be 0");
        assert(greater_than) else $error("Testcase 2 failed: Expected greater_than to be 1");
        
        // Testcase 3: a = -10, b = -10
        a = -10;
        b = -10;
        #1;  // Wait for 1 time unit
        
        // Assertions for testcase 3
        assert(equal) else $error("Testcase 3 failed: Expected equal to be 1");
        assert(!less_than) else $error("Testcase 3 failed: Expected less_than to be 0");
        assert(!greater_than) else $error("Testcase 3 failed: Expected greater_than to be 0");
        
        // Add more testcases if needed
        
        $display("All testcases passed!");
    end
endmodule
