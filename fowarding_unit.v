`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:42:13 04/10/2021 
// Design Name: 
// Module Name:    fowarding_unit 
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
module fowarding_unit(output reg[1:0] forwardA, forwardB, 
							 input[4:0] rs_IDEX, rt_IDEX, rd_EXMEM, rd_MEMWB,
							 input reg_write_EXMEM, reg_write_MEMWB, clk
							 );

		always@(*) begin
			if(reg_write_EXMEM && (rd_EXMEM != 0) && (rd_EXMEM == rs_IDEX))
				forwardA <= 2'b10;
			else if(reg_write_MEMWB && (rd_MEMWB != 0) &&
			(rd_MEMWB == rs_IDEX))
				forwardA <= 2'b01;
			else
				forwardA <= 2'b00;
			
			if(reg_write_EXMEM && (rd_EXMEM != 0) && (rd_EXMEM == rt_IDEX))
				forwardB <= 2'b10;
			else if(reg_write_MEMWB && (rd_MEMWB != 0) &&
					(rd_MEMWB == rt_IDEX))
				forwardB <= 2'b01;
			else
				forwardB <= 2'b00;
		end

endmodule
