`timescale 1ns/1ps

module data_memory_tb;

reg clk;
reg MemRead, MemWrite;
reg [31:0] address;
reg [31:0] write_data;
wire [31:0] read_data;

integer pass_count = 0;
integer fail_count = 0;

data_memory uut (
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);

always #5 clk = ~clk;

task check_read;
    input [31:0] addr;
    input [31:0] expected;
    input integer test_number;

    begin
        address = addr;
        MemRead = 1;
        #2;

        if (read_data === expected) begin
            $display("TEST %0d PASS", test_number);
            pass_count = pass_count + 1;
        end else begin
            $display("TEST %0d FAIL: Expected=%h Got=%h",
                     test_number, expected, read_data);
            fail_count = fail_count + 1;
        end

        MemRead = 0;
    end
endtask

initial begin
    clk = 0;
    MemRead = 0;
    MemWrite = 0;
    address = 0;
    write_data = 0;

    $dumpfile("simulation/waveforms/data_memory.vcd");
    $dumpvars(0, data_memory_tb);

    // Write 100 to address 0
    @(negedge clk);
    address = 0;
    write_data = 100;
    MemWrite = 1;
    @(posedge clk);
    #1;
    MemWrite = 0;

    // Write 250 to address 4
    @(negedge clk);
    address = 4;
    write_data = 250;
    MemWrite = 1;
    @(posedge clk);
    #1;
    MemWrite = 0;

    // Test 1: Read address 0
    check_read(0, 100, 1);

    // Test 2: Read address 4
    check_read(4, 250, 2);

    // Test 3: Read unwritten address
    check_read(8, 0, 3);

    // Test 4: Read disabled
    MemRead = 0;
    address = 0;
    #2;
    if (read_data === 0) begin
        $display("TEST 4 PASS");
        pass_count = pass_count + 1;
    end else begin
        $display("TEST 4 FAIL");
        fail_count = fail_count + 1;
    end

    $display("------------------------------");
    $display("TOTAL PASSED: %0d", pass_count);
    $display("TOTAL FAILED: %0d", fail_count);
    $display("------------------------------");

    $finish;
end

endmodule