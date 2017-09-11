module controller(
	input CLK100MHZ,	//ϵͳʱ��
	input power,		//��Դ��ť
	input pause,		//����/��ͣ
	input mode,			//ģʽѡ��
	input [3:0]weight,	//����������
//	input stage,	//ˮλ������
	output [7:0]AN,
	output [7:0]CN,		//�����
	output  LED_POWER,	//��Դָʾ��
	output  LED_PAUSE	//��ָͣʾ��
//	output  LED_WASH,	//ϴ��ָʾ��
//	output  LED_RINSE,	//Ưϴָʾ��
//	output  LED_DEWATERING,//˦��ָʾ��
//	output  LED_INTAKE,	//��ˮָʾ��
//	output  LED_OUTLET,	//��ˮָʾ��
//	output  BEEPER		//����������LED�ƴ��棩
	);
	
	wire power_state, pause_state,wash_state,rinse_state,
	      dewatering_state,intake_state,outlet_state;//��ָʾ��״̬
	wire [3:0]weight_state;
	dashboard Dashboard1(power,pause,weight,power_state, pause_state,weight_state);
	assign LED_POWER = power_state;
	assign LED_PAUSE = pause_state;
	
	
	wire [7:0]total_time,process_time;           
	fsm_mode Mode_FSM(mode,pause_state,weight_state,total_time,process_time);
	wire clock;
	devider#(50000000) f_1Hz(CLK100MHZ,clock);
	
	
	
	wire [31:0]display2,display1;
    wire [7:0]total_remain,process_remain,stage_state;
    assign total_remain = total_time;
    assign process_remain = process_time;
    assign stage_state = weight_state;     
    BCD_en_decoder En_decoder1(stage_state,total_remain,process_remain,stage_state,display2,display1);
    sdc SDC1(CLK100MHZ,display2,display1,AN,CN);  
      
    
    
    
endmodule