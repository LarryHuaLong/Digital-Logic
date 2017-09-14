`timescale 1ns/1ps
module Controller_tb;
    reg CLK100MHZ;	//ϵͳʱ��
	reg power;		//��Դ��ť
	reg pause;		//����/��ͣ
	reg mode;			//ģʽѡ��
	reg [3:0]weight;	//����������
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
            weight <= 4;  power <= 0;   pause <= 0;  mode <= 0;//��ʼ״̬
            #50000 power <= 1;#50000 power <= 0;
            #10000 mode <= 1;#10000 mode <= 0;
            #10000 mode <= 1;#10000 mode <= 0;
            #10000 mode <= 1;#10000 mode <= 0;
            #10000 mode <= 1;#10000 mode <= 0;
            #10000 mode <= 1;#10000 mode <= 0;
            #10000 mode <= 1;#10000 mode <= 0;
            #49920 pause <= 1;#5000 pause <= 0;
            #10000000 pause <= 1;#5000 pause <= 0;
            #5000000 pause <= 1;#5000 pause <= 0;
            #11000000 mode <= 1;#1000 mode <= 0;
            #1000 $finish;
        end
    
    
    
endmodule