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
	output  LED_DEWATERING,//˦��ָʾ��
	output  BEEPER		//����������LED�ƴ��棩
	);
	
	wire power_state, pause_state,
	   intake_state,wash_state,rinse_state,outlet_state,dewatering_state;//��ָʾ��״̬
	wire [3:0]weight_state;
	wire [31:0]display2,display1;
    wire [7:0]stage_state,total_remain,process_remain,second_remain;
    wire [5:0]leds;
	dashboard Dashboard1(power,pause,power_state, pause_state);
	
	fsm FSM(CLK100MHZ,mode,weight,power_state,pause_state,weight_state,total_remain,process_remain,second_remain,leds);
        
    BCD_en_decoder En_decoder1(stage_state,total_remain,process_remain,second_remain,display2,display1);
	
	sdc SDC1(CLK100MHZ,display2,display1,AN,CN);
	assign BEEPER = power | pause | mode | leds[5];
	assign {LED_INTAKE,LED_WASH,LED_RINSE,LED_OUTLET,LED_DEWATERING} = leds;
    assign LED_POWER = power_state;
    assign LED_PAUSE = pause_state;
    assign stage_state = weight_state; 
      
        
endmodule







