`timescale 1ns / 1ps

module music_dds(
    input clk, rst,
    input [6:0] fcw_addr,
    output [15:0] sine_out
    );
    
    wire [23:0] fcw;
    wire [11:0] addr;

    // frequency control word ROM instantiation
    fcw_table fcw_lut(.fcw_addr(fcw_addr), .fcw(fcw));
    
    //  numerically-controlled oscillator instantiation
    nco nco(.clk(clk), .rst(rst), .fcw(fcw), .addr(addr));
   
    // sine values ROM instantiation
    tri_table tri_lut(
        .tri_addr(addr), .tri_word(sine_out));


endmodule
