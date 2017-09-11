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
	output  LED_PAUSE	//��ָͣʾ��
	/*output  LED_WASH,	//ϴ��ָʾ��
	output  LED_RINSE,	//Ưϴָʾ��
	output  LED_DEWATERING,//˦��ָʾ��
	output  LED_INTAKE,	//��ˮָʾ��
	output  LED_OUTLET,	//��ˮָʾ��
	output  BEEPER	*/	//����������LED�ƴ��棩
	);
	
	wire power_state, pause_state,wash_state,rinse_state,
	      dewatering_state,intake_state,outlet_state;//��ָʾ��״̬
	wire [3:0]weight_state;
	wire [31:0]display2,display1;
    wire [7:0]stage_state,total_remain,process_remain,second_remain;
    wire clk_10000Hz,clock;
    wire [4]
	dashboard Dashboard1(power,pause,power_state, pause_state);
	
	devider#(5000) f_10000Hz(CLK100MHZ,clk_10000Hz);
	devider#(5) f_1Hz(CLK100MHZ,clock);
	
	fsm FSM(clock,mode,weight,power_state,pause_state,weight_state,total_remain,process_remain,second_remain);
        
    BCD_en_decoder En_decoder1(stage_state,total_remain,process_remain,second_remain,display2,display1);
	
	sdc SDC1(clk_10000Hz,display2,display1,AN,CN);
	  
    assign LED_POWER = power_state;
    assign LED_PAUSE = pause_state;
    assign stage_state = weight_state; 
      
        
endmodule







