`timescale 1ns / 1ps

module BCD_en_decoder(
    input [31:0] nums,
    output [31:0] display2,
    output [31:0] display1
    );
    wire [8:0]num1,num2,num3,num4;
    BCD_encoder encoder1(nums[31:24],num1[8:4],num1[3:0]);
    BCD_encoder encoder2(nums[23:16],num2[8:4],num2[3:0]);
    BCD_encoder encoder3(nums[15:8],num3[8:4],num3[3:0]);
    BCD_encoder encoder4(nums[7:0],num4[8:4],num4[3:0]);
    
    BCD_decoder decoder1(num1[8:4],display2[31:24]);
    BCD_decoder decoder1(num1[3:0],display2[23:16]);
    BCD_decoder decoder1(num2[8:4],display2[15:8]);
    BCD_decoder decoder1(num2[3:0],display2[7:0]);
    BCD_decoder decoder1(num3[8:4],display1[31:24]);
    BCD_decoder decoder1(num3[3:0],display1[23:16]);
    BCD_decoder decoder1(num4[8:4],display1[15:8]);
    BCD_decoder decoder1(num4[3:0],display1[7:0]);
endmodule
