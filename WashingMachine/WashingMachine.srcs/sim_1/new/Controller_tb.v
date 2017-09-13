`timescale 1ns/1ps
module Controller_tb;
    reg CLK100MHZ;	//ϵͳʱ��
	reg power;		//��Դ��ť
	reg pause;		//����/��ͣ
	reg mode;			//ģʽѡ��
	reg [3:0]weight;	//����������
	//reg stage;	//ˮλ������
	wire [7:0]AN;
	wire [7:0]CN;		//�����
	wire  LED_POWER;	//��Դָʾ��
	wire  LED_PAUSE;	//��ָͣʾ��
//	wire  LED_WASH;	//ϴ��ָʾ��
//	wire  LED_RINSE;	//Ưϴָʾ��
//	wire  LED_DEWATERING;//˦��ָʾ��
//	wire  LED_INTAKE;	//��ˮָʾ��
//	wire  LED_OUTLET;	//��ˮָʾ��
//	wire  BEEPER;		//����������LED�ƴ��棩
    controller Controller(CLK100MHZ,power,pause,mode,weight,AN,CN,LED_POWER,LED_PAUSE);
    
    initial CLK100MHZ = 1;
    always #5 CLK100MHZ = ~CLK100MHZ;
    initial begin
            weight <= 4;  power <= 0;   pause <= 0;  mode <= 0;//��ʼ״̬
            #500 power <= 1;#500 power <= 0;
            #1000 mode <= 1;#100 mode <= 0;
            #1000 mode <= 1;#100 mode <= 0;
            #1000 mode <= 1;#100 mode <= 0;
            #5000 pause <= 1;#500 pause <= 0;
            #11000000 mode <= 1;#100 mode <= 0;
            #1000 $finish;
        end
    
    
    
endmodule