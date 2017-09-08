module FSM_MODE(
	input mode,
	input pause_state,
	input [3:0]weight_state,
	output reg [7:0]total_time,
	output reg [7:0]process_time
	);
	localparam mode1 = 3'b000,mode2 = 3'b001,mode3 = 3'b011,
               mode4 = 3'b010,mode5 = 3'b110,mode6 = 3'b100;
	reg [2:0]mode_state;//ģʽ״̬
	initial begin 
	       mode_state <= mode1;//��Դ���л���ϴƯ��ģʽ
		   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
		   process_time <= weight_state;//ϴ�ӹ���ʱ��
		  end     
	always @(posedge mode)
	   if(pause_state == 0)
	   case(mode_state)
			mode1:begin mode_state <= mode2;//�л�����ϴģʽ
					   total_time <= weight_state + 9;//��ϴģʽ��ʱ��
					   process_time <= weight_state + 9;//ϴ�ӹ���ʱ��
				   end
			mode2:begin mode_state <= mode3;//�л���ϴƯģʽ
					   total_time <= weight_state + weight_state + 21;//ϴƯģʽ��ʱ��
					   process_time <= weight_state + 9;//ϴ�ӹ���ʱ��
				   end
			mode3:begin mode_state <= mode4;//�л�����Ưģʽ
					   total_time <= weight_state + 12;//��Ưģʽ��ʱ��
					   process_time <= weight_state + 12;//Ưϴ����ʱ��
				   end	   
			mode4:begin mode_state <= mode5;//�л���Ư��ģʽ
					   total_time <= weight_state + 18;//Ư��ģʽ��ʱ��
					   process_time <= weight_state + 12;//Ưϴ����ʱ��
				   end
			mode5:begin mode_state <= mode6;//�л�������ģʽ
					   total_time <= 6;//����ģʽ��ʱ��
					   process_time <= 6;//��ˮ����ʱ��
				   end
			mode6:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_time <= weight_state+9;//ϴ�ӹ���ʱ��
				   end
			default:begin mode_state <= mode1;//�л���ϴƯ��ģʽ
					   total_time <= weight_state + weight_state + 27;//ϴƯ��ģʽ��ʱ��
					   process_time <= weight_state+9;//ϴ�ӹ���ʱ��
				   end        
	   endcase
endmodule

module FSM_PROCESS(
    
    
    );
    
    
endmodule









