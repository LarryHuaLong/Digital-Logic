module FSM_MODE(
	input mode,
	input pause_state,
	input [3:0]weight_state,
	output reg [7:0]total_time,
	output reg [7:0]process_time
	);
	localparam mode1 = 3'b000,mode2 = 3'b001,mode3 = 3'b011,
               mode4 = 3'b010,mode5 = 3'b110,mode6 = 3'b100;
	reg [2:0]mode_state;//模式状态
	initial begin 
	       mode_state <= mode1;//电源打开切换到洗漂脱模式
		   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
		   process_time <= weight_state;//洗涤过程时间
		  end     
	always @(posedge mode)
	   if(pause_state == 0)
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
					   process_time <= weight_state+9;//洗涤过程时间
				   end
			default:begin mode_state <= mode1;//切换到洗漂脱模式
					   total_time <= weight_state + weight_state + 27;//洗漂脱模式总时间
					   process_time <= weight_state+9;//洗涤过程时间
				   end        
	   endcase
endmodule

module FSM_PROCESS(
    
    
    );
    
    
endmodule









