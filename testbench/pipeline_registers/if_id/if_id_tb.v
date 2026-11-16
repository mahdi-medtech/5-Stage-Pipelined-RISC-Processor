`timescale 1ns/1ps

module if_id_tb;

reg clk, reset, enable, flush;
reg [31:0] pc_in, instruction_in;

wire [31:0] pc_out, instruction_out;

integer pass_count = 0;
integer fail_count = 0;

if_id uut(
    .clk(clk), .reset(reset),
    .enable(enable), .flush(flush),
    .pc_in(pc_in),
    .instruction_in(instruction_in),
    .pc_out(pc_out),
    .instruction_out(instruction_out)
);

always #5 clk = ~clk;

task check;
input [31:0] expected_pc;
input [31:0] expected_instruction;
begin
    if (pc_out === expected_pc &&
        instruction_out === expected_instruction) begin
        $display("PASS");
        pass_count = pass_count + 1;
    end
    else begin
        $display("FAIL");
        fail_count = fail_count + 1;
    end
end
endtask

initial begin

    $dumpfile("simulation/waveforms/if_id.vcd");
    $dumpvars(0, if_id_tb);

    clk = 0;
    reset = 1;
    enable = 1;
    flush = 0;
    pc_in = 0;
    instruction_in = 0;

    @(posedge clk); #1;
    check(0, 0);

    reset = 0;
    pc_in = 32'd4;
    instruction_in = 32'h00A00093;

    @(posedge clk); #1;
    check(4, 32'h00A00093);

    enable = 0;
    pc_in = 32'd8;

    @(posedge clk); #1;
    check(4, 32'h00A00093);

    enable = 1;
    flush = 1;

    @(posedge clk); #1;
    check(0, 0);

    $display("IF/ID PASSED: %0d FAILED: %0d",
             pass_count, fail_count);

    $finish;

end

endmodule