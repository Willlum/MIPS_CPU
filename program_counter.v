`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:11:33 04/07/2021 
// Design Name: 
// Module Name:    program_counter 
// Project Name: 
// Target Devices: 
//////////////////////////////////////////////////////////////////////////////////
module program_counter #(
	 parameter DATA_WIDTH = 32
	 )(
	 input clk,
	 input reset,
	 input pc_load,
    output[DATA_WIDTH-1:0] curAddress
    );

	 wire[DATA_WIDTH-1:0] nextAddress;
	 
	 	pipeline_reg #(DATA_WIDTH) pc_reg(
					.data_in(nextAddress),
					.reset(reset),
					.clk(clk),
					.write_enable(pc_load),
					.data_out(curAddress)
	 );
	 
	 ALU_32_bit adder(
		.a(curAddress),
		.b(4), //Add 4
		.opcode(4'b0010), //add opcode
		.result(nextAddress), 
		.overflow(), 
		.zero()
	 ); 
endmodule