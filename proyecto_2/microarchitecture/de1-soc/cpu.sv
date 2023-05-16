module cpu(
   input  clk_50Mhz, 
	input  rst,
   input  init,
	output h_sync,
	output v_sync,
	output vga_clk,
	output [7:0] red,
	output [7:0] green,
	output [7:0] blue
);

	// VGA variables
	logic video_on;
	logic [7:0]  color;
	logic [9:0]  pixel_x;
	logic [9:0]  pixel_y;
	logic [17:0] address_vga;
	
	// CPU variable
	logic cpu_clk;

	clock_divider clk_divider(clk_50Mhz,clk);

	always_comb begin : switch
		if(init) begin
			cpu_clk <= clk;
		end
		else begin
			cpu_clk <= 0;
		end
	end

	processor pipeline_cpu (
      .clk(cpu_clk),
		.vga_clk(vga_clk),
      .reset(!rst),
		.address_vga(address_vga),
		.color(color)
    );

	controller vga_controller(
		.clk_50Mhz(clk_50Mhz),
		.rst(rst),
		.h_sync(h_sync),
		.v_sync(v_sync),
		.vga_clk(vga_clk),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.video_on(video_on)
	);

	pixel_printer grapher(
		.vga_clk(vga_clk),
		.rst(rst),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.color(color),
		.red(red),
		.green(green),
		.blue(blue),
		.address(address_vga)
	);

	
endmodule