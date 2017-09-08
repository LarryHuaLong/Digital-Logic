`timescale 1ns / 1ps

module BCD_en_decoder_tb;
    reg [7:0] number1, number2,number3,number4;
    wire [31:0] display2;
    wire [31:0] display1;

    BCD_en_decoder en_decoder1(number1, number2,number3,number4,display2,display1);
    
    initial begin
        number1 = 3;number2 = 2;number3 = 1;number4 = 0;
        #10 number1 = 13;number2 = 12;number3 = 11;number4 = 10;
        #10 number1 = 30;number2 = 20;number3 = 10;number4 = 00;
        #10 $finish;
        
        
    end
    
endmodule
