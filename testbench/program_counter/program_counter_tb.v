`timescale 1ns/1ps

module program_counter_tb;

    reg clk;
    reg reset;
    reg enable;
    reg [31:0] next_pc;

    wire [31:0] pc;

    integer passed = 0;
    integer failed = 0;

    program_counter uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    task check;
        input [31:0] expected;
        input integer test_number;

        begin
            @(posedge clk);
            #1;

            if (pc === expected) begin
                $display("TEST %0d PASSED | PC = %h",
                         test_number, pc);
                passed = passed + 1;
            end
            else begin
                $display("TEST %0d FAILED | Expected = %h, Got = %h",
                         test_number, expected, pc);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        clk = 0;
        reset = 1;
        enable = 0;
        next_pc = 0;

        $dumpfile("simulation/waveforms/program_counter.vcd");
        $dumpvars(0, program_counter_tb);

        // Test 1: Reset
        check(32'h00000000, 1);

        // Test 2: Increment to next instruction
        reset = 0;
        enable = 1;
        next_pc = 32'h00000004;
        check(32'h00000004, 2);

        // Test 3: Next instruction
        next_pc = 32'h00000008;
        check(32'h00000008, 3);

        // Test 4: Branch jump
        next_pc = 32'h00000020;
        check(32'h00000020, 4);

        // Test 5: Stall, PC must hold
        enable = 0;
        next_pc = 32'h00000024;
        check(32'h00000020, 5);

        // Test 6: Resume
        enable = 1;
        next_pc = 32'h00000024;
        check(32'h00000024, 6);

        // Test 7: Reset during execution
        reset = 1;
        check(32'h00000000, 7);

        #10;

        $display("--------------------------------");
        $display("PROGRAM COUNTER TEST SUMMARY");
        $display("PASSED: %0d", passed);
        $display("FAILED: %0d", failed);
        $display("--------------------------------");

        $finish;
    end

endmodule