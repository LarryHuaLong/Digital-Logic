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
              
	reg [2:0]mode_state;//ģʽ״̬
	wire clk_min,done_process,done_total,reset_second,reset_process,reset_total;
	
    down_counter c_second(clk_second,reset_second,8'b00111011,clk_min,second_remain);//���Ӽ�ʱ��
    down_counter c_process(clk_min,reset_process,process_time,done_process,process_remain);//������ʱ��ʱ��
    down_counter c_total(clk_min,reset_total,total_time,done_total,total_remain);//��ʱ��ʱ��
    
    assign clk_second = pause_state ? clock : 0 ;
    assign reset_second = !power_state ? 0 : !clk_min;
  
	initial begin 
               mode_state = mode1;//��Դ���л���ϴƯ��ģʽ
               weight_state = 3;
               total_remain = weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
               process_remain = weight_state;//��ˮ����ʱ��
              end  
	
	always @(posedge done_process)
	   case(process)
	   
	   endcase
		  
	always @(weight)
                  if(!pause_state) weight_state = weight;
	always @(posedge mode)
	   if(pause_state == 0)
	   case(mode_state)
			mode1:begin mode_state <= mode2;//�л�����ϴģʽ
					   total_remain <= weight_state + 9;//��ϴģʽ��ʱ��
					   process_remain <= weight_state + 9;//ϴ�ӹ���ʱ��
				   end
			mode2:begin mode_state <= mode3;//�л���ϴƯģʽ
					   total_remain <= weight_state + weight_state + 21;//ϴƯģʽ��ʱ��
					   process_remain <= weight_state + 9;//ϴ�ӹ���ʱ��
				   end
			mode3:begin mode_state <= mode4;//�л�����Ưģʽ
					   total_remain <= weight_state + 12;//��Ưģʽ��ʱ��
					   process_remain <= weight_state + 12;//Ưϴ����ʱ��
				   end	   
			mode4:begin mode_state <= mode5;//�л���Ư��ģʽ
					   total_remain <= weight_state + 18;//Ư��ģʽ��ʱ��
					   process_remain <= weight_state + 12;//Ưϴ����ʱ��
				   end
			mode5:begin mode_state <= mode6;//�л�������ģʽ
					   total_remain <= 6;//����ģʽ��ʱ��
					   process_remain <= 6;//��ˮ����ʱ��
				   end
			mode6:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_remain <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_remain <= weight_state+9;//ϴ�ӹ���ʱ��
				   end
			default:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_remain <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_remain <= weight_state+9;//ϴ�ӹ���ʱ��
				   end        
	   endcase
endmodule








