`timescale 1ns/1ps
module Controller_tb;
    reg CLK100MHZ;	//ϵͳʱ��
	reg power;		//��Դ��ť
	reg pause;		//����/��ͣ
	reg mode;		//ģʽѡ��
	reg [2:0]weight;//����������
	wire [7:0]AN;
	wire [7:0]CN;	//�����
	wire  LED_POWER,//��Դָʾ��
      LED_PAUSE,    //��ָͣʾ��
      LED_INTAKE,   //��ˮָʾ��
      LED_OUTLET,    //��ˮָʾ��
      LED_WASH,     //ϴ��ָʾ��
      LED_RINSE,    //Ưϴָʾ��
      LED_DEWATERING,//��ˮָʾ��
      BEEPER ;       //����������LED�ƴ��棩
    controller Controller(CLK100MHZ,power,pause,mode,weight,AN,CN,LED_POWER,LED_PAUSE,
                        LED_INTAKE,LED_OUTLET,LED_WASH,LED_RINSE,LED_DEWATERING,BEEPER);
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    initial begin
            weight = 5;  power = 0;   pause = 0;  mode = 0;//��ʼ״̬
            #50000 power = 1;#10000 power = 0;//����Դ��ť
            #120005 mode = 1;#10000 mode = 0;//ģʽ�л�
            #120050 mode = 1;#10000 mode = 0;
            #120500 mode = 1;#10000 mode = 0;
            #125000 mode = 1;#10000 mode = 0;
            #120500 mode = 1;#10000 mode = 0;
            #120050 mode = 1;#10000 mode = 0;//�л���ϴƯ��ģʽ
            #130005 pause = 1;#10000 pause = 0;//����������ť
            #5000000 mode = 1;#10000 mode = 0;
            #1000000 pause = 1;#10000 pause = 0;//�������10���Ӻ���ͣ����
            #600000 mode = 1;#10000 mode = 0;//��ͣ1���Ӻ����ѡ��ģʽ����ϴģʽ
            #600000 pause = 1;#10000 pause = 0;//1���Ӻ�ʼ����
            #10000000 $finish;//20���Ӻ�������
        end
endmodule
