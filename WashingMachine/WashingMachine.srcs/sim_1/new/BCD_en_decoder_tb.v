`timescale 1ns / 1ps

module BCD_en_decoder_tb;
    reg [7:0] number1, number2,number3,number4;
    wire [31:0] display2;
    wire [31:0] display1;

    BCD_en_decoder en_decoder(number1, number2,number3,number4,display2,display1);
    
    initial begin
        number1 = 3;number2 = 2;number3 = 1;number4 = 0;
        #10 number1 = 16;number2 = 12;number3 = 11;number4 = 10;
        #10 number1 = 33;number2 = 27;number3 = 48;number4 = 00;
        #10 $finish;
        
        
    end
    
endmodule
