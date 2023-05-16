module controller(
	input  logic clk_50Mhz,
	input  logic rst,
	output logic h_sync,
	output logic v_sync,
	output logic vga_clk,
	output logic [9:0] pixel_x,
	output logic [9:0] pixel_y,
	output logic video_on
);

// Horizontal parameters (measured in clock cycles / pixels)
localparam H_SCAN = 800;
localparam H_ACTIVE_REGION_START = 0;
localparam H_ACTIVE_REGION_END   = 640;
localparam H_SYNC_PULSE_START    = 656;
localparam H_SYNC_PULSE_END      = 752;

// Vertical parameters (measured in horizontal lines)
localparam V_SCAN = 525;
localparam V_ACTIVE_REGION_START = 0;
localparam V_ACTIVE_REGION_END   = 480;
localparam V_SYNC_PULSE_START    = 490;
localparam V_SYNC_PULSE_END      = 492;

// Parameters for readability
localparam LOW  = 1'b_0;
localparam HIGH = 1'b_1;

// Clock division
logic clk_25Mhz;
clock_divider clk_divider(clk_50Mhz,clk_25Mhz);

// Control variables
logic enable_v_counter = 0;
logic [9:0] h_counter = 0; 
logic [9:0] v_counter = 0;

always @(posedge clk_25Mhz or posedge rst) begin
	
	// Reset
	if (rst) begin
		h_counter <= 0; 
		v_counter <= 0;
	end

	else begin

		// Horizontal sync
		if (h_counter < H_SCAN) begin
			h_counter <= h_counter + 1;
			enable_v_counter <= LOW;
		end

		else begin
			h_counter <= 0;
			enable_v_counter <= HIGH;
		end

		// Vertical sync
		if (enable_v_counter == HIGH) begin
			if(v_counter < V_SCAN) begin
				v_counter <= v_counter + 1;
			end
			else begin
				v_counter <= 0;
			end
		end
	end
end

assign vga_clk = clk_25Mhz;

assign h_sync = (h_counter >= H_SYNC_PULSE_START && h_counter < H_SYNC_PULSE_END) ? HIGH:LOW;
assign v_sync = (v_counter >= V_SYNC_PULSE_START && v_counter < V_SYNC_PULSE_END) ? HIGH:LOW;

assign video_on = (h_counter >= H_ACTIVE_REGION_START && h_counter < H_ACTIVE_REGION_END &&
						 v_counter >= V_ACTIVE_REGION_START && v_counter < V_ACTIVE_REGION_END);
						 
assign pixel_x = h_counter;
assign pixel_y = v_counter;
						 
endmodule