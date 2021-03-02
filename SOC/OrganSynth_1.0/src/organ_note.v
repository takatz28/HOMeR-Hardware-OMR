`timescale 1ns / 1ps

module organ_note(
    input clk, rst,
    input [6:0] note,
    output [17:0] wave_out
    );
    
    wire [6:0] fcw_sub_fund;
    wire [6:0] fcw_sub_third;
    wire [6:0] fcw_fund;
//    wire [23:0] fcw_octave;
    wire [15:0] sub_fund;
    wire [15:0] sub_third;
    wire [15:0] fund;
//    wire [15:0] octave;
    
    fcw_ctrl ctrl(.note(note), 
        .fcw_sub_fund(fcw_sub_fund), 
        .fcw_sub_third(fcw_sub_third), 
        .fcw_fund(fcw_fund)
//        .fcw_octave(fcw_octave)
        );
        
    music_dds dds_sub_fund(.clk(clk), .rst(rst),
        .fcw_addr(fcw_sub_fund),
        .sine_out(sub_fund)
        );
    
    music_dds dds_sub_third(.clk(clk), .rst(rst),
        .fcw_addr(fcw_sub_third),
        .sine_out(sub_third)
        );

    music_dds dds_fund(.clk(clk), .rst(rst),
        .fcw_addr(fcw_fund),
        .sine_out(fund)
        );

//    music_dds dds_octave(.clk(clk), .rst(rst),
//        .fcw_addr(fcw_octave),
//        .sine_out(octave)
//        );
        
    tone_gen tone_gen(
        .sub_fund(sub_fund),
        .sub_third(sub_third),
        .fund(fund),
//        .octave(octave),
        .tone(wave_out)
        );
        
endmodule
