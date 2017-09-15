`timescale 1ns/1ps
module controller(
	input CLK100MHZ,	//ϵͳʱ��
	input power,		//��Դ��ť
	input pause,		//����/��ͣ
	input mode,			//ģʽѡ��
	input [2:0]weight,	//����������
	input stage,	//ˮλ������
	output [7:0]AN,
	output [7:0]CN,		//�����
	output  LED_POWER,	//��Դָʾ��
	output  LED_PAUSE,	//��ָͣʾ��
	output  LED_INTAKE,	//��ˮָʾ��
	output  LED_WASH,	//ϴ��ָʾ��
	output  LED_RINSE,	//Ưϴָʾ��
	output  LED_OUTLET,	//��ˮָʾ��
	output  LED_DEWATERING,//��ˮָʾ��
	output  BEEPER		//����������LED�ƴ��棩
	);
    wire clk_clock,clk_reset,clk_1,clk_10;
    devider#(5000) f_10000Hz(CLK100MHZ,clk_reset);
    devider#(5000000) f_10Hz(CLK100MHZ,clk_10);
    devider#(50000000) f_1Hz(CLK100MHZ,clk_1);
    assign clk_clock = stage ? clk_10 : clk_1;
    wire [2:0]weight_state;
    wire power_state, pause_state,finished,dududu;
    dashboard Dashboard(clk_clock,clk_reset,power,pause,weight,finished,
                        weight_state,power_state, pause_state,dududu);
	wire [7:0]load_process_time;
    wire [7:0] total_remain,process_remain,second_remain;
    wire [7:0]total_time,mode_time,process_time,next_process_time;  
    wire [4:0]process_running;
    wire [2:0]wrd_state;
    wire running_state,clk_second,clk_minite,
        done_second,done_process,done_total,
        reset_second,reset_process,reset_total;
    fsm FSM(clk_reset,mode,power_state,pause_state,weight_state,done_process,wrd_state,
           total_time,mode_time,process_time,next_process_time,running_state,process_running,finished);
	down_counter#(0) c_second(clk_second,reset_second,8'b00111100,done_second,second_remain);//���Ӽ�ʱ��
    down_counter#(1) c_process(clk_minite,reset_process,load_process_time,done_process,process_remain);//������ʱ��ʱ��
    down_counter#(1) c_total(clk_minite,reset_total,total_time,done_total,total_remain);//��ʱ��ʱ��
    assign load_process_time = !running_state ?  process_time : next_process_time;
    assign clk_second = power_state ? (pause_state ? clk_clock : (running_state ? 0 : clk_reset )) : 0;
    assign clk_minite = power_state ? (pause_state ? done_second  : (running_state ? 0 : clk_reset) ): 0;
    assign reset_process = power_state ? (running_state ? !done_process : 0) : 0;
    assign reset_total =  power_state ? (running_state ?  1 : 0) : 0 ;
    assign reset_second = power_state ? (pause_state ? !done_second : (running_state ? 1 : 0)) : 0;
   	wire [31:0]display2,display1;
   	wire [7:0]stage_state;
    BCD_en_decoder En_decoder(total_remain,process_remain,second_remain,stage_state,display2,display1);
    assign stage_state = weight_state; 
    wire [7:0]AN_DATA;
	sdc SDC(clk_reset,display2,display1,AN_DATA,CN);
	assign AN = power_state ? AN_DATA : 8'b11111111 ;
	
	assign LED_POWER = power_state;
    assign LED_PAUSE = pause_state;
	assign LED_INTAKE = power_state&(process_running[4] ? clk_clock : 0);
	assign LED_OUTLET = power_state&(process_running[3] ? clk_clock : 0);
	assign LED_WASH = power_state&(process_running[2] ? clk_clock : wrd_state[2]);
	assign LED_RINSE = power_state&(process_running[1] ? clk_clock : wrd_state[1]);
	assign LED_DEWATERING = power_state&(process_running[0] ? clk_clock : wrd_state[0]);
	
	assign BEEPER = power_state & (power | pause | mode | dududu);
        
endmodule







