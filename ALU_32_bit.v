`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name:    ALU_32_bit
// Create Date:    08:39:37 02/19/2021 
//
//////////////////////////////////////////////////////////////////////////////////

module ALU_32_bit(input[31:0] a,input[31:0] b, input [3:0]opcode,
						output[31:0] result, output overflow, output zero);
	 
		wire [31:0]carry;
		wire carry_out;
					
		assign carry_out = carry[31];		
		//If result is zero then set flag to 1
		assign zero = (result) ? 0 : 1;
		//Cin and Cout of MSB adder 
		assign overflow = carry[31] ^ carry[30];
			
		//First bit outside of generate to init c_in value
		ALU_one_bit ALU(
					.result(result[0]),
					.c_out(carry[0]),
					.a(a[0]),
					.b(b[0]),
					//B-invert signal for subtracting
					.c_in(opcode[2]), 
					.opcode(opcode)
				);	
				
		generate 
			genvar i;
			for(i=1;i<=31;i=i+1)begin: M // Block identifier	
				ALU_one_bit ALU(
					.result(result[i]),
					.c_out(carry[i]),
					.a(a[i]),
					.b(b[i]),
					.c_in(carry[i-1]),
					.opcode(opcode)
				);
			end
		endgenerate
endmodule
