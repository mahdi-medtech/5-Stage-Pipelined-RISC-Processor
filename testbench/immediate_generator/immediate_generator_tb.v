`timescale 1ns/1ps

module immediate_generator_tb;

reg [31:0] instruction;
wire [31:0] immediate;

integer pass_count = 0;
integer fail_count = 0;

immediate_generator uut (
    .instruction(instruction),
    .immediate(immediate)
);

initial begin

    $dumpfile("simulation/waveforms/immediate_generator.vcd");
    $dumpvars(0, immediate_generator_tb);

    // Test 1: I-Type ADDI, immediate = 10
    instruction = 32'h00A00093;
    #10;
    if (immediate == 32'd10) begin
        $display("TEST 1 PASS: I-Type ADDI");
        pass_count = pass_count + 1;
    end else begin
        $display("TEST 1 FAIL: Expected 10, Got %0d", immediate);
        fail_count = fail_count + 1;
    end

    // Test 2: I-Type LW, immediate = -4
    instruction = 32'hFFC0A103;
    #10;
    if (immediate == -32'd4) begin
        $display("TEST 2 PASS: I-Type LW");
        pass_count = pass_count + 1;
    end else begin
        $display("TEST 2 FAIL: Expected -4, Got %0d", $signed(immediate));
        fail_count = fail_count + 1;
    end

    // Test 3: S-Type SW, immediate = 12
    instruction = 32'h0020A623;
    #10;
    if (immediate == 32'd12) begin
        $display("TEST 3 PASS: S-Type SW");
        pass_count = pass_count + 1;
    end else begin
        $display("TEST 3 FAIL: Expected 12, Got %0d", immediate);
        fail_count = fail_count + 1;
    end

    // Test 4: B-Type BEQ, immediate = 16
    instruction = 32'h00208863;
    #10;
    if (immediate == 32'd16) begin
        $display("TEST 4 PASS: B-Type BEQ");
        pass_count = pass_count + 1;
    end else begin
        $display("TEST 4 FAIL: Expected 16, Got %0d", immediate);
        fail_count = fail_count + 1;
    end

    $display("--------------------------------");
    $display("TOTAL PASSED: %0d", pass_count);
    $display("TOTAL FAILED: %0d", fail_count);
    $display("--------------------------------");

    $finish;

end

endmodule