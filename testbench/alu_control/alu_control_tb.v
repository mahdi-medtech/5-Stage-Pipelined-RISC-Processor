`timescale 1ns/1ps

module alu_control_tb;

    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [6:0] opcode;

    wire [2:0] ALUControl;

    integer passed = 0;
    integer failed = 0;

    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .ALUControl(ALUControl)
    );

    task check;
        input [2:0] expected;
        input integer test_number;

        begin
            #10;

            if (ALUControl === expected) begin
                $display("TEST %0d PASSED | ALUControl = %b",
                         test_number, ALUControl);
                passed = passed + 1;
            end
            else begin
                $display("TEST %0d FAILED | Expected = %b, Got = %b",
                         test_number, expected, ALUControl);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("simulation/waveforms/alu_control.vcd");
        $dumpvars(0, alu_control_tb);

        // Test 1: Load/store ADD
        ALUOp = 2'b00;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        opcode = 7'b0000011;
        check(3'b000, 1);

        // Test 2: Branch SUB
        ALUOp = 2'b01;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        opcode = 7'b1100011;
        check(3'b001, 2);

        // Test 3: R-type ADD
        ALUOp = 2'b10;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        opcode = 7'b0110011;
        check(3'b000, 3);

        // Test 4: R-type SUB
        ALUOp = 2'b10;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        opcode = 7'b0110011;
        check(3'b001, 4);

        // Test 5: R-type AND
        ALUOp = 2'b10;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        opcode = 7'b0110011;
        check(3'b010, 5);

        // Test 6: R-type OR
        ALUOp = 2'b10;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        opcode = 7'b0110011;
        check(3'b011, 6);

        // Test 7: R-type XOR
        ALUOp = 2'b10;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        opcode = 7'b0110011;
        check(3'b100, 7);

        // Test 8: ADDI
        ALUOp = 2'b10;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        opcode = 7'b0010011;
        check(3'b000, 8);

        #10;

        $display("--------------------------------");
        $display("ALU CONTROL TEST SUMMARY");
        $display("PASSED: %0d", passed);
        $display("FAILED: %0d", failed);
        $display("--------------------------------");

        $finish;
    end

endmodule