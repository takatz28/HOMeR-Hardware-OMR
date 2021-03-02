module tone_gen(
    input [15:0] sub_fund,
    input [15:0] sub_third,
    input [15:0] fund,
//    input [15:0] octave,
    output reg [17:0] tone
);

    always @ (*)
        tone = (sub_fund >> 4) + (sub_third >> 4) + (fund << 1);
//        tone = (sub_fund >> 4) + (sub_third >> 2) + (octave >> 1) + (fund << 1);

endmodule