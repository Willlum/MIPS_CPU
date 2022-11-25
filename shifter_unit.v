`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:22:43 04/12/2021 
// Design Name: 
// Module Name:    shifter_unit 
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
module shifter_unit(
			input[31:0] sign_extended_data,
			output reg[31:0]sign_shifted_data
    );
	always @(*) sign_shifted_data = (sign_extended_data << 2);
endmodule
