`timescale 1ns/1ps

module branch_unit_tb;

reg [31:0] pc;
reg [31:0] immediate;

reg [31:0] rs1_data;
reg [31:0] rs2_data;

reg Branch;
reg [2:0] funct3;

wire [31:0] pc_plus4;
wire [31:0] branch_target;
wire branch_taken;
wire [31:0] next_pc;

integer pass_count = 0;
integer fail_count = 0;

branch_unit uut(
    .pc(pc),
    .immediate(immediate),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .Branch(Branch),
    .funct3(funct3),
    .pc_plus4(pc_plus4),
    .branch_target(branch_target),
    .branch_taken(branch_taken),
    .next_pc(next_pc)
);

task check;
    input expected_taken;
    input [31:0] expected_next_pc;
    input integer test_number;

    begin

        #10;

        if (branch_taken === expected_taken &&
            next_pc === expected_next_pc) begin

            $display("TEST %0d PASS", test_number);
            pass_count = pass_count + 1;

        end

        else begin

            $display(
                "TEST %0d FAIL: Taken=%b NextPC=%h",
                test_number,
                branch_taken,
                next_pc
            );

            fail_count = fail_count + 1;

        end

    end
endtask

initial begin

    $dumpfile("simulation/waveforms/branch_unit.vcd");
    $dumpvars(0, branch_unit_tb);

    pc = 32'd100;
    immediate = 32'd16;

    rs1_data = 32'd10;
    rs2_data = 32'd10;

    Branch = 0;
    funct3 = 3'b000;

    // TEST 1: Normal sequential execution
    check(0, 32'd104, 1);

    // TEST 2: BEQ with equal operands
    Branch = 1;
    funct3 = 3'b000;

    check(1, 32'd116, 2);

    // TEST 3: BEQ with unequal operands
    rs2_data = 32'd20;

    check(0, 32'd104, 3);

    // TEST 4: BNE with unequal operands
    funct3 = 3'b001;

    check(1, 32'd116, 4);

    // TEST 5: BNE with equal operands
    rs2_data = 32'd10;

    check(0, 32'd104, 5);

    // TEST 6: Branch disabled
    Branch = 0;

    check(0, 32'd104, 6);

    // TEST 7: Unsupported branch funct3
    Branch = 1;
    funct3 = 3'b010;

    check(0, 32'd104, 7);

    // TEST 8: Negative branch offset
    funct3 = 3'b000;
    immediate = -32'd8;
    rs1_data = 32'd15;
    rs2_data = 32'd15;

    check(1, 32'd92, 8);

    // Verify PC+4 independently
    if (pc_plus4 === 32'd104) begin
        $display("PC+4 CHECK PASS");
        pass_count = pass_count + 1;
    end
    else begin
        $display("PC+4 CHECK FAIL");
        fail_count = fail_count + 1;
    end

    $display("--------------------------------");
    $display("TOTAL PASSED: %0d", pass_count);
    $display("TOTAL FAILED: %0d", fail_count);
    $display("--------------------------------");

    $finish;

end

endmodule