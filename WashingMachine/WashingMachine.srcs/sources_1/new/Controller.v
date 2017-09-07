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
	localparam mode1 = 3'b000,mode2 = 3'b001,mode3 = 3'b011,
	           mode4 = 3'b010,mode5 = 3'b110,mode6 = 3'b100;
	reg [7:0]total_time,process_time,stage_state;
	wire [31:0]display2,display1;
	BCD_en_decoder en_decoder1({total_time,porcess_time,stage_state,8'b00000000},display2,display1);

	
	SDC SDC_(CLK100MHZ,display2,display1,AN,CN);
	
	reg power_state;// 电源状态
	initial power_state = 0;
	always @(posedge power) power_state = ~power_state;//按一次电源按钮，电源状态翻转
	           
	reg pause_state;//运行状态，1为运行，0为暂停
	initial pause_state = 0;
	always @(posedge pause) 
	   pause_state = ~pause_state;//按一次启动按钮，运行状态翻转
	           
	reg [3:0]weight_state;
	initial weight_state = 3;
	always @(weight)
	   if(!pause_state) weight_state = weight;           
	           
	reg [2:1]mode_state;//模式状态
	initial mode_state = mode1;   
	always @(posedge power_state) 
		begin mode_state <= mode1;//电源打开切换到洗漂脱模式
		   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
		   process_time <= weight_state;//洗涤过程时间
		  end        
	always @(posedge mode)
	   case(mode_state)
			mode1:begin mode_state <= mode2;//切换到单洗模式
					   total_time <= weight_state + 9;//单洗模式总时间
					   process_time <= weight_state + 9;//洗涤过程时间
				   end
			mode2:begin mode_state <= mode3;//切换到洗漂模式
					   total_time <= weight_state + weight_state + 21;//洗漂模式总时间
					   process_time <= weight_state + 9;//洗涤过程时间
				   end
			mode3:begin mode_state <= mode4;//切换到单漂模式
					   total_time <= weight_state + 12;//单漂模式总时间
					   process_time <= weight_state + 12;//漂洗过程时间
				   end	   
			mode4:begin mode_state <= mode5;//切换到漂脱模式
					   total_time <= weight_state + 18;//漂脱模式总时间
					   process_time <= weight_state + 12;//漂洗过程时间
				   end
			mode5:begin mode_state <= mode6;//切换到单脱模式
					   total_time <= 6;//单脱模式总时间
					   process_time <= 6;//脱水过程时间
				   end
			mode6:begin mode_state <= mode1;//切换到洗漂脱模式
					   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
					   process_time <= weight_state;//洗涤过程时间
				   end
			default:begin mode_state <= mode1;//切换到洗漂脱模式
					   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
					   process_time <= weight_state;//洗涤过程时间
				   end        
	   endcase
	
endmodule