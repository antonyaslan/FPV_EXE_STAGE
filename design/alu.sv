`timescale 1ns / 1ps

import common::*;


module alu(
    input wire [3:0] control,
    input wire [31:0] left_operand,
    input wire [31:0] right_operand,
    output logic [31:0] result
);

    // Create signed versions of the operands, as all operands are
    // treated as unsigned by systemverilog.
    wire signed [31:0] signed_left_operand;
    wire signed [31:0] signed_right_operand;
    assign signed_left_operand = left_operand;
    assign signed_right_operand = right_operand;

    always_comb begin
        case (control)
            ALU_AND: result = left_operand & right_operand;
            ALU_OR: result = left_operand | right_operand;
            ALU_ADD: result = left_operand + right_operand;
            ALU_SUB: result = left_operand - right_operand;
            ALU_XOR: result = left_operand ^ right_operand;
            ALU_SLT: result = signed_left_operand < signed_right_operand ? 1 : 0;
            ALU_SLTU: result = left_operand < right_operand ? 1 : 0;
            ALU_SLL: result = left_operand << right_operand;
            ALU_SRL: result = left_operand >> right_operand;
            ALU_SRA: result = signed_left_operand >>> right_operand;
            default: result = left_operand + right_operand;
        endcase
    end

endmodule
