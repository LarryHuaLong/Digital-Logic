`timescale 1ps / 1ps
module divider_tb;
    reg clk100MHz;
    wire clk;
    devider#(20) devider(clk100MHz,clk) ;
    initial clk100MHz = 0;
    always #5 clk100MHz = ~clk100MHz;
    
endmodule
