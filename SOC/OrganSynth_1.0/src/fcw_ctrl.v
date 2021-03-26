/*************************************************************************
 * Module name:		fcw_ctrl
 * Input arg(s):	Note value (legal: 1-88)
 * Output arg(s):	Note equivalents of the fundamental frequency and 
 *					overtones
 * Description:		Checks the value of the input note and produces the 
 *					note values of the corresponding sub-third and sub-
 *					fundamental frequencies, and the input note itself
 *************************************************************************/
`timescale 1ns / 1ps
 module fcw_ctrl(
	// port declarations
    input [6:0] note,
    output reg [6:0] fcw_sub_fund,
    output reg [6:0] fcw_sub_third,
    output reg [6:0] fcw_fund
    );

	// Sub-fundamental note offset: 12 semitones below the input note
    parameter SUB_FUND = 12;
	// Sub-third note offset: 7 semitones above the input note
    parameter SUB = 7;

    always @ (note) begin
		// Since the synthesizer is based on the grand piano, the legal 
		// inputs are between 1 and 88
        if (note >= 1 && note <= 88) begin
			// for all legal inputs, the fundamental note is the 
			// same as the input note
            fcw_fund = note;
			// To avoid hearing unnecessary noises, adjustments are made
			// for certain cases
            if (note < 13) begin
				// for notes lower than 13, the sub-fundamental harmonic
				// is removed
                fcw_sub_fund = 127;
                fcw_sub_third = note + SUB;
            end
            else if (note > 81) begin
				// for notes higher than 81, the sub-third harmonic
				// is removed
                fcw_sub_fund = note - SUB_FUND;
                fcw_sub_third = 127;
            end
            else begin
				// for all other cases, both overtone cases exist		
                fcw_sub_fund = note - SUB_FUND;
                fcw_sub_third = note + SUB;
            end
        end
		// For all inputs that are out of range, the notes are set to 
		// max value (silence)
        else begin
            fcw_sub_fund = 127;
            fcw_sub_third = 127;
            fcw_fund = 127;
        end
    end
    
endmodule