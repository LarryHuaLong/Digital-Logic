module controller(
	input CLK100MHZ,	//系统时钟
	input power,		//电源按钮
	input pause,		//启动/暂停
	input mode,			//模式选择
	input [3:0]weight,	//重量传感器
//	input stage,	//水位传感器
	output [7:0]AN,
	output [7:0]CN,		//数码管
	output  LED_POWER,	//电源指示灯
	output  LED_PAUSE	//暂停指示灯
//	output  LED_WASH,	//洗涤指示灯
//	output  LED_RINSE,	//漂洗指示灯
//	output  LED_DEWATERING,//甩干指示灯
//	output  LED_INTAKE,	//进水指示灯
//	output  LED_OUTLET,	//排水指示灯
//	output  BEEPER		//蜂鸣器（用LED灯代替）
	);
	
	wire power_state, pause_state,wash_state,rinse_state,
	      dewatering_state,intake_state,outlet_state;//各指示灯状态
	wire [3:0]weight_state;
	dashboard Dashboard1(power,pause,weight,power_state, pause_state,weight_state);
	assign LED_POWER = power_state;
	assign LED_PAUSE = pause_state;
	
	
	wire [7:0]total_time,process_time;           
	fsm_mode Mode_FSM(mode,pause_state,weight_state,total_time,process_time);
	wire clock;
	devider#(50000000) f_1Hz(CLK100MHZ,clock);
	
	
	
	wire [31:0]display2,display1;
    wire [7:0]total_remain,process_remain,stage_state;
    assign total_remain = total_time;
    assign process_remain = process_time;
    assign stage_state = weight_state;     
    BCD_en_decoder En_decoder1(stage_state,total_remain,process_remain,stage_state,display2,display1);
    sdc SDC1(CLK100MHZ,display2,display1,AN,CN);  
      
    
    
    
endmodule