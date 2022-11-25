`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:43:17 04/12/2021 
// Design Name: 
// Module Name:    branch_hazard_unit 
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
module branch_hazard_unit(
			input[4:0] IDEX_rd,IFID_rs, IFID_rt,EXMEM_rd, MEMWB_rd, IDEX_rt,
			input branch, IDEX_reg_write, EXMEM_reg_write, MEMWB_reg_write, IDEX_mem_read, EXMEM_mem_read, ready,
			output reg[1:0] forwardRs, forwardRt,
			output reg pc_write,
			output reg IDEX_zero,
			output reg IFID_write
    );
	always @(*)begin
		if(IDEX_mem_read && ((IDEX_rt == IFID_rs) || (IDEX_rt == IFID_rt)))
		begin
				pc_write <= 0;
				IDEX_zero <= 1;
				IFID_write <= 0;
		end
		else if(branch && IDEX_reg_write && (IDEX_rd !=0) && (IDEX_rd == IFID_rs))
		begin
			pc_write <= 0;
			IDEX_zero <= 1;
			IFID_write <= 0;
		end
	 else if (branch && IDEX_reg_write && (IDEX_rd !=0) && (IDEX_rd == IFID_rt))
			begin
			pc_write <= 0;
			IDEX_zero <= 1;
			IFID_write <= 0;
		end
	 else if(branch && EXMEM_mem_read && ((EXMEM_rd == IFID_rs) || (EXMEM_rd == IFID_rt))) 
			begin
			pc_write <= 0;
			IDEX_zero <= 1;
			IFID_write <= 0;
		end
	 else if(!ready)begin // mem stall
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
	
	always@(*)begin
		if((EXMEM_reg_write) && (EXMEM_rd != 0) && (EXMEM_rd == IFID_rs)) 
			forwardRs = 2'b10;
		else if((MEMWB_reg_write && MEMWB_rd != 0) && 
	
		(MEMWB_rd == IFID_rs))
			forwardRs <= 2'b01;
		else
			forwardRs <= 2'b00;
	end
	
	always@(*)begin
		if((EXMEM_reg_write) && (EXMEM_rd != 0) && (EXMEM_rd == IFID_rt)) 
			forwardRt = 2'b10;
		else if((MEMWB_reg_write && MEMWB_rd != 0) && 
					(MEMWB_rd == IFID_rt))
			forwardRt <= 2'b01;
		else
			forwardRt <= 2'b00;
	end 
endmodule
