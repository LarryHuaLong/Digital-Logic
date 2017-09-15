`timescale 1ns/1ps
module fsm(
    input clk_reset,
    input mode,
	input power_state,
	input pause_state,
	input [2:0]weight_state,
	input done_process,
	output [2:0]wrd_state,
	output reg [7:0] total_time,
    output reg [7:0] process_time,
    output reg [7:0] next_process_time,
    output reg running_state,
    output [4:0] process_running,//五个进程的运行状态
    output reg finished
	);
	localparam mode1 = 3'b111,mode2 = 3'b100,mode3 = 3'b110,
               mode4 = 3'b010,mode5 = 3'b011,mode6 = 3'b001;
    localparam process0 = 3'b000,process1 = 3'b001,process2 = 3'b010,process3 = 3'b011,
			   process4 = 3'b111,process5 = 3'b110,process6 = 3'b100,process7 = 3'b101;
	reg [2:0]mode_state,process_state;//模式和进程状态
	reg wash_state,rinse_state,dewatering_state;//洗衣程序状态
	reg intake_running,wash_running,rinse_running,outlet_running,dewatering_running;//进程状态
	reg ex_mode,ex_pause_state,ex_done_process;//为识别边沿事件设置的中间变量
	assign wrd_state = {wash_state,rinse_state,dewatering_state};
    assign process_running = {intake_running,outlet_running,wash_running,rinse_running,dewatering_running};
	initial begin //初始状态
               running_state <= 0;
               finished <= 0;
               mode_state <= mode1;//默认洗漂脱模式
               {wash_state,rinse_state,dewatering_state} <= 3'b0;
               total_time <= 33;
               process_state <= process0;
               process_time <= 3;//进水时间
               next_process_time <= 9;//下个进程是洗衣
               {intake_running,wash_running,rinse_running,outlet_running,dewatering_running} <= 5'b00000;
           end
	always @(posedge clk_reset) ex_mode = #10 mode ;
	always @(posedge clk_reset) ex_pause_state = #10 pause_state;
	always @(posedge clk_reset) ex_done_process = #10 done_process;
	always @(posedge clk_reset)
	   if(!power_state)//电源关闭时
		   begin
		       finished = 0;
			   running_state = 0;
			   mode_state = mode1;//切换到洗漂脱模式
			   total_time = weight_state + weight_state + 27;
			   process_state = process0;
			   process_time = weight_state;//进水时间
			   next_process_time = 9;//下个进程是洗衣
			   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
			   {intake_running,wash_running,rinse_running,outlet_running,dewatering_running} = 5'b00000;
		   end
	   else if( !mode && !pause_state && ex_mode)//响应mode上升沿
			case(mode_state)
			mode1:begin running_state = 0;finished = 0;
			           mode_state = mode2;//切换到单洗模式
					   total_time = weight_state + 9;//单洗模式总时间
					   process_state = process0;
					   process_time = weight_state;//进水时间
					   next_process_time = 9;//下个进程是洗衣
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode2:begin running_state = 0;finished = 0;
			           mode_state = mode3;//切换到洗漂模式
					   total_time = weight_state + weight_state + 21;
					   process_state = process0;
					   process_time = weight_state;//进水时间
					   next_process_time = 9;//下个进程是洗衣
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode3:begin running_state = 0;finished = 0;
			           mode_state = mode4;//切换到单漂模式
					   total_time = weight_state + 12;//单漂模式总时间
					   process_state = process2;
					   process_time = 3;//排水时间
					   next_process_time = 3;//下个进程是甩干
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end	   
			mode4:begin running_state = 0;finished = 0;
			           mode_state = mode5;//切换到漂脱模式
					   total_time = weight_state + 18;//漂脱模式总时间
					   process_state = process2;
					   process_time = 3;//排水时间
					   next_process_time = 3;//下个进程是甩干
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode5:begin running_state = 0;finished = 0;
			           mode_state = mode6;//切换到单脱模式
					   total_time = 6;//单脱模式总时间
					   process_state = process6;
					   process_time = 3;//排水过程时间
					   next_process_time = 3;//下个进程是甩干
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode6:begin running_state = 0;finished = 0;
			           mode_state = mode1;//切换到洗漂脱模式
					   total_time = weight_state + weight_state + 27;
					   process_state = process0;
					   process_time = weight_state;//进水时间
					   next_process_time = 9;//下个进程是洗衣
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			default:begin running_state = 0;finished = 0;
			           mode_state = mode1;//切换到洗漂脱模式
					   total_time = weight_state + weight_state + 27;
					   process_state = process0;
					   process_time = weight_state;//进水时间
					   next_process_time = 9;//下个进程是洗衣
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
	        endcase
        else if( pause_state && !ex_pause_state) //响应pause_state上升沿
            begin running_state = 1;finished = 0;
			case(process_state)
                 process0:begin intake_running = 1;end
                 process1:begin wash_running = 1;end
                 process2:begin outlet_running = 1;end
                 process3:begin dewatering_running = 1;end
                 process4:begin intake_running = 1;end
                 process5:begin rinse_running = 1;end
                 process6:begin outlet_running = 1;end
                 process7:begin dewatering_running = 1;end
             endcase
             end
        else if( !pause_state && ex_pause_state) //响应pause_state下降沿
             case(process_state)
                  process0:begin intake_running = 0;end
                  process1:begin wash_running = 0;end
                  process2:begin outlet_running = 0;end
                  process3:begin dewatering_running = 0;end
                  process4:begin intake_running = 0;end
                  process5:begin rinse_running = 0;end
                  process6:begin outlet_running = 0;end
                  process7:begin dewatering_running = 0;end
              endcase  
        else if( pause_state && !done_process && ex_done_process)//响应done_process下降沿
		   case(process_state)
           process0:begin 
						intake_running = 0;//完成进水
                        wash_running = 1;//开始洗衣
                        process_state = process1;
                        process_time = 9;
                        next_process_time = 3;//下个进程是排水
                    end
           process1:begin 
						wash_running = 0;//完成洗衣
						wash_state = 0;
						if(mode_state == mode2)//如果是单洗则结束
							begin running_state = 0;finished = 1;
							   mode_state = mode1;//切换到洗漂脱模式
                               total_time = weight_state + weight_state + 27;
                               process_state = process0;
                               process_time = weight_state;//进水时间
                               next_process_time = 9;//下个进程是洗衣
                               {wash_state,rinse_state,dewatering_state} = #10 mode_state;
							end
						else begin  //否则开始排水
								process_state = process2;
								process_time = 3;
								outlet_running = 1;//开始排水
								next_process_time = 3;//下个进程是甩干
							 end
                    end
           process2:begin 
						outlet_running = 0;//完成排水
                        dewatering_running = 1;//开始甩干
                        process_state = process3;
                        process_time = 3;
						next_process_time = weight_state;//下个进程是进水
                    end
           process3:begin 
						dewatering_running = 0;	//完成甩干
                        intake_running = 1;//开始进水
                        process_state = process4;
                        process_time = weight_state;
                        next_process_time = 6;//下个进程是漂洗
					end
           process4:begin 
                        intake_running = 0;// 完成进水
						rinse_running = 1;//开始漂洗
						process_state = process5;
                        process_time = 6;
						next_process_time = 3;//下个进程是排水
                    end
           process5:begin 
						rinse_running = 0;//完成漂洗
						rinse_state = 0;
                        if(mode_state == mode3 || mode_state == mode4) 
                            begin //如果是洗漂或单漂模式则结束
                               running_state = 0;finished = 1;
                               mode_state = mode1;//切换到洗漂脱模式
                               total_time = weight_state + weight_state + 27;
                               process_state = process0;
                               process_time = weight_state;//进水时间
                               next_process_time = 9;//下个进程是洗衣
                               {wash_state,rinse_state,dewatering_state} = #10 mode_state;                            
                            end
                        else begin //否则开始排水
                                process_state = process6;
                                process_time = 3;
                                outlet_running = 1;//开始排水
                                next_process_time = 3;//下个进程是甩干
                             end
                    end
           process6:begin 
                        outlet_running = 0;//完成排水
                        dewatering_running = 1;//开始甩干
                        process_state = process7;
                        process_time = 3;
                        next_process_time = weight_state;//下个进程是进水
					end
           process7:begin 
                       dewatering_running = 0;//完成甩干
                       dewatering_state = 0;
                       running_state = 0;
                       finished = 1;
                       mode_state = mode1;//切换到洗漂脱模式
                       total_time = weight_state + weight_state + 27;
                       process_state = process0;
                       process_time = weight_state;//进水时间
                       next_process_time = 9;//下个进程是洗衣
                       {wash_state,rinse_state,dewatering_state} = #10 mode_state;
                    end
           endcase
endmodule








