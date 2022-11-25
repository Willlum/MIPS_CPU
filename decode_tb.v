`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:36:50 03/11/2021
// Design Name:   write_decoder
// Module Name:   /home/ise/VM_Shared/ece483_L5_gallagher/decode_tb.v
// Project Name:  ece483_L5_gallagher
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: write_decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module decode_tb;

	// Inputs
	reg [4:0] reg_write;

	// Outputs
	wire [31:0] output_enable;

	// Instantiate the Unit Under Test (UUT)
	write_decoder uut (
		.output_enable(output_enable), 
		.reg_write(reg_write)
	);

	initial begin
		// Initialize Inputs
		reg_write = 0;
		repeat(32) #5 reg_write = reg_write + 1'b1;
		
		#5$finish;
	end
      
endmodule

