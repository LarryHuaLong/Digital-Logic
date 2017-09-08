`timescale 10ns/1ps
module FSM_MODE_tb;
    reg mode;
    reg pause_state;
    reg [3:0]weight_state;
    wire [7:0]total_time;
    wire [7:0]process_time;
    
    fsm_mode Mode_FSM(mode,pause_state,weight_state,total_time,process_time);
     
     initial begin
            mode = 0;
            pause_state = 0;
            weight_state = 3;
        end
     always begin
            #10 mode = 1;
            #1 mode = 0;
            #2 mode = 1;
            #1 mode = 0;
            #2 mode = 1;
            #1 mode = 0;
            #2 mode = 1;
            #1 mode = 0;
            #2 mode = 1;
            #1 mode = 0;
            #2 mode = 1;
            #1 mode = 0;
            #2 mode = 1;
            #1 mode = 0;
            #1 pause_state = 1;
            #2 mode = 1;
            #1 mode = 0;
            #2 mode = 1;
            #1 mode = 0;
            $finish;
        end
     
endmodule