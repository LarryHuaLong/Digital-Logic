`timescale 1ns/1ps
module FSM_tb;
    reg clock,mode;
    reg pause_state;
    reg [3:0]weight_state;
    wire [7:0]total_time;
    wire [7:0]process_time;
    
    fsm Mode_FSM(clock,mode,weight,power_state,pause_state,weight_state,total_remain,process_remain,second_remain);
     
    initial begin
            clock = 0;
            mode = 0;
            pause_state = 0;
            weight_state = 3;
        end
    always #5 clock = ~clock;
     
            
endmodule







