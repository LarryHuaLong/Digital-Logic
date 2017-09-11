`timescale 1ns/1ps
module down_counter_tb;
    reg CLK100MHZ;
    reg pause_state,power_state;
    wire clock;
    devider#(10) devider(CLK100MHZ,clock) ;
    wire clk_second,clk_min,clk_hour,reset_second,reset_min;
    assign clk_second = pause_state ? clock : 0 ;
    assign reset_second = !power_state ? 0 : !clk_min;
    assign reset_min = !clk_hour ? 1 : !clk_hour;
    down_counter counter1(clk_second,reset_second,8'b00111100,clk_min);
    down_counter c_min(clk_min,reset_min,8'b00001000,clk_hour);
    
    
    initial begin 
            CLK100MHZ = 0;
            power_state = 0; 
            pause_state = 0;
            # 10 power_state = 1;
            # 10 pause_state = 1;
            #30000 power_state = 0;
            #30000 power_state = 1;
            #10500 pause_state = 0;
            #10000 pause_state = 1;
            #120000 $finish;
            end
    
    always #5 CLK100MHZ = ~CLK100MHZ;
    
endmodule