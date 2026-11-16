`timescale 1ns/1ps

module id_ex_tb;

reg clk, reset, enable, flush;

reg [31:0] pc_in, rs1_data_in;
reg [31:0] rs2_data_in, immediate_in;

reg [4:0] rs1_in, rs2_in, rd_in;
reg [2:0] funct3_in;
reg [6:0] funct7_in;

reg RegWrite_in, ALUSrc_in;
reg MemRead_in, MemWrite_in;
reg MemToReg_in, Branch_in;
reg [1:0] ALUOp_in;

wire [31:0] pc_out, rs1_data_out;
wire [31:0] rs2_data_out, immediate_out;

wire [4:0] rs1_out, rs2_out, rd_out;
wire [2:0] funct3_out;
wire [6:0] funct7_out;

wire RegWrite_out, ALUSrc_out;
wire MemRead_out, MemWrite_out;
wire MemToReg_out, Branch_out;
wire [1:0] ALUOp_out;

integer pass_count = 0;
integer fail_count = 0;

id_ex uut(.*);

always #5 clk = ~clk;

initial begin

    $dumpfile("simulation/waveforms/id_ex.vcd");
    $dumpvars(0, id_ex_tb);

    clk = 0;
    reset = 1;
    enable = 1;
    flush = 0;

    pc_in = 4;
    rs1_data_in = 10;
    rs2_data_in = 20;
    immediate_in = 15;

    rs1_in = 1;
    rs2_in = 2;
    rd_in = 3;

    funct3_in = 0;
    funct7_in = 0;

    RegWrite_in = 1;
    ALUSrc_in = 1;
    MemRead_in = 0;
    MemWrite_in = 0;
    MemToReg_in = 0;
    Branch_in = 0;
    ALUOp_in = 2;

    @(posedge clk); #1;

    if (pc_out == 0 && RegWrite_out == 0) begin
        $display("TEST 1 PASS: RESET");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 1 FAIL");
        fail_count = fail_count + 1;
    end

    reset = 0;

    @(posedge clk); #1;

    if (pc_out == 4 &&
        rs1_data_out == 10 &&
        rs2_data_out == 20 &&
        immediate_out == 15 &&
        rd_out == 3 &&
        RegWrite_out == 1 &&
        ALUOp_out == 2) begin

        $display("TEST 2 PASS: DATA CAPTURE");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 2 FAIL");
        fail_count = fail_count + 1;
    end

    enable = 0;
    pc_in = 100;

    @(posedge clk); #1;

    if (pc_out == 4) begin
        $display("TEST 3 PASS: STALL");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 3 FAIL");
        fail_count = fail_count + 1;
    end

    enable = 1;
    flush = 1;

    @(posedge clk); #1;

    if (pc_out == 0 && RegWrite_out == 0) begin
        $display("TEST 4 PASS: FLUSH");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 4 FAIL");
        fail_count = fail_count + 1;
    end

    $display("ID/EX PASSED: %0d FAILED: %0d",
             pass_count, fail_count);

    $finish;

end

endmodule