`timescale 1ns/1ps
module down_counter_tb;
    reg CLK100MHZ,power_state, pause_state;//各指示灯状态
	
	
    reg [7:0]total_time,process_time;
    wire [7:0]total_remain,process_remain,second_remain;
    wire clock,clk_min,
            done_process,done_total,
            reset_second,reset_process,reset_total;
    devider#(50) f_1Hz(CLK100MHZ,clock);
    down_counter#(1) c_second(clk_second,reset_second,12'b00111100,clk_min,second_remain);//秒钟计时器
    down_counter#(60) c_process(clk_minite,reset_process,process_time,done_process,process_remain);//过程用时计时器
        down_counter#(60) c_total(clk_minite,reset_total,total_time,done_total,total_remain);//总时计时器
        
    assign finished = done_total ;
    assign clk_second = pause_state ? clock : 0;
    assign clk_minite = power_state ? (pause_state ? clk_min : (reset_total ? 0 : CLK100MHZ)) : CLK100MHZ;
    assign reset_second = power_state||pause_state ? !clk_min : 0;
    assign reset_process = power_state||pause_state ? !done_process : 0 ;// && done_process ;
    assign reset_total = power_state&&pause_state ? 1 : 0;
    
    initial total_time = 27;
    initial process_time = 9;
    always @(negedge done_process) process_time = process_time + 5;
    initial begin 
            CLK100MHZ = 0;
            power_state = 0; 
            pause_state = 0;
            # 100 power_state = 1;
            # 100 pause_state = 1;
            #300000 power_state = 0;
            #100000 power_state = 1;
            #105000 pause_state = 0;
            #100000 pause_state = 1;
            #2000000 $finish;
            end
    
    always #5 CLK100MHZ = ~CLK100MHZ;
    
endmodule