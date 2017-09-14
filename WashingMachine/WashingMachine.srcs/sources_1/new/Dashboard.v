`timescale 1ns / 1ps
module dashboard(
    input clk,
    input power,
    input pause,
    input finished,
    output power_state,
    output pause_state
    );
    reg power_state,pause_state;//电源状态和运行状态，1为打开/运行，0为关闭/暂停
    reg ex_power,ex_pause,ex_finished;//一个时钟前按钮状态
    initial power_state = 0;
    initial pause_state = 0;
    always @(posedge clk) ex_power = #10 power;
    always @(posedge clk) ex_pause = #10 pause;
    always @(posedge clk) ex_finished = #10 finished;
    always @(posedge clk)
            if(!power && ex_power)//如果有power下降沿
                power_state = ~power_state;//按一次电源按钮，电源状态翻转
            else if(!power_state || finished && !ex_finished)//如果电源关闭或洗衣结束
                pause_state = 0;
            else if(power_state && !pause && ex_pause)//如果电源开启且有pause下降沿
                pause_state = ~pause_state;
            else;
endmodule
