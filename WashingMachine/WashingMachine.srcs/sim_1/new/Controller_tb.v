module Controller_tb;
    reg CLK100MHZ;	//ϵͳʱ��
	reg power;		//��Դ��ť
	reg pause;		//����/��ͣ
	reg mode;			//ģʽѡ��
	reg [3:0]weight;	//����������
	reg stage;	//ˮλ������
	wire [7:0]AN;
	wire [7:0]CN;		//�����
	wire  LED_POWER;	//��Դָʾ��
	wire  LED_PAUSE;	//��ָͣʾ��
	wire  LED_WASH;	//ϴ��ָʾ��
	wire  LED_RINSE;	//Ưϴָʾ��
	wire  LED_DEWATERING;//˦��ָʾ��
	wire  LED_INTAKE;	//��ˮָʾ��
	wire  LED_OUTLET;	//��ˮָʾ��
	wire  BEEPER;		//����������LED�ƴ��棩
    
    
    
endmodule