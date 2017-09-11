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
    output [4:0] leds
	);
	localparam mode1 = 3'b111,mode2 = 3'b110,mode3 = 3'b100,
               mode4 = 3'b010,mode5 = 3'b011,mode6 = 3'b001;
    localparam process0 = 3'b000,process1 = 3'b001,process2 = 3'b010,process3 = 3'b011,
			   process4 = 3'b111,process5 = 3'b110,process6 = 3'b100,process7 = 3'b101;
	reg [2:0]mode_state,process_state;//ģʽ�ͽ���״̬
	reg [7:0]total_time,process_time;
	wire clock,clk_second,clk_min,clk_minite,
       done_process,done_total,
       reset_second,reset_process,reset_total;
	reg intake_state,wash_state,rinse_state,outlet_state,dewatering_state;
	devider#(50000000) f_1Hz(CLK100MHZ,clock);
    down_counter c_second(clk_second,reset_second,8'b00111100,clk_min,second_remain);//���Ӽ�ʱ��
    down_counter c_process(clk_minite,reset_process,process_time,done_process,process_remain);//������ʱ��ʱ��
    down_counter c_total(clk_minite,reset_total,total_time,done_total,total_remain);//��ʱ��ʱ��
    
    assign leds = {intake_state,wash_state,rinse_state,outlet_state,dewatering_state};
    assign clk_second = pause_state ? clock : 0;
    assign clk_minite = pause_state ? clk_min : CLK100MHZ;
    assign reset_second = power_state&&pause_state ? !clk_min : 0;
    assign reset_process = power_state&&pause_state ? !done_process : 0;
    assign reset_total = power_state&&pause_state ? !done_total : 0;
    
	initial begin 
		   mode_state = mode1;//��Դ���л���ϴƯ��ģʽ
		   weight_state = 3;
		   total_time = weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
		   process_state = process0;
		   process_time = weight_state;//��ˮʱ��
		   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} = 5'b11111;
           end
	
	/*always @(posedge done_process,posedge pause_state)
	   case(process_state)
	   process0:begin 
				        
				end
	   process1:begin  
				    
				end
	   process2:begin 
				    
				end
	   process3:begin 
				    
				end
	   process4:begin 
				    
				end
	   process5:begin 
				    
				end
	   process6:begin 
			         
				end
	   process7:begin 
				    
				end
	   endcase*/
		  
	always @(weight)
                  if(!pause_state) weight_state = weight;
	always @(posedge mode)
	   if(pause_state == 0)
	   case(mode_state)
			mode1:begin mode_state <= mode2;//�л�����ϴģʽ
					   total_time <= weight_state + 9;//��ϴģʽ��ʱ��
					   process_state <= process0;
					   process_time <= weight_state;//��ˮʱ��
					   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} <= 5'b11000;
				   end
			mode2:begin mode_state <= mode3;//�л���ϴƯģʽ
					   total_time <= weight_state + weight_state + 21;//ϴƯģʽ��ʱ��
					   process_state <= process0;
					   process_time <= weight_state;//��ˮʱ��
					   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} <= 5'b11111;
				   end
			mode3:begin mode_state <= mode4;//�л�����Ưģʽ
					   total_time <= weight_state + 12;//��Ưģʽ��ʱ��
					   process_state <= process2;
					   process_time <= 3;//��ˮʱ��
					   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} <= 5'b10111;
				   end	   
			mode4:begin mode_state <= mode5;//�л���Ư��ģʽ
					   total_time <= weight_state + 18;//Ư��ģʽ��ʱ��
					   process_state <= process2;
					   process_time <= 3;//��ˮʱ��
					   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} <= 5'b11111;
				   end
			mode5:begin mode_state <= mode6;//�л�������ģʽ
					   total_time <= 6;//����ģʽ��ʱ��
					   process_state <= process6;
					   process_time <= 3;//��ˮ����ʱ��
					   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} <= 5'b00011;
				   end
			mode6:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_state <= process0;
					   process_time <= weight_state;//��ˮʱ��
					   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} <= 5'b11111;
				   end
			default:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_state <= process0;
					   process_time <= weight_state;//��ˮʱ��
					   {intake_state,wash_state,rinse_state,outlet_state,dewatering_state} <= 5'b11111;
				   end
	   endcase
endmodule








