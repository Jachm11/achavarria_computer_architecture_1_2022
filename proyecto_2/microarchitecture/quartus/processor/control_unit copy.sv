module control_unit (
	input  logic[1:0] inst_type,
	input  logic[1:0] dir_mode,
    input  logic[2:0] opcode,
    output logic result_source,
    output logic alu_source,
    output logic mem_write,
    output logic reg_write,
    output logic jump,
    output logic branch,
    output logic[2:0] alu_control
);

    always_comb begin
        if (inst_type == 2'b00) begin // Logic-Arithmetic instructions
            result_source <= 0; // ALU
            mem_write <= 0; 
            reg_write <= 1;
            jump <= 0;
            branch <= 0; 

            alu_source
            alu_control
        end
        else begin
            if (opcode == 3'b000 & dir_mode == 2'b01) begin // STORE
                result_source <= 1; // X
                mem_write <= 1; 
                reg_write <= 0;
                jump <= 0;
                branch <= 0; 
                alu_source <= 1; // Imm
            end
            else begin
                if (inst_type == 2'b01) begin // LOAD
                    result_source <= 1; // MEM
                    mem_write <= 0; 
                    reg_write <= 1;
                    jump <= 0;
                    branch <= 0; 
                    alu_source <= 1; // Imm
                end
				else begin
                    if(opcode == 3'b000) begin //JUMP
                        result_source <= 0; // ALU
                        mem_write <= 0; 
                        reg_write <= 1;
                        jump <= 1;
                        branch <= 0; 
                        alu_source <= 1; // Imm
                    end
                    else begin // BRANCH
                        result_source <= 0; // X
                        mem_write <= 0; 
                        reg_write <= 0;
                        jump <= 0;
                        branch <= 1; 
                        alu_source <= 0; // Imm
                    end	
                end	 
            end
        end
    end
	
endmodule