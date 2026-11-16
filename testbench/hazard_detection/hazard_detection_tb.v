`timescale 1ns/1ps

module hazard_detection_tb;

reg [4:0] ID_EX_rd;
reg ID_EX_MemRead;

reg [4:0] IF_ID_rs1;
reg [4:0] IF_ID_rs2;

wire PCWrite;
wire IF_ID_Write;
wire ID_EX_Flush;

integer pass_count = 0;
integer fail_count = 0;

hazard_detection uut(
    .ID_EX_rd(ID_EX_rd),
    .ID_EX_MemRead(ID_EX_MemRead),
    .IF_ID_rs1(IF_ID_rs1),
    .IF_ID_rs2(IF_ID_rs2),
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .ID_EX_Flush(ID_EX_Flush)
);

task check;
input expected_PCWrite;
input expected_IF_ID_Write;
input expected_ID_EX_Flush;
input integer test_number;

begin
    #10;

    if (PCWrite === expected_PCWrite &&
        IF_ID_Write === expected_IF_ID_Write &&
        ID_EX_Flush === expected_ID_EX_Flush) begin

        $display("TEST %0d PASS", test_number);
        pass_count = pass_count + 1;

    end else begin

        $display("TEST %0d FAIL: PC=%b IF_ID=%b FLUSH=%b",
                 test_number, PCWrite,
                 IF_ID_Write, ID_EX_Flush);

        fail_count = fail_count + 1;

    end
end
endtask

initial begin

    $dumpfile("simulation/waveforms/hazard_detection.vcd");
    $dumpvars(0, hazard_detection_tb);

    // TEST 1: No hazard
    ID_EX_rd = 5'd3;
    ID_EX_MemRead = 0;
    IF_ID_rs1 = 5'd3;
    IF_ID_rs2 = 5'd4;

    check(1, 1, 0, 1);

    // TEST 2: Hazard through rs1
    ID_EX_MemRead = 1;
    check(0, 0, 1, 2);

    // TEST 3: Hazard through rs2
    IF_ID_rs1 = 5'd5;
    IF_ID_rs2 = 5'd3;

    check(0, 0, 1, 3);

    // TEST 4: No matching source register
    IF_ID_rs1 = 5'd5;
    IF_ID_rs2 = 5'd6;

    check(1, 1, 0, 4);

    // TEST 5: Destination register is x0
    ID_EX_rd = 5'd0;
    IF_ID_rs1 = 5'd0;
    IF_ID_rs2 = 5'd0;

    check(1, 1, 0, 5);

    // TEST 6: MemRead disabled
    ID_EX_rd = 5'd3;
    ID_EX_MemRead = 0;
    IF_ID_rs1 = 5'd3;

    check(1, 1, 0, 6);

    // TEST 7: Both source registers match
    ID_EX_MemRead = 1;
    IF_ID_rs1 = 5'd3;
    IF_ID_rs2 = 5'd3;

    check(0, 0, 1, 7);

    $display("--------------------------------");
    $display("TOTAL PASSED: %0d", pass_count);
    $display("TOTAL FAILED: %0d", fail_count);
    $display("--------------------------------");

    $finish;

end

endmodule