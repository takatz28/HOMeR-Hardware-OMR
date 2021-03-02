`timescale 1ns / 1ps

module harmonizer(
	input clk, rst,
	input [6:0] note_in7, note_in6, note_in5, note_in4,
	input [6:0] note_in3, note_in2, note_in1, note_in0,
	output [23:0] wave_out
	);
	
	wire [17:0] note7, note6, note5, note4;
	wire [17:0] note3, note2, note1, note0;
		
	organ_note N7(.clk(clk), .rst(rst), 
	   .note(note_in7), .wave_out(note7));

	organ_note N6(.clk(clk), .rst(rst),
	   .note(note_in6), .wave_out(note6));
	
	organ_note N5(.clk(clk), .rst(rst),
	   .note(note_in5), .wave_out(note5));
	
	organ_note N4(.clk(clk), .rst(rst),
	   .note(note_in4), .wave_out(note4));
	
	organ_note N3(.clk(clk), .rst(rst),
	   .note(note_in3), .wave_out(note3));
	
	organ_note N2(.clk(clk), .rst(rst),
	   .note(note_in2), .wave_out(note2));
	
	organ_note N1(.clk(clk), .rst(rst),
	   .note(note_in1), .wave_out(note1));
	
	organ_note N0(.clk(clk), .rst(rst),
	   .note(note_in0), .wave_out(note0));

    blender wav_blend(.clk(clk), .rst(rst),
        .note7(note7), .note6(note6), 
        .note5(note5), .note4(note4), 
        .note3(note3), .note2(note2), 
        .note1(note1), .note0(note0), 
        .wave_out(wave_out));

endmodule