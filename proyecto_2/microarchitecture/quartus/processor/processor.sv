module processor(
	input logic clk,
	input logic reset
);

	//---------------- FETCH---------------------------------
	logic PCSrcE;
	logic[8:0] PCTargetE;
	
	logic[8:0] PCF_prime;
	logic[8:0] PCF;
	logic[8:0] PCPlus4F;
	always_comb begin : pc_plus_4
		PCPlus4F <= PCF + 4;
	end

	always_comb begin : pc_select
		if (!PCSrcE) begin
			PCF_prime <= PCPlus4F;
		end
		else begin
			PCF_prime <= PCTargetE;
		end
	end

	pipeline_register #(9, 9) pc(
		.clk(clk),
		.reset(reset),
		.in(PCF_prime),
		.enable(1),
		.out(PCF)
	);

	logic[31:0] instrF;
	instruction_memory  #(9, 32) instruction_memory(
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
		.reset(reset),
		.in({PCF,PCPlus4F,instrF}),
		.enable(1),
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
	logic resultW;
	logic rdW;
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

	logic[128:0] DE_output;
	logic[31:0] RD1E;
	logic[31:0] RD2E;
	logic[8:0] PCE;
	logic[31:0] immExtE;
	logic[8:0] PCPlus4E;
	logic[4:0] rdE;

	logic[1:0] resultSrcE;
	logic ALUSrcE;
	logic memWriteE;
	logic regWriteE;
	logic jumpE;
	logic branchE;
	logic[2:0] aluControlE;

	pipeline_register #(129, 129) DE_pipe(
		.clk(clk),
		.reset(reset),
		.in({rdD,RD1D,RD2D,immExtD,PCD,PCPlus4D,resultSrcD,ALUSrcD,memWriteD,regWriteD,jumpD,branchD,aluControlD}),
		.enable(1),
		.out(DE_output)
	);

	assign {rdE,RD1E,RD2E,immExtE,PCE,PCPlus4E,resultSrcE,ALUSrcE,memWriteE,regWriteE,jumpE,branchE,aluControlE} = DE_output;


	//---------------------EXECUTE-------------------------------
	
	

endmodule