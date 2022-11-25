`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// 
// Create Date:    14:06:39 04/07/2021 
// Design Name: 
// Module Name:    control_unit 
// Project Name: 
//
//////////////////////////////////////////////////////////////////////////////////
module control_unit(input [5:0]opcode, 
						  output[1:0] ALUop, 
						  output reg_write,
						  output mem_read,
						  output mem_write,
						  output mem_to_reg,
						  output alu_source,
						  output reg_dest,
						  output branch
						  );

	wire nOp0,nOp1,nOp2,nOp3,nOp4,nOp5, r_format, lw, sw, beq;

	not(nOp0, opcode[0]);
	not(nOp1, opcode[1]);
	not(nOp2, opcode[2]);
	not(nOp3, opcode[3]);
	not(nOp4, opcode[4]);
	not(nOp5, opcode[5]);

	and(r_format,nOp0,nOp1,nOp2,nOp3,nOp4,nOp5);
	and(lw, opcode[0], opcode[1], nOp2, nOp3, nOp4, opcode[5]);
	and(sw, opcode[0], opcode[1], nOp2, opcode[3], nOp4, opcode[5]);
	and(beq, nOp0,nOp1,opcode[2],nOp3,nOp4,nOp5);
	or(reg_write, r_format, lw);
	or(alu_source,lw,sw);
	
	assign ALUop[1:0] = {r_format, beq};
	assign mem_read = lw;
	assign mem_write = sw;
	assign reg_dest = r_format;
	assign mem_to_reg = lw;
	assign branch = beq;

endmodule
