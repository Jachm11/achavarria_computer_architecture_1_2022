module hazard_unit(
    input logic[4:0] rs1D,
    input logic[4:0] rs2D,
    input logic[4:0] rs1E,
    input logic[4:0] rs2E,
    input logic[4:0] rdE,
    input logic PCSrcE,
    input logic resultSrcE,
    input logic[4:0] rdM,
    input logic regWriteM,
    input logic resultSrcM,
    input logic[4:0] rdW,
    input logic regWriteW,
    output logic stallF,
    output logic stallD,
    output logic flushD,
    output logic flushE,
    output logic[1:0] fowardAE,
    output logic[1:0] fowardBE
);

    logic lw_stall;

    always_comb begin : foward_hazards_rs1
        if ((rs1E == rdM) && regWriteM) begin
            fowardAE = 2'b10;    
        end
        else begin
            if ((rs1E == rdW) && regWriteW) begin
                fowardAE = 2'b01;    
            end
            else begin
                fowardAE = 2'b00;    
            end
        end
    end

    always_comb begin : foward_hazards_rs2
        if ((rs2E == rdM) && regWriteM) begin
            fowardBE <= 2'b10;    
        end
        else begin
            if ((rs2E == rdW) && regWriteW) begin
                fowardBE <= 2'b01;    
            end
            else begin
                fowardBE <= 2'b00;    
            end
        end
    end

    assign lw_stall = resultSrcE && (rs1D == rdE || rs2D == rdE);

    assign stallF = lw_stall;
    assign stallD = lw_stall;
    assign flushD = PCSrcE;
    assign flushE = resultSrcM  && (rs1D == rdM || rs2D == rdM);

endmodule