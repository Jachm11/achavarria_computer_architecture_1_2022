module pixel_printer(
	input  logic vga_clk,
	input  logic rst,
	input  logic video_on,
	input  logic [9:0] pixel_x,
	input  logic [9:0] pixel_y,
	input  logic [7:0] color,
	output logic [7:0] red,
	output logic [7:0] green,
	output logic [7:0] blue,
	output logic [13:0] address // 0x0000 to 0x2710
);

	//Frame constants
	localparam X_START = 170;
	localparam Y_START = 90;
	localparam OFFSET = 300;

	// RGB constants
	localparam BLACK = 8'h00;

	//Logic
	logic on_frame;

	assign on_frame = (pixel_x >= X_START && pixel_y >= Y_START &&
							 pixel_x < X_START+OFFSET && pixel_y < Y_START+OFFSET);
												 
	always @(posedge vga_clk or negedge rst)  begin
		if (!rst) begin
			address <= 14'd3;
		end
		else begin
			if (on_frame) begin
				address <= address + 14'd1;
				if (address >= 10002) begin
					address <= 14'd3;
				end
			end
		end
	end

	always @(posedge vga_clk) begin
		if(~video_on) begin
			red   <= BLACK;
			green <= BLACK;
			blue  <= BLACK;
		end
		else begin
			if (on_frame) begin
				red   <= color;
				green <= color;
				blue  <= color;
			end
			else begin
				red   <= BLACK;
				green <= BLACK;
				blue  <= BLACK;
			end
		end
	end

endmodule