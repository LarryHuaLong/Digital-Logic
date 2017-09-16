`timescale 1ns/1ps
module Controller_tb;
    reg CLK100MHZ;	//系统时钟
	reg power;		//电源按钮
	reg pause;		//启动/暂停
	reg mode;		//模式选择
	reg [2:0]weight;//重量传感器
	wire [7:0]AN;
	wire [7:0]CN;	//数码管
	wire  LED_POWER,//电源指示灯
      LED_PAUSE,    //暂停指示灯
      LED_INTAKE,   //进水指示灯
      LED_OUTLET,    //排水指示灯
      LED_WASH,     //洗涤指示灯
      LED_RINSE,    //漂洗指示灯
      LED_DEWATERING,//脱水指示灯
      BEEPER ;       //蜂鸣器（用LED灯代替）
    controller Controller(CLK100MHZ,power,pause,mode,weight,AN,CN,LED_POWER,LED_PAUSE,
                        LED_INTAKE,LED_OUTLET,LED_WASH,LED_RINSE,LED_DEWATERING,BEEPER);
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    initial begin
            weight = 5;  power = 0;   pause = 0;  mode = 0;//初始状态
            #50000 power = 1;#10000 power = 0;//按电源按钮
            #120005 mode = 1;#10000 mode = 0;//模式切换
            #120050 mode = 1;#10000 mode = 0;
            #120500 mode = 1;#10000 mode = 0;
            #125000 mode = 1;#10000 mode = 0;
            #120500 mode = 1;#10000 mode = 0;
            #120050 mode = 1;#10000 mode = 0;//切换回洗漂脱模式
            #130005 pause = 1;#10000 pause = 0;//按下启动按钮
            #5000000 mode = 1;#10000 mode = 0;
            #1000000 pause = 1;#10000 pause = 0;//大概运行10分钟后暂停运行
            #600000 mode = 1;#10000 mode = 0;//暂停1分钟后从新选择模式到单洗模式
            #600000 pause = 1;#10000 pause = 0;//1分钟后开始运行
            #10000000 $finish;//20分钟后仿真结束
        end
endmodule
