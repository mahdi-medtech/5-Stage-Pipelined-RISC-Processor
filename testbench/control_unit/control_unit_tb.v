`timescale 1ns/1ps

module control_unit_tb;

reg [6:0] opcode;

wire RegWrite;
wire ALUSrc;
wire MemRead;
wire MemWrite;
wire MemToReg;
wire Branch;
wire [1:0] ALUOp;

integer passed = 0;
integer failed = 0;

control_unit uut (
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemToReg(MemToReg),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

initial begin

    $dumpfile("simulation/waveforms/control_unit.vcd");
    $dumpvars(0, control_unit_tb);

    // Test 1: R-Type
    opcode = 7'b0110011;
    #10;
    if (RegWrite && !ALUSrc && ALUOp == 2'b10) begin
        $display("TEST 1 PASS: R-Type");
        passed = passed + 1;
    end
    else begin
        $display("TEST 1 FAIL: R-Type");
        failed = failed + 1;
    end

    // Test 2: ADDI
    opcode = 7'b0010011;
    #10;
    if (RegWrite && ALUSrc && ALUOp == 2'b10) begin
        $display("TEST 2 PASS: ADDI");
        passed = passed + 1;
    end
    else begin
        $display("TEST 2 FAIL: ADDI");
        failed = failed + 1;
    end

    // Test 3: Load Word
    opcode = 7'b0000011;
    #10;
    if (RegWrite && ALUSrc && MemRead && MemToReg && !MemWrite) begin
        $display("TEST 3 PASS: LW");
        passed = passed + 1;
    end
    else begin
        $display("TEST 3 FAIL: LW");
        failed = failed + 1;
    end

    // Test 4: Store Word
    opcode = 7'b0100011;
    #10;
    if (!RegWrite && ALUSrc && MemWrite && !MemRead) begin
        $display("TEST 4 PASS: SW");
        passed = passed + 1;
    end
    else begin
        $display("TEST 4 FAIL: SW");
        failed = failed + 1;
    end

    // Test 5: Branch
    opcode = 7'b1100011;
    #10;
    if (Branch && ALUOp == 2'b01 && !RegWrite) begin
        $display("TEST 5 PASS: BRANCH");
        passed = passed + 1;
    end
    else begin
        $display("TEST 5 FAIL: BRANCH");
        failed = failed + 1;
    end

    // Test 6: Invalid opcode
    opcode = 7'b1111111;
    #10;
    if (!RegWrite && !ALUSrc && !MemRead &&
        !MemWrite && !MemToReg && !Branch &&
        ALUOp == 2'b00) begin
        $display("TEST 6 PASS: INVALID OPCODE");
        passed = passed + 1;
    end
    else begin
        $display("TEST 6 FAIL: INVALID OPCODE");
        failed = failed + 1;
    end

    $display("--------------------------------");
    $display("TOTAL PASSED: %0d", passed);
    $display("TOTAL FAILED: %0d", failed);
    $display("--------------------------------");

    $finish;

end

endmodule