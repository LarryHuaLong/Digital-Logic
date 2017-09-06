module SDC(
	input CLK100MHZ,
	input [31:0]data,
	output [7:0]AN,
	output [7:0]CN
	);
	reg [7:0]AN;
	reg [7:0]CN;
	reg [2:0]n;
	
	wire clk;
	devider#(5000) f_100Hz(CLK100MHZ,clk);
	wire [7:0]num0,num1,num2,num3,num4,num5,num6,num7;
	BCD_decoder dec1(data[31:28],num7);
	BCD_decoder dec2(data[27:24],num6);
	BCD_decoder dec3(data[23:20],num5);
	BCD_decoder dec4(data[19:16],num4);
	BCD_decoder dec5(data[15:12],num3);
	BCD_decoder dec6(data[11:8],num2);
	BCD_decoder dec7(data[7:4],num1);
	BCD_decoder dec8(data[3:0],num0);
	
	
	
	initial 
	   begin
	       AN <= 8'b11111111;
	       CN <= 8'b11111111; 
	       n <= 3'b000;
	   end
	always @(posedge clk)
	begin
		case(n)
			0:begin  AN <= 8'b01111111;  CN <= data[63:56]; n <= n + 1; end
			1:begin  AN <= 8'b10111111;  CN <= data[55:48]; n <= n + 1; end
			2:begin  AN <= 8'b11011111;  CN <= data[47:40]; n <= n + 1; end
			3:begin  AN <= 8'b11101111;  CN <= data[39:32]; n <= n + 1; end
			4:begin  AN <= 8'b11110111;  CN <= data[31:24]; n <= n + 1; end
			5:begin  AN <= 8'b11111011;  CN <= data[23:16]; n <= n + 1; end
			6:begin  AN <= 8'b11111101;  CN <= data[15:8]; n <= n + 1; end
			7:begin  AN <= 8'b11111110;  CN <= data[7:0]; n <= n + 1; end
		endcase
	end
endmodule