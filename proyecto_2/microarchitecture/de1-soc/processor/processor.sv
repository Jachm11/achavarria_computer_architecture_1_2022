module processor(
	input logic clk,
	input logic vga_clk,
	input logic reset,
	input logic[17:0] address_vga,
	output logic[7:0] color
);
	//---------------- HAZARD SIGNALS---------------------------------
	logic stallF;
    logic stallD;
    logic flushD;
    logic flushE;
    logic[1:0] fowardAE;
    logic[1:0] fowardBE;
	 logic syncD;
	 logic syncE;
	 logic recall_stall_D;
	
	//---------------- FETCH---------------------------------
	logic PCSrcE;
	logic[8:0] PCTargetE;
	
	logic[8:0] PCF_prime;
	logic[8:0] PCF;
	logic[8:0] PCPlus4F;
	always_comb begin : pc_plus_4
		PCPlus4F <= PCF + 9'b000000001;
	end

	always_comb begin : pc_select
		if (!PCSrcE) begin
			PCF_prime <= PCPlus4F;
		end
		else begin
			PCF_prime <= PCTargetE;
		end
	end

	pc_register #(9, 9) pc(
		.clk(clk),
		.reset(reset),
		.in(PCF_prime),
		.enable(!stallF),
		.out(PCF)
	);

	logic[31:0] instrF;
	instruction_memory  #(10, 32) instruction_memory(
		.address(PCF),
		.read(instrF)
	);

	//-------------------------FD------------------------------

	logic[49:0] FD_output;
	logic[31:0] instrD;
	logic[8:0] PCD;
	logic[8:0] PCPlus4D;
	pipeline_register #(50, 50) FD_pipe(
		.clk(clk),
		.reset(!syncD),
		.in({PCF,PCPlus4F,instrF}),
		.enable(!stallD),
		.out(FD_output)
	);

	assign {PCD, PCPlus4D, instrD} = FD_output;

	//---------------------DECODE-------------------------------

	logic[1:0] resultSrcD;
	logic ALUSrcD;
	logic memWriteD;
	logic regWriteD;
	logic jumpD;
	logic branchD;
	logic is_rd;
	logic immSrcD;
	logic[2:0] aluControlD;
	control_unit control_unit (
        .inst_type(instrD[1:0]),
        .dir_mode(instrD[3:2]),
        .opcode(instrD[6:4]),
        .result_source(resultSrcD),
        .alu_source(ALUSrcD),
        .mem_write(memWriteD),
        .reg_write(regWriteD),
        .jump(jumpD),
        .branch(branchD),
		.is_rd(is_rd),
		.imm_src(immSrcD),
        .alu_control(aluControlD)
    );

	logic[4:0] rdD;
	assign rdD = instrD[11:7];

	logic[4:0] ry;
	always_comb begin : reg_select
		if (is_rd) begin
			ry <= instrD[21:17];
		end
		else begin
			ry <= instrD[11:7];
		end 
	end

	logic regWriteW;
	logic[31:0] resultW;
	logic[4:0] rdW;
	logic[31:0] RD1D;
	logic[31:0] RD2D;
	register_file #(5, 32) register_file (
		.clk(clk),
		.write_enable(regWriteW),
		.address1(instrD[16:12]),
		.address2(ry),
		.address3(rdW),
		.write_data(resultW),
		.read_data1(RD1D),
		.read_data2(RD2D)
	);

	logic[31:0] immExtD;
	logic[31:0] imm15Ext;
	logic[31:0] imm20Ext;
	sign_extend #(20, 32) extend_20 (
		.a(instrD[31:12]),
		.o(imm20Ext)
	);

	sign_extend #(15, 32) extend_15 (
		.a(instrD[31:17]),
		.o(imm15Ext)
  	);

	always_comb begin : imm_select
		if (immSrcD) begin
			immExtD <= imm20Ext;
		end
		else begin
			immExtD <= imm15Ext;
		end 
	end

	//-------------------------DE------------------------------

	logic[141:0] DE_output;
	logic[31:0] RD1E;
	logic[31:0] RD2E;
	logic[8:0] PCE;
	logic[31:0] immExtE;
	logic[8:0] PCPlus4E;
	logic[4:0] rdE;
	logic[4:0] rs1E;
	logic[4:0] rs2E;

	logic[1:0] resultSrcE;
	logic ALUSrcE;
	logic memWriteE;
	logic regWriteE;
	logic jumpE;
	logic branchE;
	logic[2:0] aluControlE;
	logic[2:0] opcodeE;

	pipeline_register #(142, 142) DE_pipe(
		.clk(clk),
		.reset(!syncE),
		.in({instrD[16:12],ry,instrD[6:4],rdD,RD1D,RD2D,immExtD,PCD,PCPlus4D,resultSrcD,ALUSrcD,memWriteD,regWriteD,jumpD,branchD,aluControlD}),
		.enable(1),
		.out(DE_output)
	);

	assign {rs1E,rs2E,opcodeE,rdE,RD1E,RD2E,immExtE,PCE,PCPlus4E,resultSrcE,ALUSrcE,memWriteE,regWriteE,jumpE,branchE,aluControlE} = DE_output;


	//---------------------EXECUTE-------------------------------
	
	logic[31:0] RD1E_foward;
	logic[31:0] ALUResultM;
	always_comb begin : fowarding_RD1
		if (fowardAE == 0) begin
			RD1E_foward <= RD1E;
		end
		else begin
			if (fowardAE == 1) begin
				RD1E_foward <= resultW; 
			end
			else begin
				RD1E_foward <= ALUResultM;
			end
		end
	end
	
	logic[31:0] RD2E_foward;
	always_comb begin : fowarding_RD2
		if (fowardBE == 0) begin
			RD2E_foward <= RD2E;
		end
		else begin
			if (fowardBE == 1) begin
				RD2E_foward <= resultW; 
			end
			else begin
				RD2E_foward <= ALUResultM;
			end
		end
	end

	logic[31:0] srcAE;
	always_comb begin: first_source
		if(opcodeE == 0 && aluControlE == 5) begin
			srcAE <= immExtE;
		end
		else begin
			srcAE <= RD1E_foward;
		end
	end
	
	logic[31:0] srcBE;
	always_comb begin : second_source
		if(opcodeE == 0 && aluControlE == 5) begin
			srcBE <= 12;
		end
		else begin
			if (!ALUSrcE) begin
				srcBE <= RD2E_foward;
			end
			else begin
				srcBE <= immExtE;
			end
		end
	end

	logic[31:0] ALUResultE_aux;
	alu #(32) ALU (
        .operation(aluControlE),
        .a(srcAE),
        .b(srcBE),
        .out(ALUResultE_aux)
    );

	logic equal;
	logic less_than;
	logic greater_than;
	comparison_unit #(32) comparison_unit (
        .a(srcAE),
        .b(srcBE),
        .equal(equal),
		.less_than(less_than),
		.greater_than(greater_than)
    );
	 
	logic[31:0] ALUResultE;
	always_comb begin : PC_target
		if (opcodeE == 0 && jumpE) begin
			PCTargetE <= ALUResultE_aux;
			ALUResultE <= PCPlus4E;
		end
		else begin
			if(jumpE) begin
				ALUResultE <= PCPlus4E;
			end
			else begin
				ALUResultE <= ALUResultE_aux;
			end
			PCTargetE <= PCE + immExtE;
		end
	end
	 
	logic branch_ok;
	always_comb begin : verify_branch
		if(!branchE) begin
			branch_ok <= 0;
		end
		else begin
			if (opcodeE == 3'b001) begin
				branch_ok <= (equal == 1'b1);
			end
			else begin
				if (opcodeE == 3'b010) begin
					branch_ok <= (equal == 1'b0);
				end
				else begin
					if(opcodeE == 3'b011) begin
						branch_ok <= ((equal == 1'b1) || (less_than == 1'b1));
					end
					else begin
						if(opcodeE == 3'b100) begin
							branch_ok <= (less_than == 1'b1);
						end
						else begin
							branch_ok <= 0;
						end
					end
				end
			end
		end
	end

	always_comb begin : pc_source
		PCSrcE <= jumpE || (branch_ok) && branchE;
	end

	logic[31:0] writeDataE;
	assign writeDataE = RD2E_foward;

	//-------------------------EM------------------------------

	logic regWriteM;
	logic[1:0] resultSrcM;
	logic memWriteM;

	logic[31:0] writeDataM;
	logic[4:0] rdM;
	logic[2:0] opcodeM;
	logic[8:0] PCPlus4M;
	logic[84:0] EM_output;
	pipeline_register #(85,85) EM_pipe(
		.clk(clk),
		.reset(reset),
		.in({opcodeE,regWriteE,resultSrcE,memWriteE,ALUResultE,writeDataE,rdE,PCPlus4E}),
		.enable(1),
		.out(EM_output)
	);

	assign {opcodeM,regWriteM,resultSrcM,memWriteM,ALUResultM,writeDataM,rdM,PCPlus4M} = EM_output;

	//---------------------MEMORY-------------------------------


	logic[31:0] address_even;
	logic[31:0] address_odd;
	logic mem_write_even;
	logic mem_write_odd;
	always_comb begin : write_select
		if(ALUResultM[0] == 0) begin
			mem_write_even <= memWriteM;
			mem_write_odd <= 0;
			address_even <= ALUResultM >> 1;
		end
		else begin
			mem_write_even <= 0;
			mem_write_odd <= memWriteM;
			if (memWriteM) begin
				address_even <= ALUResultM >> 1;
			end
			else begin
				if (opcodeE != 1) begin
					address_even <= (ALUResultM >> 1) + 1;
				end
				else begin
					address_even <= ALUResultM >> 1;
				end
			end
		end
		address_odd <= ALUResultM >> 1;
	end
	
	logic even_vga;
	logic odd_vga;
	always_comb begin
		if (address_vga[0] == 0) begin
			even_vga <= 1;
			odd_vga <= 0;
		end
		else begin
			even_vga <= 0;
			odd_vga <= 1;
		end
	end
	
	logic[7:0] RAM_out_even;
	logic[7:0] RAM_out_odd;
	logic[7:0] color_even;
	logic[7:0] color_odd;
	data_memory #(17,8,"/home/jachm/Documents/Repos/achavarria_computer_architecture_1_2022/proyecto_2/microarchitecture/de1-soc/memory/even_ram.mem") data_memory_even(
		.clk(clk),
		.clk_2(vga_clk),
		.write_enable(mem_write_even),
		.address(address_even),
		.address_2(address_vga >> 1),
		.data_in(writeDataM),
		.data_out(RAM_out_even),
		.data_out_2(color_even)
	);
	data_memory #(17,8,"/home/jachm/Documents/Repos/achavarria_computer_architecture_1_2022/proyecto_2/microarchitecture/de1-soc/memory/odd_ram.mem") data_memory_odd(
		.clk(clk),
		.clk_2(vga_clk),
		.write_enable(mem_write_odd),
		.address(address_odd),
		.address_2(address_vga >> 1),
		.data_in(writeDataM),
		.data_out(RAM_out_odd),
		.data_out_2(color_odd)
	);
	
	always_comb begin: select_color
		if (even_vga) begin
			color <= color_even;
		end
		else begin
			color <= color_odd;
		end
	end

	logic[15:0] RAM_out;
	always_comb begin : prepare_read_data
		if(ALUResultM[0] == 0) begin
			if (opcodeM == 1) begin
				RAM_out <= {8'b0,RAM_out_even};
			end
			else begin
				RAM_out <= {RAM_out_odd,RAM_out_even};
			end
		end
		else begin
			if (opcodeM == 1) begin
				RAM_out <= {8'b0,RAM_out_odd};
			end
			else begin
				RAM_out <= {RAM_out_even,RAM_out_odd};
			end
		end
	end
	
	logic[31:0] RAM_signed;
	sign_extend #(16, 32) extend_ram (
		.a(RAM_out),
		.o(RAM_signed)
  	);
	
	logic[31:0] readDataM;
	always_comb begin
		if(opcodeM == 1 || opcodeM == 2) begin
			readDataM <= {16'b0,RAM_out};
		end
		else begin
			readDataM <= RAM_signed;
		end
	end

	//-------------------------MW------------------------------

	logic[1:0] resultSrcW;
	logic[31:0] ALUResultW;

	logic[31:0] readDataW;
	logic[8:0] PCPlus4W;

	logic[80:0] MW_output;

	pipeline_register #(81,81) MW_pipe(
		.clk(clk),
		.reset(reset),
		.in({regWriteM,resultSrcM,ALUResultM,readDataM,rdM,PCPlus4M}),
		.enable(1),
		.out(MW_output)
	);

	assign {regWriteW,resultSrcW,ALUResultW,readDataW,rdW,PCPlus4W} = MW_output;

	//---------------------WRITEBACK-------------------------------

	multiplexer #(4,32) writeback (
		.select(resultSrcW),
		.channels({32'h0,PCPlus4W,readDataW,ALUResultW}),
		.out(resultW)
	);

	//----------------HAZARD UNIT---------------------------------

	hazard_unit hazard_unit (
        .rs1D(instrD[16:12]),
        .rs2D(ry),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .rdE(rdE),
        .PCSrcE(PCSrcE),
        .resultSrcE(resultSrcE),
        .rdM(rdM),
        .regWriteM(regWriteM),
        .resultSrcM(resultSrcM),
        .rdW(rdW),
        .regWriteW(regWriteW),
        .stallF(stallF),
        .stallD(stallD),
        .flushD(flushD),
        .flushE(flushE),
        .fowardAE(fowardAE),
        .fowardBE(fowardBE)
    );
	 
	 always_ff @(negedge clk) begin: recall_stall
		if (stallD) begin
			recall_stall_D <= 1;
		end
		else begin
			recall_stall_D <= 0;
		end
	 end
	 
	 always_ff @(negedge clk or posedge flushD) begin :sync_D
		if (flushD) begin
			syncD <= flushD;
		end
		if (!clk) begin
			syncD <= 0;
		end
	 end
	 
	 always_ff @(negedge clk or negedge stallD) begin :sync_E
		if (!stallD) begin
			syncE <= recall_stall_D;
		end
		if (!clk) begin
			syncE <= 0;
		end
	 end

endmodule