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
	output logic [16:0] address
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
												 
	always @(posedge vga_clk or posedge rst)  begin
		if (rst) begin
			address <= 17'd324;
		end
		else begin
			if (on_frame) begin
				address <= address + 17'd1;
				if (address >= 90323) begin
					address <= 17'd324;
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