module Controller(
	input CLK100MHZ,	//ϵͳʱ��
	input power,		//��Դ��ť
	input pause,		//����/��ͣ
	input mode,			//ģʽѡ��
	input [3:0]weight,	//����������
	input [3:0]stage,	//ˮλ������
	output [7:0]AN,
	output [7:0]CN,		//�����
	output LED_POWER,	//��Դָʾ��
	output LED_PAUSE,	//��ָͣʾ��
	output LED_WASH,	//ϴ��ָʾ��
	output LED_RINSE,	//Ưϴָʾ��
	output LED_DEWATERING,//˦��ָʾ��
	output LED_INTAKE,	//��ˮָʾ��
	output LED_OUTLET,	//��ˮָʾ��
	output BEEPER		//����������LED�ƴ��棩
	);
	
	
	
	
endmodule