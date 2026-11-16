module ex_mem(
    input clk,
    input reset,
    input enable,
    input flush,

    input [31:0] pc_in,
    input [31:0] alu_result_in,
    input [31:0] write_data_in,

    input [4:0] rd_in,

    input zero_in,
    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input MemToReg_in,
    input Branch_in,

    output reg [31:0] pc_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,

    output reg [4:0] rd_out,

    output reg zero_out,
    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemToReg_out,
    output reg Branch_out
);

always @(posedge clk) begin

    if (reset || flush) begin

        pc_out <= 0;
        alu_result_out <= 0;
        write_data_out <= 0;
        rd_out <= 0;

        zero_out <= 0;
        RegWrite_out <= 0;
        MemRead_out <= 0;
        MemWrite_out <= 0;
        MemToReg_out <= 0;
        Branch_out <= 0;

    end

    else if (enable) begin

        pc_out <= pc_in;
        alu_result_out <= alu_result_in;
        write_data_out <= write_data_in;
        rd_out <= rd_in;

        zero_out <= zero_in;
        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemToReg_out <= MemToReg_in;
        Branch_out <= Branch_in;

    end

end

endmodule