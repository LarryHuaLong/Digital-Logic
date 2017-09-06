module SDC(
	input CLK100MHZ,
	//input [7:0][7:0]data,
	output [7:0]AN,
	output [7:0]CN
	);
	reg [7:0]AN,CN;
	wire clk;
	reg n;
	devider#(1000000) f_100Hz(CLK100MHZ,clk);
	initial n = 0;
	
	localparam
                data7 = 8'b1110000,
                data6 = 8'b1011111,
                data5 = 8'b1011011,
                data4 = 8'b0110011,
                data3 = 8'b1111001,
                data2 = 8'b1101101,
                data1 = 8'b0110000,
                data0 = 8'b1111110;
               
            
	
	always @(posedge clk)
	begin
		case(n)
			0:begin  AN = 8'b01111111;  CN = data7; n = n + 1; end
			1:begin  AN = 8'b10111111;  CN = data6; n = n + 1; end
			2:begin  AN = 8'b11011111;  CN = data5; n = n + 1; end
			3:begin  AN = 8'b11101111;  CN = data4; n = n + 1; end
			4:begin  AN = 8'b11110111;  CN = data3; n = n + 1; end
			5:begin  AN = 8'b11111011;  CN = data2; n = n + 1; end
			6:begin  AN = 8'b11111101;  CN = data1; n = n + 1; end
			7:begin  AN = 8'b11111110;  CN = data0; n = n + 1;n = 0; end
			default:n = 0;
		endcase
		
	end
endmodule