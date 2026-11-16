module fpga_top (
    input wire clk,
    input wire reset,

    output wire [5:0] led
);

    wire [31:0] pc_debug;
    wire [31:0] result_debug;
    wire branch_debug;
    wire stall_debug;

    processor CPU (
        .clk(clk),
        .reset(reset),

        .pc_debug(pc_debug),
        .result_debug(result_debug),
        .branch_debug(branch_debug),
        .stall_debug(stall_debug)
    );

    assign led[3:0] = pc_debug[5:2];
    assign led[4] = branch_debug;
    assign led[5] = stall_debug;

endmodule