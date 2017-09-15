`timescale 1ns/1ps
module Controller_tb;
    reg CLK100MHZ;	//系统时钟
	reg power;		//电源按钮
	reg pause;		//启动/暂停
	reg mode;			//模式选择
	reg [2:0]weight;	//重量传感器
	reg stage;	//水位传感器
	wire [7:0]AN;
	wire [7:0]CN;		//数码管
	wire  LED_POWER,	//电源指示灯
      LED_PAUSE,    //暂停指示灯
      LED_INTAKE,    //进水指示灯
      LED_WASH,    //洗涤指示灯
      LED_RINSE,    //漂洗指示灯
      LED_OUTLET,    //排水指示灯
      LED_DEWATERING,//脱水指示灯
      BEEPER ;       //蜂鸣器（用LED灯代替）
    controller Controller(CLK100MHZ,power,pause,mode,weight,stage,AN,CN,LED_POWER,LED_PAUSE,LED_INTAKE,LED_WASH,LED_RINSE,LED_OUTLET,LED_DEWATERING,BEEPER);
    
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    initial begin
            stage = 1;
            weight = 5;  power = 0;   pause = 0;  mode = 0;//初始状态
            #500000 power = 1;#50000 power = 0;//按电源按钮
            #200050 mode = 1;#50000 mode = 0;//模式切换
            #200500 mode = 1;#50000 mode = 0;
            #205000 mode = 1;#50000 mode = 0;
            #250000 mode = 1;#50000 mode = 0;
            #205005 mode = 1;#50000 mode = 0;
            #200500 mode = 1;#50000 mode = 0;//切换到洗漂脱模式
            #300050 pause = 1;#50000 pause = 0;//按下启动按钮
            #60000000 pause = 1;#50000 pause = 0;//运行10分钟后暂停运行
            #3000000 pause = 1;#50000 pause = 0;//30秒后继续运行
            #210000000 $finish;//35分钟后仿真结束
            #100000 $finish;
        end
    
    
    
endmodule