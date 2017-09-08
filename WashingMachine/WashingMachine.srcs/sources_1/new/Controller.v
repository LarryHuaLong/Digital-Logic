module Controller(
	input CLK100MHZ,	//ϵͳʱ��
	input power,		//��Դ��ť
	input pause,		//����/��ͣ
	input mode,			//ģʽѡ��
	input [3:0]weight,	//����������
	input stage,	//ˮλ������
	output [7:0]AN,
	output [7:0]CN,		//�����
	output reg LED_POWER,	//��Դָʾ��
	output reg LED_PAUSE,	//��ָͣʾ��
	output reg LED_WASH,	//ϴ��ָʾ��
	output reg LED_RINSE,	//Ưϴָʾ��
	output reg LED_DEWATERING,//˦��ָʾ��
	output reg LED_INTAKE,	//��ˮָʾ��
	output reg LED_OUTLET,	//��ˮָʾ��
	output reg BEEPER		//����������LED�ƴ��棩
	);
	
	wire power_state;// ��Դ״̬
	wire pause_state;//����״̬��1Ϊ���У�0Ϊ��ͣ
	wire [3:0]weight_state;
	Dashboard(power,pause,weight,power_state, pause_state,weight_state);
	assign LED_POWER = power_state;
	assign LED_PAUSE = pause_state;
	
	
	wire [7:0]total_time,process_time;           
	FSM_MODE MODE_FSM(mode,pause_state,weight_state,total_time,process_time);
	
	wire [31:0]display2,display1;
    reg [7:0]total_remain,process_remain,stage_state;
    always if(pause_state == 0)
            begin
                total_remain <= total_time;
                process_remain <= process_time;
                stage_state <= weight_state;
            end
    SDC SDC1(CLK100MHZ,display2,display1,AN,CN);      
    BCD_en_decoder en_decoder1(stage_state,total_remain,porcess_remian,stage_state,display2,display1);
    
      
endmodule