`timescale 1ns / 1ps
module BCD_decoder(
    input [3:0]BCD,
    output reg [7:0] result
    );
    initial result = 8'b11111111;
    always @(BCD)
        case (BCD)
         4'd0:result=8'b00000011;
         4'd1:result=8'b10011111;
         4'd2:result=8'b00100101;
         4'd3:result=8'b00001101;
         4'd4:result=8'b10011001;
         4'd5:result=8'b01001001;
         4'd6:result=8'b01000001;
         4'd7:result=8'b00011111;
         4'd8:result=8'b00000001;
         4'd9:result=8'b00001001;
        default: result=8'b11111111;
        endcase
endmodule
