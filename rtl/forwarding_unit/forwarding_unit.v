module forwarding_unit(
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,

    input [4:0] EX_MEM_rd,
    input EX_MEM_RegWrite,

    input [4:0] MEM_WB_rd,
    input MEM_WB_RegWrite,

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

always @(*) begin

    // Default: Use register file data
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    // Forwarding for ALU operand A
    if (EX_MEM_RegWrite &&
        (EX_MEM_rd != 0) &&
        (EX_MEM_rd == ID_EX_rs1)) begin

        ForwardA = 2'b10;

    end

    else if (MEM_WB_RegWrite &&
             (MEM_WB_rd != 0) &&
             (MEM_WB_rd == ID_EX_rs1)) begin

        ForwardA = 2'b01;

    end

    // Forwarding for ALU operand B
    if (EX_MEM_RegWrite &&
        (EX_MEM_rd != 0) &&
        (EX_MEM_rd == ID_EX_rs2)) begin

        ForwardB = 2'b10;

    end

    else if (MEM_WB_RegWrite &&
             (MEM_WB_rd != 0) &&
             (MEM_WB_rd == ID_EX_rs2)) begin

        ForwardB = 2'b01;

    end

end

endmodule