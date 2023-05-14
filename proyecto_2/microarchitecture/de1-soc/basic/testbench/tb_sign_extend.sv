module tb_sign_extend;

  // Define parameters
  parameter N = 8;
  parameter M = 16;

  // Declare signals
  logic [N-1:0] a;
  logic [M-1:0] o;

  // Instantiate the sign extender module
  sign_extend #(N, M) dut (
    .a(a),
    .o(o)
  );

  // Stimulus generation
  initial begin
    $monitor("a = %b, o = %b", a, o);

    // Test case 1: Positive number
    a = 8'h7F;
    #10;

    // Test case 2: Negative number
    a = 8'hFF;
    #10;

    // Test case 3: Zero
    a = 8'h00;
    #10;

    // Test case 4: Random value
    a = $random;
    #10;

  end

endmodule
