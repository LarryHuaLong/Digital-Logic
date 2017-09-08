`timescale 1ns / 1ps

module BCD_en_decoder(
    input [7:0] number1,
    input [7:0] number2,
    input [7:0] number3,
    input [7:0] number4,
    output [31:0] display2,
    output [31:0] display1
    );
    wire [7:0]num1,num2,num3,num4;
    BCD_encoder encoder1(number1,num1[7:4],num1[3:0]);
    BCD_encoder encoder2(number2,num2[7:4],num2[3:0]);
    BCD_encoder encoder3(number3,num3[7:4],num3[3:0]);
    BCD_encoder encoder4(number4,num4[7:4],num4[3:0]);
    
    BCD_decoder decoder1(num1[7:4],display2[31:24]);
    BCD_decoder decoder2(num1[3:0],display2[23:16]);
    BCD_decoder decoder3(num2[7:4],display2[15:8]);
    BCD_decoder decoder4(num2[3:0],display2[7:0]);
    BCD_decoder decoder5(num3[7:4],display1[31:24]);
    BCD_decoder decoder6(num3[3:0],display1[23:16]);
    BCD_decoder decoder7(num4[7:4],display1[15:8]);
    BCD_decoder decoder8(num4[3:0],display1[7:0]);
endmodule
