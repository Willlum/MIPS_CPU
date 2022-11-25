`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:33:02 04/15/2021 
// Design Name: 
// Module Name:    mips_cache 
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
module mips_cache#(parameter DATA_WIDTH = 32)(
	input				clock,
	input				reset,
	//cpu interface
	input [31:0] 	address_from_cpu,
	input 			valid_cache,
	input[31:0]		data_from_cpu,
	output reg		cache_ready,
	output reg [31:0]	data_to_cpu,
	//memory interface
	input 				mem_ready,
	input [127:0] 	data_from_mem,
	output[127:0] 	data_to_mem,
	output[31:0]	address_to_mem,
	output reg			valid_mem,
	output cache_hit
    );

	`define CLOG2(x) \
	 (x <= 2) ? 1 : \
	 (x <= 4) ? 2 : \
	 (x <= 8) ? 3 : \
	 (x <= 16) ? 4 : \
	 (x <= 32) ? 5 : \
	 (x <= 64) ? 6 : \
	 -1
	 
   localparam CACHE_DEPTH = 4;
	localparam BYTE_OFFSET_BITS = 2;
	localparam CACHE_INDEX_BITS = `CLOG2(CACHE_DEPTH);
	
	localparam   STATE_IDLE 		   = 2'b00,
					 STATE_COMPARE_TAG	= 2'b01,
					 STATE_ALLOCATE	   = 2'b10,
					 STATE_WRITE_BACK	   = 2'b11;

	reg [1:0] state, next_state;
	reg cache_valid [CACHE_DEPTH-1:0];
	reg cache_dirty [CACHE_DEPTH-1:0];
	reg [(DATA_WIDTH-CACHE_INDEX_BITS-BYTE_OFFSET_BITS-1):0] cache_tag[CACHE_DEPTH-1:0];
	reg [DATA_WIDTH-1:0] cache_data[CACHE_DEPTH-1:0];
	
	wire[(DATA_WIDTH-CACHE_INDEX_BITS-BYTE_OFFSET_BITS)-1:0] addr_tag = address_from_cpu[DATA_WIDTH-1:CACHE_INDEX_BITS+BYTE_OFFSET_BITS];
	wire[CACHE_INDEX_BITS-1:0] addr_index = address_from_cpu[DATA_WIDTH-CACHE_INDEX_BITS-BYTE_OFFSET_BITS-1:BYTE_OFFSET_BITS];

   integer i;
   always @ (negedge reset) begin
        for (i = 0; i < CACHE_DEPTH; i = i+1) begin
            cache_valid[i] = 0;
				cache_dirty[i] = 0;
				cache_tag[i] = 0;
        end
   end
	
	assign address_to_mem = address_from_cpu;
	assign cache_hit = ((addr_tag == cache_tag[addr_index]) && cache_valid[addr_index]);
	
	always@(negedge clock, posedge reset)begin 
		if(reset) 
			begin
				state <= STATE_IDLE;
				valid_mem <= 1'b0;
				cache_ready <= 1'b1;
			end
		else begin
			state <= next_state;
			if(state==STATE_IDLE)begin
			end
			else if(state==STATE_COMPARE_TAG)begin
				if(cache_hit && valid_cache) begin
					data_to_cpu <= cache_data[addr_index];
				end
				
			end
			else if(state==STATE_ALLOCATE) begin
				if(mem_ready) begin
					cache_valid[addr_index] <= 1'b1;
					cache_tag[addr_index] <= addr_tag;
					cache_data[addr_index]<= data_from_mem[31:0];
					data_to_cpu <= data_from_mem[31:0];
				end 
			end
		end	
	end
		
	always @ (*) begin
			case(state)
			  STATE_IDLE:
					begin
						if(valid_cache)begin
							next_state <= STATE_COMPARE_TAG;
							cache_ready <= 1'b0;
							valid_mem <= 1'b0;
						end
						else begin
							next_state <= STATE_IDLE;
							cache_ready <= 1'b1;
							valid_mem <= 1'b0;
						end
					end
			  STATE_COMPARE_TAG:
					begin
						if(cache_hit)begin
							next_state <= STATE_IDLE;
							cache_ready <= 1'b1;
							valid_mem <= 1'b0;
						end
						else if(!cache_hit)begin
							next_state <= STATE_ALLOCATE;
							cache_ready <= 1'b0;
							valid_mem <= 1'b1;
						end
						else if(cache_dirty[addr_index] && cache_hit) next_state <= STATE_WRITE_BACK;
					end
			   STATE_ALLOCATE:
					begin
						if(mem_ready)begin
								next_state <= STATE_COMPARE_TAG;
								cache_ready <= 1'b0;
								valid_mem <= 1'b0;
							end
						else begin
							next_state <= STATE_ALLOCATE;
							valid_mem <= 1'b1;
							cache_ready <= 1'b0;
						end
					end
				STATE_WRITE_BACK:
					begin
						if(mem_ready) next_state <= STATE_ALLOCATE;
						else  		  next_state <= STATE_WRITE_BACK;
					end
			endcase
		end
endmodule
