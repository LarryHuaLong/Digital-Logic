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
	localparam mode1 = 3'b000,mode2 = 3'b001,mode3 = 3'b011,
	           mode4 = 3'b010,mode5 = 3'b110,mode6 = 3'b100;
	reg [7:0]total_time,process_time,stage_state;
	wire [31:0]display2,display1;
	BCD_en_decoder en_decoder1({total_time,porcess_time,stage_state,8'b00000000},display2,display1);

	
	SDC SDC_(CLK100MHZ,display2,display1,AN,CN);
	
	reg power_state;// ��Դ״̬
	initial power_state = 0;
	always @(posedge power) power_state = ~power_state;//��һ�ε�Դ��ť����Դ״̬��ת
	           
	reg pause_state;//����״̬��1Ϊ���У�0Ϊ��ͣ
	initial pause_state = 0;
	always @(posedge pause) 
	   pause_state = ~pause_state;//��һ��������ť������״̬��ת
	           
	reg [3:0]weight_state;
	initial weight_state = 3;
	always @(weight)
	   if(!pause_state) weight_state = weight;           
	           
	reg [2:1]mode_state;//ģʽ״̬
	initial mode_state = mode1;   
	always @(posedge power_state) 
		begin mode_state <= mode1;//��Դ���л���ϴƯ��ģʽ
		   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
		   process_time <= weight_state;//ϴ�ӹ���ʱ��
		  end        
	always @(posedge mode)
	   case(mode_state)
			mode1:begin mode_state <= mode2;//�л�����ϴģʽ
					   total_time <= weight_state + 9;//��ϴģʽ��ʱ��
					   process_time <= weight_state + 9;//ϴ�ӹ���ʱ��
				   end
			mode2:begin mode_state <= mode3;//�л���ϴƯģʽ
					   total_time <= weight_state + weight_state + 21;//ϴƯģʽ��ʱ��
					   process_time <= weight_state + 9;//ϴ�ӹ���ʱ��
				   end
			mode3:begin mode_state <= mode4;//�л�����Ưģʽ
					   total_time <= weight_state + 12;//��Ưģʽ��ʱ��
					   process_time <= weight_state + 12;//Ưϴ����ʱ��
				   end	   
			mode4:begin mode_state <= mode5;//�л���Ư��ģʽ
					   total_time <= weight_state + 18;//Ư��ģʽ��ʱ��
					   process_time <= weight_state + 12;//Ưϴ����ʱ��
				   end
			mode5:begin mode_state <= mode6;//�л�������ģʽ
					   total_time <= 6;//����ģʽ��ʱ��
					   process_time <= 6;//��ˮ����ʱ��
				   end
			mode6:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_time <= weight_state;//ϴ�ӹ���ʱ��
				   end
			default:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_time <= weight_state;//ϴ�ӹ���ʱ��
				   end        
	   endcase
	
endmodule