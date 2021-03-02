`timescale 1ns / 1ps

module blender(
    input clk, rst,
    input [17:0] note7, note6, note5, note4,
    input [17:0] note3,note2, note1, note0,
    output reg [23:0] wave_out
    );
    
    reg [23:0] wave_tmp;
    
    always @ (*)
        wave_tmp = note7 + note6 + note5 + note4 + note3 + note2 + note1 + note0;
        
    always @ (posedge clk or negedge rst)
    begin
        if (!rst) wave_out <= 0;
        else wave_out <= (wave_tmp << 3);
    end
    
endmodule
