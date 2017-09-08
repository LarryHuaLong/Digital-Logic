`timescale 1ns / 1ps
module Dashboard(
    input power,
    input pause,
    input [3:0] weight,
    output power_state,
    output pause_state,
    output [3:0] weight_state
    );
    
    reg power_state;// ��Դ״̬
    initial power_state = 0;
    always @(posedge power) power_state = ~power_state;//��һ�ε�Դ��ť����Դ״̬��ת
               
    reg pause_state;//����״̬��1Ϊ���У�0Ϊ��ͣ
    initial pause_state = 0;
    always @(posedge pause) 
        if(power_state == 0) pause_state = 0;
        else pause_state = ~pause_state;//��Դ�򿪵�����£���һ��������ť������״̬��ת
               
    reg [3:0]weight_state;
    initial weight_state = 3;
    always @(weight)
       if(!pause_state) weight_state = weight;
       
endmodule
