module instruction_memory(
    input  [31:0] pc,
    output [31:0] instruction
);

reg [31:0] memory [0:255];

assign instruction = memory[pc[9:2]];

integer i;

initial begin

    // Initialize memory
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'h00000013; // RISC-V NOP

    // Sample RISC-V instructions
    memory[0]  = 32'h00A00093; // ADDI x1, x0, 10
    memory[1]  = 32'h01400113; // ADDI x2, x0, 20
    memory[2]  = 32'h002081B3; // ADD x3, x1, x2
    memory[3]  = 32'h40208233; // SUB x4, x1, x2
    memory[4]  = 32'h00302023; // SW x3, 0(x0)
    memory[5]  = 32'h00002183; // LW x3, 0(x0)
    memory[6]  = 32'h001182B3; // ADD x5, x3, x1
    memory[7]  = 32'h00108463; // BEQ x1, x1, 8
    memory[8]  = 32'h06300093; // ADDI x1, x0, 99 (flush)
    memory[9]  = 32'h04D00393; // ADDI x7, x0, 77 (branch target)

end

endmodule