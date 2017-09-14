`timescale 1ns / 1ps
module dashboard(
   // input clk,
    input power,
    input pause,
    input finished,
    output power_state,
    output pause_state
    );
    
    reg power_state;// ��Դ״̬
    initial power_state = 0;
    always @(posedge power) 
        power_state = ~power_state;//��һ�ε�Դ��ť����Դ״̬��ת
               
    reg pause_state;//����״̬��1Ϊ���У�0Ϊ��ͣ
    wire finished_ex;
    assign #10 finished_ex = finished;
    initial pause_state = 0;
    //always @(posedge pause,negedge power_state,posedge finished) 
    always @(posedge pause,negedge power_state,posedge finished) 
        if(!power_state) pause_state = 0;//��ԴΪ0��Ϊ0ʱ������״̬��0
        else if( finished && !finished_ex )  pause_state = 0;
        else if( pause ) pause_state = ~pause_state;//��Դ�򿪵�����£���һ��������ť������״̬��ת
        else;
     
endmodule
