module processor (
    input wire clk,
    input wire reset,

    output wire [31:0] pc_debug,
    output wire [31:0] result_debug,
    output wire branch_debug,
    output wire stall_debug
);

    // =====================================================
    // IF STAGE: INSTRUCTION FETCH
    // =====================================================

    wire [31:0] pc_current;
    wire [31:0] pc_plus4;
    wire [31:0] instruction;
    wire [31:0] next_pc;

    wire [31:0] branch_target;
    wire branch_taken;

    wire PCWrite;
    wire IF_ID_Write;
    wire ID_EX_Flush;

    assign pc_plus4 = pc_current + 32'd4;

    program_counter PC (
        .clk(clk),
        .reset(reset),
        .enable(PCWrite),
        .next_pc(next_pc),
        .pc(pc_current)
    );

    instruction_memory IM (
        .pc(pc_current),
        .instruction(instruction)
    );

    // =====================================================
    // IF/ID PIPELINE REGISTER
    // =====================================================

    wire [31:0] IF_ID_PC;
    wire [31:0] IF_ID_Instruction;

    if_id IF_ID (
        .clk(clk),
        .reset(reset),
        .enable(IF_ID_Write),
        .flush(branch_taken),
        .pc_in(pc_current),
        .instruction_in(instruction),
        .pc_out(IF_ID_PC),
        .instruction_out(IF_ID_Instruction)
    );

    // =====================================================
    // ID STAGE: INSTRUCTION DECODE
    // =====================================================

    wire RegWrite_ID;
    wire ALUSrc_ID;
    wire MemRead_ID;
    wire MemWrite_ID;
    wire MemToReg_ID;
    wire Branch_ID;
    wire [1:0] ALUOp_ID;

    control_unit CU (
        .opcode(IF_ID_Instruction[6:0]),
        .RegWrite(RegWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .MemRead(MemRead_ID),
        .MemWrite(MemWrite_ID),
        .MemToReg(MemToReg_ID),
        .Branch(Branch_ID),
        .ALUOp(ALUOp_ID)
    );

    wire [31:0] immediate_ID;

    immediate_generator IG (
        .instruction(IF_ID_Instruction),
        .immediate(immediate_ID)
    );

    wire [31:0] read_data1_ID;
    wire [31:0] read_data2_ID;

    wire [31:0] writeback_data;
    wire [4:0] writeback_rd;
    wire writeback_RegWrite;

    register_file RF (
        .clk(clk),
        .reg_write(writeback_RegWrite),
        .read_addr1(IF_ID_Instruction[19:15]),
        .read_addr2(IF_ID_Instruction[24:20]),
        .write_addr(writeback_rd),
        .write_data(writeback_data),
        .read_data1(read_data1_ID),
        .read_data2(read_data2_ID)
    );

    // =====================================================
    // HAZARD DETECTION
    // =====================================================

    wire [4:0] hazard_rs1;
    wire [4:0] hazard_rs2;

    wire [6:0] ID_opcode;

    assign ID_opcode = IF_ID_Instruction[6:0];

    // Only compare source registers actually used
    assign hazard_rs1 =
        (ID_opcode == 7'b0110011 ||
         ID_opcode == 7'b0010011 ||
         ID_opcode == 7'b0000011 ||
         ID_opcode == 7'b0100011 ||
         ID_opcode == 7'b1100011)
        ? IF_ID_Instruction[19:15] : 5'd0;

    assign hazard_rs2 =
        (ID_opcode == 7'b0110011 ||
         ID_opcode == 7'b0100011 ||
         ID_opcode == 7'b1100011)
        ? IF_ID_Instruction[24:20] : 5'd0;

    wire [4:0] ID_EX_rd;
    wire ID_EX_MemRead;

    hazard_detection HD (
        .ID_EX_rd(ID_EX_rd),
        .ID_EX_MemRead(ID_EX_MemRead),
        .IF_ID_rs1(hazard_rs1),
        .IF_ID_rs2(hazard_rs2),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ID_EX_Flush(ID_EX_Flush)
    );

    // =====================================================
    // ID/EX PIPELINE REGISTER
    // =====================================================

    wire [31:0] ID_EX_PC;
    wire [31:0] ID_EX_rs1_data;
    wire [31:0] ID_EX_rs2_data;
    wire [31:0] ID_EX_immediate;

    wire [4:0] ID_EX_rs1;
    wire [4:0] ID_EX_rs2;

    wire [2:0] ID_EX_funct3;
    wire [6:0] ID_EX_funct7;

    wire ID_EX_RegWrite;
    wire ID_EX_ALUSrc;
    wire ID_EX_MemWrite;
    wire ID_EX_MemToReg;
    wire ID_EX_Branch;
    wire [1:0] ID_EX_ALUOp;

    id_ex IDEX (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .flush(ID_EX_Flush | branch_taken),

        .pc_in(IF_ID_PC),
        .rs1_data_in(read_data1_ID),
        .rs2_data_in(read_data2_ID),
        .immediate_in(immediate_ID),

        .rs1_in(IF_ID_Instruction[19:15]),
        .rs2_in(IF_ID_Instruction[24:20]),
        .rd_in(IF_ID_Instruction[11:7]),

        .funct3_in(IF_ID_Instruction[14:12]),
        .funct7_in(IF_ID_Instruction[31:25]),

        .RegWrite_in(RegWrite_ID),
        .ALUSrc_in(ALUSrc_ID),
        .MemRead_in(MemRead_ID),
        .MemWrite_in(MemWrite_ID),
        .MemToReg_in(MemToReg_ID),
        .Branch_in(Branch_ID),
        .ALUOp_in(ALUOp_ID),

        .pc_out(ID_EX_PC),
        .rs1_data_out(ID_EX_rs1_data),
        .rs2_data_out(ID_EX_rs2_data),
        .immediate_out(ID_EX_immediate),

        .rs1_out(ID_EX_rs1),
        .rs2_out(ID_EX_rs2),
        .rd_out(ID_EX_rd),

        .funct3_out(ID_EX_funct3),
        .funct7_out(ID_EX_funct7),

        .RegWrite_out(ID_EX_RegWrite),
        .ALUSrc_out(ID_EX_ALUSrc),
        .MemRead_out(ID_EX_MemRead),
        .MemWrite_out(ID_EX_MemWrite),
        .MemToReg_out(ID_EX_MemToReg),
        .Branch_out(ID_EX_Branch),
        .ALUOp_out(ID_EX_ALUOp)
    );

    // =====================================================
    // EX STAGE: EXECUTE
    // =====================================================

    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    wire [31:0] EX_MEM_ALUResult;
    wire [31:0] EX_MEM_WriteData;
    wire [4:0] EX_MEM_rd;
    wire EX_MEM_RegWrite;
    wire EX_MEM_MemRead;
    wire EX_MEM_MemWrite;
    wire EX_MEM_MemToReg;

    wire [31:0] MEM_WB_ReadData;
    wire [31:0] MEM_WB_ALUResult;
    wire [4:0] MEM_WB_rd;
    wire MEM_WB_RegWrite;
    wire MEM_WB_MemToReg;

    forwarding_unit FU (
        .ID_EX_rs1(ID_EX_rs1),
        .ID_EX_rs2(ID_EX_rs2),

        .EX_MEM_rd(EX_MEM_rd),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),

        .MEM_WB_rd(MEM_WB_rd),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),

        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    reg [31:0] forwarded_A;
    reg [31:0] forwarded_B;

    always @(*) begin

        case (ForwardA)
            2'b10: forwarded_A = EX_MEM_ALUResult;
            2'b01: forwarded_A = writeback_data;
            default: forwarded_A = ID_EX_rs1_data;
        endcase

        case (ForwardB)
            2'b10: forwarded_B = EX_MEM_ALUResult;
            2'b01: forwarded_B = writeback_data;
            default: forwarded_B = ID_EX_rs2_data;
        endcase

    end

    wire [31:0] ALU_B;
    wire [2:0] ALUControl;
    wire [31:0] ALU_Result;
    wire ALU_Zero;

    assign ALU_B = ID_EX_ALUSrc
                   ? ID_EX_immediate
                   : forwarded_B;

    alu_control AC (
        .ALUOp(ID_EX_ALUOp),
        .funct3(ID_EX_funct3),
        .funct7(ID_EX_funct7),
        .opcode(7'b0110011),
        .ALUControl(ALUControl)
    );

    alu ALU (
        .A(forwarded_A),
        .B(ALU_B),
        .ALU_Control(ALUControl),
        .Result(ALU_Result),
        .Zero(ALU_Zero)
    );

    // =====================================================
    // BRANCH UNIT
    // =====================================================

    wire [31:0] unused_branch_pc4;
    wire [31:0] unused_branch_next_pc;

    branch_unit BU (
        .pc(ID_EX_PC),
        .immediate(ID_EX_immediate),
        .rs1_data(forwarded_A),
        .rs2_data(forwarded_B),
        .Branch(ID_EX_Branch),
        .funct3(ID_EX_funct3),
        .pc_plus4(unused_branch_pc4),
        .branch_target(branch_target),
        .branch_taken(branch_taken),
        .next_pc(unused_branch_next_pc)
    );

    next_pc_selector NPC (
        .pc_plus4(pc_plus4),
        .branch_target(branch_target),
        .branch_taken(branch_taken),
        .next_pc(next_pc)
    );

    // =====================================================
    // EX/MEM PIPELINE REGISTER
    // =====================================================

    wire [31:0] EX_MEM_PC;
    wire EX_MEM_Zero;
    wire EX_MEM_Branch;

    ex_mem EXMEM (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .flush(1'b0),

        .pc_in(ID_EX_PC),
        .alu_result_in(ALU_Result),
        .write_data_in(forwarded_B),

        .rd_in(ID_EX_rd),

        .zero_in(ALU_Zero),
        .RegWrite_in(ID_EX_RegWrite),
        .MemRead_in(ID_EX_MemRead),
        .MemWrite_in(ID_EX_MemWrite),
        .MemToReg_in(ID_EX_MemToReg),
        .Branch_in(ID_EX_Branch),

        .pc_out(EX_MEM_PC),
        .alu_result_out(EX_MEM_ALUResult),
        .write_data_out(EX_MEM_WriteData),

        .rd_out(EX_MEM_rd),

        .zero_out(EX_MEM_Zero),
        .RegWrite_out(EX_MEM_RegWrite),
        .MemRead_out(EX_MEM_MemRead),
        .MemWrite_out(EX_MEM_MemWrite),
        .MemToReg_out(EX_MEM_MemToReg),
        .Branch_out(EX_MEM_Branch)
    );

    // =====================================================
    // MEM STAGE: MEMORY ACCESS
    // =====================================================

    wire [31:0] data_memory_read;

    data_memory DM (
        .clk(clk),
        .MemRead(EX_MEM_MemRead),
        .MemWrite(EX_MEM_MemWrite),
        .address(EX_MEM_ALUResult),
        .write_data(EX_MEM_WriteData),
        .read_data(data_memory_read)
    );

    // =====================================================
    // MEM/WB PIPELINE REGISTER
    // =====================================================

    mem_wb MEMWB (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .flush(1'b0),

        .read_data_in(data_memory_read),
        .alu_result_in(EX_MEM_ALUResult),

        .rd_in(EX_MEM_rd),

        .RegWrite_in(EX_MEM_RegWrite),
        .MemToReg_in(EX_MEM_MemToReg),

        .read_data_out(MEM_WB_ReadData),
        .alu_result_out(MEM_WB_ALUResult),

        .rd_out(MEM_WB_rd),

        .RegWrite_out(MEM_WB_RegWrite),
        .MemToReg_out(MEM_WB_MemToReg)
    );

    // =====================================================
    // WB STAGE: WRITEBACK
    // =====================================================

    assign writeback_data = MEM_WB_MemToReg
                            ? MEM_WB_ReadData
                            : MEM_WB_ALUResult;

    assign writeback_rd = MEM_WB_rd;
    assign writeback_RegWrite = MEM_WB_RegWrite;

    assign pc_debug = pc_current;
    assign result_debug = writeback_data;
    assign branch_debug = branch_taken;
    assign stall_debug = ~PCWrite;

endmodule