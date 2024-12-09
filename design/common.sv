package common;

    typedef enum logic [3:0]
    {
        ALU_AND = 4'b0000,
        ALU_OR = 4'b0001,
        ALU_ADD = 4'b0010,
        ALU_SUB = 4'b0011,
        ALU_XOR = 4'b0100,
        ALU_SLT = 4'b0101,
        ALU_SLTU = 4'b0110,
        ALU_SLL = 4'b0111,
        ALU_SRL = 4'b1000,
        ALU_SRA = 4'b1001
    } alu_op_t;

    // nop == addi x0, x0, 0
    logic [31:0] NOP_INSTRUCTION = 32'b00000000000000000000000000010011;

    typedef enum logic [2:0]
    {
        R_TYPE,
        I_TYPE,
        // Same as I_TYPE, but used for SRAI, SRLI, SLLI
        I_S_TYPE,
        S_TYPE,
        B_TYPE,
        U_TYPE,
        J_TYPE
    } encoding_t;

    typedef enum logic [1:0]
    {
        BRANCH_EQ,
        BRANCH_NE,
        BRANCH_LT,
        BRANCH_GE
    } branch_cond_t;

    typedef enum logic [1:0] 
    {
        NO_FWD,
        EX_MEM_FWD,
        MEM_WB_FWD
    } fwd_t;

    typedef struct packed
    {
        alu_op_t alu_op;
        encoding_t encoding;
        logic alu_src;
        logic mem_read;
        logic mem_write;
        logic reg_write;
        logic mem_to_reg;
        logic is_branch;
        branch_cond_t branch_cond;
    } control_t;

    typedef struct packed
    {
        logic [6:0] funct7;
        logic [4:0] rs2;
        logic [4:0] rs1;
        logic [2:0] funct3;
        logic [4:0] rd;
        logic [6:0] opcode;
    } instruction_t;

    typedef struct  packed
    {
        logic [31:0] pc;
        instruction_t instruction;
    } if_id_t;


    typedef struct packed
    {
        logic [4:0] reg_rd_id;
        logic [31:0] data1;
        logic [31:0] data2;
        logic [31:0] immediate_data;
        instruction_t instruction;
        control_t control;
        logic [31:0] pc;
    } id_ex_t;


    typedef struct packed
    {
        logic [4:0] reg_rd_id;
        control_t control;
        logic [31:0] alu_data;
        logic [31:0] memory_data;
        logic [31:0] pc_branch;
        logic partial_zero_flag;
    } ex_mem_t;


    typedef struct packed
    {
        logic [4:0] reg_rd_id;
        logic [31:0] memory_data;
        logic [31:0] alu_data;
        control_t control;
    } mem_wb_t;


    function automatic [31:0] immediate_extension(instruction_t instruction, encoding_t inst_encoding);
        case (inst_encoding)
            I_TYPE: immediate_extension =
                { {20{instruction.funct7[6]}}, {instruction.funct7,
                    instruction.rs2}
                };
            // shamt[5] must always be zero in RV32I for SRAI, SRLI, SLLI
            I_S_TYPE: immediate_extension =
                { 27'b0, instruction.rs2};
            S_TYPE: immediate_extension =
                { {20{instruction.funct7[6]}}, {instruction.funct7,
                    instruction.rd}
                };
            B_TYPE: immediate_extension =
                { {20{instruction.funct7[6]}}, {instruction.funct7[6],
                    instruction.rd[0], instruction.funct7[5:0],
                    instruction.rd[4:1]}
                };
            U_TYPE: immediate_extension =
                { {instruction.funct7, instruction.rs2,
                    instruction.rs1, instruction.funct3}, {12{1'b0}}
                };
            default: immediate_extension = // R-type
                { {20{instruction.funct7[6]}},
                    {instruction.funct7, instruction.rs2}
                };
        endcase
    endfunction

endpackage
