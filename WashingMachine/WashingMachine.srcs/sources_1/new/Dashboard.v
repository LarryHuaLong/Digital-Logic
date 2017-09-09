`timescale 1ns / 1ps
module dashboard(
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
               
    reg pause_temp1,pause_temp2;
    assign pause_state = pause_temp1 & pause_temp2;//����״̬��1Ϊ���У�0Ϊ��ͣ
    initial pause_temp1 = 1;
    always @(negedge power)pause_temp1 = !pause_state;
    initial pause_temp2 = 0;
    always @(posedge pause) 
        if(power_state == 0) pause_temp2 = 0;
        else pause_temp2 = ~pause_temp2 ;//��Դ�򿪵�����£���һ��������ť������״̬��ת
               
    reg [3:0]weight_state;//����������
    initial weight_state = 3;
    always @(weight)
       if(!pause_state) weight_state = weight;
       
endmodule
