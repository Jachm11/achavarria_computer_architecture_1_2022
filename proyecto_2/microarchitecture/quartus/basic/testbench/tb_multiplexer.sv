module tb_multiplexer;

  // Parameters
  localparam N = 5;
  localparam M = 4;

  // Inputs
  logic [2:0] select;
  logic [N-1:0][M-1:0] channels;

  // Outputs
  logic [M-1:0] out;

  // Instantiate the multiplexer module
  multiplexer #(.N(N), .M(M)) dut (
    .select(select),
    .channels(channels),
    .out(out)
  );

  // Initialize inputs
  initial begin
    select = 0;
    channels = '{
      4'b1111, 
      4'b1110, 
      4'b1101, 
      4'b1100,
		4'b0001
    };

    // Test the multiplexer
    // Select channel 0
    select <= 0;
    #5;
    assert(out === channels[0]);

    // Select channel 3
    select <= 3;
    #5;
    assert(out === channels[3]);

    // Select channel 4
    select <= 4;
    #5;
    assert(out === channels[4]);

  end

endmodule