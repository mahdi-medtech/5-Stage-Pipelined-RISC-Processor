module hazard_detection(
    input [4:0] ID_EX_rd,
    input ID_EX_MemRead,

    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,

    output reg PCWrite,
    output reg IF_ID_Write,
    output reg ID_EX_Flush
);

always @(*) begin

    // Default: No hazard
    PCWrite = 1'b1;
    IF_ID_Write = 1'b1;
    ID_EX_Flush = 1'b0;

    // Detect load-use hazard
    if (ID_EX_MemRead &&
        (ID_EX_rd != 5'b00000) &&
        ((ID_EX_rd == IF_ID_rs1) ||
         (ID_EX_rd == IF_ID_rs2))) begin

        PCWrite = 1'b0;
        IF_ID_Write = 1'b0;
        ID_EX_Flush = 1'b1;

    end

end

endmodule