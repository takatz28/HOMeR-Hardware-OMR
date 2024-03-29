/*************************************************************************
 * Module name:		fcw_table
 * Input arg(s):	FCW address
 * Output arg(s):	Equivalent FCW
 * Description:		Lookup table for the frequency control word based on
 *					the input note
 *************************************************************************/
 `timescale 1ns / 1ps
module fcw_table(
	// port declarations
    input [6:0] fcw_addr,
    output reg [23:0] fcw
    );
    
    always @ (fcw_addr) begin
        case (fcw_addr)
            7'h01: fcw = 24'h00258b;
            7'h02: fcw = 24'h0027c7;
            7'h03: fcw = 24'h002a25;
            7'h04: fcw = 24'h002ca6;
            7'h05: fcw = 24'h002f4e;
            7'h06: fcw = 24'h00321e;
            7'h07: fcw = 24'h003519;
            7'h08: fcw = 24'h003841;
            7'h09: fcw = 24'h003b9a;
            7'h0a: fcw = 24'h003f25;
            7'h0b: fcw = 24'h0042e6;
            7'h0c: fcw = 24'h0046e0;
            7'h0d: fcw = 24'h004b17;
            7'h0e: fcw = 24'h004f8f;
            7'h0f: fcw = 24'h00544a;
            7'h10: fcw = 24'h00594d;
            7'h11: fcw = 24'h005e9c;
            7'h12: fcw = 24'h00643c;
            7'h13: fcw = 24'h006a32;
            7'h14: fcw = 24'h007083;
            7'h15: fcw = 24'h007734;
            7'h16: fcw = 24'h007e4a;
            7'h17: fcw = 24'h0085cd;
            7'h18: fcw = 24'h008dc1;
            7'h19: fcw = 24'h00962f;
            7'h1a: fcw = 24'h009f1e;
            7'h1b: fcw = 24'h00a894;
            7'h1c: fcw = 24'h00b29a;
            7'h1d: fcw = 24'h00bd39;
            7'h1e: fcw = 24'h00c879;
            7'h1f: fcw = 24'h00d465;
            7'h20: fcw = 24'h00e106;
            7'h21: fcw = 24'h00ee68;
            7'h22: fcw = 24'h00fc95;
            7'h23: fcw = 24'h010b9a;
            7'h24: fcw = 24'h011b83;
            7'h25: fcw = 24'h012c5f;
            7'h26: fcw = 24'h013e3c;
            7'h27: fcw = 24'h015128;
            7'h28: fcw = 24'h016534;
            7'h29: fcw = 24'h017a72;
            7'h2a: fcw = 24'h0190f3;
            7'h2b: fcw = 24'h01a8ca;
            7'h2c: fcw = 24'h01c20d;
            7'h2d: fcw = 24'h01dcd0;
            7'h2e: fcw = 24'h01f92a;
            7'h2f: fcw = 24'h021734;
            7'h30: fcw = 24'h023707;
            7'h31: fcw = 24'h0258bf;
            7'h32: fcw = 24'h027c78;
            7'h33: fcw = 24'h02a250;
            7'h34: fcw = 24'h02ca69;
            7'h35: fcw = 24'h02f4e4;
            7'h36: fcw = 24'h0321e6;
            7'h37: fcw = 24'h035195;
            7'h38: fcw = 24'h03841a;
            7'h39: fcw = 24'h03b9a0;
            7'h3a: fcw = 24'h03f254;
            7'h3b: fcw = 24'h042e68;
            7'h3c: fcw = 24'h046e0e;
            7'h3d: fcw = 24'h04b17e;
            7'h3e: fcw = 24'h04f8f0;
            7'h3f: fcw = 24'h0544a1;
            7'h40: fcw = 24'h0594d2;
            7'h41: fcw = 24'h05e9c9;
            7'h42: fcw = 24'h0643cd;
            7'h43: fcw = 24'h06a32b;
            7'h44: fcw = 24'h070834;
            7'h45: fcw = 24'h07733f;
            7'h46: fcw = 24'h07e4aa;
            7'h47: fcw = 24'h085cd0;
            7'h48: fcw = 24'h08dc1e;
            7'h49: fcw = 24'h0962fc;
            7'h4a: fcw = 24'h09f1e1;
            7'h4b: fcw = 24'h0a8941;
            7'h4c: fcw = 24'h0b29a4;
            7'h4d: fcw = 24'h0bd392;
            7'h4e: fcw = 24'h0c879a;
            7'h4f: fcw = 24'h0d4657;
            7'h50: fcw = 24'h0e1069;
            7'h51: fcw = 24'h0ee682;
            7'h52: fcw = 24'h0fc955;
            7'h53: fcw = 24'h10b9a1;
            7'h54: fcw = 24'h11b83c;
            7'h55: fcw = 24'h12c5f9;
            7'h56: fcw = 24'h13e3c0;
            7'h57: fcw = 24'h151287;
            7'h58: fcw = 24'h16534c;
            default: fcw = 24'h000000;         
        endcase    
    end
endmodule
