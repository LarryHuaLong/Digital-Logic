`timescale 1ns/1ps
module Controller_tb;
    reg CLK100MHZ;	//ϵͳʱ��
	reg power;		//��Դ��ť
	reg pause;		//����/��ͣ
	reg mode;			//ģʽѡ��
	reg [2:0]weight;	//����������
	reg stage;	//ˮλ������
	wire [7:0]AN;
	wire [7:0]CN;		//�����
	wire  LED_POWER,	//��Դָʾ��
      LED_PAUSE,    //��ָͣʾ��
      LED_INTAKE,    //��ˮָʾ��
      LED_WASH,    //ϴ��ָʾ��
      LED_RINSE,    //Ưϴָʾ��
      LED_OUTLET,    //��ˮָʾ��
      LED_DEWATERING,//��ˮָʾ��
      BEEPER ;       //����������LED�ƴ��棩
    controller Controller(CLK100MHZ,power,pause,mode,weight,stage,AN,CN,LED_POWER,LED_PAUSE,LED_INTAKE,LED_WASH,LED_RINSE,LED_OUTLET,LED_DEWATERING,BEEPER);
    
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    initial begin
            stage = 1;
            weight = 5;  power = 0;   pause = 0;  mode = 0;//��ʼ״̬
            #500000 power = 1;#50000 power = 0;//����Դ��ť
            #200050 mode = 1;#50000 mode = 0;//ģʽ�л�
            #200500 mode = 1;#50000 mode = 0;
            #205000 mode = 1;#50000 mode = 0;
            #250000 mode = 1;#50000 mode = 0;
            #205005 mode = 1;#50000 mode = 0;
            #200500 mode = 1;#50000 mode = 0;//�л���ϴƯ��ģʽ
            #300050 pause = 1;#50000 pause = 0;//����������ť
            #60000000 pause = 1;#50000 pause = 0;//����10���Ӻ���ͣ����
            #3000000 pause = 1;#50000 pause = 0;//30����������
            #210000000 $finish;//35���Ӻ�������
            #100000 $finish;
        end
    
    
    
endmodule