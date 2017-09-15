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
    output [4:0] process_running,//������̵�����״̬
    output reg finished
	);
	localparam mode1 = 3'b111,mode2 = 3'b100,mode3 = 3'b110,
               mode4 = 3'b010,mode5 = 3'b011,mode6 = 3'b001;
    localparam process0 = 3'b000,process1 = 3'b001,process2 = 3'b010,process3 = 3'b011,
			   process4 = 3'b111,process5 = 3'b110,process6 = 3'b100,process7 = 3'b101;
	reg [2:0]mode_state,process_state;//ģʽ�ͽ���״̬
	reg wash_state,rinse_state,dewatering_state;//ϴ�³���״̬
	reg intake_running,wash_running,rinse_running,outlet_running,dewatering_running;//����״̬
	reg ex_mode,ex_pause_state,ex_done_process;//Ϊʶ������¼����õ��м����
	assign wrd_state = {wash_state,rinse_state,dewatering_state};
    assign process_running = {intake_running,outlet_running,wash_running,rinse_running,dewatering_running};
	initial begin //��ʼ״̬
               running_state <= 0;
               finished <= 0;
               mode_state <= mode1;//Ĭ��ϴƯ��ģʽ
               {wash_state,rinse_state,dewatering_state} <= 3'b0;
               total_time <= 33;
               process_state <= process0;
               process_time <= 3;//��ˮʱ��
               next_process_time <= 9;//�¸�������ϴ��
               {intake_running,wash_running,rinse_running,outlet_running,dewatering_running} <= 5'b00000;
           end
	always @(posedge clk_reset) ex_mode = #10 mode ;
	always @(posedge clk_reset) ex_pause_state = #10 pause_state;
	always @(posedge clk_reset) ex_done_process = #10 done_process;
	always @(posedge clk_reset)
	   if(!power_state)//��Դ�ر�ʱ
		   begin
		       finished = 0;
			   running_state = 0;
			   mode_state = mode1;//�л���ϴƯ��ģʽ
			   total_time = weight_state + weight_state + 27;
			   process_state = process0;
			   process_time = weight_state;//��ˮʱ��
			   next_process_time = 9;//�¸�������ϴ��
			   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
			   {intake_running,wash_running,rinse_running,outlet_running,dewatering_running} = 5'b00000;
		   end
	   else if( !mode && !pause_state && ex_mode)//��Ӧmode������
			case(mode_state)
			mode1:begin running_state = 0;finished = 0;
			           mode_state = mode2;//�л�����ϴģʽ
					   total_time = weight_state + 9;//��ϴģʽ��ʱ��
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode2:begin running_state = 0;finished = 0;
			           mode_state = mode3;//�л���ϴƯģʽ
					   total_time = weight_state + weight_state + 21;
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode3:begin running_state = 0;finished = 0;
			           mode_state = mode4;//�л�����Ưģʽ
					   total_time = weight_state + 12;//��Ưģʽ��ʱ��
					   process_state = process2;
					   process_time = 3;//��ˮʱ��
					   next_process_time = 3;//�¸�������˦��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end	   
			mode4:begin running_state = 0;finished = 0;
			           mode_state = mode5;//�л���Ư��ģʽ
					   total_time = weight_state + 18;//Ư��ģʽ��ʱ��
					   process_state = process2;
					   process_time = 3;//��ˮʱ��
					   next_process_time = 3;//�¸�������˦��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode5:begin running_state = 0;finished = 0;
			           mode_state = mode6;//�л�������ģʽ
					   total_time = 6;//����ģʽ��ʱ��
					   process_state = process6;
					   process_time = 3;//��ˮ����ʱ��
					   next_process_time = 3;//�¸�������˦��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode6:begin running_state = 0;finished = 0;
			           mode_state = mode1;//�л���ϴƯ��ģʽ
					   total_time = weight_state + weight_state + 27;
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			default:begin running_state = 0;finished = 0;
			           mode_state = mode1;//�л���ϴƯ��ģʽ
					   total_time = weight_state + weight_state + 27;
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
	        endcase
        else if( pause_state && !ex_pause_state) //��Ӧpause_state������
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
        else if( !pause_state && ex_pause_state) //��Ӧpause_state�½���
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
        else if( pause_state && !done_process && ex_done_process)//��Ӧdone_process�½���
		   case(process_state)
           process0:begin 
						intake_running = 0;//��ɽ�ˮ
                        wash_running = 1;//��ʼϴ��
                        process_state = process1;
                        process_time = 9;
                        next_process_time = 3;//�¸���������ˮ
                    end
           process1:begin 
						wash_running = 0;//���ϴ��
						wash_state = 0;
						if(mode_state == mode2)//����ǵ�ϴ�����
							begin running_state = 0;finished = 1;
							   mode_state = mode1;//�л���ϴƯ��ģʽ
                               total_time = weight_state + weight_state + 27;
                               process_state = process0;
                               process_time = weight_state;//��ˮʱ��
                               next_process_time = 9;//�¸�������ϴ��
                               {wash_state,rinse_state,dewatering_state} = #10 mode_state;
							end
						else begin  //����ʼ��ˮ
								process_state = process2;
								process_time = 3;
								outlet_running = 1;//��ʼ��ˮ
								next_process_time = 3;//�¸�������˦��
							 end
                    end
           process2:begin 
						outlet_running = 0;//�����ˮ
                        dewatering_running = 1;//��ʼ˦��
                        process_state = process3;
                        process_time = 3;
						next_process_time = weight_state;//�¸������ǽ�ˮ
                    end
           process3:begin 
						dewatering_running = 0;	//���˦��
                        intake_running = 1;//��ʼ��ˮ
                        process_state = process4;
                        process_time = weight_state;
                        next_process_time = 6;//�¸�������Ưϴ
					end
           process4:begin 
                        intake_running = 0;// ��ɽ�ˮ
						rinse_running = 1;//��ʼƯϴ
						process_state = process5;
                        process_time = 6;
						next_process_time = 3;//�¸���������ˮ
                    end
           process5:begin 
						rinse_running = 0;//���Ưϴ
						rinse_state = 0;
                        if(mode_state == mode3 || mode_state == mode4) 
                            begin //�����ϴƯ��Ưģʽ�����
                               running_state = 0;finished = 1;
                               mode_state = mode1;//�л���ϴƯ��ģʽ
                               total_time = weight_state + weight_state + 27;
                               process_state = process0;
                               process_time = weight_state;//��ˮʱ��
                               next_process_time = 9;//�¸�������ϴ��
                               {wash_state,rinse_state,dewatering_state} = #10 mode_state;                            
                            end
                        else begin //����ʼ��ˮ
                                process_state = process6;
                                process_time = 3;
                                outlet_running = 1;//��ʼ��ˮ
                                next_process_time = 3;//�¸�������˦��
                             end
                    end
           process6:begin 
                        outlet_running = 0;//�����ˮ
                        dewatering_running = 1;//��ʼ˦��
                        process_state = process7;
                        process_time = 3;
                        next_process_time = weight_state;//�¸������ǽ�ˮ
					end
           process7:begin 
                       dewatering_running = 0;//���˦��
                       dewatering_state = 0;
                       running_state = 0;
                       finished = 1;
                       mode_state = mode1;//�л���ϴƯ��ģʽ
                       total_time = weight_state + weight_state + 27;
                       process_state = process0;
                       process_time = weight_state;//��ˮʱ��
                       next_process_time = 9;//�¸�������ϴ��
                       {wash_state,rinse_state,dewatering_state} = #10 mode_state;
                    end
           endcase
endmodule








