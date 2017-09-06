`timescale 1ns / 1ps
module BCD_decoder(
    input BCD,
    output [7:0] result
    );
    reg [7:0] result;
    always @(BCD)
    case (BCD) // ÓÃ case Óï¾ä½øĞĞÒëÂë
     4'd0:result=8'b1111110;
     4'd1:result=8'b0110000;
     4'd2:result=8'b1101101;
     4'd3:result=8'b1111001;
     4'd4:result=8'b0110011;
     4'd5:result=8'b1011011;
     4'd6:result=8'b1011111;
     4'd7:result=8'b1110000;
     4'd8:result=8'b1111111;
     4'd9:result=8'b1111011;
    default: decodeout=8'bx;
    endcase
endmodule
