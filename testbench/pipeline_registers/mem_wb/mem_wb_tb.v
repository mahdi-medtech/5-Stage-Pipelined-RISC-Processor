`timescale 1ns/1ps

module mem_wb_tb;

reg clk, reset, enable, flush;

reg [31:0] read_data_in, alu_result_in;
reg [4:0] rd_in;

reg RegWrite_in, MemToReg_in;

wire [31:0] read_data_out, alu_result_out;
wire [4:0] rd_out;

wire RegWrite_out, MemToReg_out;

integer pass_count = 0;
integer fail_count = 0;

mem_wb uut(.*);

always #5 clk = ~clk;

initial begin

    $dumpfile("simulation/waveforms/mem_wb.vcd");
    $dumpvars(0, mem_wb_tb);

    clk = 0;
    reset = 1;
    enable = 1;
    flush = 0;

    read_data_in = 200;
    alu_result_in = 100;
    rd_in = 6;
    RegWrite_in = 1;
    MemToReg_in = 1;

    @(posedge clk); #1;

    if (read_data_out == 0 && RegWrite_out == 0) begin
        $display("TEST 1 PASS: RESET");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 1 FAIL");
        fail_count = fail_count + 1;
    end

    reset = 0;

    @(posedge clk); #1;

    if (read_data_out == 200 &&
        alu_result_out == 100 &&
        rd_out == 6 &&
        RegWrite_out == 1 &&
        MemToReg_out == 1) begin

        $display("TEST 2 PASS: DATA CAPTURE");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 2 FAIL");
        fail_count = fail_count + 1;
    end

    enable = 0;
    read_data_in = 500;

    @(posedge clk); #1;

    if (read_data_out == 200) begin
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

    if (read_data_out == 0 && RegWrite_out == 0) begin
        $display("TEST 4 PASS: FLUSH");
        pass_count = pass_count + 1;
    end
    else begin
        $display("TEST 4 FAIL");
        fail_count = fail_count + 1;
    end

    $display("MEM/WB PASSED: %0d FAILED: %0d",
             pass_count, fail_count);

    $finish;

end

endmodule