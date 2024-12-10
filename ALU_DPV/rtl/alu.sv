import common::*;

module alu(
    input 		clk,
    input 		reset,
    input 		valid,
    input [2:0] 	command,
    input [31:0] 	in_a,
    input [31:0] 	in_b,
    output logic [31:0] result
);

    // Create signed versions of the operands, as all operands are
    // treated as unsigned by systemverilog.
    wire signed [31:0] signed_in_a;
    wire signed [31:0] signed_in_b;
    logic [31:0]         temp_result;
   
    assign signed_in_a = in_a;
    assign signed_in_b = in_b;

    always_comb begin
        case (command)
            ALU_AND: temp_result = in_a & in_b;
            ALU_OR: temp_result = in_a | in_b;
            ALU_ADD: temp_result = in_a + in_b;
            ALU_SUB: temp_result = in_a - in_b;
            ALU_XOR: temp_result = in_a ^ in_b;
            // ALU_SLT: temp_result = signed_in_a < signed_in_b ? 1 : 0;
            // ALU_SLTU: temp_result = in_a < in_b ? 1 : 0;
            // ALU_SLL: temp_result = in_a << in_b;
            // ALU_SRL: temp_result = in_a >> in_b;
            // ALU_SRA: temp_result = signed_in_a >>> in_b;
            default: temp_result = in_a + in_b;
        endcase
    end

always @(posedge clk) begin
	if(reset) begin
		result <= 'b0;
	end
	else if (valid) begin
		result <= temp_result;
	end
	else begin
		result <= temp_result;
	end
end

   
endmodule
