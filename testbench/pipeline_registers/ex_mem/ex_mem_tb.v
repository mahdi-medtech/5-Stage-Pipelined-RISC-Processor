`timescale 1ns/1ps

module ex_mem_tb;

reg clk, reset, enable, flush;

reg [31:0] pc_in, alu_result_in, write_data_in;
reg [4:0] rd_in;

reg zero_in, RegWrite_in;
reg MemRead_in, MemWrite_in;
reg MemToReg_in, Branch_in;

wire [31:0] pc_out, alu_result_out, write_data_out;
wire [4:0] rd_out;

wire zero_out, RegWrite_out;
wire MemRead_out, MemWrite_out;
wire MemToReg_out, Branch_out;

integer pass_count = 0;
integer fail_count = 0;

ex_mem uut(.*);

always #5 clk = ~clk;

initial begin

    $dumpfile("simulation/waveforms/ex_mem.vcd");
    $dumpvars(0, ex_mem_tb);

    clk = 0;
    reset = 1;
    enable = 1;
    flush = 0;

    pc_in = 4;
    alu_result_in = 100;
    write_data_in = 50;
    rd_in = 5;

    zero_in = 1;
    RegWrite_in = 1;
    MemRead_in = 1;
    MemWrite_in = 0;
    MemToReg_in = 1;
    Branch_in = 0;

    @(posedge clk); #1;

    if (alu_result_out == 0 && RegWrite_out == 0) begin
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
        alu_result_out == 100 &&
        write_data_out == 50 &&
        rd_out == 5 &&
        zero_out == 1 &&
        RegWrite_out == 1 &&
        MemRead_out == 1) begin

        $display("TEST 2 PASS: DATA CAPTURE");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 2 FAIL");
        fail_count = fail_count + 1;
    end

    enable = 0;
    alu_result_in = 200;

    @(posedge clk); #1;

    if (alu_result_out == 100) begin
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

    if (alu_result_out == 0 && RegWrite_out == 0) begin
        $display("TEST 4 PASS: FLUSH");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 4 FAIL");
        fail_count = fail_count + 1;
    end

    $display("EX/MEM PASSED: %0d FAILED: %0d",
             pass_count, fail_count);

    $finish;

end

endmodule