`timescale 1ns/1ps
module down_counter_tb;
    reg CLK100MHZ,power_state, pause_state;//各指示灯状态
	
	
    reg [7:0]total_time,process_time;
    wire [7:0]total_remain,process_remain,second_remain;
    wire clock,clk_min,
            done_process,done_total,
            reset_second,reset_process,reset_total;
    devider#(5) f_1Hz(CLK100MHZ,clock);  
    down_counter c_second(clk_second,reset_second,8'b00111011,clk_min,second_remain);//秒钟计时器
    down_counter c_process(clk_min,reset_process,process_time,done_process,process_remain);//过程用时计时器
    down_counter c_total(clk_min,reset_total,total_time,done_total,total_remain);//总时计时器
    assign clk_second = pause_state ? clock : 0 ;
    assign reset_second = !power_state ? 0 : !clk_min;
    assign reset_process = !power_state ? 0 : !done_process;
    assign reset_total = !power_state ? 0 : !done_total;
    
    initial total_time = 27;
    initial process_time = 9;
    always @(negedge done_process) process_time = process_time + 5;
    initial begin 
            CLK100MHZ = 0;
            power_state = 0; 
            pause_state = 0;
            # 10 power_state = 1;
            # 10 pause_state = 1;
            #30000 power_state = 0;
            #10000 power_state = 1;
            #10500 pause_state = 0;
            #10000 pause_state = 1;
            #200000 $finish;
            end
    
    always #5 CLK100MHZ = ~CLK100MHZ;
    
endmodule