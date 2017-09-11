`timescale 1ns/1ps
module down_counter_tb;
    reg clock;
    wire reset;
    reg [7:0]data;
    wire qd;
    down_counter counter1(clock,reset,data,qd);
    assign reset = !qd;
    
    initial begin 
            clock <= 0;
            data <= 8'b00111100;
            #200 $finish;
            end
    
    always #5 clock = ~clock;
    
endmodule