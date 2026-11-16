`timescale 1ns/1ps

module next_pc_selector_tb;

    reg [31:0] pc_plus4;
    reg [31:0] branch_target;
    reg branch_taken;

    wire [31:0] next_pc;

    integer passed = 0;
    integer failed = 0;

    next_pc_selector uut (
        .pc_plus4(pc_plus4),
        .branch_target(branch_target),
        .branch_taken(branch_taken),
        .next_pc(next_pc)
    );

    task check;
        input [31:0] expected;
        input integer test_number;

        begin
            #10;

            if (next_pc === expected) begin
                $display("TEST %0d PASSED | next_pc = %h",
                         test_number, next_pc);
                passed = passed + 1;
            end
            else begin
                $display("TEST %0d FAILED | Expected = %h, Got = %h",
                         test_number, expected, next_pc);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("simulation/waveforms/next_pc_selector.vcd");
        $dumpvars(0, next_pc_selector_tb);

        // Test 1: Normal execution
        pc_plus4 = 32'h00000004;
        branch_target = 32'h00000020;
        branch_taken = 0;
        check(32'h00000004, 1);

        // Test 2: Branch taken
        branch_taken = 1;
        check(32'h00000020, 2);

        // Test 3: Different sequential address
        pc_plus4 = 32'h00000008;
        branch_target = 32'h00000040;
        branch_taken = 0;
        check(32'h00000008, 3);

        // Test 4: Different branch target
        branch_taken = 1;
        check(32'h00000040, 4);

        // Test 5: Negative branch target
        pc_plus4 = 32'h0000000C;
        branch_target = 32'hFFFFFFF0;
        branch_taken = 1;
        check(32'hFFFFFFF0, 5);

        // Test 6: Branch not taken
        branch_taken = 0;
        check(32'h0000000C, 6);

        // Test 7: Same addresses
        pc_plus4 = 32'h00000010;
        branch_target = 32'h00000010;
        branch_taken = 1;
        check(32'h00000010, 7);

        #10;

        $display("--------------------------------");
        $display("NEXT PC SELECTOR TEST SUMMARY");
        $display("PASSED: %0d", passed);
        $display("FAILED: %0d", failed);
        $display("--------------------------------");

        $finish;
    end

endmodule