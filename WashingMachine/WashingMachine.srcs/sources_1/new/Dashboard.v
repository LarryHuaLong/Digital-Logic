`timescale 1ns / 1ps
module dashboard(
    input clk_clock,
    input clk_reset,
    input power,
    input pause,
    input [2:0]weight,
    input finished,
    output reg [2:0]weight_state,
    output reg power_state,
    output reg pause_state,
    output dududu
    );
    reg ex_power,ex_pause,ex_finished,ending,ex_ending;
    reg [3:0]count;
    assign dududu = ending ? count[0] : 0;
    initial begin 
                power_state = 0;
                pause_state = 0;
                ending = 0;
                count = 10;
            end
    always @(posedge clk_reset) ex_power = #10 power;
    always @(posedge clk_reset) ex_pause = #10 pause;
    always @(posedge clk_reset) ex_finished = #10 finished;
    always @(posedge clk_clock) 
        if(!ending) count = 10;
        else if(count&&finished)count = count - 1;
        else;
    always @(posedge clk_reset) 
        if(!power_state) weight_state = (weight > 3)? weight : 3;
        else;
    always @(posedge clk_reset) ex_ending = #10 ending;
    always @(posedge clk_reset)
        if(!power && ex_power)//响应电源按钮下降沿
            power_state = ~power_state; 
        else if(!power_state)//响应电源关闭
            begin pause_state = 0;ending = 0;end
        else if(!ending && ex_ending)//响应dududu后自动关闭电源
            power_state = 0;
        else if(!pause && ex_pause)//如果电源开启响应暂停按钮
            begin pause_state = ~pause_state;ending = 0;end
        else if(finished && !ex_finished)//响应洗衣模式结束
            begin pause_state = 0;ending = 1;end
        else if(!count) 
            power_state = 0;
        else;
endmodule
