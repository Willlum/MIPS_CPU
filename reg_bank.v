`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    08:12:42 03/10/2021 
// Design Name: 
// Module Name:    reg_32bit_bank 
// Project Name: 
//
//////////////////////////////////////////////////////////////////////////////////
module reg_bank(
    input 				  reset,
    input 			 		 clk,
	 input					we,
    input[4:0]		 read_reg_1,
    input[4:0]		 read_reg_2,
	 input[4:0]		 write_reg,
	 input[31:0]   write_data,
    output[31:0] read_data_1,
    output[31:0] read_data_2
    );
	 
	wire[31:0]  write_select;
	wire[31:0]   data[31:0];
	
	
	write_decoder decoder(.output_enable(write_select) , .reg_write(write_reg));

	general_reg #(0, 32) zero_reg (
					.data_in(0),
					.reset(reset),
					.clk(clk),
					.write_enable(we),
					.write_select(),
					.data_out(data[0])
				);

	 generate 
			genvar i;
			for(i=1;i<=31;i=i+1)begin: N // Block identifier	
				general_reg #(i+5, 32) registers (
					.data_in(write_data),
					.reset(reset),
					.clk(clk),
					.write_enable(we),
					.write_select(write_select[i-1]),
					.data_out(data[i])
				);
			end
		endgenerate
		
			
	assign read_data_1 = data[read_reg_1];
	assign read_data_2 = data[read_reg_2];
	
endmodule
module general_reg #(
							parameter VALUE = 0,
						   parameter DATA_WIDTH = 32
							)(
						 input[DATA_WIDTH-1:0] data_in,  
						 input reset,
						 input clk,
						 input write_enable,
						 input write_select,
						 output reg[DATA_WIDTH-1:0] data_out);
			
	   always @ (negedge clk, posedge reset) begin
			   if(reset) data_out <= VALUE;
			   else if (write_enable && write_select)data_out <= data_in;
		end		 	
endmodule

module write_decoder(output reg[31:0] output_enable , input[4:0] reg_write);
	always @ (reg_write) begin
		case(reg_write)
			5'h0: output_enable = 32'h0000_0000;
			5'h1: output_enable = 32'h0000_0001;
			5'h2: output_enable = 32'h0000_0002;
			5'h3: output_enable = 32'h0000_0004;
			5'h4: output_enable = 32'h0000_0008;
			5'h5: output_enable = 32'h0000_0010;
			5'h6: output_enable = 32'h0000_0020;
			5'h7: output_enable = 32'h0000_0040;
			5'h8: output_enable = 32'h0000_0080;
			5'h9: output_enable = 32'h0000_0100;
			5'ha: output_enable = 32'h0000_0200;
			5'hb: output_enable = 32'h0000_0400;
			5'hc: output_enable = 32'h0000_0800;
			5'hd: output_enable = 32'h0000_1000;
			5'he: output_enable = 32'h0000_2000;
			5'hf: output_enable = 32'h0000_4000;
			5'h10: output_enable = 32'h0000_8000;
			5'h11: output_enable = 32'h0001_0000;
			5'h12: output_enable = 32'h0002_0000;
			5'h13: output_enable = 32'h0004_0000;
			5'h14: output_enable = 32'h0008_0000;
			5'h15: output_enable = 32'h0010_0000;
			5'h16: output_enable = 32'h0020_0000;
			5'h17: output_enable = 32'h0040_0000;
			5'h18: output_enable = 32'h0080_0000;
			5'h19: output_enable = 32'h0100_0000;
			5'h1a: output_enable = 32'h0200_0000;
			5'h1b: output_enable = 32'h0400_0000;
			5'h1c: output_enable = 32'h0800_0000;
			5'h1d: output_enable = 32'h1000_0000;
			5'h1e: output_enable = 32'h2000_0000;
			5'h1f: output_enable = 32'h4000_0000;
		endcase
	end
endmodule
