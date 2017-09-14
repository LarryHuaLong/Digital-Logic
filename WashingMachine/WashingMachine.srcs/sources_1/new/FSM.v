`timescale 1ns/1ps
module fsm(
    input clk_clock,
    input clk_reset,
    input mode,
	input [3:0]weight,
	input power_state,
	input pause_state,
	output reg [3:0]weight_state,
	output [7:0] total_remain,
    output [7:0] process_remain,
    output [7:0] second_remain,
    output [4:0] leds,
    output finished
	);
	localparam mode1 = 3'b111,mode2 = 3'b100,mode3 = 3'b110,
               mode4 = 3'b010,mode5 = 3'b011,mode6 = 3'b001;
    localparam process0 = 3'b000,process1 = 3'b001,process2 = 3'b010,process3 = 3'b011,
			   process4 = 3'b111,process5 = 3'b110,process6 = 3'b100,process7 = 3'b101;
	reg [2:0]mode_state,process_state;//ģʽ�ͽ���״̬
	reg [7:0]total_time,process_time,next_process_time;
	reg [7:0]load_process_time;
	wire clk_second,clk_minite,
       clk_min,done_process,done_total,
       reset_second,reset_process,reset_total;
	reg wash_state,rinse_state,dewatering_state;
	reg running_state,intake_running,wash_running,
	   rinse_running,outlet_running,dewatering_running;
	reg ex_mode,ex_pause_state,ex_done_process;
	down_counter#(0) c_second(clk_second,reset_second,8'b00111100,clk_min,second_remain);//���Ӽ�ʱ��
    down_counter#(1) c_process(clk_minite,reset_process,load_process_time,done_process,process_remain);//������ʱ��ʱ��
    down_counter#(1) c_total(clk_minite,reset_total,total_time,done_total,total_remain);//��ʱ��ʱ��
    always @(posedge clk_reset) load_process_time = pause_state ? next_process_time : process_time ;
    assign finished = !total_remain;
    assign clk_second = power_state ? (pause_state ? clk_clock : (running_state ? 0 : clk_reset )) : 0;
    assign clk_minite = power_state ? (pause_state ? clk_min : ( running_state ? 0 : clk_reset )) : 0;
    assign reset_second = power_state ? (pause_state ? !clk_min : (running_state ? 1 : 0)) : 0;
    assign reset_process = power_state ? (pause_state ? !done_process : (running_state ? 1 : 0)) : 0;
    assign reset_total =  power_state ? (pause_state ?  1 : 0) : 0 ;
    assign leds[4] = intake_running ? clk_clock : 0;
    assign leds[3] = outlet_running ? clk_clock : 0;
    assign leds[2] = wash_running ? clk_clock : wash_state;
    assign leds[1] = rinse_running ? clk_clock : rinse_state;
    assign leds[0] = dewatering_running ? clk_clock : dewatering_state;
    
	initial begin 
	       running_state = 0;
		   weight_state = 3;
		   mode_state = mode1;//��Դ���л���ϴƯ��ģʽ
		   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
		   total_time = weight_state + weight_state + 27;
		   process_state = process0;
		   process_time = weight_state;//��ˮʱ��
		   next_process_time = 9;//�¸�������ϴ��
		   {intake_running,wash_running,rinse_running,outlet_running,dewatering_running} = 5'b00000;
           end
	always @(posedge clk_reset) ex_mode = #10 mode ;
	always @(posedge clk_reset) ex_pause_state = #10 pause_state;
	always @(posedge clk_reset) ex_done_process = #10 done_process;
	always @(posedge clk_reset)
       if(!pause_state) weight_state = weight < 4 ? 3 : weight;
	always @(posedge clk_reset)
	   if(!power_state)//��Դ�ر�ʱ
		   begin 
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
			mode1:begin running_state = 0;
			           mode_state = mode2;//�л�����ϴģʽ
					   total_time = weight_state + 9;//��ϴģʽ��ʱ��
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode2:begin running_state = 0;
			           mode_state = mode3;//�л���ϴƯģʽ
					   total_time = weight_state + weight_state + 21;
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode3:begin running_state = 0;
			           mode_state = mode4;//�л�����Ưģʽ
					   total_time = weight_state + 12;//��Ưģʽ��ʱ��
					   process_state = process2;
					   process_time = 3;//��ˮʱ��
					   next_process_time = 3;//�¸�������˦��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end	   
			mode4:begin running_state = 0;
			           mode_state = mode5;//�л���Ư��ģʽ
					   total_time = weight_state + 18;//Ư��ģʽ��ʱ��
					   process_state = process2;
					   process_time = 3;//��ˮʱ��
					   next_process_time = 3;//�¸�������˦��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode5:begin running_state = 0;
			           mode_state = mode6;//�л�������ģʽ
					   total_time = 6;//����ģʽ��ʱ��
					   process_state = process6;
					   process_time = 3;//��ˮ����ʱ��
					   next_process_time = 3;//�¸�������˦��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			mode6:begin running_state = 0;
			           mode_state = mode1;//�л���ϴƯ��ģʽ
					   total_time = weight_state + weight_state + 27;
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
			default:begin running_state = 0;
			           mode_state = mode1;//�л���ϴƯ��ģʽ
					   total_time = weight_state + weight_state + 27;
					   process_state = process0;
					   process_time = weight_state;//��ˮʱ��
					   next_process_time = 9;//�¸�������ϴ��
					   {wash_state,rinse_state,dewatering_state} = #10 mode_state;
				   end
	        endcase
        else if( pause_state && !ex_pause_state) //��Ӧpause_state������
			case(process_state)
                 process0:begin running_state = 1;intake_running = 1;end
                 process1:begin running_state = 1;wash_running = 1;end
                 process2:begin running_state = 1;outlet_running = 1;end
                 process3:begin running_state = 1;dewatering_running = 1;end
                 process4:begin running_state = 1;intake_running = 1;end
                 process5:begin running_state = 1;rinse_running = 1;end
                 process6:begin running_state = 1;outlet_running = 1;end
                 process7:begin running_state = 1;dewatering_running = 1;end
             endcase
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
           process0:begin //��ɽ�ˮ
						intake_running = 0;
                        process_state = process1;
                        process_time = 9;
                        wash_running = 1;//��ʼϴ��
                        next_process_time = 3;//�¸���������ˮ
                    end
           process1:begin //���ϴ��
						wash_running = 0;
						wash_state = 0;
						if(mode_state == mode2)//����ǵ�ϴ�����
							begin running_state = 0;
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
							 end
						next_process_time = 3;//�¸�������˦��
                    end
           process2:begin //�����ˮ
						outlet_running = 0;
                        process_state = process3;
                        process_time = 3;
                        dewatering_running = 1;//��ʼ˦��
						next_process_time = weight_state;//�¸������ǽ�ˮ
                    end
           process3:begin //���˦��
						dewatering_running = 0;	
                        process_state = process4;
                        process_time = weight_state;
                        intake_running = 1;//��ʼ��ˮ
                        next_process_time = 6;//�¸�������Ưϴ
					end
           process4:begin //��ɽ�ˮ
                        intake_running = 0;// ������ˮ
						process_state = process5;
                        process_time = 6;
                        rinse_running = 1;//��ʼƯϴ
						next_process_time = 3;//�¸���������ˮ
                    end
           process5:begin //���Ưϴ
						rinse_running = 0;
						rinse_state = 0;
                        if(mode_state == mode3 || mode_state == mode4) 
                            begin //�����ϴƯ��Ưģʽ�����
                               running_state = 0;
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
                             end
 						next_process_time = 3;//�¸�������˦��
                    end
           process6:begin //�����ˮ
                        outlet_running = 0;
						process_state = process7;
                        process_time = 3;
                        dewatering_running = 1;//��ʼ˦��
						next_process_time = weight_state;//�¸������ǽ�ˮ
					end
           process7:begin //���˦��
                       running_state = 0;   
                       dewatering_running = 0;
                       dewatering_state = 0;
                       mode_state = mode1;//�л���ϴƯ��ģʽ
                       total_time = weight_state + weight_state + 27;
                       process_state = process0;
                       process_time = weight_state;//��ˮʱ��
                       next_process_time = 9;//�¸�������ϴ��
                       {wash_state,rinse_state,dewatering_state} = #10 mode_state;
                    end
           endcase

	
endmodule








