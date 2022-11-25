module inst_mem(i_adr, o_dat);

	input 	[31:0]	i_adr;
	output	[31:0]	o_dat;
	
	reg 		[31:0]	rom [0:63];
	reg 		[31:0]	o_dat;

	initial begin
		//$readmemh("seq2_swlw.mem",rom, 0, 63);
		//$readmemh("lab08_seq1.mem",rom, 0, 63);
		//$readmemh("lab08_seq2.mem",rom, 0, 63);
		//$readmemh("lab08_seq3.mem",rom, 0, 63);
		//$readmemh("lab08_seq4.mem",rom, 0, 63);
		//$readmemh("bubble_sort.mem",rom, 0, 63);
	end

	always @(i_adr) begin
		o_dat <= rom[i_adr[7:2]];
	end
	
	
endmodule
