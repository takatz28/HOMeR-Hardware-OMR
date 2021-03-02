module fcw_ctrl(
    input [6:0] note,
    output reg [6:0] fcw_sub_fund,
    output reg [6:0] fcw_sub_third,
    output reg [6:0] fcw_fund
//    output reg [23:0] fcw_octave
    );

    parameter SUB_FUND = 12;
    parameter SUB = 7;
//    parameter OCTAVE = 23;

    always @ (note) begin
        if (note >= 1 && note <= 88) begin
            fcw_fund = note;
//            if (note < 13) begin
//                fcw_sub_fund = 127;
//                fcw_sub_third = note + SUB;
//            end
//            else if (note > 81) begin
//                fcw_sub_fund = note - SUB_FUND;
//                fcw_sub_third = 127;
//            end
//            else begin
            fcw_sub_fund = note - SUB_FUND;
            fcw_sub_third = note + SUB;
//            end
//            fcw_octave = note + OCTAVE;
        end
        else begin
            fcw_sub_fund = 127;
            fcw_sub_third = 127;
            fcw_fund = 127;
//            fcw_octave = 0;
        end
    end
    
endmodule