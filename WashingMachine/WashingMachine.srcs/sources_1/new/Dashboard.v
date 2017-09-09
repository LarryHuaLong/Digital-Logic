`timescale 1ns / 1ps
module dashboard(
    input power,
    input pause,
    input [3:0] weight,
    output power_state,
    output pause_state,
    output [3:0] weight_state
    );
    
    reg power_state;// 电源状态
    initial power_state = 0;
    always @(posedge power) power_state = ~power_state;//按一次电源按钮，电源状态翻转
               
    reg pause_temp1,pause_temp2;
    assign pause_state = pause_temp1 & pause_temp2;//运行状态，1为运行，0为暂停
    initial pause_temp1 = 1;
    always @(negedge power)pause_temp1 = !pause_state;
    initial pause_temp2 = 0;
    always @(posedge pause) 
        if(power_state == 0) pause_temp2 = 0;
        else pause_temp2 = ~pause_temp2 ;//电源打开的情况下，按一次启动按钮，运行状态翻转
               
    reg [3:0]weight_state;//质量传感器
    initial weight_state = 3;
    always @(weight)
       if(!pause_state) weight_state = weight;
       
endmodule
