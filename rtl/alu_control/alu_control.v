module alu_control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    input  wire [6:0] opcode,

    output reg  [2:0] ALUControl
);

    // ALU operation encoding:
    // 000 = ADD
    // 001 = SUB
    // 010 = AND
    // 011 = OR
    // 100 = XOR

    always @(*) begin

        case (ALUOp)

            // Loads and stores
            2'b00: begin
                ALUControl = 3'b000;
            end

            // Branch comparison
            2'b01: begin
                ALUControl = 3'b001;
            end

            // R-type and immediate arithmetic
            2'b10: begin

                // ADDI
                if (opcode == 7'b0010011) begin
                    ALUControl = 3'b000;
                end

                // R-type
                else begin
                    case (funct3)

                        3'b000: begin
                            if (funct7 == 7'b0100000)
                                ALUControl = 3'b001;
                            else
                                ALUControl = 3'b000;
                        end

                        3'b111: ALUControl = 3'b010;

                        3'b110: ALUControl = 3'b011;

                        3'b100: ALUControl = 3'b100;

                        default: ALUControl = 3'b000;

                    endcase
                end
            end

            default: begin
                ALUControl = 3'b000;
            end

        endcase
    end

endmodule