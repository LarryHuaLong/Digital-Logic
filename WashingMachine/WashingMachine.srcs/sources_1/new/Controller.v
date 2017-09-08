module Controller(
	input CLK100MHZ,	//系统时钟
	input power,		//电源按钮
	input pause,		//启动/暂停
	input mode,			//模式选择
	input [3:0]weight,	//重量传感器
	input stage,	//水位传感器
	output [7:0]AN,
	output [7:0]CN,		//数码管
	output reg LED_POWER,	//电源指示灯
	output reg LED_PAUSE,	//暂停指示灯
	output reg LED_WASH,	//洗涤指示灯
	output reg LED_RINSE,	//漂洗指示灯
	output reg LED_DEWATERING,//甩干指示灯
	output reg LED_INTAKE,	//进水指示灯
	output reg LED_OUTLET,	//排水指示灯
	output reg BEEPER		//蜂鸣器（用LED灯代替）
	);
	
	wire power_state;// 电源状态
	wire pause_state;//运行状态，1为运行，0为暂停
	wire [3:0]weight_state;
	Dashboard(power,pause,weight,power_state, pause_state,weight_state);
	assign LED_POWER = power_state;
	assign LED_PAUSE = pause_state;
	
	
	wire [7:0]total_time,process_time;           
	FSM_MODE MODE_FSM(mode,pause_state,weight_state,total_time,process_time);
	
	wire [31:0]display2,display1;
    reg [7:0]total_remain,process_remain,stage_state;
    always if(pause_state == 0)
            begin
                total_remain <= total_time;
                process_remain <= process_time;
                stage_state <= weight_state;
            end
    SDC SDC1(CLK100MHZ,display2,display1,AN,CN);      
    BCD_en_decoder en_decoder1(stage_state,total_remain,porcess_remian,stage_state,display2,display1);
    
      
endmodule