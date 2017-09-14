`timescale 1ns / 1ps
module dashboard(
    input clk,
    input power,
    input pause,
    input finished,
    output power_state,
    output pause_state
    );
    reg power_state,pause_state;//��Դ״̬������״̬��1Ϊ��/���У�0Ϊ�ر�/��ͣ
    reg ex_power,ex_pause,ex_finished;//һ��ʱ��ǰ��ť״̬
    initial power_state = 0;
    initial pause_state = 0;
    always @(posedge clk) ex_power = #10 power;
    always @(posedge clk) ex_pause = #10 pause;
    always @(posedge clk) ex_finished = #10 finished;
    always @(posedge clk)
            if(!power && ex_power)//�����power�½���
                power_state = ~power_state;//��һ�ε�Դ��ť����Դ״̬��ת
            else if(!power_state || finished && !ex_finished)//�����Դ�رջ�ϴ�½���
                pause_state = 0;
            else if(power_state && !pause && ex_pause)//�����Դ��������pause�½���
                pause_state = ~pause_state;
            else;
endmodule
