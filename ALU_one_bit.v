`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name:    ALU_one_bit 
// Create Date:    02/12/2021 
//
//////////////////////////////////////////////////////////////////////////////////

module ALU_one_bit(result, c_out, a, b, c_in, opcode);
	output result;
	output c_out;
	input a, b, c_in;
	input [3:0] opcode;		
	wire a_n, b_n, a_mux_out, b_mux_out, c1, c2, c3, and_out,or_out, a_mux_select,b_mux_select,sum;
	wire [1:0] operation_select;

	assign operation_select = opcode[1:0];
	assign b_mux_select = opcode[2];
	assign a_mux_select = opcode[3];
	
	not(a_n,a);
	not(b_n,b);

	assign a_mux_out = (a_mux_select) ? a_n : a;
	assign b_mux_out = (b_mux_select) ? b_n : b;

	//Full adder
	xor(sum, a_mux_out,b_mux_out,c_in);
	and(c1,a_mux_out,b_mux_out);
	and(c2,a_mux_out,c_in);
	and(c3,c_in,b_mux_out);
	or(c_out,c1,c2,c3);
	//AND
	and(and_out, a_mux_out, b_mux_out);
	//OR
	or(or_out, a_mux_out, b_mux_out);	
	//Output MUX
	mux4to1 m4to1(result, and_out, or_out, sum, b_mux_out, opcode[1:0]);
endmodule
	
module mux4to1(output reg result, input in0,in1,in2,in3,input[1:0]select);
	always @(in0,in1,in2,in3,select) begin
		case(select)
			2'b00: result = in0; //and
			2'b01: result = in1; //or
			2'b10: result = in2; //add
			2'b11: result = in3; //
		endcase
	end
endmodule 
	
