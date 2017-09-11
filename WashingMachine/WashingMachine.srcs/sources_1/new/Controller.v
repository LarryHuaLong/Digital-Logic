module controller(
	input CLK100MHZ,	//系统时钟
	input power,		//电源按钮
	input pause,		//启动/暂停
	input mode,			//模式选择
	input [3:0]weight,	//重量传感器
	input stage,	//水位传感器
	output [7:0]AN,
	output [7:0]CN,		//数码管
	output  LED_POWER,	//电源指示灯
	output  LED_PAUSE	//暂停指示灯
	/*output  LED_WASH,	//洗涤指示灯
	output  LED_RINSE,	//漂洗指示灯
	output  LED_DEWATERING,//甩干指示灯
	output  LED_INTAKE,	//进水指示灯
	output  LED_OUTLET,	//排水指示灯
	output  BEEPER	*/	//蜂鸣器（用LED灯代替）
	);
	
	wire power_state, pause_state,wash_state,rinse_state,
	      dewatering_state,intake_state,outlet_state;//各指示灯状态
	wire [3:0]weight_state;
	wire [31:0]display2,display1;
    wire [7:0]stage_state,total_remain,process_remain,second_remain;
    wire clk_10000Hz,clock;
    wire [4]
	dashboard Dashboard1(power,pause,power_state, pause_state);
	
	devider#(5000) f_10000Hz(CLK100MHZ,clk_10000Hz);
	devider#(5) f_1Hz(CLK100MHZ,clock);
	
	fsm FSM(clock,mode,weight,power_state,pause_state,weight_state,total_remain,process_remain,second_remain);
        
    BCD_en_decoder En_decoder1(stage_state,total_remain,process_remain,second_remain,display2,display1);
	
	sdc SDC1(clk_10000Hz,display2,display1,AN,CN);
	  
    assign LED_POWER = power_state;
    assign LED_PAUSE = pause_state;
    assign stage_state = weight_state; 
      
        
endmodule







