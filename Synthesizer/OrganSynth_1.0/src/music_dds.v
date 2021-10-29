/*************************************************************************
 * Module name:		music_dds
 * Input arg(s):	Clock, reset, input note
 * Output arg(s):	Single triangle waveform output
 * Description:		Top-level module for a digital direct synthesizer
 *************************************************************************/
`timescale 1ns / 1ps
module music_dds(
	// port declarations
    input clk, rst,
    input [6:0] fcw_addr,
    output [15:0] tri_out
    );
    
	// internal signal declarations
    wire [23:0] fcw;
    wire [11:0] addr;

    // frequency control word ROM instantiation
    fcw_table fcw_lut(.fcw_addr(fcw_addr), .fcw(fcw));
    
    // numerically-controlled oscillator instantiation
    nco nco(.clk(clk), .rst(rst), .fcw(fcw), .addr(addr));
   
    // triangle values values ROM instantiation
    tri_table tri_lut(
        .tri_addr(addr), .tri_word(tri_out));

endmodule
