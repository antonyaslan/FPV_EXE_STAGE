`timescale 1ns / 1ps

import common::*;


module execute_stage(
    input clk,
    input reset_n,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] immediate_data,
    input [31:0] ex_mem_data,
    input [31:0] mem_wb_data,
    input control_t control_in,
    input [31:0] pc,
    input fwd_t forward_a,
    input fwd_t forward_b,
    output control_t control_out,
    output logic [31:0] alu_data,
    output logic [31:0] memory_data,
    output logic [31:0] pc_branch
);

    logic [31:0] left_operand;
    logic [31:0] right_operand, right_operand_alu;

    // Create signed copy of imm. data for use in branch offsets, always signed
    wire signed [31:0] branch_offset;
    assign branch_offset = immediate_data;


    always_comb begin: operand_selector
        left_operand = control_in.encoding == U_TYPE ? 32'b0 :
            forward_a == NO_FWD ? data1 :
            forward_a == EX_MEM_FWD ? ex_mem_data :
            forward_a == MEM_WB_FWD ? mem_wb_data :
            data1;
        right_operand = forward_b == NO_FWD ? data2 :
            forward_b == EX_MEM_FWD ? ex_mem_data :
            forward_b == MEM_WB_FWD ? mem_wb_data :
            data2;
        right_operand_alu = control_in.alu_src ? immediate_data : right_operand;
        // TODO - Check if shamt[5] = 1 for SLLI, SRLI, SRAI and throw exception if it is (atlas, pg160)
    end


    alu inst_alu(
        .control(control_in.alu_op),
        .left_operand(left_operand),
        .right_operand(right_operand_alu),
        .result(alu_data)
    );


    assign control_out = control_in;
    assign memory_data = right_operand;
    assign pc_branch = pc + (branch_offset*2); // Multiply offset by two (atlas, pg21)
endmodule
