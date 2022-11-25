`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:35:02 04/08/2021
// Design Name:   Mips_Five_Stage_Pipeline
// Module Name:   /home/ise/VM_Shared/ece483_L7_gallagher/mips_tb.v
// Project Name:  ece483_L7_gallagher
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mips_Five_Stage_Pipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_tb;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	Mips_Five_Stage_Pipeline uut (
		.clk(clk), 
		.reset(reset)
	);
	 real clk_count = 0.0;
	 real instruction_count = 0.0;
	
	always @ ( posedge clk) clk_count <= clk_count + 1'd1;
	always @ (posedge clk)begin
			if((uut.reg_write || uut.mem_read || uut.mem_write || uut.branch) && (uut.pc_write)/*stall*/) 
				instruction_count = instruction_count + 1;
		end
	always @(posedge clk)begin
		if(uut.regFile.N[9].registers.data_out== 1)begin
			$display("Cycles: %d, Instructions: %d\n",clk_count, instruction_count);
			$display("CPI: %f\n",clk_count/instruction_count);
			$finish;
		end
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		#2 reset = 0;
	end
	
	initial begin
		forever begin
			#5 clk = !clk;
		end
	end
	

endmodule

