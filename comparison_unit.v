`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:34 04/12/2021 
// Design Name: 
// Module Name:    comparison_unit 
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
module comparison_unit(
	input[31:0] r1,r2,
	output reg branch_taken
    );
	 always@(*)begin
		if(r1 == r2) branch_taken <= 1;
		else branch_taken <=0;
	
	 end
endmodule
