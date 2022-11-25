`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// Dan Hauer 2020
// ECE 483 - Advanced Digital Systems Engineering
// Southern Illinois University at Edwardsville
//
////////////////////////////////////////////////////////////////////////////////

module mem_128b_256B(
	input [31:0] 	address,
	input 			valid,
	input				write,
	input [127:0] 	in,
	output reg [127:0]	out,
	output 			ready,
	input				clock,
	input				reset
	);

	reg [3:0] count;
	wire restart_count;
	localparam COUNT_INI = 8;
   
	reg [31:0] memory [0:63];
	
	initial begin
		$readmemh("bubble_sort.mem",memory, 0, 63);
		//$readmemh("lab08_seq1.mem",memory, 0, 63);
		//$readmemh("lab08_seq2.mem",memory, 0, 63);
		//$readmemh("lab08_seq3.mem",memory, 0, 63);
		//$readmemh("lab08_seq4.mem",memory, 0, 63);
	   //$readmemh("seq1_rtype.mem",memory, 0, 63);
		//$readmemh("seq2_swlw.mem",memory, 0, 63);
	end

	

	reg [31:0] 	address_latched;
	reg [127:0]	in_latched;
	reg			write_latched;

	reg [2:0] state, next_state;
	
	parameter STATE_IDLE = 0, STATE_WAIT = 1, STATE_OUT = 2;

   always @ (posedge clock, posedge reset)
      if (reset) begin
			state <= STATE_IDLE;    // Initialize to state STATE_IDLE
			count <= 0;
			address_latched <= 0;
			write_latched <= 0;
			out <= 128'hx;
		end
		else begin
			state <= next_state;   // Clocked operations
			if (restart_count) count <= COUNT_INI;
			else count <= count - 1;
			
			if (state == STATE_IDLE) begin
				address_latched <= address[31:2];
				write_latched <= write;
				in_latched <= in;
			end
			
			if (next_state == STATE_OUT) begin
				if (write_latched) begin
					{memory[address_latched+3], memory[address_latched+2],
					 memory[address_latched+1], memory[address_latched  ]} <= in_latched;
					 out <= in_latched;
				end
				else out <= {memory[address_latched+3], memory[address_latched+2],
				             memory[address_latched+1], memory[address_latched  ]};
			end
		end
	
	assign restart_count = (state!=STATE_WAIT);
	assign ready = (state==STATE_OUT);
	
	always @ (state or valid or count)        // Determine next state
		case (state)		
			STATE_IDLE: begin
								if (valid) next_state = STATE_WAIT;
								else next_state = STATE_IDLE;
							end
					
			STATE_WAIT: begin
								if (count==4'h0) next_state = STATE_OUT;
								else next_state = STATE_WAIT;
							end

			STATE_OUT: 	begin
								next_state = STATE_IDLE;			
							end
			default: 	next_state = STATE_IDLE;
		endcase
		
endmodule