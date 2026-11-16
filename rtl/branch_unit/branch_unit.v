module branch_unit(
    input [31:0] pc,
    input [31:0] immediate,

    input [31:0] rs1_data,
    input [31:0] rs2_data,

    input Branch,
    input [2:0] funct3,

    output [31:0] pc_plus4,
    output [31:0] branch_target,
    output reg branch_taken,
    output [31:0] next_pc
);

// Calculate sequential PC
assign pc_plus4 = pc + 32'd4;

// Calculate branch destination
assign branch_target = pc + immediate;

// Branch condition logic
always @(*) begin

    branch_taken = 1'b0;

    if (Branch) begin

        case (funct3)

            // BEQ: Branch if equal
            3'b000:
                branch_taken = (rs1_data == rs2_data);

            // BNE: Branch if not equal
            3'b001:
                branch_taken = (rs1_data != rs2_data);

            default:
                branch_taken = 1'b0;

        endcase

    end

end

// Select next PC
assign next_pc = branch_taken ? branch_target : pc_plus4;

endmodule