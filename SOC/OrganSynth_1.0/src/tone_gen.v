/*************************************************************************
 * Module name:		tone_gen
 * Input arg(s):	fundamental, sub-fundamental, and sub-third waveform
 *					samples
 * Output arg(s):	sum of samples
 * Description:		Function that produces an organ-like waveform sample
 *************************************************************************/
 module tone_gen(
	// port declarations
    input [15:0] sub_fund,
    input [15:0] sub_third,
    input [15:0] fund,
    output reg [17:0] tone
);

    always @ (*)
		// Adds the three frequency samples to add timbre to the tone
		// - the overtones are shifted right so that they won't 
		// - overpower the fundamental sound
        tone = (sub_fund >> 4) + (sub_third >> 4) + (fund << 1);

endmodule