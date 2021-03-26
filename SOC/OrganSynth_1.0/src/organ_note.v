/*************************************************************************
 * Module name:		organ_note
 * Input arg(s):	Clock, reset, note
 * Output arg(s):	Synthesized wave output 
 * Description:		Tfop-level module for a single-note synthesizer
 *************************************************************************/
 `timescale 1ns / 1ps
module organ_note(
	// port declarations
    input clk, rst,
    input [6:0] note,
    output [17:0] wave_out
    );

	// internal signal declarations
    wire [6:0] fcw_sub_fund;
    wire [6:0] fcw_sub_third;
    wire [6:0] fcw_fund;
    wire [15:0] sub_fund;
    wire [15:0] sub_third;
    wire [15:0] fund;
    
	// frequency control word controller instantiation
    fcw_ctrl ctrl(.note(note), 
        .fcw_sub_fund(fcw_sub_fund), 
        .fcw_sub_third(fcw_sub_third), 
        .fcw_fund(fcw_fund)
        );
        
	// sub-fundamental DDS instantiation
    music_dds dds_sub_fund(.clk(clk), .rst(rst),
        .fcw_addr(fcw_sub_fund),
        .tri_out(sub_fund)
        );
    
	// sub-third DDS instantiation
    music_dds dds_sub_third(.clk(clk), .rst(rst),
        .fcw_addr(fcw_sub_third),
        .tri_out(sub_third)
        );

	// fundamental DDS instantiation
    music_dds dds_fund(.clk(clk), .rst(rst),
        .fcw_addr(fcw_fund),
        .tri_out(fund)
        );
        
	// tone generator instantiation
	tone_gen tone_gen(
        .sub_fund(sub_fund),
        .sub_third(sub_third),
        .fund(fund),
        .tone(wave_out)
        );
        
endmodule
