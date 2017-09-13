`timescale 1ns/1ps
module fsm(
    input CLK100MHZ,
	input mode,
	input [3:0]weight,
	input power_state,
	input pause_state,
	output reg [3:0]weight_state,
	output [7:0] total_remain,
    output [7:0] process_remain,
    output [7:0] second_remain,
    output [5:0] leds,
    output finished
	);
	localparam mode1 = 3'b111,mode2 = 3'b100,mode3 = 3'b110,
               mode4 = 3'b010,mode5 = 3'b011,mode6 = 3'b001;
    localparam process0 = 3'b000,process1 = 3'b001,process2 = 3'b010,process3 = 3'b011,
			   process4 = 3'b111,process5 = 3'b110,process6 = 3'b100,process7 = 3'b101;
	reg [2:0]mode_state,process_state;//模式和进程状态
	reg [7:0]total_time,process_time;
	//wire [7:0]load_process_time;
	wire clock,clk_second,clk_min,clk_minite,clk_reset,
       done_process,done_total,
       reset_second,reset_process,reset_total;
	reg wash_state,rinse_state,dewatering_state;
	reg intake_running,wash_running,rinse_running,outlet_running,dewatering_running;
	reg pause_ex_state;
	
	devider#(50000000) f_1Hz(CLK100MHZ,clock);
    down_counter#(0) c_second(clk_second,reset_second,8'b00111100,clk_min,second_remain);//秒钟计时器
    down_counter#(1) c_process(clk_minite,reset_process,process_time,done_process,process_remain);//过程用时计时器
    down_counter#(1) c_total(clk_minite,reset_total,total_time,done_total,total_remain);//总时计时器
    down_counter c_reset(CLK100MHZ,reset_reset,8'b11000000,clk_reset);//复位脉冲
    //assign load_process_time = pause_state ? next_process_time : process_time;
    assign finished = !total_remain && !second_remain;
    assign clk_second = power_state ? (pause_state ? clock : ( !reset_second ? clk_reset : 0 ) ) : 0;
    assign clk_minite = power_state ? (pause_state ? clk_min : ( (!reset_process || !reset_total) ? clk_reset : 0 ) ) : 0;
    assign reset_reset = !clk_reset;
    assign reset_second = power_state&&pause_state ? !clk_min :  (!mode || 0);
    assign reset_process =  power_state&&pause_state ? (!done_process && !mode): 0;
    assign reset_total =  power_state&&pause_state ? (!mode || 0) : 0 ;
    assign leds[5] = pause_state ? clock : 0;
    assign leds[4] = intake_running ? clock : 0;
    assign leds[3] = outlet_running ? clock : 0;
    assign leds[2] = wash_running ? clock : wash_state;
    assign leds[1] = rinse_running ? clock : rinse_state;
    assign leds[0] = dewatering_running ? clock : dewatering_state;
    
	initial begin 
		   mode_state = mode1;//电源打开切换到洗漂脱模式
		   {wash_state,rinse_state,dewatering_state} = mode_state;
		   weight_state = 3;
		   total_time = weight_state + weight_state + 27;//洗漂脱模式总时间
		   process_state = process0;
		   process_time = weight_state;//进水时间
		   //next_process_time = 9;//洗衣时间
		   {intake_running,wash_running,rinse_running,outlet_running,dewatering_running} = 5'b00000;
           end
	always @(posedge clk_reset) pause_ex_state = pause_state;
	always @(negedge power_state,posedge mode,posedge pause_state,negedge done_process)
	   if(!power_state)
			//响应power_state下降沿
		   begin mode_state <= mode1;//切换到洗漂脱模式
			   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
			   process_state <= process0;
			   process_time <= weight_state;//排水时间
			   //next_process_time = 9;//洗衣时间
			   {wash_state,rinse_state,dewatering_state} = mode_state;
		   end
	   else if( mode && !pause_state && !done_process)
			//响应mode上升沿
			case(mode_state)
			mode1:begin mode_state <= mode2;//切换到单洗模式
					   total_time <= weight_state + 9;//单洗模式总时间
					   process_state <= process0;
					   process_time <= weight_state;//进水时间
					   //next_process_time = 9;//洗衣时间
					   {wash_state,rinse_state,dewatering_state} = mode_state;
				   end
			mode2:begin mode_state <= mode3;//切换到洗漂模式
					   total_time <= weight_state + weight_state + 21;//洗漂模式总时间
					   process_state <= process0;
					   process_time <= weight_state;//进水时间
					   //next_process_time = 9;//洗衣时间
					   {wash_state,rinse_state,dewatering_state} = mode_state;
				   end
			mode3:begin mode_state <= mode4;//切换到单漂模式
					   total_time <= weight_state + 12;//单漂模式总时间
					   process_state <= process2;
					   process_time <= 3;//排水时间
					   //next_process_time = 3;//甩干时间
					   {wash_state,rinse_state,dewatering_state} = mode_state;
				   end	   
			mode4:begin mode_state <= mode5;//切换到漂脱模式
					   total_time <= weight_state + 18;//漂脱模式总时间
					   process_state <= process2;
					   process_time <= 3;//排水时间
					   //next_process_time = 3;//甩干时间
					   {wash_state,rinse_state,dewatering_state} = mode_state;
				   end
			mode5:begin mode_state <= mode6;//切换到单脱模式
					   total_time <= 6;//单脱模式总时间
					   process_state <= process6;
					   process_time <= 3;//排水过程时间
					   //next_process_time = 3;//甩干时间
					   {wash_state,rinse_state,dewatering_state} = mode_state;
				   end
			mode6:begin mode_state <= mode1;//切换到洗漂脱模式
					   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
					   process_state <= process0;
					   process_time <= weight_state;//进水时间
					   //next_process_time = 9;//洗衣时间
					   {wash_state,rinse_state,dewatering_state} = mode_state;
				   end
			default:begin mode_state <= mode1;//切换到洗漂脱模式
					   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
					   process_state <= process0;
					   process_time <= weight_state;//进水时间
					   //next_process_time = 9;//洗衣时间
					   {wash_state,rinse_state,dewatering_state} = mode_state;
				   end
	        endcase
	        else if( pause_state && !pause_ex_state)
               //响应pause_state上升沿
			case(process_state)
                 process0:begin wash_running = 1;intake_running = 1;end
                 process1:begin wash_running = 1;end
                 process2:begin rinse_running = 1;outlet_running = 1;end
                 process3:begin rinse_running = 1;dewatering_running = 1;end
                 process4:begin rinse_running = 1;intake_running = 1;end
                 process5:begin rinse_running = 1;end
                 process6:begin dewatering_running = 1;outlet_running = 1;end
                 process7:begin dewatering_running = 1;end
             endcase  
        else if( !mode && pause_state && !done_process && pause_ex_state)
			//响应done_process下降沿
		   case(process_state)
           process0:begin //完成进水后洗衣
                        process_state = process1;
                        process_time = 9;
                        wash_running = 1;//开始洗衣
                        intake_running = 0;
                       // if(mode_state == mode2)      next_process_time = 0;//进程结束   else next_process_time = 3;//排水时间
                    end
           process1:begin //完成洗衣后
                        if(mode_state == mode2)//如果是单洗则结束
                            begin
                                process_state = process0;
                                process_time = weight_state;
                                wash_running = 0;
                                wash_state = 0;
                            end
                        else begin  //否则开始排水
                                process_state = process2;
                                process_time = 3;
                                outlet_running = 1;//开始排水
                                wash_running = 0;
                                wash_state = 0;
							//	next_process_time = 3;//甩干时间
                             end
                    end
           process2:begin //完成排水后甩干
                        process_state = process3;
                        process_time = 3;
                        dewatering_running = 1;//开始甩干
						//next_process_time = weight_state;//进水时间
                        outlet_running = 0;
                    end
           process3:begin //完成甩干后进水
                        process_state = process4;
                        process_time = weight_state;
					//	next_process_time = 6;//漂洗时间
                        intake_running = 1;//开始进水
                        dewatering_running = 0;
					end
           process4:begin //完成进水后漂洗
                        process_state = process5;
                        process_time = 6;
					//if(mode_state == mode3 || mode_state == mode4)
					//		next_process_time = 0;
					//	else next_process_time = 3;
                        rinse_running = 1;//开始漂洗
                        intake_running = 0;// 结束进水
                    end
           process5:begin //完成漂洗后
                        if(mode_state == mode3 || mode_state == mode4) 
                            begin //如果是洗漂或单漂模式则结束
                            process_state = process0;
                            process_time = weight_state;
                            rinse_running = 0;
                            rinse_state = 0;
                            end
                        else begin //否则开始排水
                                process_state = process6;
                                process_time = 3;
						//		next_process_time = 3;//甩干时间按
                                outlet_running = 1;//开始排水
                                rinse_running = 0;
                                rinse_state = 0;
                             end
                    end
           process6:begin //完成排水后甩干
                        process_state = process7;
                        process_time = 3;
					//	next_process_time = 0;
                        dewatering_running = 1;//开始甩干
                        outlet_running = 0;
                    end
           process7:begin //完成甩干后结束
                        process_state = process0;
                        process_time = weight_state;
					//	next_process_time = weight_state;//进水时间
                        dewatering_running = 0;
                        dewatering_state = 0;
                    end
           endcase

	always @(weight)
             if(!pause_state) weight_state = weight < 4 ? 3 : weight;
endmodule








