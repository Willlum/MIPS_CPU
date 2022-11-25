`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:51:53 04/07/2021
// Design Name:   program_counter
// Module Name:   /home/ise/VM_Shared/ece483_L7_gallagher/pc_tb.v
// Project Name:  ece483_L7_gallagher
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: program_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pc_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] curAddress;

	// Instantiate the Unit Under Test (UUT)
	program_counter uut (
		.clk(clk), 
		.reset(reset), 
		.curAddress(curAddress)
	);
	reg [7:0] clk_count = 'd0;

	always @ ( posedge clk) clk_count <= clk_count + 1'd1;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100$finish;
        
		// Add stimulus here

	end
   initial begin
		#1 reset = 0;
		forever begin
			#5 clk = !clk;
		end
	end   
endmodule

