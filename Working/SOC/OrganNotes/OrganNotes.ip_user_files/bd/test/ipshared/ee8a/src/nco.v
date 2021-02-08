`timescale 1ns / 1ps

module nco(
	input clk, rst,
	input [23:0] fcw,
    output reg [11:0] addr
	);

	parameter DIV = 28'd1024;
	reg fdiv_clk;
	reg [15:0] rom_memory [1023:0];
	reg [23:0] accum;
	reg [28:0] fdiv_cnt;

	// sampling frequency divider process (48kHz clock generator)
	always @ (posedge clk or negedge rst) begin
		if(!rst)
			fdiv_cnt <= 0;
		else if (fdiv_cnt < (DIV-1))
			fdiv_cnt <= fdiv_cnt +1;    
		else
			fdiv_cnt <= 0;
	end
	always @ (fdiv_cnt) fdiv_clk = (fdiv_cnt < (DIV/2)) ? 1'b0 : 1'b1;

	// phase accummulator process
	always @ (posedge fdiv_clk or negedge rst)
	begin
		if (!rst) 
			accum <= 0;
		else
			accum <= accum + fcw;
	end

	// to address the ROM, the 12 MSB's of the phase accummulator will be used
    always @ (accum or fcw) begin
        if (fcw == 0)
            addr = 12'hc00;
        else	   
            addr = accum[23:12];
    end
endmodule