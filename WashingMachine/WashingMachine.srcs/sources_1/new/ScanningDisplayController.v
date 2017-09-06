module SDC(
	input CLK100MHZ,
	input [31:0]display2,
	input [31:0]display1,
	output [7:0]AN,
	output [7:0]CN
	);
	reg [7:0]AN;
	reg [7:0]CN;
	reg [2:0]n;
	
	wire clk;
	devider#(5000) f_100Hz(CLK100MHZ,clk);
	
	initial 
	   begin
	       AN <= 8'b11111111;
	       CN <= 8'b11111111; 
	       n <= 3'b000;
	   end
	always @(posedge clk)
	begin
		case(n)
			0:begin  AN <= 8'b01111111;  CN <= display2[31:24]; n <= n + 1; end
			1:begin  AN <= 8'b10111111;  CN <= display2[23:16]; n <= n + 1; end
			2:begin  AN <= 8'b11011111;  CN <= display2[15:8]; n <= n + 1; end
			3:begin  AN <= 8'b11101111;  CN <= display2[7:0]; n <= n + 1; end
			4:begin  AN <= 8'b11110111;  CN <= display1[31:24]; n <= n + 1; end
			5:begin  AN <= 8'b11111011;  CN <= display1[23:16]; n <= n + 1; end
			6:begin  AN <= 8'b11111101;  CN <= display1[15:8]; n <= n + 1; end
			7:begin  AN <= 8'b11111110;  CN <= display1[7:0]; n <= n + 1; end
		endcase
	end
endmodule