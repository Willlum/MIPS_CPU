`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// 
//
// Create Date:    07:27:34 03/10/2021 
// Design Name:    Mips_Five_Stage_Pipeline
//
//////////////////////////////////////////////////////////////////////////////////
module Mips_Five_Stage_Pipeline#(parameter DATA_WIDTH = 32)(
    input clk,
	 input reset
    );
		
	localparam IFID_WIDTH = 64;
	localparam IDEX_WIDTH = 124;
	localparam EXMEM_WIDTH = 73;
	localparam MEMWB_WIDTH = 70;
	
	localparam CONTROL_WIDTH = 9;
	// Hazard unit
	wire pc_write;
	wire IFID_write;
	wire IDEX_zero;
	//Control unit
	wire [3:0]ALUctl;
	wire [1:0]ALUop;
	wire alu_source,reg_dest,mem_write,mem_read,reg_write,mem_to_reg,branch;
	// IFID
	wire [DATA_WIDTH-1:0]IFID_read_data_1, IFID_read_data_2, ALU_result,IFID_nextAddress;
	wire[4:0] rs,rt,rd;
	wire[5:0] opcode, func;
	wire[DATA_WIDTH-1:0] signExtendedData;
	wire[15:0] immediate; 
	wire [IFID_WIDTH-1:0] IFID_out;
	//	IDEX
   wire [IDEX_WIDTH-1:0] IDEX_out;
	wire[5:0] IDEX_func;
	wire[DATA_WIDTH-1:0] IDEX_read_data_1,IDEX_read_data_2, IDEX_signExtendedData;
	wire[4:0] IDEX_rs, IDEX_rd,IDEX_rt; 
	wire[1:0] IDEX_ALUop;
	wire IDEX_reg_write,IDEX_reg_dest,IDEX_alu_source,IDEX_mem_to_reg,IDEX_mem_write,IDEX_mem_read,IDEX_branch;
	wire[1:0] forwardA, forwardB;
	// EXMEM
	wire [EXMEM_WIDTH-1:0] EXMEM_out;
	wire[DATA_WIDTH-1:0] EXMEM_write_data,EXMEM_forwardB_result,EXMEM_signExtendedData;
	wire[4:0] EXMEM_rd; 
	wire EXMEM_reg_write,EXMEM_mem_write,EXMEM_mem_read,EXMEM_branch;
	//MEMWB
	wire[DATA_WIDTH-1:0] MEMWB_write_data;
	wire[4:0] MEMWB_rd; 
	wire [MEMWB_WIDTH-1:0] MEMWB_out;
	wire[DATA_WIDTH-1:0] MEMWB_from_data_mem;
   wire MEMWB_mem_to_reg;		
	wire MEMWB_reg_write;
	wire[DATA_WIDTH-1:0] data_from_MEMWB;
	
	wire [DATA_WIDTH-1:0] instMemToIFID;
	wire[DATA_WIDTH-1:0] pc_or_branch,nextAddress,PCorBranchMux_out;
	wire[DATA_WIDTH-1:0] forwardRs_result, forwardRt_result;
	wire branch_taken;
	wire[1:0] forwardRs, forwardRt;
	wire[DATA_WIDTH-1:0] jump_address, IFID_shifted_data;
	
	wire cache_ready,valid_mem, mem_ready,cache_hit;
	wire[127:0] data_to_mem, inst_mem_out;
	wire[31:0] address_to_mem,data_to_cpu,address_to_cache;
	
	mux_2_to_1 #(32) PCorBranch(.result(PCorBranchMux_out),.select(branch && branch_taken),.in0(nextAddress),.in1(jump_address));
	pipeline_reg #(32) PC(.data_in(PCorBranchMux_out),.data_out(address_to_cache),.write_enable(pc_write),.reset(reset),.clk(clk));
	Adder #(32)A(.out(nextAddress),.in0(address_to_cache),.in1(4),.clk(clk)); 
	
/*	mips_cache #(32) L1_cache_32(
					.clock(clk),
					.reset(reset),
					//cpu to cache interface
					.address_from_cpu(address_to_cache),
					.valid_cache(!valid_mem),
					.cache_ready(cache_ready),
				   .data_from_cpu(),
	            .data_to_cpu(data_to_cpu),
					//cache to memory interface
					.mem_ready(ready),
					.data_from_mem(inst_mem_out),
				   .address_to_mem(address_to_mem),
					.valid_mem(valid_mem),
					.data_to_mem(),
					.cache_hit(cache_hit)
    );*/
	 
 	mips_cache_128 #(32) L1_cache_128(
					.clock(clk),
					.reset(reset),
					//cpu to cache interface
					.address_from_cpu(address_to_cache),
					.valid_cache(!valid_mem),
					.cache_ready(cache_ready),
				   .data_from_cpu(),
	            .data_to_cpu(data_to_cpu),
					//cache to memory interface
					.mem_ready(ready),
					.data_from_mem(inst_mem_out),
				   .address_to_mem(address_to_mem),
					.valid_mem(valid_mem),
					.data_to_mem(),
					.cache_hit(cache_hit)
    );
	 
	mem_128b_256B inst_mem(
					//.in(),
					.address(address_to_mem),
					.valid(valid_mem),
					.write(1'b0),
					.out(inst_mem_out),
					.ready(ready),
					.clock(clk),
					.reset(reset)
					);
					
	wire[IFID_WIDTH-1:0]IFID_in = {nextAddress, data_to_cpu};						

/* START IF/ID Register */
	pipeline_reg #(IFID_WIDTH) IFID_Reg(
					.data_in(IFID_in),
					.reset(reset),
					.zero((branch && branch_taken) && (pc_write)/*!stall*/),
					.clk(clk),
					.write_enable(IFID_write), //From Hazard Unit
					.data_out(IFID_out)
	);
	
	assign immediate = IFID_out[15:0];
	assign opcode = IFID_out[31:26];
	assign rs = IFID_out[25:21];
	assign rt = IFID_out[20:16];
	assign rd = IFID_out[15:11];
	assign func = IFID_out[5:0];
	assign IFID_nextAddress = IFID_out[63:32];
/* END IF/ID Register */
 
	sign_extender signExtenderUnit(.in(immediate),.out(signExtendedData));
	shifter_unit shifter(.sign_extended_data(signExtendedData),.sign_shifted_data(IFID_shifted_data));
	Adder addressCalculator(.out(jump_address),.in0(IFID_nextAddress),.in1(IFID_shifted_data),.clk(clk));
	
	control_unit ctlUnit(
		.opcode(opcode), 
		.ALUop(ALUop),
		.reg_write(reg_write),
		.reg_dest(reg_dest),
		.alu_source(alu_source),
		.mem_to_reg(mem_to_reg),
		.mem_write(mem_write),
		.mem_read(mem_read),
		.branch(branch)
		);
		
	branch_hazard_unit branchHazard(
		.ready(cache_ready && cache_hit),
		.IDEX_rd(IDEX_rd),
		.IDEX_rt(IDEX_rt),
		.IFID_rs(rs),
		.IFID_rt(rt),
		.EXMEM_rd(EXMEM_rd),
		.MEMWB_rd(MEMWB_rd),
		.branch(branch), 
		.IDEX_reg_write(IDEX_reg_write),
		.EXMEM_reg_write(EXMEM_reg_write),
		.MEMWB_reg_write(MEMWB_reg_write),
		.IDEX_mem_read(IDEX_mem_read),
		.EXMEM_mem_read(EXMEM_mem_read),
		.forwardRs(forwardRs), 
		.forwardRt(forwardRt),
		.pc_write(pc_write),
		.IDEX_zero(IDEX_zero),
		.IFID_write(IFID_write)
    );
	
	wire[CONTROL_WIDTH-1:0] zeroIDEXmux_in = {branch,ALUop,reg_write,reg_dest,alu_source,mem_to_reg,mem_write,mem_read};
	wire[CONTROL_WIDTH-1:0] zeroIDEXmux_out;
	
	mux_2_to_1 #(CONTROL_WIDTH) zeroIDEXmux(.result(zeroIDEXmux_out),.select(IDEX_zero),.in0(zeroIDEXmux_in),.in1(0));
	
	reg_bank regFile(
		.reset(reset),
		.clk(clk),
		.we(MEMWB_reg_write),
		.read_reg_1(rs),
		.read_reg_2(rt),
	   .write_reg(MEMWB_rd),
		.write_data(data_from_MEMWB),
		.read_data_1(IFID_read_data_1),
		.read_data_2(IFID_read_data_2)
    );
	 
	 mux_4_to_1#(32)forwardRsMux(.result(forwardRs_result),.select(forwardRs),.in0(IFID_read_data_1),.in1(data_from_MEMWB),.in2(EXMEM_write_data));
	 mux_4_to_1#(32)forwardRtMux(.result(forwardRt_result),.select(forwardRt),.in0(IFID_read_data_2),.in1(data_from_MEMWB),.in2(EXMEM_write_data));
	 comparison_unit comparator(forwardRs_result,forwardRt_result,branch_taken);
	
	
/* START ID/EX Register */	       
	wire [IDEX_WIDTH-1:0] IDEX_in = {
		 rs,//123-119
		 rt,//118-114
		 zeroIDEXmux_out[4],//113
		 zeroIDEXmux_out[3],//112
		 zeroIDEXmux_out[2],//111
		 zeroIDEXmux_out[1],//110
		 zeroIDEXmux_out[0],//109
		 signExtendedData,//108-78
		 func,//77-72
		 IFID_read_data_1, //71-40 
		 IFID_read_data_2, //39-8 
		 rd,//7-3
		 zeroIDEXmux_out[7:6],//2-1
		 zeroIDEXmux_out[5]//0
		 };


	pipeline_reg #(IDEX_WIDTH) IDEX_Reg(
		.data_in(IDEX_in),
		.reset(reset),
		.clk(clk),
		.write_enable(1'b1),
		.data_out(IDEX_out)
	);
	
	assign {
		  IDEX_rs,
		  IDEX_rt,
		  IDEX_reg_dest,
		  IDEX_alu_source,
		  IDEX_mem_to_reg,
		  IDEX_mem_write,
		  IDEX_mem_read,
		  IDEX_signExtendedData,
		  IDEX_func,
		  IDEX_read_data_1,
		  IDEX_read_data_2,
		  IDEX_rd,
		  IDEX_ALUop,
		  IDEX_reg_write
			 } = IDEX_out;
/* END ID/EX Register */
	wire[DATA_WIDTH-1:0] alu_souce_select;
	wire[4:0] reg_dest_select;
	wire[DATA_WIDTH-1:0] forwardA_result,forwardB_result;

	
	alu_control aluCtl(.func(IDEX_func), .ALUop(IDEX_ALUop),.ALUctl(ALUctl));
	
	mux_2_to_1#(5) RegDestMux (.result(reg_dest_select),.select(IDEX_reg_dest),.in0(IDEX_rt), .in1(IDEX_rd));
	
	mux_4_to_1#(32)forwardAMux(.result(forwardA_result),.select(forwardA),.in0(IDEX_read_data_1),.in1(data_from_MEMWB),.in2(EXMEM_write_data));
	mux_4_to_1#(32)forwardBMux(.result(forwardB_result),.select(forwardB),.in0(IDEX_read_data_2),.in1(data_from_MEMWB),.in2(EXMEM_write_data));
	mux_2_to_1#(32)AluSourceMux(.result(alu_souce_select),.select(IDEX_alu_source),.in0(forwardB_result), .in1(IDEX_signExtendedData));
	
	fowarding_unit fowardingUnit(
		  .forwardA(forwardA), 
		  .forwardB(forwardB), 
		  .rs_IDEX(IDEX_rs),
		  .rt_IDEX(IDEX_rt),
		  .rd_EXMEM(EXMEM_rd),
		  .rd_MEMWB(MEMWB_rd),
		  .reg_write_EXMEM(EXMEM_reg_write), 
		  .reg_write_MEMWB(MEMWB_reg_write), 
		  .clk(clk)
											);

	ALU_32_bit mipsALU(
		.a(forwardA_result),
		.b(alu_souce_select),
		.opcode(ALUctl),
		.result(ALU_result), 
		.overflow(), 
		.zero()
	 );
	 
/* Start EX/MEM  Register */
	wire [EXMEM_WIDTH-1:0] EXMEM_in = {
									IDEX_mem_to_reg,//72
									IDEX_mem_write,//71
									IDEX_mem_read,//70
									forwardB_result,//69-38
									ALU_result, //37-6
									reg_dest_select,//5-1
									IDEX_reg_write //0
										};
	
	
	pipeline_reg #(EXMEM_WIDTH) EXMEM_Reg(
		.data_in(EXMEM_in),
		.reset(reset),
		.clk(clk),
		.write_enable(1'b1),
		.data_out(EXMEM_out)
	);
	
	assign {
			  EXMEM_mem_to_reg,
			  EXMEM_mem_write,
			  EXMEM_mem_read,
			  EXMEM_forwardB_result,
			  EXMEM_write_data,
			  EXMEM_rd,
			  EXMEM_reg_write
			  } = EXMEM_out;	 
/* End EX/MEM  Register */

	wire[DATA_WIDTH-1:0] data_mem_to_MEMWB;
	
	data_mem dataMemory(
		.i_adr(EXMEM_write_data), 
		.i_dat(EXMEM_forwardB_result),
	   .o_dat(data_mem_to_MEMWB),
	   .R(EXMEM_mem_read),
	   .W(EXMEM_mem_write)
								);

/* Start MEM/WB Register */
	wire [MEMWB_WIDTH-1:0] MEMWB_in = {
									  data_mem_to_MEMWB,
									  EXMEM_mem_to_reg,
									  EXMEM_write_data, 
									  EXMEM_rd, 
									  EXMEM_reg_write
									 };
	
	
	pipeline_reg #(MEMWB_WIDTH) MEMWB_Reg(
					.data_in(MEMWB_in),
					.reset(reset),
					.clk(clk),
					.write_enable(1'b1),
					.data_out(MEMWB_out)
	);
	
	assign {
			  MEMWB_from_data_mem,
			  MEMWB_mem_to_reg,
			  MEMWB_write_data, 
			  MEMWB_rd,
			  MEMWB_reg_write
			  } = MEMWB_out;
/* End MEM/WB Register */ 
	mux_2_to_1#(32) memToRegMux(.result(data_from_MEMWB),.select(MEMWB_mem_to_reg),.in0(MEMWB_write_data), .in1(MEMWB_from_data_mem));
endmodule

module pipeline_reg #(parameter REG_WIDTH = 0)(data_in,data_out,write_enable,clk,reset,zero);

	output reg [REG_WIDTH-1:0] data_out;
	input [REG_WIDTH-1:0]data_in;
	input clk,reset,write_enable,zero;
	
	always @ (posedge clk, posedge reset)
	begin
		if(reset || zero)
			data_out <= 0;
		else if(write_enable)	
			data_out <= data_in;
	end
endmodule