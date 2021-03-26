/*************************************************************************
 * Module name:		nco
 * Input arg(s):	clock, reset, frequency control word
 * Output arg(s):	ROM address
 * Description:		Numerically-controlled oscillator that generates the 
 *					address values for the triangle waveform lookup table
 *************************************************************************/
 `timescale 1ns / 1ps
module nco(
	input clk, rst,
	input [23:0] fcw,
    output reg [11:0] addr
	);

	// Scaling factor to produce a 48kHz to match audio codec sampling 
	// frequency
	parameter DIV = 28'd1024;
	
	// internal signal declarations
	reg fdiv_clk;
	reg [23:0] accum;
	reg [28:0] fdiv_cnt;

	// Sampling frequency divider process (48kHz clock generator)
	always @ (posedge clk or negedge rst) begin
		if(!rst)
			fdiv_cnt <= 0;
		else if (fdiv_cnt < (DIV-1))
			fdiv_cnt <= fdiv_cnt +1;    
		else
			fdiv_cnt <= 0;
	end
	always @ (fdiv_cnt) fdiv_clk = (fdiv_cnt < (DIV/2)) ? 1'b0 : 1'b1;

	// Phase accummulator process
	always @ (posedge fdiv_clk or negedge rst)
	begin
		if (!rst) 
			accum <= 0;
		else
			accum <= accum + fcw;
	end

	// To address the ROM, the 12 MSB's of the phase accummulator 
	// will be used
    always @ (accum or fcw) begin
        if (fcw == 0)
            addr = 12'h000;
        else	   
            addr = accum[23:12];
    end
	
endmodule