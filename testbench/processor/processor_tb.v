`timescale 1ns/1ps

module processor_tb;

    reg clk;
    reg reset;

    processor uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    integer hazard_count = 0;
    integer branch_count = 0;

    always @(posedge clk) begin
        if (!reset) begin
            if (!uut.PCWrite)
                hazard_count = hazard_count + 1;

            if (uut.branch_taken)
                branch_count = branch_count + 1;
        end
    end

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

        $display("Register x5 = %0d", uut.RF.registers[5]);

        $display("Register x7 = %0d", uut.RF.registers[7]);

        $display("Data Memory[0] = %0d",
                 uut.DM.memory[0]);

        $display("--------------------------------");
        $display("PIPELINE CONTROL VERIFICATION");

        $display("Load-use stalls detected: %0d", hazard_count);
        $display("Branches taken: %0d", branch_count);

        if (hazard_count > 0 && branch_count > 0 &&
            uut.RF.registers[1] == 10 &&
            uut.RF.registers[5] == 40 &&
            uut.RF.registers[7] == 77) begin

            $display("PIPELINE CONTROL TEST: PASSED");

        end
        else begin

            $display("PIPELINE CONTROL TEST: FAILED");

        end

        $display("=======================================");

        $finish;
    end

endmodule