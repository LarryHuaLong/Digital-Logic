module dashboard_tb;
    reg power;
    reg pause;
    wire power_state;
    wire pause_state;
    dashboard Dashboard(power,pause,,power_state,pause_state,);
    
    initial begin
        power = 0;pause = 0;
        #10 power = 1;#2 power = 0;
        #10 pause = 1;#2 pause = 0;
        #10 pause = 1;#2 pause = 0;
        #10 pause = 1;#2 pause = 0;
        #10 power = 1;#2 power = 0;
        #10 pause = 1;#2 pause = 0;
        #10 power = 1;#2 power = 0;
        #20 pause = 1;#2 pause = 0;
        #10 $finish;
        end
    
    
endmodule