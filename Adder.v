`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:29:31 04/12/2021 
// Design Name: 
// Module Name:    Adder 
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
module Adder#(parameter DATA_WIDTH = 32)(out,in0,in1,clk);

	output reg [31:0] out;
	input [31:0] in0,in1;
	input clk;
	
	always @ (*) begin
			out = in0 + in1;
	end	
endmodule
