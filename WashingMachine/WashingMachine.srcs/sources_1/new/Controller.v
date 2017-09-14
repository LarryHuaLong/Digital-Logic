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
    wire finished,dududu;
    wire clk_clock,clk_reset,clk_1,clk_10000,clk_100000,clk_10000000;
    devider#(5000) f_100000Hz(CLK100MHZ,clk_reset);
    devider#(5000000) f_1000Hz(CLK100MHZ,clk_10);
    devider#(50000000) f_1Hz(CLK100MHZ,clk_1);
    assign clk_clock = stage ? clk_10 : clk_1;
	dashboard Dashboard1(clk_clock,clk_reset,power,pause,finished,power_state, pause_state,dududu);
	fsm FSM(clk_clock,clk_reset,mode,weight,power_state,pause_state,weight_state,total_remain,process_remain,second_remain,leds,finished);
    BCD_en_decoder En_decoder1(total_remain,process_remain,stage_state,second_remain,display2,display1);
    wire [7:0]AN_DATA;
	sdc SDC1(clk_reset,display2,display1,AN_DATA,CN);
	assign AN = power_state ? AN_DATA : 8'b11111111 ;
	assign {LED_INTAKE,LED_OUTLET,LED_WASH,LED_RINSE,LED_DEWATERING} = power_state ? leds : 5'b00000;
	assign BEEPER = power | pause | mode | dududu;
    assign LED_POWER = power_state;
    assign LED_PAUSE = pause_state;
    assign stage_state = weight_state; 
      
        
endmodule







