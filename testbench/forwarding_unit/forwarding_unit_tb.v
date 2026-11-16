`timescale 1ns/1ps

module forwarding_unit_tb;

reg [4:0] ID_EX_rs1;
reg [4:0] ID_EX_rs2;

reg [4:0] EX_MEM_rd;
reg EX_MEM_RegWrite;

reg [4:0] MEM_WB_rd;
reg MEM_WB_RegWrite;

wire [1:0] ForwardA;
wire [1:0] ForwardB;

integer pass_count = 0;
integer fail_count = 0;

forwarding_unit uut(
    .ID_EX_rs1(ID_EX_rs1),
    .ID_EX_rs2(ID_EX_rs2),
    .EX_MEM_rd(EX_MEM_rd),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .MEM_WB_rd(MEM_WB_rd),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

task check;
input [1:0] expected_A;
input [1:0] expected_B;
input integer test_number;

begin

    #10;

    if (ForwardA === expected_A &&
        ForwardB === expected_B) begin

        $display("TEST %0d PASS", test_number);
        pass_count = pass_count + 1;

    end

    else begin

        $display("TEST %0d FAIL: A=%b B=%b",
                 test_number, ForwardA, ForwardB);

        fail_count = fail_count + 1;

    end

end
endtask

initial begin

    $dumpfile("simulation/waveforms/forwarding_unit.vcd");
    $dumpvars(0, forwarding_unit_tb);

    // Initialize
    ID_EX_rs1 = 0;
    ID_EX_rs2 = 0;
    EX_MEM_rd = 0;
    EX_MEM_RegWrite = 0;
    MEM_WB_rd = 0;
    MEM_WB_RegWrite = 0;

    // TEST 1: No forwarding
    ID_EX_rs1 = 1;
    ID_EX_rs2 = 2;
    check(2'b00, 2'b00, 1);

    // TEST 2: EX/MEM forwarding to A
    EX_MEM_rd = 1;
    EX_MEM_RegWrite = 1;
    check(2'b10, 2'b00, 2);

    // TEST 3: EX/MEM forwarding to B
    EX_MEM_rd = 2;
    check(2'b00, 2'b10, 3);

    // TEST 4: MEM/WB forwarding to A
    EX_MEM_RegWrite = 0;
    MEM_WB_rd = 1;
    MEM_WB_RegWrite = 1;
    check(2'b01, 2'b00, 4);

    // TEST 5: MEM/WB forwarding to B
    MEM_WB_rd = 2;
    check(2'b00, 2'b01, 5);

    // TEST 6: EX/MEM priority over MEM/WB
    EX_MEM_rd = 1;
    EX_MEM_RegWrite = 1;
    MEM_WB_rd = 1;
    MEM_WB_RegWrite = 1;
    check(2'b10, 2'b00, 6);

    // TEST 7: Never forward register x0
    ID_EX_rs1 = 0;
    ID_EX_rs2 = 0;
    EX_MEM_rd = 0;
    MEM_WB_rd = 0;
    check(2'b00, 2'b00, 7);

    $display("--------------------------------");
    $display("TOTAL PASSED: %0d", pass_count);
    $display("TOTAL FAILED: %0d", fail_count);
    $display("--------------------------------");

    $finish;

end

endmodule