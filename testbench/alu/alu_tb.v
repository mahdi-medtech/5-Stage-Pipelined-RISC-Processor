module alu_tb;

reg [31:0] A, B;
reg [2:0] ALU_Control;

wire [31:0] Result;
wire Zero;

alu uut (
    .A(A),
    .B(B),
    .ALU_Control(ALU_Control),
    .Result(Result),
    .Zero(Zero)
);

initial begin

    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);

    A = 10;
    B = 5;

    ALU_Control = 3'b000;
    #10;

    ALU_Control = 3'b001;
    #10;

    ALU_Control = 3'b010;
    #10;

    ALU_Control = 3'b011;
    #10;

    ALU_Control = 3'b100;
    #10;

    A = 10;
    B = 10;

    ALU_Control = 3'b001;
    #10;

    $finish;

end

endmodule