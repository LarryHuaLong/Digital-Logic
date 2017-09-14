module dashboard_tb;
    reg clk;
    reg power;
    reg pause;
    reg finished;
    wire power_state;
    wire pause_state;
    dashboard Dashboard(clk,power,pause,finished,power_state,pause_state);
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        power = 0;pause = 0;finished = 0;
        #100 power = 1;#200 power = 0;
        #100 power = 1;#300 power = 0;
        #100 power = 1;#300 power = 0;
        #100 pause = 1;#200 pause = 0;
        #100 power = 1;#200 power = 0;
        
        
        #100 pause = 1;#200 pause = 0;
        #100 pause = 1;#200 pause = 0;
        #100 pause = 1;#200 pause = 0;
        
        #100 finished = 1;#20 finished = 0;
       
        #100 power = 1;#200 power = 0;
        #100 pause = 1;#200 pause = 0;
        #100 power = 1;#200 power = 0;
        #200 pause = 1;#200 pause = 0;
        #100 $finish;
        end
    
    
endmodule