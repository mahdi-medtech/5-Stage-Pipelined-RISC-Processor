`timescale 1ns/1ps

module instruction_memory_tb;

reg [31:0] pc;
wire [31:0] instruction;

integer pass_count = 0;
integer fail_count = 0;

instruction_memory uut (
    .pc(pc),
    .instruction(instruction)
);

task check_instruction;
    input [31:0] address;
    input [31:0] expected;
    input integer test_number;

    begin
        pc = address;
        #10;

        if (instruction === expected) begin
            $display("TEST %0d PASS: PC=%0d", test_number, address);
            pass_count = pass_count + 1;
        end
        else begin
            $display("TEST %0d FAIL: Expected=%h Got=%h",
                     test_number, expected, instruction);
            fail_count = fail_count + 1;
        end
    end
endtask

initial begin

    $dumpfile("simulation/waveforms/instruction_memory.vcd");
    $dumpvars(0, instruction_memory_tb);

    check_instruction(0,  32'h00A00093, 1);
    check_instruction(4,  32'h01400113, 2);
    check_instruction(8,  32'h002081B3, 3);
    check_instruction(12, 32'h40208233, 4);
    check_instruction(16, 32'h00302023, 5);
    check_instruction(20, 32'h00002183, 6);
    check_instruction(24, 32'h00208463, 7);

    // Test unused memory location (NOP)
    check_instruction(28, 32'h00000013, 8);

    $display("--------------------------------");
    $display("TOTAL PASSED: %0d", pass_count);
    $display("TOTAL FAILED: %0d", fail_count);
    $display("--------------------------------");

    $finish;

end

endmodule