`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:52:25 04/08/2021
// Design Name:   Hazard_Unit
// Module Name:   /home/ise/VM_Shared/ece483_L7_gallagher/haz_tb.v
// Project Name:  ece483_L7_gallagher
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Hazard_Unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module haz_tb;

	// Inputs
	reg mem_read;
	reg [4:0] rt1;
	reg [4:0] rt2;
	reg [4:0] rs1;
	reg clk;
	// Outputs
	wire pc_write;
	wire IDEX_zero;
	wire IFID_write;

	// Instantiate the Unit Under Test (UUT)
	Hazard_Unit uut (
		.mem_read(mem_read), 
		.rt1(rt1), 
		.rt2(rt2), 
		.rs1(rs1), 
		.clk(clk),
		.pc_write(pc_write), 
		.IDEX_zero(IDEX_zero), 
		.IFID_write(IFID_write)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		mem_read = 0;
		rt1 = 0;
		rt2 = 0;
		rs1 = 0;
		#10
		mem_read = 1;
		rt1 = 1;
		rt2 = 2;
		rs1 = 3;
		#10		
		rt1 = 1;
		rt2 = 1;
		rs1 = 0;
		#10
		rt1 = 1;
		rt2 = 0;
		rs1 = 0;
		#10
		rt1 = 1;
		rt2 = 0;
		rs1 = 1;
		// Wait 100 ns for global reset to finish
		#100$finish;
        
		// Add stimulus here

	end
    initial begin
		forever begin
			#5 clk = !clk;
		end
	end    
endmodule

