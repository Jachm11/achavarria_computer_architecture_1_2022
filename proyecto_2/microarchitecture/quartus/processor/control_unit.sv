module control_unit (
	input  logic[1:0] inst_type,
	input  logic[1:0] dir_mode,
    input  logic[2:0] opcode,
    output logic[1:0] result_source,
    output logic alu_source,
    output logic mem_write,
    output logic reg_write,
    output logic jump,
    output logic branch,
    output logic is_rd,
    output logic imm_src,
    output logic[2:0] alu_control
);

    localparam AA0 = 7'b0000000; // ADD
	localparam AA1 = 7'b0010000; // SUB
	localparam AA2 = 7'b0100000; // MUL
	localparam AA3 = 7'b0110000; // DIV
	localparam AA4 = 7'b1000000; // REMU
	localparam BA0 = 7'b0000100; // ADDI
	localparam BA1 = 7'b0010100; // SLL
    localparam BA2 = 7'b0100100; // SLR
    localparam BB0 = 7'b0000101; // SB
    localparam BB1 = 7'b0010101; // LBU
    localparam BB2 = 7'b0100101; // LHU
    localparam BB3 = 7'b0110101; // LH
    localparam BC0 = 7'b0000110; // JALR
    localparam BC1 = 7'b0010110; // BEQ
    localparam BC2 = 7'b0100110; // BNE
    localparam BC3 = 7'b0110110; // BLE
    localparam BC4 = 7'b1000110; // BLT
    localparam CA0 = 7'b0001000; // LUI
    localparam CC0 = 7'b0001010; // JAL

    logic[11:0] control_signals;

    // result_source 00 -> ALU
    // result_source 01 -> MEM
    // result_source 10 -> PC+4

    // alu_source 0 -> REG
    // alu_source 1 -> IMM 

    always_comb begin

        case ({opcode,dir_mode,inst_type})
// result_source, result_source, alu_source, mem_write, reg_write, jump, branch, alu_control, alu_control, alu_control

            AA0: control_signals =  12'b000010010000;
		    AA1: control_signals =  12'b000010010001;
            AA2: control_signals =  12'b000010010010;
            AA3: control_signals =  12'b000010010011;
            AA4: control_signals =  12'b000010010100;
            BA0: control_signals =  12'b001010010000;
            BA1: control_signals =  12'b001010010101;		
            BA2: control_signals =  12'b001010010110;
            BB0: control_signals =  12'b011100000000;
            BB1: control_signals =  12'b011010010000;
            BB2: control_signals =  12'b011010010000;
            BB3: control_signals =  12'b011010010000;
            BC0: control_signals =  12'b101011010000;
            BC1: control_signals =  12'b000000100000;
            BC2: control_signals =  12'b000000100000;
            BC3: control_signals =  12'b000000100000;
            BC4: control_signals =  12'b000000100000;
            CA0: control_signals =  12'b001010011101;
            CC0: control_signals =  12'b001011011000;
            default: control_signals =  12'b0000000000;
        endcase

    end

    assign {result_source, alu_source, mem_write, reg_write, jump, branch, is_rd, imm_src, alu_control} = control_signals;
	
endmodule