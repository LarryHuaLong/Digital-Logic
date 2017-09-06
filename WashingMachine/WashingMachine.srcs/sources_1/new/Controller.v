module Controller(
	input CLK100MHZ,	//系统时钟
	input power,		//电源按钮
	input pause,		//启动/暂停
	input mode,			//模式选择
	input [3:0]weight,	//重量传感器
	input [3:0]stage,	//水位传感器
	output [7:0]AN,
	output [7:0]CN,		//数码管
	output LED_POWER,	//电源指示灯
	output LED_PAUSE,	//暂停指示灯
	output LED_WASH,	//洗涤指示灯
	output LED_RINSE,	//漂洗指示灯
	output LED_DEWATERING,//甩干指示灯
	output LED_INTAKE,	//进水指示灯
	output LED_OUTLET,	//排水指示灯
	output BEEPER		//蜂鸣器（用LED灯代替）
	);
	
	
	
	
endmodule