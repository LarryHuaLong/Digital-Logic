`timescale 1ns/1ps
module FSM_tb;
    reg clock,mode;
    reg power_state,pause_state;
    reg [3:0]weight;
    wire [3:0]weight_state;
    wire [7:0]total_remain,process_remain,second_remain;
    wire [4:0]leds;
    
    fsm FSM(clock,mode,weight,power_state,pause_state,weight_state,total_remain,process_remain,second_remain,leds);
     
    initial begin
            clock = 0;
            mode = 0;
            power_state = 0;
            pause_state = 0;
            weight = 3;
            #66 power_state = 1;
            #5 mode = 1;#1 mode = 0;
            #50 mode = 1;#1 mode = 0;
            #50 mode = 1;#1 mode = 0;
            #200 pause_state = 1;
            #20000 $finish;
        end
    always #5 clock = ~clock;
     
            
endmodule







