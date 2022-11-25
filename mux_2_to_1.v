`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:13:05 04/08/2021 
// Design Name: 
// Module Name:    mux_2_to_1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux_2_to_1 #(parameter DATA_WIDTH=1)( output reg[DATA_WIDTH-1:0] result,input[DATA_WIDTH-1:0]in0,input[DATA_WIDTH-1:0]in1, input select);
	always @(in0,in1,select) begin
		case(select)
			1'b0: result = in0; 
			1'b1: result = in1;
		endcase
	end
endmodule

module mux_4_to_1 #(parameter DATA_WIDTH=1)(output reg[DATA_WIDTH-1:0] result, input[DATA_WIDTH-1:0] in0,in1,in2,in3, input[1:0]select);
	always @(in0,in1,in2,in3,select) begin
		case(select)
			2'b00: result = in0; 
			2'b01: result = in1; 
			2'b10: result = in2; 
			2'b11: result = in3;
		endcase
	end
endmodule 