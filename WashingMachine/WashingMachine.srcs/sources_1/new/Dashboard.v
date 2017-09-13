`timescale 1ns / 1ps
module dashboard(
    input power,
    input pause,
    input finished,
    output power_state,
    output pause_state
    );
    
    reg power_state;// 电源状态
    initial power_state = 0;
    always @(posedge power) 
        power_state = ~power_state;//按一次电源按钮，电源状态翻转
               
    reg pause_state;//运行状态，1为运行，0为暂停
    initial pause_state = 0;
    always @(posedge pause,negedge power_state,negedge finished) 
        if(!power_state) pause_state = 0;//电源为0或降为0时，运行状态置0
        else if(!pause && !finished) pause_state = 0;
        else pause_state = ~pause_state;//电源打开的情况下，按一次启动按钮，运行状态翻转
     
endmodule
