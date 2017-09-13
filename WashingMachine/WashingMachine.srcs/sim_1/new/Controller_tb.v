`timescale 1ns/1ps
module Controller_tb;
    reg CLK100MHZ;	//系统时钟
	reg power;		//电源按钮
	reg pause;		//启动/暂停
	reg mode;			//模式选择
	reg [3:0]weight;	//重量传感器
	//reg stage;	//水位传感器
	wire [7:0]AN;
	wire [7:0]CN;		//数码管
	wire  LED_POWER;	//电源指示灯
	wire  LED_PAUSE;	//暂停指示灯
//	wire  LED_WASH;	//洗涤指示灯
//	wire  LED_RINSE;	//漂洗指示灯
//	wire  LED_DEWATERING;//甩干指示灯
//	wire  LED_INTAKE;	//进水指示灯
//	wire  LED_OUTLET;	//排水指示灯
//	wire  BEEPER;		//蜂鸣器（用LED灯代替）
    controller Controller(CLK100MHZ,power,pause,mode,weight,AN,CN,LED_POWER,LED_PAUSE);
    
    initial CLK100MHZ = 1;
    always #5 CLK100MHZ = ~CLK100MHZ;
    initial begin
            weight <= 4;  power <= 0;   pause <= 0;  mode <= 0;//初始状态
            #500 power <= 1;#500 power <= 0;
            #1000 mode <= 1;#100 mode <= 0;
            #1000 mode <= 1;#100 mode <= 0;
            #1000 mode <= 1;#100 mode <= 0;
            #5000 pause <= 1;#500 pause <= 0;
            #11000000 mode <= 1;#100 mode <= 0;
            #1000 $finish;
        end
    
    
    
endmodule