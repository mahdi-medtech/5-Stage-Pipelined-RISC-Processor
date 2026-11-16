`timescale 1ns/1ps

module processor_tb;

    reg clk;
    reg reset;

    processor uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        $dumpfile("simulation/waveforms/processor.vcd");
        $dumpvars(0, processor_tb);

        #20;
        reset = 0;

        // Allow processor to execute instructions
        #300;

        $display("\n========== PROCESSOR RESULTS ==========");

        $display("Register x1 = %0d",
                 uut.RF.registers[1]);

        $display("Register x2 = %0d",
                 uut.RF.registers[2]);

        $display("Register x3 = %0d",
                 uut.RF.registers[3]);

        $display("Register x4 = %0d (signed: %0d)",
                 uut.RF.registers[4],
                 $signed(uut.RF.registers[4]));

        $display("Data Memory[0] = %0d",
                 uut.DM.memory[0]);

        $display("=======================================");

        $finish;
    end

endmodule