module fsm(
    input clock,
	input mode,
	input [3:0]weight,
	input power_state,
	input pause_state,
	output reg [3:0]weight_state,
	output [7:0] total_remain,
    output [7:0] process_remain,
    output [7:0] second_remain
	);
	localparam mode1 = 3'b111,mode2 = 3'b110,mode3 = 3'b100,
               mode4 = 3'b010,mode5 = 3'b011,mode6 = 3'b001;
              
	reg [2:0]mode_state;//模式状态
	wire clk_min,done_process,done_total,reset_second,reset_process,reset_total;
	
    down_counter c_second(clk_second,reset_second,8'b00111011,clk_min,second_remain);//秒钟计时器
    down_counter c_process(clk_min,reset_process,process_time,done_process,process_remain);//过程用时计时器
    down_counter c_total(clk_min,reset_total,total_time,done_total,total_remain);//总时计时器
    
    assign clk_second = pause_state ? clock : 0 ;
    assign reset_second = !power_state ? 0 : !clk_min;
  
	initial begin 
               mode_state = mode1;//电源打开切换到洗漂脱模式
               weight_state = 3;
               total_remain = weight_state + weight_state + 27;//洗漂脱模式总时间
               process_remain = weight_state;//进水过程时间
              end  
	
	always @(posedge done_process)
	   case(process)
	   
	   endcase
		  
	always @(weight)
                  if(!pause_state) weight_state = weight;
	always @(posedge mode)
	   if(pause_state == 0)
	   case(mode_state)
			mode1:begin mode_state <= mode2;//切换到单洗模式
					   total_remain <= weight_state + 9;//单洗模式总时间
					   process_remain <= weight_state + 9;//洗涤过程时间
				   end
			mode2:begin mode_state <= mode3;//切换到洗漂模式
					   total_remain <= weight_state + weight_state + 21;//洗漂模式总时间
					   process_remain <= weight_state + 9;//洗涤过程时间
				   end
			mode3:begin mode_state <= mode4;//切换到单漂模式
					   total_remain <= weight_state + 12;//单漂模式总时间
					   process_remain <= weight_state + 12;//漂洗过程时间
				   end	   
			mode4:begin mode_state <= mode5;//切换到漂脱模式
					   total_remain <= weight_state + 18;//漂脱模式总时间
					   process_remain <= weight_state + 12;//漂洗过程时间
				   end
			mode5:begin mode_state <= mode6;//切换到单脱模式
					   total_remain <= 6;//单脱模式总时间
					   process_remain <= 6;//脱水过程时间
				   end
			mode6:begin mode_state <= mode1;//切换到洗漂脱模式
					   total_remain <= weight_state + weight_state + 27;//洗漂脱模式总时间
					   process_remain <= weight_state+9;//洗涤过程时间
				   end
			default:begin mode_state <= mode1;//切换到洗漂脱模式
					   total_remain <= weight_state + weight_state + 27;//洗漂脱模式总时间
					   process_remain <= weight_state+9;//洗涤过程时间
				   end        
	   endcase
endmodule








