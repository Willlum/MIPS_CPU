`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    18:31:09 04/07/2021 
// Design Name: 
// Module Name:    alu_control 
// Project Name: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu_control(input[5:0]func, 
						 input[1:0]ALUop, 
						 output reg[3:0] ALUctl);
		
		always @(*) begin
			if(ALUop == 2'b10) begin//R-type
				case(func)
					6'b100100: ALUctl = 4'b0000; //and
					6'b100101: ALUctl = 4'b0001; //or
					6'b100111: ALUctl = 4'b1100; //nor
					6'b100000: ALUctl = 4'b0010; //add
					6'b100010: ALUctl = 4'b0110; //subtract
				 endcase
			end 
			else if(ALUop == 2'b01) ALUctl = 4'b0011;//branch
			else if(ALUop == 2'b00) ALUctl = 4'b0010;//lw and sw
     end 
	
endmodule
