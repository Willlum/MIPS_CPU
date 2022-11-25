`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:01 04/07/2021 
// Design Name: 
// Module Name:    Load_Use_Hazard_Unit 
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
module Hazard_Unit(
    input clk,
	 input IDEX_mem_read,
    input[4:0] IDEXrt1,
    input[4:0] IFIDrt2,
    input[4:0] IFIDrs1,
	 output reg pc_write,
	 output reg IDEX_zero,
	 output reg IFID_write
	 
    );
	
	always@ (*) begin
		if(IDEX_mem_read && ((IDEXrt1 == IFIDrs1) || (IDEXrt1 == IFIDrt2)))begin // stall pipeline
			pc_write <= 0;
			IDEX_zero <= 1;
			IFID_write <= 0;
		end
		else begin 
			pc_write <= 1;
			IDEX_zero <= 0;
			IFID_write <= 1;
		end
	end

endmodule
