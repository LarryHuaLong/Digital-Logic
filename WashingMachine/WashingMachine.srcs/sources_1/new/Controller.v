`timescale 1ns/1ps

module controller(
	input CLK100MHZ,	//ϵͳʱ��
	input power,		//��Դ��ť
	input pause,		//����/��ͣ
	input mode,			//ģʽѡ��
	input [3:0]weight,	//����������
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
	
	wire power_state, pause_state,
	   intake_state,wash_state,rinse_state,outlet_state,dewatering_state;//��ָʾ��״̬
	wire [3:0]weight_state;
	wire [31:0]display2,display1;
    wire [7:0]stage_state,total_remain,process_remain,second_remain;
    wire [5:0]leds;
    wire finished;
    wire clk_clock,clk_reset,clk_1,clk_1000,clk_100000,clk_10000000;
    devider#(5) f_10000000Hz(CLK100MHZ,clk_10000000);
    devider#(500) f_100000Hz(CLK100MHZ,clk_100000);
    devider#(50000) f_1000Hz(CLK100MHZ,clk_1000);
    devider#(50000000) f_1Hz(CLK100MHZ,clk_1);
   
    assign clk_clock = stage ? clk_100000 : clk_1;
    assign clk_reset = stage ? clk_10000000 : clk_1000;
	dashboard Dashboard1(clk_reset,power,pause,finished,power_state, pause_state);
	fsm FSM(clk_clock,clk_reset,mode,weight,power_state,pause_state,weight_state,total_remain,process_remain,second_remain,leds,finished);
    BCD_en_decoder En_decoder1(total_remain,process_remain,stage_state,second_remain,display2,display1);
	sdc SDC1(clk_reset,display2,display1,AN,CN);
	assign BEEPER = power | pause | mode | leds[5];
	assign {LED_INTAKE,LED_OUTLET,LED_WASH,LED_RINSE,LED_DEWATERING} = leds[4:0];
    assign LED_POWER = power_state;
    assign LED_PAUSE = pause_state;
    assign stage_state = weight_state; 
      
        
endmodule







